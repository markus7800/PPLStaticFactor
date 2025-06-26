// adapted from https://proceedings.mlr.press/v51/ritchie16.html
// Ritchie et al. 2016. C3: Lightweight Incrementalized MCMC for Probabilistic Programs using Continuations and Callsite Caching
var ppl = require("./ppl.js");

var model = {
    transition: [
        [0.1, 0.2, 0.7],
        [0.1, 0.8, 0.1],
        [0.3, 0.3, 0.4]
    ]
}

var ys = [
    3.36, 2.87, 1.54, 1.13, 2.05, 2.55, 3.08, 1.23, 2.37, 2.5,
    1.42, 1.46, 0.65, 1.15, 0.31, 2.89, 0.96, 2.23, 1.55, 1.52,
    2.72, 4.16, 2.4, 2.41, 1.05, 3.05, 2.04, 3.47, 1.08, 0.63,
    3.87, 0.08, 2.06, 2.21, 2.24, 1.77, 0.67, 2.45, 4.05, 2.95,
    1.65, 3.01, 3.74, 1.54, 2.47, 1.54, 3.7, 4.29, 0.93, 1.95
]

var hmmfn = function(ctx, data, n) {
	if (n === 0) {
		return 0; // initial state
	} else {
		var prevState = hmmfn(ctx, data, n-1);
		var state = transition(ctx, prevState, n);
		var obs = data[n-1]
		observation(ctx, state, obs);
		return state;
	}
}

var transition = function(ctx, prevState, i) {
	var x = (ctx["x_" + i] !== undefined) ? ctx["x_" + i] : ppl.discrete_sample(model.transition[prevState], 1.);
	ctx["x_" + i] = x;
	return x;
}

var observation = function(ctx, state, obs) {
    ctx.lp += ppl.gaussian_score(state, 1., obs)
}

var model_data_annealed = function(ctx, i) {
	hmmfn(ctx, ys, i);
}

// ctx = {lp: 0.}
// model_data_annealed(ctx, 10)
// console.log(ctx)
// console.log(ctx.lp)


console.time('SMC')
ppl.smc(model_data_annealed, 100, ys.length)
console.timeEnd('SMC')