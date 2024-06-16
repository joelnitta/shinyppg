# Encrypt passwords with sodium

user_base <-
  readr::read_csv("working/secrets.csv") |>
  dplyr::mutate(
    password = purrr::map_chr(password, sodium::password_store)
  )

usethis::use_data(user_base, overwrite = TRUE, internal = TRUE)
