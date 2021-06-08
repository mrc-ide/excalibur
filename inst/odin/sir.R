
#relations
deriv(S) <- -beta*S*I/N #frequency dependent transmission
deriv(I) <- beta*S*I/N - I*gamma - I*alpha
deriv(R) <- I*gamma
deriv(D) <- I*alpha
beta <- interpolate(ct, betas, "constant")
output(beta) <- beta
#initial conditions
initial(S) <- N - I0
initial(I) <- I0
initial(R) <- 0
initial(D) <- 0
#parameter values
N <- user()
I0 <- user()
betas[] <- user()
ct[] <- user()
gamma <- user()
pDeath <- user()
alpha <- -log(1-pDeath) #calculate rate of death from probability of death 0.1
#dimensions
dim(betas) <- user()
dim(ct) <- length(betas)
