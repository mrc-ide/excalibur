test_that("calculateDownstreamNodes - Error message functions", {
  model <- setSEIRD(N = 1000, Beta = 1, Lambda = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)

  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = c(120, 100),
  ))
  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = "1"
  ))
  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 2000
  ))

  model <- setSEIRD(N = 1000, Beta = 1, Lambda = 1, Gamma = 1/5, ProbOfDeath = 0, I0 = 1)

  expect_error(excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  ))
})

test_that("calculateDownstreamNodes - Compare to known results", {
  model <- setSEIRD(N = 1000, Beta = 1, Lambda = 1, Gamma = 1/5, ProbOfDeath = 0.5, I0 = 1)
  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 50
  )
  expect_equal(model@currentState$D, 50)
  expect_equal(model@currentState$R, 50 * 1/5 / (-log(1-0.5)))

  model <- excalibur::calculateDownstreamExponentialNodes(
    model, deaths = 10
  )
  expect_equal(model@currentState$R, 10 * 1/5 / (-log(1-0.5)))


  model <- setSEIRD(N = 500, Beta = 2, Lambda = 1, Gamma = 1/2, ProbOfDeath = 0.1, I0 = 1)
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

test_that("estimate - Compare to known results", {
  model <- setSEIRD(N = 1000, Beta = c(1,5,6), Gamma = 1/5, Lambda = 1/3,
                    ProbOfDeath = 0.1,
                   I0 = 1, changeTimes = c(2,7))

  #simulate a result
  time <- 10
  results <- simulate(model, t = time)
  infected <- results$I
  exposed <- results$E
  susceptible <- results$S
  deaths <- simulate(model, t = c(2,7,time))$D
  #estimate
  model <- calculateCurrentState(model, t=time, deaths=deaths, nderiv = 7)
  estExposed <- currentState(model)$E
  estInfected <- currentState(model)$I
  estSusceptible <- currentState(model)$S
  #compare
  accuracy <- 0.01 #allow leway due to round etc.
  expect_true(abs(estInfected - infected)/infected < accuracy*10)
  expect_true(abs(estExposed - exposed)/exposed < accuracy*10)
  expect_true(abs(estSusceptible - susceptible)/susceptible < accuracy)
})

test_that("calculateNthDeriv - Compare to known results", {
  N <- 1000
  Beta <- 1
  Gamma <- 1/5
  Lambda <- 1/3
  Alpha <- 1/10
  ProbOfDeath <- 1-exp(-Alpha)
  model <- setSEIRD(N = N, Beta = Beta, Gamma = Gamma, Lambda = Lambda,
                    ProbOfDeath = ProbOfDeath,
                    I0 = 1)
  model@currentState$t <- 5
  #calculate the 2nd derivative
  secondD <- excalibur::calculateNthDeriv(model, nderiv=2)
  #set S, D and R so that E + I = 15
  E <- 10
  I <- 5
  model@currentState$S <- N - E - I - 300
  model@currentState$D <- 50
  model@currentState$R <- 250
  expect_equal(secondD(model, I), Lambda*Alpha*E - Alpha*(Alpha+Gamma)*I)
  #set S, D and R so that E + I = 50
  E <- 20
  I <- 30
  model@currentState$S <- N - E - I - 300
  model@currentState$D <- 50
  model@currentState$R <- 250
  expect_equal(secondD(model, I), Lambda*Alpha*E - Alpha*(Alpha+Gamma)*I)

  #now third deriv
  thirdD <- excalibur::calculateNthDeriv(model, nderiv=3)
  #set S, D and R and E + I
  E <- 10
  I <- 5
  model@currentState$S <- N - E - I - 300
  model@currentState$D <- 50
  model@currentState$R <- 250
  expect_equal(thirdD(model, I), Lambda*Alpha*Beta*model@currentState$S*I/N -
                 Alpha*Lambda^2*E -
                 Alpha*Lambda*(Alpha+Gamma)*E +
                 Alpha*(Alpha + Gamma)^2*I)
  #set S, D and R so that E + I = 50
  E <- 20
  I <- 30
  model@currentState$S <- N - E - I - 300
  model@currentState$D <- 50
  model@currentState$R <- 250
  expect_equal(thirdD(model, I), Lambda*Alpha*Beta*model@currentState$S*I/N -
                 Alpha*Lambda^2*E -
                 Alpha*Lambda*(Alpha+Gamma)*E +
                 Alpha*(Alpha + Gamma)^2*I)

})

test_that("getNthDeriv - Compare to known calculate", {
  N <- 1000
  Beta <- 1
  Gamma <- 1/5
  Lambda <- 1/3
  Alpha <- 1/10
  ProbOfDeath <- 1-exp(-Alpha)
  model <- setSEIRD(N = N, Beta = Beta, Gamma = Gamma, Lambda = Lambda,
                    ProbOfDeath = ProbOfDeath,
                    I0 = 1)
  model@currentState$t <- 5
  #calculate the 3rd derivative
  thirdD <- excalibur::calculateNthDeriv(model, nderiv=3)
  #get 3rd dervivative
  thirdDstored <- excalibur::getNthDeriv(model, nderiv=3)
  expect_equal(body(thirdD), body(thirdDstored))

  #calculate the 6th derivative
  sixD <- excalibur::calculateNthDeriv(model, nderiv=6)
  #get 6th dervivative
  sixDstored <- excalibur::getNthDeriv(model, nderiv=6)
  expect_equal(body(sixD), body(sixDstored))

  #check that trying to get a non-existant nderiv returns NA
  expect_true(is.na(excalibur::getNthDeriv(model, nderiv=20)))
})
