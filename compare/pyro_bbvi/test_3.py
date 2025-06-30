from bbvi import *
from pyro.optim import Adam

from torchviz import make_dot

def model():
    x = pyro.sample("x", dist.Normal(1.,1.))
    y = pyro.sample("y", dist.Normal(x,0.5))
    z = pyro.sample("z", dist.Normal(y,0.5), obs=torch.tensor(1.))

def guide():
    x = continuous_vd("x", 1)
    y = continuous_vd("y", 1)

pyro.set_rng_seed(0)
        
n_iter = 1
L = 1

adam_params = {"lr": 0.005, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)

vi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_TraceGraph_ELBO(num_particles=L), L=L, n_iter=n_iter)

print(vi, vi.loss)
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

x = qx.sample()
print("x", x, "qx", qx.log_prob(x), "px", dist.Normal(1.,1.).log_prob(x), "py")
y = qy.sample()
print("y", y, "qy", qy.log_prob(y), "py", dist.Normal(x, 0.5).log_prob(y), "pz", dist.Normal(y, 0.5).log_prob(torch.tensor(1.)))

surrogate_elbo = (
    dist.Normal(1.,1.).log_prob(x) + dist.Normal(x, 0.5).log_prob(y) + dist.Normal(y, 0.5).log_prob(torch.tensor(1.)) +
    (qx.log_prob(x) * torch_item(dist.Normal(1.,1.).log_prob(x) + dist.Normal(x, 0.5).log_prob(y) - qx.log_prob(x))) +
    (qy.log_prob(y) * torch_item(dist.Normal(x, 0.5).log_prob(y) + dist.Normal(y, 0.5).log_prob(torch.tensor(1.)) - qy.log_prob(y)))
)

print("surrogate elbo", surrogate_elbo)
surrogate_elbo.backward()
print("bbvi grads", mx.grad, sx.grad, my.grad, sy.grad)
