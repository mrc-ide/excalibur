#' An S4 class to represent generic epidemic models
#'
#' All specific epidemic models should inherit from this class. It is not
#' intended for direct use.
#'
#' @slot odinModel A slot to contain the generated epidemic model produced by odin
#' @noRd
methods::setClass(
  "epiModel",
  contains = "VIRTUAL",
  slots = list(
    odinModel = "environment"
  )
)
