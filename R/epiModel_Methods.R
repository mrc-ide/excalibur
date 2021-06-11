#' @include epiModel_Class.R
#' @include currentState_Generics.R
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
#' An S4 method to calculate current state of an object of the epiModel class
#'
#' Calls two generic functions to calculate the downstream nodes and esimate
#' the infectious population in turn. These will be specific to each type of
#' epiModel class.
#'
#' @param epiModel The epidemic model, whose current state is to be calculated.
#' @param ... Any other arguements to provide to the method.
#' @return An epiModel of object of the same class as that given.
#' @examples
#' #set up model
#' model <- setSIR(N = 100, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
#' #Set the deaths
#' deaths <- c(10,20)
#' #calculate current state
#' model <- calculateCurrentState(model, deaths)
#' #return the current state
#' currentState(model)
#' @export
setMethod("calculateCurrentState", signature("epiModel"),
          function(epiModel, ...){
            epiModel <- calculateDownstreamExponentialNodes(epiModel, ...)
            epiModel <- estimateInfectiousNode(epiModel, ...)
            return(epiModel)
          }
)
#' An S4 method to return current state of an object of the epiModel class
#'
#' @param epiModel The epidemic model, whose current state is to be returned.
#' @return A list of labelled values.
#' @examples
#' #set up model
#' model <- setSIR(N = 100, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
#' #Set the deaths
#' deaths <- c(10,20)
#' #calculate current state
#' model <- calculateCurrentState(model, deaths)
#' #return the current state
#' currentState(model)
#' @export
setMethod("currentState", signature("epiModel"),
          function(epiModel){
            return(epiModel@currentState)
          }
)
