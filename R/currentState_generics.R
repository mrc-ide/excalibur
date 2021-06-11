#' A generic function to call the relevant methods to calculate the current
#' state at a given time based upon some inputs
#'
#' At present only has one method, which is for all objects of class "epiModel".
#'
#' @param epiModel The epidemic model, whose current state is to be calculated.
#' @param ... Any other arguements to provide to the method.
#'
#' @export
setGeneric("calculateCurrentState", function(epiModel, ...){
  standardGeneric("calculateCurrentState")
})
#' A inner function to calculate the states of downstream exponential model
#' compartments.
#'
#' This calculates, for example R and D in an SIRD model.
#'
#' @inheritParams calculateCurrentState
#'
setGeneric("calculateDownstreamExponentialNodes", function(epiModel, ...){
  standardGeneric("calculateDownstreamExponentialNodes")
})
#' A inner function to calculate the states ofnon-exponential model
#' compartments.
#'
#' This calculates, for example S and I in an SIRD model.
#'
#' @inheritParams calculateCurrentState
#'
setGeneric("estimateInfectiousNode", function(epiModel, ...){
  standardGeneric("estimateInfectiousNode")
})
#' A function to return the list of values in the currentState slot of an
#' epimodel object.
#'
#' @param epiModel The epidemic model, whose current state is to be print.
#' @param ... Any other arguements to provide to the method.
#'
#' @export
setGeneric("currentState", function(epiModel, ...){
  standardGeneric("currentState")
})

