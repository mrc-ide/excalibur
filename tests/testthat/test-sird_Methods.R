test_that("calculateDownstreamNodes - Error message functions", {
  model <- setSIRD(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)

  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = c(120, 100),
  ))
  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = "1"
  ))
  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 2000
  ))

  model <- setSIRD(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)

  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  ))
})

test_that("calculateDownstreamNodes - Compare to known results", {
  model <- setSIRD(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 50
  )
  expect_equal(model@currentState$D, 50)
  expect_equal(model@currentState$R, 50 * 1/5 / (-log(1-0.5)))

  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  )
  expect_equal(model@currentState$R, 10 * 1/5 / (-log(1-0.5)))


  model <- setSIRD(N = 500, Beta = 2, Gamma = 1/2, ProbOfDeath = 0.1, I0 = 1)
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
  model <- setSIRD(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)

  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = c(180,100)
  ))
  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = c(90,100)
  ))
  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = "10"
  ))
  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = 2000
  ))

  model <- setSIRD(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)

  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = 100
  ))

  model <- setSIRD(N = 1000, Beta = c(1,5), Gamma = 1/5, ProbOfDeath = 0, I0 = 1,
                  changeTimes = 10)

  expect_error(excalibur::estimateInfectiousNode(
    model, deaths = 100
  ))
})


test_that("estimateInfectiousNode - Compare to known results", {
  model <- setSIRD(N = 1000, Beta = 1, Gamma = 1/5, ProbOfDeath = 0.1, I0 = 1)

  #simulate a result
  time <- 10
  results <- simulate(model, t = time)
  infected <- results$I
  susceptible <- results$S
  deaths <- results$D
  #estimate
  model <- calculateCurrentState(model, time, deaths)
  estInfected <- currentState(model)$I
  estSusceptible <- currentState(model)$S
  #compare
  accuracy <- 0.01 #allow leway due to round etc.
  expect_true(abs(estInfected - infected)/infected < accuracy)
  expect_true(abs(estSusceptible - susceptible)/susceptible < accuracy)

  model <- setSIRD(N = 1000, Beta = c(2,0.5), Gamma = 1/5, ProbOfDeath = 0.1,
                  I0 = 1, changeTimes = 5)

  #simulate a result
  time <- 10
  results <- simulate(model, t = time)
  infected <- results$I
  susceptible <- results$S
  deaths <- simulate(model, t = c(5,time))$D
  #estimate
  model <- calculateCurrentState(model, time, deaths)
  estInfected <- currentState(model)$I
  estSusceptible <- currentState(model)$S
  #compare
  accuracy <- 0.01 #allow leway due to round etc.
  expect_true(abs(estInfected - infected)/infected < accuracy)
  expect_true(abs(estSusceptible - susceptible)/susceptible < accuracy)
})
