#' An S4 class to represent an SIR epidemic model
#'
#' A class to tell the generic functions to apply SIR specific methods.
#'
#' @inheritParams epiModelClass
#' @noRd
SIRModelClass <- setClass(
  "sirModel",
  contains = "epiModel"
)

#' Produce an SIR with time-varying Beta values
#'
#' First section of the function is a wrapper for the internal generator
#' function for the class sirModel. The second part setups up the Odin model in
#' the odinModel slot with the specified parameter values.
#'
#' @param N Total population.
#' @param Beta Transmission parameter(s).
#' @param Gamma Rate of recovery.
#' @param ProbOfDeath Instantaneous probability of death whilst infected.
#' @param I0 Size of initial infected population.
#' @param changeTimes If length(Beta)>1 then the corresponding time-points at
#' which the parameters are changed.
#' @export
setSIR <- function(N, Beta, Gamma, ProbOfDeath, I0, changeTimes = NULL){
  #set class
  modelObject <- SIRModelClass()
  #setup odin model
  #output
  return(modelObject)
}
