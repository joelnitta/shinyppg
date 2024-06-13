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

test_that("undo works", {
  dwctaxon::dct_options(
    user_name = "me",
    user_id = "123",
    stamp_modified_by = TRUE,
    stamp_modified_by_id = TRUE,
    extra_cols = c("modifiedBy", "modifiedByID")
  )
  ppg <- ppg_small
  ppg_mod_1 <- ppg |>
    dwctaxon::dct_modify_row(
      scientificName = "Loxogramme antrophyoides (Baker) C. Chr.",
      taxonomicStatus = "synonym",
      parentNameUsage = "Cyathea meridensis H. Karst."
    )
  save_patch(ppg, ppg_mod_1)
  ppg_mod_2 <- ppg_mod_1 |>
    dwctaxon::dct_add_row(scientificName = "me")
  save_patch(ppg_mod_1, ppg_mod_2)
  recoverd_ppg_mod_1 <- undo_change(ppg_mod_2)
  expect_equal(
    ppg_mod_1,
    recoverd_ppg_mod_1
  )
  recovered_ppg <- undo_change(ppg_mod_1)
  expect_equal(ppg, recovered_ppg)
  dwctaxon::dct_options(reset = TRUE)
})
