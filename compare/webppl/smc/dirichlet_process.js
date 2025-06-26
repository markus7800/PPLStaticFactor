var ppl = require("./ppl.js");

var xs = [0.42, 0.29, -0.01, 0.37, 0.23, 0.54, 0.95, 0.9, 0.48, 0.82, 0.88, 0.61, 0.83, 0.56, 0.42, 0.83, 0.36, 0.41, 0.51, 0.39, 0.06, 0.23, 0.4, 0.33, 0.23, 0.49, 0.13, 1.06, 0.22, 0.65, 0.25, 0.6, 0.25, 0.28, 0.23, 0.45, 0.34, 0.29, 0.88, 0.83, 0.81, 0.27, 0.72, 0.27, 0.43, 0.51, 0.35, 0.91, 0.31, 0.83]

var break_stick = function(ctx, i, alpha, stick, b, cumprod) {
    if (stick > 0.01) {
        var new_cumprod = cumprod * (1. - b)
        var new_b = (ctx["b_" + i] !== undefined) ? ctx["b_" + i] : ppl.beta_sample(1., alpha)
        ctx["b_" + i] = new_b;
        var theta = (ctx["theta_" + i] !== undefined) ? ctx["theta_" + i] : ppl.gaussian_sample(0., 1.)
        ctx["theta_" + i] = theta;
        var new_stick = stick - b * cumprod
        var res = break_stick(ctx, i + 1, alpha, new_stick, new_b, new_cumprod)
        res.weights.push(b * cumprod)
        res.thetas.push(theta)
        return res
    } else {
        return {weights: [], thetas: []}
    }
}

var foreach = function(lst, fn) {
    var foreach_ = function(i) {
        if (i < lst.length) {
            fn(lst[i], i);
            foreach_(i + 1);
        }
    }
    foreach_(0);
};

var model_rec = function(ctx, data) {
    var res = break_stick(ctx, 0, 5., 1., 0., 1.)
    var weights = ppl.Vector(res.weights).div(ppl.sum(res.weights))
    var thetas = res.thetas
    foreach(data, function(x, i) {
        var z = (ctx["z_" + i] !== undefined) ? ctx["z_" + i] : ppl.discrete_sample(weights.data, 1.0)
        ctx["z_" + i] = z
        ctx.lp += ppl.gaussian_score(thetas[z < thetas.length ? z : thetas.length - 1], 0.1, x)

    })

}

var model_data_annealed = function(ctx, i) {
    return model_rec(ctx, xs.slice(0,i))
}

// ctx = {lp: 0.}
// model_data_annealed(ctx, 10)
// console.log(ctx)
// console.log(ctx.lp)

console.time('SMC')
ppl.smc(model_data_annealed, 100, xs.length)
console.timeEnd('SMC')