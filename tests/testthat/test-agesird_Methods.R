test_that("calculateCurrentState - Compare to known results", {
  model <- setAgeSIRD(N = c(100,100), Betas = matrix(c(1,0.5,0.2,1), nrow=2, byrow=TRUE),
                       Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1))

  #simulate a result
  time <- 10
  results <- simulate(model, t = time)
  infected <- results[,names(results) %in% c("I[1]", "I[2]")]
  susceptible <- results[,names(results) %in% c("S[1]", "S[2]")]
  recovered <- results[,names(results) %in% c("R[1]", "R[2]")]
  deaths <- results[,names(results) %in% c("D[1]", "D[2]")]
  #estimate
  model <- calculateCurrentState(model, time, deaths)
  current <- currentState(model)
  estInfected <- current[,names(current) %in% c("I[1]", "I[2]")]
  estSusceptible <- current[,names(current) %in% c("S[1]", "S[2]")]
  estRecovered <- current[,names(current) %in% c("R[1]", "R[2]")]
  #compare
  accuracy <- 0.01 #allow leway due to round etc.
  expect_true(all(abs(estInfected - infected)/infected < accuracy))
  expect_true(all(abs(estSusceptible - susceptible)/susceptible < accuracy))
  expect_true(all(abs(estRecovered - recovered)/recovered < accuracy))


  Betas <- array(NA, dim=c(2,2,2)) #set up array, the first dimension will be time
  Betas[1,,] <- matrix(c(1,0.5,
                        0.2,1), nrow=2, byrow = TRUE)
  Betas[2,,] <- matrix(c(1,0.1,
                          0,5), nrow=2, byrow = TRUE)
  model <- setAgeSIRD(N = c(100,100), Beta = Betas,
                       Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1), changeTimes = 5)

  #simulate a result
  time <- 10
  results <- simulate(model, t = c(5,time))
  infected <- results[2,names(results) %in% c("I[1]", "I[2]")]
  susceptible <- results[2,names(results) %in% c("S[1]", "S[2]")]
  recovered <- results[2,names(results) %in% c("R[1]", "R[2]")]
  deaths <- results[,names(results) %in% c("D[1]", "D[2]")]
  #estimate
  model <- calculateCurrentState(model, time, deaths)
  current <- currentState(model)
  estInfected <- current[,names(current) %in% c("I[1]", "I[2]")]
  estSusceptible <- current[,names(current) %in% c("S[1]", "S[2]")]
  estRecovered <- current[,names(current) %in% c("R[1]", "R[2]")]
  #compare
  accuracy <- 0.01 #allow leway due to round etc.
  expect_true(all(abs(estInfected - infected)/infected < accuracy))
  expect_true(all(abs(estSusceptible - susceptible)/susceptible < accuracy))
  expect_true(all(abs(estRecovered - recovered)/recovered < accuracy))
})

test_that("calculateCurrentState - errors", {
  expect_error(calculateCurrentState(setAgeSIRD(N = c(100,100), Betas = matrix(c(1,0.5,0.2,1), nrow=2, byrow=TRUE),
             Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1)), 10,
             deaths =
               matrix(1, nrow = 2, ncol = 2)))

  expect_error(calculateCurrentState(setAgeSIRD(N = c(100,100), Betas = matrix(c(1,0.5,0.2,1), nrow=2, byrow=TRUE),
                                   Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1)), 10,
                        deaths =
                          matrix(1, nrow = 1, ncol = 3)))

  expect_error(suppressWarnings(calculateCurrentState(setAgeSIRD(N = c(100,100), Betas = matrix(c(1,0.5,0.2,1), nrow=2, byrow=TRUE),
                                   Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1)), 10,
                        deaths = matrix("a", nrow = 1, ncol = 2))))


  expect_error(calculateCurrentState(setAgeSIRD(N = c(100,100), Betas = matrix(c(1,0.5,0.2,1), nrow=2, byrow=TRUE),
                                   Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1)), 10,
                        deaths = matrix(c(10,150), nrow = 1, ncol = 2)))

  Betas <- array(NA, dim=c(2,2,2)) #set up array, the first dimension will be time
  Betas[1,,] <- matrix(c(1,0.5,
                         0.2,1), nrow=2, byrow = TRUE)
  Betas[2,,] <- matrix(c(1,0.1,
                         0,5), nrow=2, byrow = TRUE)
  model <- setAgeSIRD(N = c(100,100), Beta = Betas,
                      Gamma = 1/5, ProbOfDeath = 1/20, I0 = c(1,1), changeTimes = 5)

  expect_error(calculateCurrentState(model, 10,
                        deaths = matrix(
                          c(
                          10,70), nrow = 1, ncol = 2)))

  model@initialState$D0 <- c(10,10)

  expect_error(calculateCurrentState(model, 10,
                        deaths = matrix(
                          c(5,60,
                            10,70), nrow = 2, ncol = 2)))
})
