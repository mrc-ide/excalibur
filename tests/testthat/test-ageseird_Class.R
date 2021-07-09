library(excalibur)

test_that("Class definitions", {
  testModel <- setAgeSEIRD(N=c(10,10), Betas=matrix(c(1,1/2,
                                                     1/2,1),
                                                   nrow = 2,
                                                   byrow = TRUE),
                          Gamma=3, Lambda = 1/2, ProbOfDeath=0.5, I0=c(1,0))

  expect_true(is.environment(testModel@odinModel))
  expect_true(is.list(testModel@currentState))
  expect_true(is.list(testModel@initialState))
  expect_true(is.list(testModel@parameters))
  expect_s4_class(testModel, "ageseirdModel")
  expect_error(testModel@odinModel <- 1)
  expect_error(testModel@odinModel <- "a")
  expect_error(testModel@odinModel <- testModel)
  expect_error(testModel@currentState <- 1)
  expect_error(testModel@currentState <- "a")
  expect_error(testModel@currentState <- testModel)
})

test_that("odinModel Assignment", {
  testModel <- setAgeSEIRD(N=c(10,10), Betas=matrix(c(1,1/2,
                                                     1/2,1),
                                                   nrow = 2,
                                                   byrow = TRUE),
                          Gamma=3, Lambda = 1/2, ProbOfDeath=0.5, I0=c(1,0))

  expect_true(is.double(testModel@odinModel$initial(t=0)))
})

test_that("initialState Assignment", {
  testModel <- setAgeSEIRD(N=c(10,100), Betas=matrix(c(1,1/2,
                                                      1/2,1),
                                                    nrow = 2,
                                                    byrow = TRUE),
                          Gamma=3, Lambda = 1/2, ProbOfDeath=0.5, I0=c(1,0))

  expect_equal(testModel@initialState$S0, c(10 - 1, 100))
  expect_equal(testModel@initialState$I0, c(1, 0))
  expect_equal(testModel@initialState$R0, c(0,0))
  expect_equal(testModel@initialState$D0, c(0,0))
  expect_equal(testModel@initialState$E0, c(0,0))
})

test_that("parameters Assignment", {
  testModel <- setAgeSEIRD(N=c(10,10), Betas=matrix(c(1,1/2,
                                                     1/2,1),
                                                   nrow = 2,
                                                   byrow = TRUE),
                          Gamma=3, Lambda = 1/2, ProbOfDeath=0.5, I0=c(1,0))

  expect_equal(testModel@parameters$Betas, array(matrix(c(1,1/2,
                                                          1/2,1),
                                                        nrow = 2,
                                                        byrow = TRUE),
                                                 dim = c(1,2,2)))
  expect_equal(testModel@parameters$changeTimes, 0)
  expect_equal(testModel@parameters$Gamma, 3)
  expect_equal(testModel@parameters$Lambda, 1/2)
  expect_equal(testModel@parameters$Alpha, excalibur:::riskToRate(0.5))
})

test_that("Input restrictions", {

  expect_error(setAgeSEIRD(N = c("100","10"), Betas = diag(c(1,1)), Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=NULL))
  expect_error(setAgeSEIRD(N = c(100, 10), Betas = diag(c(1,1)), Gamma = 1, Lambda = 1/2, ProbOfDeath = 1.5, I0 = c(1,0), changeTimes=NULL))
  expect_error(setAgeSEIRD(N = c(100, 10), Betas = diag(c(-1,1)), Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=NULL))
  expect_error(setAgeSEIRD(N = c(100.5, 10), Betas = diag(c(1,1)), Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=NULL))
  expect_error(setAgeSEIRD(N = c(100, 10), Betas = diag(c(1,1)), Gamma = c(1,2), Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=NULL))
  expect_error(setAgeSEIRD(N = c(100, 10), Betas = diag(c(1,1,1)), Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=NULL))
  expect_error(setAgeSEIRD(N = c(100, 10, 100), Betas = diag(c(1,1)), Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=NULL))
  #set up betas array
  Betas <- array(NA, dim=c(2,2,2))
  Betas[1,,] <- diag(c(1,1))
  Betas[2,,] <- diag(c(0,1))
  expect_error(setAgeSEIRD(N = c(100, 10), Betas = Betas, Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=c(4,5,6)))
  Betas <- array(NA, dim=c(3,2,2))
  Betas[1,,] <- diag(c(1,1))
  Betas[2,,] <- diag(c(0,1))
  Betas[3,,] <- diag(c(10,100))
  expect_error(setAgeSEIRD(N = c(100, 10), Betas = Betas, Gamma = 1, Lambda = 1/2, ProbOfDeath = 0.1, I0 = c(1,0), changeTimes=c(5,4)))
})

