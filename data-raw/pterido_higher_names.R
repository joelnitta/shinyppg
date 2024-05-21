## code to prepare `pterido_higher_names` dataset goes here

ppg <- load_data(data_source = "download")

pterido_higher_names <-
  ppg |>
  dplyr::filter(
    !taxonRank %in% c("form", "subspecies", "variety", "species")) |>
  dplyr::pull(scientificName) |>
  stringr::str_split_i(" ", 1) |>
  unique() |>
  sort()

usethis::use_data(pterido_higher_names, overwrite = TRUE)