dct_terms <- dwctaxon::dct_terms

cols_select <- c(
  "taxonID",
  "acceptedNameUsageID",
  "scientificName",
  "namePublishedIn",
  "taxonRank",
  "vernacularName",
  "taxonomicStatus",
  "taxonRemarks",
  "parentNameUsageID",
  "acceptedNameUsage",
  "parentNameUsage",
  "modified")

#' Load data
#'
#' Loads the most recent PPG dataset
#'
#' Internal function
#'
#' @return Tibble
#' @noRd
load_data <- function() {
  url <- "https://raw.githubusercontent.com/pteridogroup/ppg/main/data/ppg.csv"
  readr::read_csv(url, col_select = dplyr::any_of(cols_select))
}

#' Convert values of `""` to NULL
#'
#' Internal function
#'
#' @param x Input; a character vector of length 1
#' @return `NULL`
#' @noRd
null_if_blank <- function(x) {
  stopifnot(length(x) == 1)
  if (x == "") return(NULL)
  x
}