test_that("Odin Model Functionality under different inputs",{
  N <- c(10,100)
  Gamma <- 1
  ProbOfDeath <- 0.1
  I0 <- c(1,0)
  expect_true(is.double(setAgeSEIRD(N = N, Betas = matrix(c(1,2,
                                                           1/2,1), nrow = 2, byrow = FALSE),
                                   Gamma = Gamma,
                                   Lambda = 1/2,
                                   ProbOfDeath = ProbOfDeath,
                                   I0 = I0,
                                   changeTimes=NULL)@odinModel$run(c(1,10,100))))
})

test_that("Odin Model functionality in extreme scenarios",{

  #No prob of death -> no deaths
  expect_equal(as.numeric(setAgeSEIRD(N = c(100,100), Betas = matrix(c(1,2,
                                                                      1/2,1),
                                                                    nrow = 2,
                                                                    byrow = FALSE),
                                      Lambda = 1/2,
                                     Gamma = 1,
                                     ProbOfDeath = 0,
                                     I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"D[1]"]), 0)
  #no E to I, no infecteds
  expect_equal(as.numeric(setAgeSEIRD(N = c(100,100), Betas = matrix(c(1,2,
                                                                       1/2,1),
                                                                     nrow = 2,
                                                                     byrow = FALSE),
                                      Lambda = 0,
                                      Gamma = 1,
                                      ProbOfDeath = 0.1,
                                      I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"I[1]"]), 0)
  #No recovery/death + high transmission -> no susceptible
  expect_equal(as.numeric(setAgeSEIRD(N = c(100,100), Betas = matrix(c(1,2,
                                                                      1/2,1),
                                                                    nrow = 2,
                                                                    byrow = FALSE),
                                      Lambda = 1/2,
                                     Gamma = 0,
                                     ProbOfDeath = 0,
                                     I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"I[1]"]), 100)
  #No transmission -> no reduction in S
  expect_equal(as.numeric(setAgeSEIRD(N = c(100,100), Betas = diag(c(0,0)),
                                      Lambda = 1/2,
                                     Gamma = 1,
                                     ProbOfDeath = 0.1,
                                     I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"S[1]"]), 99)
  #no transmission between groups, no infections in 2nd group
  expect_equal(as.numeric(setAgeSEIRD(N = c(100,100), Betas = diag(c(1,2)),
                                      Lambda = 1/2,
                                     Gamma = 1,
                                     ProbOfDeath = 0.1,
                                     I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"S[2]"]), 100)
})

test_that("Odin Model time varying beta functionality",{
  #base
  baselines_Betas <- matrix(c(1,1/2,
                              1/2,1),
                            nrow = 2,
                            byrow = TRUE)
  baseline <- setAgeSEIRD(N=c(10,10), Betas=baselines_Betas,
                         Gamma=1, Lambda = 1/2, ProbOfDeath=0.1, I0=c(1,0))@odinModel$run(c(1,10))[2,"R[1]"]
  #now with a lesser beta that starts at t = 5 we would expect less recoveries
  Betas <-array(NA, dim=c(2,2,2))
  Betas[1,,] <- baselines_Betas
  Betas[2,,] <- baselines_Betas/10
  changeTimes <- 5
  expect_lt(setAgeSEIRD(N=c(10,10), Betas=Betas, Gamma=1, Lambda = 1/2, ProbOfDeath=0.1,
                       I0=c(1,0), changeTimes = changeTimes)@odinModel$run(c(1,10))[2,"R[1]"], baseline)
  #now if we have an increased beta
  Betas[2,,] <- baselines_Betas*10
  expect_gt(setAgeSEIRD(N=c(10,10), Betas=Betas,Gamma=1, Lambda = 1/2, ProbOfDeath=0.1,
                       I0=c(1,0), changeTimes = changeTimes)@odinModel$run(c(1,10))[2,"R[1]"], baseline)
})

