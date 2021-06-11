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
