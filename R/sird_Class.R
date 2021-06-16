#' An S4 class to represent an SIRD epidemic model
#'
#' A class to tell the generic functions to apply SIRD specific methods.
#'
#' @inheritParams epiModelClass
#' @noRd
methods::setClass(
  "sirdModel",
  contains = "epiModel"
)

#' Produce an SIRD with time-varying Beta values
#'
#' First section of the function is a wrapper for the internal generator
#' function for the class sirdModel. The second part setups up the Odin model in
#' the odinModel slot with the specified parameter values.
#'
#' @param N Total population.
#' @param Beta Transmission parameter(s).
#' @param Gamma Rate of recovery.
#' @param ProbOfDeath Instantaneous probability of death whilst infected.
#' @param I0 Size of initial infected population.
#' @param changeTimes If length(Beta)>1 then the corresponding time-points at
#' which the parameters are changed.
#' @return A object of class sirdModel with odin model code for the same model,
#' and filled slots for parameters and the initial state.
#' @examples
#' #Standard SIRD with no deaths
#' model <- setSIRD(N = 10, Beta = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)
#'
#' #SIRD with a 50% probability of death an any time whilst infected
#' model <- setSIRD(N = 10, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
#'
#' #SIRD with time-varying Beta at 10 and 50 days
#' model <- setSIRD(N = 10, Beta = c(5,1,3), Gamma = 1/5, ProbOfDeath = 0.5,
#' I0 = 1, changeTimes = c(10, 50))
#' @export
setSIRD <- function(N, Beta, Gamma, ProbOfDeath, I0, changeTimes = NULL){
  #set class
  modelObject <- methods::new("sirdModel")
  #check for incorrect inputs
  if(ProbOfDeath > 1 | ProbOfDeath < 0){
    stop("Probability of death must be between 0 and 1, to convert a rate to a
         probability use 1-exp(-rate)")
  }
  else if(any(c(Beta, Gamma, N, I0, changeTimes) < 0)){
    stop("Inputs must be positive")
  }
  else if(any(c(N, I0)%%1 != 0)){
    stop("N and I0 must be whole numbers")
  }
  else if(!is.null(changeTimes)){
    if(!identical(sort(changeTimes),changeTimes)){
      stop("Beta and changeTimes must be in increasing time order")
    }
  }
  #append 0 to change times so that it works with interpolate
  changeTimes <- c(0,changeTimes)
  #calculate death rate
  Alpha <- riskToRate(ProbOfDeath)
  #setup odin model
  modelObject@odinModel <- sirdGenerator(
    Betas = Beta,
    changeTimes = changeTimes,
    Gamma = Gamma,
    I0 = I0,
    S0 = N - I0,
    R0 = 0,
    D0 = 0,
    Alpha = Alpha
  )
  #put parameters into parameter slot
  modelObject@parameters <- list(
    Betas = Beta,
    changeTimes = changeTimes,
    Gamma = Gamma,
    Alpha = Alpha
  )
  #put initial conditions into slot
  modelObject@initialState <- list(
    S0 = N - I0,
    I0 = I0,
    R0 = 0,
    D0 = 0
  )
  #output
  return(modelObject)
}
