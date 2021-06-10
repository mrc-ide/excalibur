#' @include epimodelClass.R
#' @include currentState_generics.R
NULL

#' An S4 method run a realisation of an object of the epiModel class
#'
#' Essentially a wrapper for the run R6 method for the odin model. Also puts the
#' output into a data frame, for easier use.
#'
#' @param object An object of the epiModel class.
#' @param t The times at which to simulate from the given epiModel object, the
#' first time is always taken as the start time.
#' @param tcrit Critical times (?).
#' @return A dataframe of the odin models run output.
#' @examples
#' #set up our model
#' model <- setSIR(N = 10, Beta = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)
#' #run the model with simulate
#' simulate(model, t = seq(1,10))
#' @export
setMethod("simulate", "epiModel",
          function(object, t, tcrit=NULL){
            if(length(t) == 1){
              stop("t must be a vector of length > 1")
            }
            #use odinModel run method
            results <- object@odinModel$run(t, tcrit = tcrit)
            #package as data frame
            results <- as.data.frame(results)
            return(results)
          }
          )
#'
#' @export
setMethod("calculateCurrentState", signature("epiModel"),
          function(epiModel, t){
            epiModel <- calculateDownstreamExponentialNodes(epiModel, t)
            epiModel <- estimateInfectiousNodes(epiModel, t)
            return(epiModel)
          }
)
