#' @include epiModel_Class.R
NULL

#' An S4 class to represent an age-structured SIRD epidemic model
#'
#' A class to tell the generic functions to apply SIRD specific methods.
#'
#' @inheritParams epiModelClass
#' @noRd
methods::setClass(
  "agesirdModel",
  contains = "epiModel"
)


#' Produce an age structured SIRD with time-varying Beta values
#'
#' First section of the function is a wrapper for the internal generator
#' function for the class agesirdModel. The second part setups up the Odin model in
#' the odinModel slot with the specified parameter values.
#'
#' @param N Total for each age-group population.
#' @param Betas Transmission parameter(s), either a 2D matrix or 3D array if
#' they vary over time.
#' @param Gamma Rate of recovery.
#' @param ProbOfDeath Probability of death whilst infected, over unit time.
#' @param I0 Size of initial infected population, should be the same length as N.
#' @param changeTimes If Beta is a 2D matrix then the corresponding time-points at
#' which the Beta values are changed.
#' @return A object of class agesirdModel with odin model code for the same model,
#' and filled slots for parameters and the initial state.
#' @examples
#' #Two population model
#' model <- setAgeSIRD(N = c(100,100), Beta = matrix(c(1,0.5,0.2,1), nrow=2),
#' Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1))
#'
#' #time-varying
#' model <- setAgeSIRD(N = c(100,100), Beta = array(c(1,0.5,0.2,1,1/2,0.5,0.2,1/2), dim = rep(2,3)), nrow=2),
#' Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1), changeTimes = 5)
#' @export
setAgeSIRD <- function(N, Betas, Gamma, ProbOfDeath, I0, changeTimes = NULL){
  #set class
  modelObject <- methods::new("agesirdModel")
  #check for incorrect inputs
  if(ProbOfDeath > 1 | ProbOfDeath < 0){
    stop("Probability of death must be between 0 and 1, to convert a rate to a
         probability use 1-exp(-rate)")
  }
  else if(any(c(Betas, Gamma, N, I0, changeTimes) < 0)){
    stop("Inputs must be positive")
  }
  else if(any(c(N, I0)%%1 != 0)){
    stop("N and I0 must be whole numbers")
  }
  else if(length(dim(Betas)) == 2 & (length(N) != dim(Betas)[1] | length(N) != dim(Betas)[2] | length(N) != length(I0))){
    stop("Inconsistent number of dimensions for Betas, N and I0")
  }
  else if(length(dim(Betas)) == 3 & (length(N) != dim(Betas)[2] | length(N) != dim(Betas)[3] | length(N) != length(I0))){
    stop("Inconsistent number of dimensions for Betas, N and I0")
  }
  else if(!is.null(changeTimes)){
    if(length(dim(Betas)) != 3){
      stop("Betas should be an array of 3 dimensions")
    }
    if(!identical(sort(changeTimes),changeTimes)){
      stop("Betas and changeTimes must be in increasing time order")
    }
    else if(dim(Betas)[1] != length(changeTimes) + 1){
      stop("Inconsistent dimensions for Betas and changeTimes")
    }
  }
  #append 0 to change times so that it works with interpolate
  changeTimes <- c(0,changeTimes)
  #if Betas is a matrix we need to convert it into an array with the first dimension
  #of length 1
  if(length(dim(Betas)) == 2){
    Betas <- array(Betas, dim = c(1, nrow(Betas), ncol(Betas)))
  }
  #calculate death rate
  Alpha <- riskToRate(ProbOfDeath)
  #setup odin model
  modelObject@odinModel <- agesirdGenerator$new(
    Betas = Betas,
    changeTimes = changeTimes,
    Gamma = Gamma,
    Alpha = Alpha,
    I0 = I0,
    S0 = N - I0,
    R0 = rep(0,length(N)),
    D0 = rep(0,length(N))
  )
  #put parameters into parameter slot
  modelObject@parameters <- list(
    Betas = Betas,
    changeTimes = changeTimes,
    Gamma = Gamma,
    Alpha = Alpha
  )
  #put initial conditions into slot
  modelObject@initialState <- list(
    S0 = N - I0,
    I0 = I0,
    R0 = rep(0,length(N)),
    D0 = rep(0,length(N)),
    N = N
  )
  #setup currentState slot
  modelObject@currentState <-list(
    t = NULL,
    S = NULL,
    I = NULL,
    R = NULL,
    D = NULL
  )
  #output
  return(modelObject)
}

