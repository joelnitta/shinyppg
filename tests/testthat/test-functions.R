library(dwctaxon)

test_that("initial validation works", {
  good_dat <- dwctaxon::dct_filmies
  bad_dat <- rbind(good_dat, good_dat[1, ])
  dwctaxon::dct_options(
    check_mapping_parent_accepted = FALSE
  )
  expect_equal(
    initial_validate(good_dat),
    TRUE
  )
  # should fail with one duplicated row (dup taxonID)
  expect_equal(
    initial_validate(bad_dat),
    FALSE
  )
  dwctaxon::dct_options(reset = TRUE)
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
      scientificName = "Loxogramme antrophyoides (Baker) C.Chr.",
      taxonomicStatus = "synonym",
      parentNameUsage = "Cyathea meridensis H.Karst."
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

test_that("subsetting to taxonomic group works on single taxon", {
  crep_data <- subset_to_taxon(ppg_small, "Crepidomanes (C. Presl) C. Presl")
  expect_snapshot(crep_data)
  expect_no_error(
    dct_validate(
      crep_data,
      extra_cols = c("modifiedBy", "modifiedByID", "ipniURL")
    )
  )
})

test_that("subsetting to taxonomic group works on multiple taxa", {
  sub_data <- subset_to_taxon(
    ppg_small, c(
      "Crepidomanes (C. Presl) C. Presl",
      "Abrodictyum C.Presl"
    )
  )
  expect_snapshot(sub_data)
  expect_no_error(
    dct_validate(
      sub_data,
      extra_cols = c("modifiedBy", "modifiedByID", "ipniURL"),
      on_success = "logical"
    )
  )
})
