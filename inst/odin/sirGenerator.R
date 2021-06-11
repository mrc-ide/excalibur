
#relations
deriv(S) <- -beta*S*I/N #frequency dependent transmission
deriv(I) <- beta*S*I/N - I*gamma - I*alpha
deriv(R) <- I*gamma
deriv(D) <- I*alpha
beta <- interpolate(ct, betas, "constant")
output(beta) <- beta
N <- S + I + R + D
#initial conditions
initial(S) <- S0
initial(I) <- I0
initial(R) <- R0
initial(D) <- D0
#parameter values
S0 <- user()
I0 <- user()
R0 <- user(0)
D0 <- user(0)
betas[] <- user()
ct[] <- user()
gamma <- user()
pDeath <- user()
alpha <- -log(1-pDeath) #calculate rate of death from probability of death 0.1
#dimensions
dim(betas) <- user()
dim(ct) <- length(betas)
