#' An S4 method to calculate current state of an object of the sirdModel class
#'
#' Calls two generic functions to calculate the downstream nodes and estimate
#' the infectious population in turn.
#'
#' @param epiModel An sird model, whose current state is to be calculated.
#' @param deaths The total death count for this model, up to each of the
#' changeTimes so far.
#' @return An sirdModel object.
#' @examples
#' #set up model
#' model <- setSIRD(N = 100, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
#' #Set the deaths
#' deaths <- 20
#' time <- 10
#' #calculate current state
#' model <- calculateCurrentState(model, time, deaths)
#' #return the current state
#' currentState(model)
#' @export
setMethod("calculateCurrentState", signature("sirdModel"),
          function(epiModel, deaths){
            epiModel <- calculateDownstreamExponentialNodes(epiModel, deaths)
            epiModel <- estimateInfectiousNode(epiModel, deaths)
            return(epiModel)
          }
)
#' An S4 method to calculate current state of R and D for an SIRD/SEIRD when
#' provided with a count of the total number of deaths.
#'
#' Please note that this method does not guarantee that this state would be
#' generated by the model, given its initial conditions.
#' Calculates the number of people in the recovered state by scaling D by the
#' rate of recovery divided by the rate of death.
#' These values are then stored in the list in the slot "currentState".
#'
#' @param epiModel The epidemic model of class SIRD to have the current
#' state of R and D calculated.
#' @param deaths The total death count for this model, so far.
#' @return An object of class sirdModel with the values for D and
#' R updated for the current state.
#' @examples
#' #create example model
#' model <- setSIRD(N = 100, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
#' #Set the deaths (only one entry is required)
#' deaths <- 20
#' #call this function
#' model <- excalibur::calculateDownstreamExponentialNodes(model, deaths=deaths)
#'
#' currentState(model)
#' @export
setMethod("calculateDownstreamExponentialNodes", signature("sirdModel"),
          function(epiModel, deaths){
            totalDeaths <- deaths[length(deaths)]
            #check for errors
            sird_Methods_errorChecks(epiModel, deaths, totalDeaths)
            #Get model parameters
            Alpha <- epiModel@parameters$Alpha
            Gamma <- epiModel@parameters$Gamma
            D0 <- epiModel@initialState$D0
            R0 <- epiModel@initialState$R0
            #Calculate the number of recoveries
            R <- (totalDeaths - D0) * Gamma/Alpha + R0
            #Assigning
            epiModel@currentState$D <- totalDeaths
            epiModel@currentState$R <- R
            return(epiModel)
          }
)
#' An S4 method to estimate current state of S and I for an SIRD when provided
#' with a total count of deaths so far
#'
#' Please note that this method does not guarantee that this state would be
#' generated by the model, given its initial conditions.
#' Due to rounding etc, when the value of I would be very small the estimated I
#' will be quite different from the one generated when the model is simulated.
#' These values are then stored in the list in the slot "currentState".
#'
#' @param epiModel The epidemic model of class SIRD to have the current state of
#' S and I estimated.
#' @param deaths The total death count for this model, up to each of the
#' changeTimes so far.
#' @return An object of class sirdModel with the values for S and I updated
#' for the current state.
#' @examples
#' #create example model
#' model <- setSIRD(N = 100, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
#' #Set the deaths (only one entry is required)
#' deaths <- 20
#' #Set the time, makes no difference to this calculation, only used for simulate
#' time <- 10
#' #call this + the D+R node function
#' model <- calculateCurrentState(model, time, deaths)
#'
#' #check S and I
#' currentState(model)
#'
#' #model with time-varying Beta
#' model <- setSIRD(N = 100, Beta = c(2,1/2), Gamma = 1/5, ProbOfDeath = 0.5,
#'  I0 = 1, changeTimes = 5)
#' #Set the deaths, two entries are required now
#' deaths <- c(20,30)
#' time <- 10
#' #the model assumes that the first number 20 is the number of deaths up to the
#' #specified change time 5, and that the last number 30 is the number of deaths
#' #up to the current time (10).
#' #if the current state is not past 5, then we would set deaths <- c(20,20)
#'
#' #call this + the D+R node function
#' model <- calculateCurrentState(model, t=time, deaths=deaths)
#'
#' #check S and I
#' currentState(model)
#'
#' @export
setMethod("estimateInfectiousNode", signature("sirdModel"),
          function(epiModel, deaths){
            #check for errors in death specification
            sird_Methods_errorChecks(epiModel, deaths, deaths[length(deaths)])
            #get model parameters
            Alpha <- epiModel@parameters$Alpha
            Gamma <- epiModel@parameters$Gamma
            Beta <- epiModel@parameters$Betas
            changeTimes <- epiModel@parameters$changeTimes
            S0 <- epiModel@initialState$S0
            I0 <- epiModel@initialState$I0
            R0 <- epiModel@initialState$R0
            D0 <- epiModel@initialState$D0
            N <- epiModel@initialState$N
            #more errors checks
            if(length(deaths) != length(Beta) | length(deaths) != length(changeTimes)){
              stop("'deaths' should be a cumulative time series counting the
                      total number of deaths upto a change time for Beta. This
                      means that length(deaths) = length(Beta) = length(changeTimes) - 1.")
            }
            else if(any(deaths < D0)){
              stop("'deaths' is lower than the initial number of deaths D0")
            }
            #add initial states and changes over each beta value
            newD <- diff(c(D0, deaths))
            #Calculate S
            S <- S0 * exp(
              sum(-newD * Beta) #Beta times the reduction in S+I whilst it is
              #in use
              /(N*Alpha) #divide through
            )
            #Calculate I
            I <- N - S - epiModel@currentState$R - epiModel@currentState$D
            #assign to list
            #Assigning
            epiModel@currentState$S <- S
            epiModel@currentState$I <- I
            return(epiModel)
          }
)
#' Internal function to run repeat error checks for the SIRd methods
#' @noRd
sird_Methods_errorChecks <- function(epiModel, deaths, totalDeaths){
  #checking deaths are in the correct format
  if(any(deaths>totalDeaths) |
    !is.numeric(deaths)){
    stop("deaths must be a series of the cumulative number of deaths up to this time.")
  }
  #checking there are not more deaths than people in model
  if(totalDeaths > epiModel@odinModel$contents()$S0 +
     epiModel@odinModel$contents()$I0 +
     epiModel@odinModel$contents()$R0 +
     epiModel@odinModel$contents()$D0){
    stop("deaths exceeds model population (N)")
  }
  #if prob of death  = 0
  if(epiModel@odinModel$contents()$Alpha == 0){
    stop("Since there is no chance of death in this model, it cannot
                   be fit using death data.")
  }
}

