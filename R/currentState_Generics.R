#' A generic function to call the relevant methods to calculate the current
#' state at a given time based upon some inputs
#'
#' At present only has one method, which is for all objects of class "epiModel".
#' Before this is called, it assigns the provided time (t) to the list in the
#' slot currentState.
#' @param epiModel The epidemic model, whose current state is to be calculated.
#' @param t The time this state corresponds to, if the initial conditions
#' occured at t=0
#' @param ... Any other arguments to provide to the method.
#'
#' @export
setGeneric("calculateCurrentState", function(epiModel, t, ...){
  epiModel@currentState$t <- t
  standardGeneric("calculateCurrentState")
})
#' A function to calculate the states of downstream exponential model
#' compartments.
#'
#' This calculates, for example R and D in an SIRD model.
#'
#' @inheritParams calculateCurrentState
#' @export
setGeneric("calculateDownstreamExponentialNodes", function(epiModel, ...){
  standardGeneric("calculateDownstreamExponentialNodes")
})
#' A function to calculate the states of non-exponential model
#' compartments.
#'
#' This calculates, for example S and I in an SIRD model.
#'
#' @inheritParams calculateCurrentState
#' @export
setGeneric("estimateInfectiousNode", function(epiModel, ...){
  standardGeneric("estimateInfectiousNode")
})
#' A function to return the list of values in the currentState slot of an
#' epimodel object.
#'
#' @param epiModel The epidemic model, whose current state is to be print.
#' @param ... Any other arguments to provide to the method.
#'
#' @export
setGeneric("currentState", function(epiModel, ...){
  standardGeneric("currentState")
})

