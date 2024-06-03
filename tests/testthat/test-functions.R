library(dwctaxon)

test_that("initial validation works", {
  good_dat <- dwctaxon::dct_filmies
  bad_dat <- rbind(good_dat, good_dat[1, ])
  expect_equal(
    initial_validate(good_dat),
    TRUE
  )
  # should fail with one duplicated row (dup taxonID)
  expect_equal(
    initial_validate(bad_dat),
    FALSE
  )
})
