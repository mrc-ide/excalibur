test_that("calculateDownstreamNodes - Error message functions", {
  model <- setSIR(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)

  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = c(120, 100),
  ))
  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = "1"
  ))
  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 2000
  ))

  model <- setSIR(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)

  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  ))
})

test_that("calculateDownstreamNodes - Compare to known results", {
  model <- setSIR(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 50
  )
  expect_equal(model@currentState$D, 50)
  expect_equal(model@currentState$R, 50 * 1/5 / (-log(1-0.5)))

  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  )
  expect_equal(model@currentState$R, 10 * 1/5 / (-log(1-0.5)))


  model <- setSIR(N = 500, Beta = 2, Gamma = 1/2, ProbOfDeath = 0.1, I0 = 1)
  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 50
  )
  expect_equal(model@currentState$D, 50)
  expect_equal(model@currentState$R, 50 * 1/2 / (-log(1-0.1)))

  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  )
  expect_equal(model@currentState$R, 10 * 1/2 / (-log(1-0.1)))



})
