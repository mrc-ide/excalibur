#' excalibur: A package for looking at the calibrations in ODE epidemic models
#'
#' The excalibur package is work in progress
#'
#' @section excalibur functions:
#' setSIR: A function that produces a model of the SIR class in odin
#' simulate: A method for simulate to generate results from a models odin code.
#' currentState: Returns the current state of the model, if it has been
#' calculated.
#' calculateCurrentState: Calculates the current state of the model.
#'
#' @docType package
#' @name excalibur
NULL
#general rOxygen comments:
#' @useDynLib excalibur
#' @useDynLib excalibur, .registration = TRUE
#' @importFrom odin odin
NULL
