// adapted from https://proceedings.mlr.press/v51/ritchie16.html
// Ritchie et al. 2016. C3: Lightweight Incrementalized MCMC for Probabilistic Programs using Continuations and Callsite Caching
var ppl = require("./ppl.js");


var documents = [
    [4, 3, 5, 4, 3, 3, 3, 3, 3, 4],
    [5, 3, 4, 4, 5, 3, 4, 4, 4, 3, 5],
    [4, 5, 2, 3, 3, 1, 5, 5, 1, 4, 3, 1, 2, 5, 4, 4, 3],
    [5, 4, 2, 4, 5, 3, 4, 1, 4, 4, 3, 2, 1, 2],
    [1, 2, 2, 2, 1, 2, 2, 3, 1, 2, 2],
    [4, 4, 5, 4, 5, 5, 4],
    [3, 5, 4, 4, 4],
    [2, 2, 1, 1, 2, 1, 3, 1, 2, 1, 1, 1, 3, 2, 3, 3],
    [5, 4, 5, 4, 3, 5, 4],
    [2, 2, 2, 1, 3, 2, 1, 3, 1, 3, 1, 1, 2, 1, 2, 2],
    [4, 4, 4, 5, 5, 4], 
    [4, 5, 4],
    [3, 3, 3, 1, 3, 3, 4, 2, 1, 3],
    [4, 4, 5, 4, 4, 4, 3, 4, 3, 4, 5],
    [1, 2, 1, 3, 2, 1, 1, 2, 3, 3, 3],
    [3, 4, 1, 4, 4, 4, 4, 3, 4, 4],
    [1, 2, 2, 3, 3, 1, 1, 4, 1],
    [3, 1, 5, 3, 2, 2, 1, 1, 2, 3],
    [3, 4, 4, 5, 3, 4, 3, 1, 5],
    [5, 5, 3, 3, 4, 5, 3, 3, 3],
    [2, 3, 1, 3, 3, 1, 3, 1, 5, 5], 
    [5, 2, 2, 3, 3, 3, 1, 1],
    [5, 5, 5, 3, 1, 5, 4, 1, 3, 3],
    [3, 3, 4, 2, 5, 1, 3, 5, 2, 5, 5, 2, 1, 3, 3, 5, 3, 5, 3, 3, 5],
    [1, 2, 2, 1, 1, 2, 1, 2, 3, 1, 1]
]

var foreach = function(lst, fn) {
	var foreach_ = function(i) {
		if (i < lst.length) {
			fn(i, lst[i]);
			foreach_(i + 1);
		}
	};
	foreach_(0);
};


var repeat_n = function(n, fn) {
    lst = []
    var repeat_n_ = function(i) {
        if (i < n) {
            lst.push(fn(i));
            repeat_n_(i + 1);
        }
    }
    repeat_n_(0);
    return lst;
};

var model_rec = function(ctx, data) {
	var nTopics = (ctx["K"] !== undefined) ? ctx["K"] : ppl.poisson_sample(2) + 1
	ctx["K"] = nTopics
	var topicDistribPrior = ppl.Vector(repeat_n(nTopics, function(i) { return 1; }));
	var wordDistribPrior = ppl.Vector(repeat_n(5, function(i) { return 1; }));
	var wordDistribs = repeat_n(nTopics, function(i) {
		var theta = (ctx["theta_" + i] !== undefined) ? ctx["theta_" + i] : ppl.dirichlet_sample(wordDistribPrior);
		ctx["theta_" + i] = theta
		return theta
	});
	foreach(data, function(i, doc) {
		var topicDistrib = (ctx["phi_" + i] !== undefined) ? ctx["phi_" + i] : ppl.dirichlet_sample(topicDistribPrior);
		ctx["phi_" + i] = topicDistrib
		foreach(doc, function(j, word) {
			var topic = (ctx["z_" + j] !== undefined) ? ctx["z_" + j] : ppl.discrete_sample(topicDistrib.data, 1.);
			ctx["z_" + j] = topic
			ctx.lp += Math.log(wordDistribs[topic].data[word-1])
		});
	});
	return wordDistribs;
};

var model_data_annealed = function(ctx, n) {
	data = []
	var l = 0;
	for (var i = 0; i < documents.length; i++) {
		if (l + documents[i].length <= n) {
			data.push(documents[i])
			l += documents[i].length
			if (l == n) { break }
		} else {
			data.push(documents[i].slice(0, n-l))
			break
		}
	}
	// console.log(data)
    return model_rec(ctx, data)
}

var N_DATA = 262

// ctx = {lp: 0.}
// model_data_annealed(ctx, 100)
// console.log(ctx)
// console.log(ctx.lp)

// console.time('SMC')
// ppl.smc(model_data_annealed, 100, 262)
// console.timeEnd('SMC')