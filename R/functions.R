dct_terms <- dwctaxon::dct_terms

cols_select <- c(
  "scientificName",
  "taxonRank",
  "taxonomicStatus",
  "namePublishedIn",
  "taxonRemarks",
  "acceptedNameUsage",
  "parentNameUsage",
  "taxonID",
  "acceptedNameUsageID",
  "parentNameUsageID",
  "modified"
)

valid_tax_status <- c(
  "accepted",
  "synonym",
  "ambiguous synonym"
)

valid_tax_rank <- c(
  "species",
  "genus",
  "tribe",
  "subfamily",
  "family",
  "order",
  "form",
  "subspecies",
  "variety"
)

settings_data <- data.frame(
  Setting = cols_select,
  Ascending = TRUE
)

#' Load data
#'
#' Loads the most recent PPG dataset
#'
#' Internal function
#'
#' @param data_source Where to get the data. If 'local', data will be read from
#' saved data file in ./data. Otherwise, data will be downloaded.
#'
#' @return Tibble
#' @noRd
load_data <- function(data_source = Sys.getenv("DATA_SOURCE")) {
  url <- "https://www.dolthub.com/csv/joelnitta/ppg-test/main/ppg?include_bom=0"
  if (data_source == "local") {
    return(shinyppg::ppg_small)
  }
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
  if (x == "") {
    return(NULL)
  }
  x
}

#' Reset text in a data entry box to empty (`""`)
#'
#' Internal function
#'
#' @param session Passed to updateTextInput
#' @param item Name of text input to reset
#' @noRd
reset_data_entry <- function(session, item) {
  shiny::updateTextInput(
    session,
    item,
    value = ""
  )
}

#' Set text in a data entry box to the value from a selected row
#'
#' Internal function
#'
#' @param session Passed to updateTextInput
#' @param item Name of text input to reset
#' @param selected_row Dataframe with one row; selected row of data from PPG
#' @noRd
fill_data_entry_from_row <- function(session, item, selected_row) {
  shiny::updateTextInput(
    session,
    item,
    value = selected_row[[item]]
  )
}

#' Not used here, but needed to pass R CMD CHECK since we use
#' pkgload::load_all() in ./app.R
#'
#' @noRd
pkgload_load_all <- function(...) {
  pkgload::load_all(...)
}