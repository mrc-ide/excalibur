#' Internal function to calculate risk from a rate
#' @noRd
rateToRisk <- function(rate){
  risk <- 1-exp(-rate)
  return(risk)
}
#' Internal function to calculate a rate from a risk
#' @noRd
riskToRate <- function(risk){
  rate <- -log(1-risk)
  return(rate)
}
