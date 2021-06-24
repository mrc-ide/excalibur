
#relations
deriv(S[]) <- -S[i]*sum(infectiousWeight[i,])
deriv(I[]) <- S[i]*sum(infectiousWeight[i,]) - I[i]*Gamma - I[i]*Alpha
deriv(R[]) <- I[i]*Gamma
deriv(D[]) <- I[i]*Alpha
#values used in relations
N[] <- S[i] + I[i] + R[i] + D[i]
infectiousWeight[,] <- Betas[i,j]*I[j]/N[j] #frequency dependent transmission
#initial conditions
initial(S[]) <- S0[i]
initial(I[]) <- I0[i]
initial(R[]) <- R0[i]
initial(D[]) <- D0[i]
#parameter values
S0[] <- user()
I0[] <- user()
R0[] <- user()
D0[] <- user()
Betas[,] <- user()
Gamma <- user()
Alpha <- user()
#dimensions
dim(Betas) <- user()
dim(S0) <- user()
dim(I0) <- length(S0)
dim(R0) <- length(S0)
dim(D0) <- length(S0)
dim(S) <- length(S0)
dim(I) <- length(S0)
dim(R) <- length(S0)
dim(D) <- length(S0)
dim(N) <- length(S0)
dim(infectiousWeight) <- c(length(S0),length(S0))
