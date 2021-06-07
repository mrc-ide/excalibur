library(excalibur)

test_that("Class definitions", {
  testModel <- setSIR(10, 5, 3 , 0.5, 1)

  expect_true(isS4(testModel))
  expect_true(is.environment(testModel@odinModel))
  expect_error(testModel@odinModel <- 1)
  expect_error(testModel@odinModel <- "a")
  expect_error(testModel@odinModel <- testModel)
})
