
#relations
deriv(S) <- -Beta*S*I/N #frequency dependent transmission
deriv(E) <- Beta*S*I/N - E*Lambda
deriv(I) <- E*Lambda - I*Gamma - I*Alpha
deriv(R) <- I*Gamma
deriv(D) <- I*Alpha
Beta <- interpolate(changeTimes, Betas, "constant")
output(Beta) <- Beta
N <- S + E + I + R + D
#initial conditions
initial(S) <- S0
initial(E) <- E0
initial(I) <- I0
initial(R) <- R0
initial(D) <- D0
#parameter values
S0 <- user()
E0 <- user(0)
I0 <- user()
R0 <- user(0)
D0 <- user(0)
Betas[] <- user()
changeTimes[] <- user()
Lambda <- user()
Gamma <- user()
Alpha <- user() #calculate rate of death from probability of death 0.1
#dimensions
dim(Betas) <- user()
dim(changeTimes) <- length(Betas)
