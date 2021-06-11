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

test_that("estimateInfectiousNode - Error message functions", {
  model <- setSIR(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)

  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = c(120, 100)
  ))
  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = c("1","10")
  ))
  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = c(100,2000)
  ))
  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = 100
  ))

  model <- setSIR(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)

  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = c(10,20)
  ))
})


test_that("estimateInfectiousNode - Compare to known results", {
  model <- setSIR(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)

  #if no change in deaths then = 0
  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = c(50,50)
  )
  model <- excalibur::estimateInfectiousNode(
    model, deaths = c(50,50)
  )
  expect_equal(model@currentState$I, 0)

  #simulate a result
  results <- simulate(model, t = c(0,9,10))
  infected <- results$I[3]
  susceptible <- results$S[3]
  deaths <- results$D[c(2,3)]
  #estimate
  model <- calculateCurrentState(model, deaths)
  estInfected <- currentState(model)$I
  estSusceptible <- currentState(model)$S
  #compare
  accuracy <- 0.1 #allow leway since estimation
  expect_true(abs(estInfected - infected)/infected < accuracy)
  expect_true(abs(estSusceptible - susceptible)/susceptible < accuracy)
})
