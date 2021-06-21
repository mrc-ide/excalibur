test_that("rateToRisk/riskToRate Equivalencies", {
  rate <- 10
  expect_equal(rate, riskToRate(rateToRisk(rate)))
  risk <- 1/4
  expect_equal(risk, rateToRisk(riskToRate(risk)))
  rate <- 0
  expect_equal(rateToRisk(rate), 0)
  risk <- 1
  expect_equal(riskToRate(risk), Inf)
})

test_that("whichIndex compare to known results", {
  changeTimes <- c(0,4,5,10,101)
  expect_equal(whichIndex(0, changeTimes), 1)
  expect_equal(whichIndex(7, changeTimes), 3)
  expect_equal(whichIndex(100, changeTimes), 4)
  expect_equal(whichIndex(200, changeTimes), 5)
})
