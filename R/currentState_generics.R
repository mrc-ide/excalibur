#'
#' @export
setGeneric("calculateCurrentState", function(epiModel, t){
  standardGeneric("calculateCurrentState")
})
#'
setGeneric("calculateDownstreamExponentialNodes", function(epiModel, t){
  standardGeneric("calculateDownstreamExponentialNodes")
})
#'
setGeneric("estimateInfectiousNode", function(epiModel, t){
  standardGeneric("estimateInfectiousNode")
})

