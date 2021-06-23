
test_that("Compare simulate method to $run", {

  model <- setSIRD(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_equal(simulate(model, t = 2), as.data.frame(model@odinModel$run(c(0,2)))[-1,])
  expect_equal(simulate(model, t = c(2,100)), as.data.frame(model@odinModel$run(c(0,2,100)))[-1,])


  model <- setSIRD(N= 10, Beta=c(1,5), Gamma=1/5, ProbOfDeath = 0.5, I0 = 1,
                  changeTimes = 12)
  expect_equal(simulate(model, t = 2), as.data.frame(model@odinModel$run(c(0,2)))[-1,])
  expect_equal(simulate(model, t = c(2,100)), as.data.frame(model@odinModel$run(c(0,2,100)))[-1,])
})

test_that("Check print current state", {

  model <- setSIRD(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_true(is.data.frame(currentState(model)))
  expect_equal(length(currentState(model)), 5)
  #assign a list to slot
  model@currentState$t <- 1
  model@currentState$S <- 100
  expect_equal(currentState(model), data.frame(t=1, S=100, I = NA, R = NA, D=NA))
  model@currentState$I <- 100
  model@currentState$R <- 100
  model@currentState$D <- 100
  expect_equal(currentState(model), data.frame(t=1, S=100, I = 100, R = 100, D=100))
})

test_that("Simulate from current time",{
          #compare to known result
          model <- setSIRD(N = 1000, Beta = c(2,0.5), Gamma = 1/5, ProbOfDeath = 0.1,
                  I0 = 1, changeTimes = 5)
          #simulate a result
          time <- 10
          results <- simulate(model, t = 20)
          #death data
          deaths <- simulate(model, t = c(5,time))$D
          #estimate
          model <- calculateCurrentState(model, time, deaths)
          #simulate from current time
          results2 <- simulate(model, useCurrent = T, t = 20)
          #compare
          accuracy <- 0.01 #allow leway due to round etc.
          expect_true(abs(results$S - results2$S)/results$S < accuracy)
          expect_true(abs(results$I - results2$I)/results$I < accuracy)
          expect_true(abs(results$R - results2$R)/results$R < accuracy)
          expect_equal(results$t, results2$t)

          #compare to simulation from initial
          results <- simulate(model, useCurrent = F, t = 30)
          results2 <- simulate(model, useCurrent = T, t = 30)
          expect_true(abs(results$S - results2$S)/results$S < accuracy)
          expect_true(abs(results$I - results2$I)/results$I < accuracy)
          expect_true(abs(results$R - results2$R)/results$R < accuracy)
          expect_equal(results$t, results2$t)

})
