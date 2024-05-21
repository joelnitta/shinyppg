## code to prepare `pterido_sp_epithets` dataset goes here

ppg <- load_data(data_source = "download")

pterido_sp_epithets <-
  ppg |>
  dplyr::filter(
    taxonRank %in% c("species")) |>
  dplyr::pull(scientificName) |>
  stringr::str_split_i(" ", 2) |>
  unique() |>
  sort()

usethis::use_data(pterido_sp_epithets, overwrite = TRUE)
