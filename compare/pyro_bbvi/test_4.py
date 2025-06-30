from bbvi import *
from pyro.optim import Adam

def model():
    x = pyro.sample("x", dist.Normal(1.,1.))
    y = pyro.sample("y", dist.Normal(x,0.5))
    z = pyro.sample("z", dist.Normal(y,0.5))
    a = pyro.sample("a", dist.Normal(x,0.5))
    b = pyro.sample("b", dist.Normal(a,0.5))

def guide():
    continuous_vd("x", 1)
    continuous_vd("y", 1)
    continuous_vd("z", 1)
    continuous_vd("a", 1)
    continuous_vd("b", 1)

pyro.set_rng_seed(0)
        
n_iter = 1
L = 1

adam_params = {"lr": 0.005, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)

vi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_TraceGraph_ELBO(num_particles=L), L=L, n_iter=n_iter)
for step in range(n_iter):
    loss = vi.step()
print()


pyro.set_rng_seed(0)

mx = torch.tensor(0., requires_grad=True)
sx = torch.tensor(0., requires_grad=True)
qx = dist.Normal(mx, torch.exp(sx)).has_rsample_(False)

my = torch.tensor(0., requires_grad=True)
sy = torch.tensor(0., requires_grad=True)
qy = dist.Normal(my, torch.exp(sy)).has_rsample_(False)

mz = torch.tensor(0., requires_grad=True)
sz = torch.tensor(0., requires_grad=True)
qz = dist.Normal(mz, torch.exp(sz)).has_rsample_(False)

ma = torch.tensor(0., requires_grad=True)
sa = torch.tensor(0., requires_grad=True)
qa = dist.Normal(ma, torch.exp(sa)).has_rsample_(False)

mb = torch.tensor(0., requires_grad=True)
sb = torch.tensor(0., requires_grad=True)
qb = dist.Normal(mb, torch.exp(sb)).has_rsample_(False)

x = qx.sample()
y = qy.sample()
z = qz.sample()
a = qa.sample()
b = qb.sample()

surrogate_elbo = (
    (dist.Normal(1.,1.).log_prob(x) + dist.Normal(x, 0.5).log_prob(y) + dist.Normal(y, 0.5).log_prob(z) + dist.Normal(x, 0.5).log_prob(a) + dist.Normal(a, 0.5).log_prob(b)) +
    (qx.log_prob(x) * torch_item(dist.Normal(1.,1.).log_prob(x) + dist.Normal(x, 0.5).log_prob(y) + dist.Normal(x, 0.5).log_prob(a) - qx.log_prob(x))) +
    (qy.log_prob(y) * torch_item(dist.Normal(x, 0.5).log_prob(y) + dist.Normal(y, 0.5).log_prob(z) - qy.log_prob(y))) +
    (qz.log_prob(z) * torch_item(dist.Normal(y, 0.5).log_prob(z) - qz.log_prob(z))) +
    (qa.log_prob(a) * torch_item(dist.Normal(x, 0.5).log_prob(a) + dist.Normal(a, 0.5).log_prob(b) - qa.log_prob(a))) +
    (qb.log_prob(b) * torch_item(dist.Normal(a, 0.5).log_prob(b) - qb.log_prob(b)))
)

print("surrogate elbo", surrogate_elbo)
surrogate_elbo.backward()
print("bbvi grads", "x", mx.grad, sx.grad, "y", my.grad, sy.grad, "z", mz.grad, sz.grad, "a", ma.grad, sa.grad, "b", mb.grad, sb.grad)
