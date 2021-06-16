#' @noRd
methods::setClass("odin_model")
#' An S4 class to represent generic epidemic models
#'
#' All specific epidemic models should inherit from this class. It is not
#' intended for direct use.
#'
#' @slot odinModel A slot to contain the generated epidemic model produced by odin
#' @slot currentState The values of the compartments at the current state
#' @slot initialState The values of the compartments at t=0, the initial state
#' @slot parameters The values of the parameters, and the times at which they change
#' @noRd
methods::setClass(
  "epiModel",
  contains = "VIRTUAL",
  slots = list(
    odinModel = "odin_model",
    currentState = "list",
    initialState = "list",
    parameters = "list"
  )
)
