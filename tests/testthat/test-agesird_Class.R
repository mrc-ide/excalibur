library(excalibur)

test_that("Class definitions", {
  testModel <- setAgeSIRD(N=c(10,10), Betas=matrix(c(1,1/2,
                                                     1/2,1),
                                                  nrow = 2,
                                                  byrow = TRUE),
                          Gamma=3, ProbOfDeath=0.5, I0=c(1,0))

  expect_true(is.environment(testModel@odinModel))
  expect_true(is.list(testModel@currentState))
  expect_true(is.list(testModel@initialState))
  expect_true(is.list(testModel@parameters))
  expect_s4_class(testModel, "agesirdModel")
  expect_error(testModel@odinModel <- 1)
  expect_error(testModel@odinModel <- "a")
  expect_error(testModel@odinModel <- testModel)
  expect_error(testModel@currentState <- 1)
  expect_error(testModel@currentState <- "a")
  expect_error(testModel@currentState <- testModel)
})

test_that("odinModel Assignment", {
  testModel <- setAgeSIRD(N=c(10,10), Betas=matrix(c(1,1/2,
                                                    1/2,1),
                                                  nrow = 2,
                                                  byrow = TRUE),
                          Gamma=3, ProbOfDeath=0.5, I0=c(1,0))

  expect_true(is.double(testModel@odinModel$initial(t=0)))
})

test_that("initialState Assignment", {
  testModel <- setAgeSIRD(N=c(10,100), Betas=matrix(c(1,1/2,
                                                    1/2,1),
                                                  nrow = 2,
                                                  byrow = TRUE),
                          Gamma=3, ProbOfDeath=0.5, I0=c(1,0))

  expect_equal(testModel@initialState$S0, c(10 - 1, 100))
  expect_equal(testModel@initialState$I0, c(1, 0))
  expect_equal(testModel@initialState$R0, c(0,0))
  expect_equal(testModel@initialState$D0, c(0,0))
})

test_that("parameters Assignment", {
  testModel <- setAgeSIRD(N=c(10,10), Betas=matrix(c(1,1/2,
                                                    1/2,1),
                                                  nrow = 2,
                                                  byrow = TRUE),
                          Gamma=3, ProbOfDeath=0.5, I0=c(1,0))

  expect_equal(testModel@parameters$Betas, matrix(c(1,1/2,
                                                    1/2,1),
                                                  nrow = 2,
                                                  byrow = TRUE))
  #expect_equal(testModel@parameters$changeTimes, 0)
  expect_equal(testModel@parameters$Gamma, 3)
  expect_equal(testModel@parameters$Alpha, excalibur:::riskToRate(0.5))
})

test_that("Input restrictions", {

  expect_error(setAgeSIRD(N = c("100","10"), Betas = diag(c(1,1)), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setAgeSIRD(N = c(100, 10), Betas = diag(c(1,1)), Gamma = 1, ProbOfDeath = 1.5, I0 = 1, changeTimes=NULL))
  expect_error(setAgeSIRD(N = c(100, 10), Betas = diag(c(-1,1)), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setAgeSIRD(N = c(100.5, 10), Betas = diag(c(1,1)), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setAgeSIRD(N = c(100, 10), Betas = diag(c(1,1)), Gamma = c(1,2), ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setAgeSIRD(N = c(100, 10), Betas = diag(c(1,1,1)), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setAgeSIRD(N = c(100, 10, 100), Betas = diag(c(1,1)), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  #expect_error(setAgeSIRD(N = c(100, 10), Betas = c(1,2,3), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=c(4,5,6)))
  #expect_error(setAgeSIRD(N = c(100, 10), Betas = c(1,2,3), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=c(5,4)))

})

test_that("Odin Model Functionality under different inputs",{
  N <- c(10,100)
  Gamma <- 1
  ProbOfDeath <- 0.1
  I0 <- c(1,0)
  expect_true(is.double(setAgeSIRD(N = N, Betas = matrix(c(1,2,
                                                          1/2,1), nrow = 2, byrow = FALSE),
                                   Gamma = Gamma,
                                   ProbOfDeath = ProbOfDeath,
                                   I0 = I0,
                                   changeTimes=NULL)@odinModel$run(c(1,10,100))))
})

test_that("Odin Model functionality in extreme scenarios",{

  #No prob of death -> no deaths
  expect_equal(as.numeric(setAgeSIRD(N = c(100,100), Betas = matrix(c(1,2,
                                                                  1/2,1),
                                                                nrow = 2,
                                                                byrow = FALSE),
                                  Gamma = 1,
                                  ProbOfDeath = 0,
                                  I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"D[1]"]), 0)
  #No recovery/death + high transmission -> no susceptible
  expect_equal(as.numeric(setAgeSIRD(N = c(100,100), Betas = matrix(c(1,2,
                                                                  1/2,1),
                                                                nrow = 2,
                                                                byrow = FALSE),
                                  Gamma = 0,
                                  ProbOfDeath = 0,
                                  I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"I[1]"]), 100)
  #No transmission -> no reduction in S
  expect_equal(as.numeric(setAgeSIRD(N = c(100,100), Betas = diag(c(0,0)),
                                     Gamma = 1,
                                     ProbOfDeath = 0.1,
                                     I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"S[1]"]), 99)
  #no transmission between groups, no infections in 2nd group
  expect_equal(as.numeric(setAgeSIRD(N = c(100,100), Betas = diag(c(1,2)),
                                     Gamma = 1,
                                     ProbOfDeath = 0.1,
                                     I0 = c(1,0), changeTimes=NULL)@odinModel$run(c(1,100))[2,"S[2]"]), 100)
})

#test_that("Odin Model time varying beta functionality",{
#
#  #base
#  expect_equal(setSIRD(N = 100, Beta = 1, Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,100))[,"Beta"], rep(1,2))
#  #Two Betas
#  expect_equal(setSIRD(N = 100, Beta = c(1,0.5), Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=c(50))@odinModel$run(c(1,100))[,"Beta"], c(1,0.5))
#  #Two Betas, evaluated at change time
#  expect_equal(setSIRD(N = 100, Beta = c(1,0.5), Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=c(50))@odinModel$run(c(1,50))[,"Beta"], c(1,0.5))
#  #three Betas
#  expect_equal(setSIRD(N = 100, Beta = c(1,0.5,7), Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=c(25,75))@odinModel$run(c(1,50,100))[,"Beta"], c(1,0.5,7))
#})

