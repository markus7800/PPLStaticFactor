// copied from webppl

var LOG_2PI = 1.8378770664093453;

var ad = require('adnn/ad');
var Tensor = require('adnn/tensor');
var seedrandom = require('seedrandom');

var rng = Math.random;

function random() {
    return rng();
}

function seedRNG(seed) {
    rng = seedrandom(seed);
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

function uniform_sample(a, b) {
    return random() * (b - a) + a
}

function random_integer_sample(n) {
    return Math.floor(random() * n);
}

function gamma_sample(shape, scale) {
    if (shape < 1) {
        var r;
        r = gamma_sample(1 + shape, scale) * Math.pow(random(), 1 / shape);
        if (r === 0) {
            return Number.MIN_VALUE;
        }
        return r;
    }
    var x, v, u;
    var d = shape - 1 / 3;
    var c = 1 / Math.sqrt(9 * d);
    while (true) {
        do {
            x = gaussian_sample(0, 1);
            v = 1 + c * x;
        } while (v <= 0);
        v = v * v * v;
        u = random();
        if (u < 1 - 0.331 * x * x * x * x || Math.log(u) < 0.5 * x * x + d * (1 - v + Math.log(v))) {
            return scale * d * v;
        }
    }
}
function dirichlet_sample(alpha) {
    var n = alpha.dims[0];
    var ssum = 0;
    var theta = new Tensor([
        n,
        1
    ]);
    var t;
    for (var i = 0; i < n; i++) {
        t = gamma_sample(alpha.data[i], 1);
        theta.data[i] = t;
        ssum += t;
    }
    for (var j = 0; j < n; j++) {
        theta.data[j] /= ssum;
        if (theta.data[j] === 0) {
            theta.data[j] = Number.MIN_VALUE;
        }
        if (theta.data[j] === 1) {
            theta.data[j] = 1 - Number.EPSILON / 2;
        }
    }
    return theta;
}
function binomial_sample(p, n) {
    var k = 0;
    var N = 10;
    var a, b;
    while (n > N) {
        a = Math.floor(1 + n / 2);
        b = 1 + n - a;
        var x = beta_sample(a, b);
        if (x >= p) {
            n = a - 1;
            p /= x;
        } else {
            k += a;
            n = b - 1;
            p = (p - x) / (1 - x);
        }
    }
    var u;
    for (var i = 0; i < n; i++) {
        u = random();
        if (u < p) {
            k++;
        }
    }
    return k || 0;
}

function poisson_sample(mu) {
    var k = 0;
    while (mu > 10) {
        var m = Math.floor(7 / 8 * mu);
        var x = gamma_sample(m, 1);
        if (x >= mu) {
            return k + binomia_sample(mu / x, m - 1);
        } else {
            mu -= x;
            k += m;
        }
    }
    var emu = Math.exp(-mu);
    var p = 1;
    do {
        p *= random();
        k++;
    } while (p > emu);
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

var smc = function(model, n_particles, n_data) {
    particles = []
    new_particles = []

    for (var i = 0; i < n_particles; i++) {
        particles.push({lp: 0.})
        new_particles.push({lp: 0.})
    }

    for (var t = 0; t < n_data; t++) {
        var log_weights = []
        for (var i = 0; i < n_particles; i++) {
            var current_lp = particles[i].lp
            particles[i].lp = 0.
            model(particles[i], i)
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
    uniform_sample: uniform_sample,
    random_integer_sample: random_integer_sample,
    dirichlet_sample: dirichlet_sample,
    binomial_sample: binomial_sample,
    poisson_sample: poisson_sample,
    Vector: Vector,
    sum: sum,
    smc: smc,
    seedRNG: seedRNG
}