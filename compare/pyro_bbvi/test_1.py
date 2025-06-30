from bbvi import *
from pyro.optim import Adam, AdagradRMSProp

from torchviz import make_dot

def model():
    x = pyro.sample("x", dist.Normal(1.,0.1))

# m = torch.tensor(0., requires_grad=True)
# s = torch.tensor(0., requires_grad=True)

def guide():
    m = pyro.param("m", torch.tensor(0.))
    s = pyro.param("s", torch.tensor(0.))
    pyro.sample("x", dist.Normal(m, torch.exp(s)).has_rsample_(True))

pyro.set_rng_seed(0)
        
n_iter = 1
L = 1

adam_params = {"lr": 0.005, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)

vi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_Trace_ELBO(num_particles=L), L=L, n_iter=n_iter)

print(vi, vi.loss)
for step in range(n_iter):
    loss = vi.step()


print()

pyro.set_rng_seed(0)
p = dist.Normal(1.,0.1)

m = torch.tensor(0., requires_grad=True)
s = torch.tensor(0., requires_grad=True)
q = dist.Normal(m, torch.exp(s)).has_rsample_(True)

x = q.rsample()
print("x", x)

print("log_q", q.log_prob(x))
print("log_r", p.log_prob(x) - q.log_prob(x))


elbo = p.log_prob(x) - q.log_prob(x)
# elbo = q.log_prob(x)
print("elbo", elbo)
# print(make_dot(elbo, show_attrs=False, show_saved=False))
elbo.backward()
print("advi grads", m.grad, s.grad)
# getBack(elbo.grad_fn)

print()

pyro.set_rng_seed(0)
p = dist.Normal(1.,0.1)

m = torch.tensor(0., requires_grad=True)
s = torch.tensor(0., requires_grad=True)
q = dist.Normal(m, torch.exp(s)).has_rsample_(False)

x = q.sample()
print("x", x)

# since p.log_prob(x) has no params it does not affect gradient
surrogate_elbo = p.log_prob(x) + (p.log_prob(x) - torch_item(q.log_prob(x))) * q.log_prob(x)
print("surrogate elbo", surrogate_elbo)
surrogate_elbo.backward()
print("bbvi grads", m.grad, s.grad)
