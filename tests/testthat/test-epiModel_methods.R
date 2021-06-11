test_that("Check error is functioning", {
  model <- setSIR(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_error(simulate(model, t=1))
})

test_that("Compare simulate method to $run", {

  model <- setSIR(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_equal(simulate(model, t = c(1,2)), as.data.frame(model@odinModel$run(c(1,2))))
  expect_equal(simulate(model, t = c(1,2,100)), as.data.frame(model@odinModel$run(c(1,2,100))))


  model <- setSIR(N= 10, Beta=c(1,5), Gamma=1/5, ProbOfDeath = 0.5, I0 = 1,
                  changeTimes = 12)
  expect_equal(simulate(model, t = c(1,2)), as.data.frame(model@odinModel$run(c(1,2))))
  expect_equal(simulate(model, t = c(1,2,100)), as.data.frame(model@odinModel$run(c(1,2,100))))
})

test_that("Check print current state", {

  model <- setSIR(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_null(currentState(model))
  #asign a list to slot
  model@currentState <- list(S = 100)
  expect_equal(currentState(model), list(S=100))
})
