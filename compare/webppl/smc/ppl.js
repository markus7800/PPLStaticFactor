var LOG_PI = 1.1447298858494002;
var LOG_2PI = 1.8378770664093453;

var ad = require('adnn/ad');

var rng = Math.random;

function random() {
    return rng();
  }

function gaussian_sample(mu, sigma) {
    var u, v, x, y, q;
    do {
        u = 1 - random();
        v = 1.7156 * (random() - 0.5);
        x = u - 0.449871;
        y = Math.abs(v) + 0.386595;
        q = x * x + y * (0.196 * y - 0.25472 * x);
    } while (q >= 0.27597 && (q > 0.27846 || v * v > -4 * u * u * Math.log(u)));
    return mu + sigma * v / u;
}
function gaussian_score(mu, sigma, x) {
    return -0.5 * (LOG_2PI + 2 * Math.log(sigma) + (x - mu) * (x - mu) / (sigma * sigma));
}

function expGammaSample(shape, scale) {
    if (shape < 1) {
        var r;
        r = expGammaSample(1 + shape, scale) + Math.log(random()) / shape;
        if (r === -Infinity) {
            return -Number.MAX_VALUE;
        }
        return r;
    }
    var x, v, u, log_v;
    var d = shape - 1 / 3;
    var c = 1 / Math.sqrt(9 * d);
    while (true) {
        do {
            x = gaussian_sample(0, 1);
            v = 1 + c * x;
        } while (v <= 0);
        log_v = 3 * Math.log(v);
        v = v * v * v;
        u = random();
        if (u < 1 - 0.331 * x * x * x * x || Math.log(u) < 0.5 * x * x + d * (1 - v + Math.log(v))) {
            return Math.log(scale) + Math.log(d) + log_v;
        }
    }
}

function beta_sample(a, b) {
    var log_x = expGammaSample(a, 1);
    var log_y = expGammaSample(b, 1);
    var v = 1 / (1 + Math.exp(log_y - log_x));
    if (v === 0) {
        v = Number.MIN_VALUE;
    } else if (v === 1) {
        v = 1 - Number.EPSILON / 2;
    }
    return v;
}

function discrete_sample(theta, thetaSum) {
    if (thetaSum === undefined) {
        thetaSum = numeric._sum(theta);
    }
    var x = random() * thetaSum;
    var k = theta.length;
    var probAccum = 0;
    for (var i = 0; i < k; i++) {
        probAccum += theta[i];
        if (x < probAccum) {
            return i;
        }
    }
    return k - 1;
}

var Vector = function(arr) {
    var n = arr.length;
    var t = ad.tensor.fromScalars(arr);
    return ad.tensor.reshape(t, [n, 1]);
  };

var reduce = function(fn, init, ar) {
    var n = ar.length;
    var helper = function(i) {
      if (i === n) {
        return init
      } else {
        return fn(ar[i], helper(i + 1))
      }
    }
  
    return helper(0);
};

var sum = function(l) {
    return reduce(function(a, b) { return a + b; }, 0, l);
};

function logsumexp(a) {
    var m = Math.max.apply(null, a);
    var sum = 0;
    for (var i = 0; i < a.length; ++i) {
        sum += a[i] === -Infinity ? 0 : Math.exp(a[i] - m);
    }
    return m + Math.log(sum);
}

var shallow_copy_ctx = function(ctx) {
    return {...ctx}
}

var smc = function(model, n_particles, data) {
    particles = []
    new_particles = []

    for (var i = 0; i < n_particles; i++) {
        particles.push({lp: 0.})
        new_particles.push({lp: 0.})
    }

    for (var t = 0; t < data.length; t++) {
        var log_weights = []
        for (var i = 0; i < n_particles; i++) {
            var current_lp = particles[i].lp
            particles[i].lp = 0.
            model(data.slice(0,i), particles[i])
            log_weights.push(particles[i].lp - current_lp)
        }
        var log_normalizer = logsumexp(log_weights)
        var weights = []
        for (var i = 0; i < n_particles; i++) {
            weights[i] = Math.exp(log_weights[i] - log_normalizer)
        }

        for (var i = 0; i < n_particles; i++) {
            var ix = discrete_sample(weights, 1.)
            new_particles[i] = shallow_copy_ctx(particles[ix])
        }

        var tmp = particles;
        particles = new_particles;
        new_particles = tmp;
    }

    return particles;
}

module.exports = {
    beta_sample: beta_sample,
    gaussian_sample: gaussian_sample,
    gaussian_score: gaussian_score,
    discrete_sample: discrete_sample,
    Vector: Vector,
    sum: sum,
    smc: smc,
}