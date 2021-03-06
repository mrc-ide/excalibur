% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/agesird_Class.R
\name{setAgeSIRD}
\alias{setAgeSIRD}
\title{Produce an age structured SIRD with time-varying Beta values}
\usage{
setAgeSIRD(N, Betas, Gamma, ProbOfDeath, I0, changeTimes = NULL)
}
\arguments{
\item{N}{Total for each age-group population.}

\item{Betas}{Transmission parameter(s), either a 2D matrix or 3D array if
they vary over time.}

\item{Gamma}{Rate of recovery.}

\item{ProbOfDeath}{Probability of death whilst infected, over unit time.}

\item{I0}{Size of initial infected population, should be the same length as N.}

\item{changeTimes}{If Beta is a 2D matrix then the corresponding time-points at
which the Beta values are changed.}
}
\value{
A object of class agesirdModel with odin model code for the same model,
and filled slots for parameters and the initial state.
}
\description{
First section of the function is a wrapper for the internal generator
function for the class agesirdModel. The second part setups up the Odin model in
the odinModel slot with the specified parameter values.
}
\examples{
#Two population model
model <- setAgeSIRD(N = c(100,100), Betas = matrix(c(1,0.5,0.2,1), nrow=2, byrow=TRUE),
Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1))

#time-varying
Betas <- array(NA, dim=c(2,2,2)) #set up array, the first dimension will be time
Betas[1,,] <- matrix(c(1,0.5,
                       0.2,1), nrow=2, byrow = TRUE)
Betas[2,,] <- matrix(c(1,0.1,
                       0,5), nrow=2, byrow = TRUE)
model <- setAgeSIRD(N = c(100,100), Beta = Betas,
Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1), changeTimes = 5)
}
