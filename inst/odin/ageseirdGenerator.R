
#relations
deriv(S[]) <- -S[i]*sum(infectiousWeight[,i])
deriv(E[]) <- S[i]*sum(infectiousWeight[,i]) - E[i]*Lambda
deriv(I[]) <- E[i]*Lambda - I[i]*Gamma - I[i]*Alpha
deriv(R[]) <- I[i]*Gamma
deriv(D[]) <- I[i]*Alpha
#values used in relations
N[] <- S[i] + E[i] + I[i] + R[i] + D[i]
infectiousWeight[,] <- Beta[i,j]*I[i]/N[i] #frequency dependent transmission
#interpolate the betas
Beta[,] <- interpolate(changeTimes, Betas, "constant")
output(Beta) <- Beta
#initial conditions
initial(S[]) <- S0[i]
initial(E[]) <- E0[i]
initial(I[]) <- I0[i]
initial(R[]) <- R0[i]
initial(D[]) <- D0[i]
#parameter values
S0[] <- user()
E0[] <- user()
I0[] <- user()
R0[] <- user()
D0[] <- user()
changeTimes[] <- user()
Betas[,,] <- user()
Lambda <- user()
Gamma <- user()
Alpha <- user()
#dimensions
dim(Betas) <- user()
dim(S0) <- user()
dim(changeTimes) <- user()
dim(E0) <- length(S0)
dim(I0) <- length(S0)
dim(R0) <- length(S0)
dim(D0) <- length(S0)
dim(S) <- length(S0)
dim(E) <- length(S0)
dim(I) <- length(S0)
dim(R) <- length(S0)
dim(D) <- length(S0)
dim(N) <- length(S0)
dim(infectiousWeight) <- c(length(S0),length(S0))
dim(Beta) <- c(length(S0),length(S0))
