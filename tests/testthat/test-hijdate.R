test_that("hijdate() gives Hijri date output", {
  expect_equal(hijdate("12-12-2021"), "07-05-1443")
})
