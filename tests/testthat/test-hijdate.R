test_that("hijdate() gives correct Hijri date output", {
  expect_equal(hijdate("12-12-2021"), "07-05-1443")
  expect_equal(hijdate("15-06-1883"), "09-08-1300")
})
