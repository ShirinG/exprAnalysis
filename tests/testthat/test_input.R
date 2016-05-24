context("test test")

test_that("testing files are found", {
  expect_that(10, equals(10))
  expect_that(10, is_identical_to(10))
})