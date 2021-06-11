
test_that("Compare simulate method to $run", {

  model <- setSIR(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_equal(simulate(model, t = 2), as.data.frame(model@odinModel$run(c(0,2)))[-1,])
  expect_equal(simulate(model, t = c(2,100)), as.data.frame(model@odinModel$run(c(0,2,100)))[-1,])


  model <- setSIR(N= 10, Beta=c(1,5), Gamma=1/5, ProbOfDeath = 0.5, I0 = 1,
                  changeTimes = 12)
  expect_equal(simulate(model, t = 2), as.data.frame(model@odinModel$run(c(0,2)))[-1,])
  expect_equal(simulate(model, t = c(2,100)), as.data.frame(model@odinModel$run(c(0,2,100)))[-1,])
})

test_that("Check print current state", {

  model <- setSIR(N= 10, Beta=1, Gamma=1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = NULL)
  expect_true(is.list(currentState(model)))
  expect_equal(length(currentState(model)), 0)
  #assign a list to slot
  model@currentState$S <- 100
  expect_equal(currentState(model), list(S=100))
})
