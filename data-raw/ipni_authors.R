## code to prepare `ipni_authors` dataset goes here

# AFAIK, the Kew World Checklist of Vascular Plants (WCVP) should contain all
# IPNI authors for vascular plants.
# WCVP data is available under CC-BY https://www.ipni.org/terms-and-conditions

# Setup ---

# Helper functions for processing author name strings

# We assume that no names have spaces, but there are few errors, in addition
# to a handful of apparently valid names with spaces.
# Example error: "A Juss." (should be "A. Juss.")
# Example name with space: "Gomes e Sousa", "'t Hart"

# Don't attempt to handle the errors here, as they are very few and have to
# be fixed on the IPNI side anyways to matter

process_auth_strings <- function(x) {
  x |>
    # remove all characters that aren't author names or whitespace
    stringr::str_remove_all("\\(|\\)|\\&|,") |>
    stringr::str_replace_all(" ex ", " ") |>
    stringr::str_replace_all(" ex\\. ", " ") |>
    stringr::str_replace_all(" non ", " ") |>
    stringr::str_replace_all(" non\\. ", " ") |>
    # protect names that should have spaces with underscore
    # (need to switch back to space after)
    stringr::str_replace_all(" f\\.", "_f.") |>
    stringr::str_replace_all("de ", "de_") |>
    stringr::str_replace_all("da ", "da_") |>
    stringr::str_replace_all("al ", "al_") |>
    stringr::str_replace_all("du ", "du_") |>
    stringr::str_replace_all("la ", "la_") |>
    stringr::str_replace_all(" e ", "_e_") |>
    stringr::str_replace_all(" y ", "_y_") |>
    stringr::str_replace_all("'t ", "'t_")
}

split_auth_strings <- function(auth_string) {
  auth_string |>
    stringr::str_squish() |>
    stringr::str_split(" +") |>
    unlist() |>
    # switch underscores back to spaces
    stringr::str_replace_all("_", " ")
}

# Download WCVP and unzip data ----
temp_file <- tempfile(fileext = ".zip")

temp_dir <- fs::path_dir(temp_file)

download.file(
  "https://sftp.kew.org/pub/data-repositories/WCVP/wcvp_dwca.zip", temp_file
)

unzip(
  temp_file,
  files = "wcvp_taxon.csv",
  exdir = temp_dir,
  overwrite = TRUE
)

wcvp_taxon_file <- fs::path(temp_dir, "wcvp_taxon.csv")

# Read in from csv
wcvp <- readr::read_delim(wcvp_taxon_file, delim = "|")

# Extract author strings
author_strings <- wcvp |>
  dplyr::pull(scientfiicnameauthorship) |>
  unique()

author_strings <- author_strings[!is.na(author_strings)]

# Extract author names
# use a tibble so we can inspect the original author strings after
all_parsed_names <-
  tibble::tibble(
    auth = author_strings
  ) |>
  dplyr::mutate(
    auth_parse = process_auth_strings(auth),
    auth_string = purrr::map(auth_parse, split_auth_strings)
  ) |>
  tidyr::unnest(auth_string) |>
  dplyr::mutate(n_char = nchar(auth_string)) |>
  dplyr::arrange(n_char)

ipni_authors <-
  all_parsed_names |>
  # delete any author names that consist of 1 character;
  # these should be errors
  dplyr::filter(n_char > 1) |>
  # Delete other short names in error
  dplyr::filter(!auth_string %in% (c("al", "ec", "ex", "le"))) |>
  dplyr::pull(auth_string) |>
  unique() |>
  sort()

usethis::use_data(ipni_authors, overwrite = TRUE)

# cleanup
fs::file_delete(temp_file)
fs::file_delete(wcvp_taxon_file)
