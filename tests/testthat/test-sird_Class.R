library(excalibur)

test_that("Class definitions", {
  testModel <- setSIRD(N=10, Beta=5, Gamma=3, ProbOfDeath=0.5, I0=1)

  expect_true(is.environment(testModel@odinModel))
  expect_true(is.list(testModel@currentState))
  expect_true(is.list(testModel@initialState))
  expect_true(is.list(testModel@parameters))
  expect_s4_class(testModel, "sirdModel")
  expect_error(testModel@odinModel <- 1)
  expect_error(testModel@odinModel <- "a")
  expect_error(testModel@odinModel <- testModel)
  expect_error(testModel@currentState <- 1)
  expect_error(testModel@currentState <- "a")
  expect_error(testModel@currentState <- testModel)
})

test_that("odinModel Assignment", {
  testModel <- setSIRD(N=10, Beta=5, Gamma=3, ProbOfDeath=0.5, I0=1)

  expect_true(is.double(testModel@odinModel$initial(t=0)))
})

test_that("initialState Assignment", {
  testModel <- setSIRD(N=10, Beta=5, Gamma=3, ProbOfDeath=0.5, I0=1)

  expect_equal(testModel@initialState$S0, 10 - 1)
  expect_equal(testModel@initialState$I0, 1)
  expect_equal(testModel@initialState$R0, 0)
  expect_equal(testModel@initialState$D0, 0)
})

test_that("parameters Assignment", {
  testModel <- setSIRD(N=10, Beta=5, Gamma=3, ProbOfDeath=0.5, I0=1)

  expect_equal(testModel@parameters$Betas, 5)
  expect_equal(testModel@parameters$changeTimes, 0)
  expect_equal(testModel@parameters$Gamma, 3)
  expect_equal(testModel@parameters$Alpha, riskToRate(0.5))
})

test_that("Input restrictions", {

  expect_error(setSIRD(N = "100", Beta = 1, Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setSIRD(N = 100, Beta = 1, Gamma = 1, ProbOfDeath = 1.5, I0 = 1, changeTimes=NULL))
  expect_error(setSIRD(N = 100, Beta = -1, Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setSIRD(N = 100.5, Beta = 1, Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
  expect_error(setSIRD(N = 100, Beta = c(1,2,3), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=c(4,5,6)))
  expect_error(setSIRD(N = 100, Beta = c(1,2,3), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=c(5,4)))
  expect_error(setSIRD(N = 100, Beta = 1, Gamma = c(1,2), ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL))
})

test_that("Odin Model Functionality under different inputs",{

  expect_true(is.double(setSIRD(N = 100, Beta = 1, Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,10,100))))
  expect_true(is.double(setSIRD(N = 100, Beta = c(1), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,10,100))))
  expect_true(is.double(setSIRD(N = 100, Beta = c(1,0.5), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=2)@odinModel$run(c(1,10,100))))
  expect_true(is.double(setSIRD(N = 100, Beta = c(1,0.5,0.75), Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=c(2,11))@odinModel$run(c(1,10,100))))
})

test_that("Odin Model functionality in extreme scenarios",{

  #No prob of death -> no deaths
  expect_equal(as.numeric(setSIRD(N = 100, Beta = 1, Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,100))[2,"D"]), 0)
  #No recovery/death + high transmission -> no susceptible
  expect_equal(as.numeric(setSIRD(N = 100, Beta = 10, Gamma = 0, ProbOfDeath = 0, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,100))[2,"I"]), 100)
  #No transmission -> no reduction in S
  expect_equal(as.numeric(setSIRD(N = 100, Beta = 0, Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,100))[2,"S"]), 99)
  #No transmission -> no
  expect_equal(as.numeric(setSIRD(N = 100, Beta = 0, Gamma = 1, ProbOfDeath = 0.1, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,100))[2,"S"]), 99)
})

test_that("Odin Model time varying beta functionality",{

  #base
  expect_equal(setSIRD(N = 100, Beta = 1, Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=NULL)@odinModel$run(c(1,100))[,"Beta"], rep(1,2))
  #Two Betas
  expect_equal(setSIRD(N = 100, Beta = c(1,0.5), Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=c(50))@odinModel$run(c(1,100))[,"Beta"], c(1,0.5))
  #Two Betas, evaluated at change time
  expect_equal(setSIRD(N = 100, Beta = c(1,0.5), Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=c(50))@odinModel$run(c(1,50))[,"Beta"], c(1,0.5))
  #three Betas
  expect_equal(setSIRD(N = 100, Beta = c(1,0.5,7), Gamma = 1, ProbOfDeath = 0, I0 = 1, changeTimes=c(25,75))@odinModel$run(c(1,50,100))[,"Beta"], c(1,0.5,7))
})
