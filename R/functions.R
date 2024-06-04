# Define vectors used in the app ----

# Valide Darwin Core (DwC) Taxon terms (columns)
dct_terms <- dwctaxon::dct_terms

# Columns to display in the main ppg dataframe
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

# Valid values to use for taxonomicStatus
valid_tax_status <- c(
  "accepted",
  "synonym",
  "ambiguous synonym",
  "variant"
)

# Valid values to use for taxonomicRank
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

# Define validation settings ----

dwctaxon::dct_options(
  check_sci_name = FALSE,
  check_mapping_accepted_status = TRUE,
  valid_tax_status = paste(valid_tax_status, collapse = ", ")
)

#' Convert output of reactable::getReactableState() for column sorting to
#' format that can be used to specify column sort order.
#'
#' The output of this function can be used as input to the `columns` arg
#' of reactable::reactable()
#'
#' Internal function
#'
#' @param col_list Output of reactable::getReactableState(name = "sorted"):
#' a named list of columns with values of "asc" for ascending order or "desc"
#' for descending order, or NULL if no columns are sorted
#'
#' @return list
#' @noRd
set_asc_desc <- function(col_list) {
  res <- col_list
  for (i in seq_along(col_list)) {
    res[[i]] <- reactable::colDef(defaultSortOrder = col_list[[i]])
  }
  res
}

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

#' Load IPNI authors
#'
#' Internal function
#'
#' @return Character vector
#' @noRd
load_authors <- function() {
  shinyppg::ipni_authors
}

#' Load higher names of pteridophytes
#'
#' Internal function
#'
#' @return Character vector
#' @noRd
load_pterido_higher_names <- function() {
  shinyppg::pterido_higher_names
}

#' Load specific epithets of pteridophytes
#'
#' Internal function
#'
#' @return Character vector
#' @noRd
load_pterido_sp_epithets <- function() {
  shinyppg::pterido_sp_epithets
}

#' updateSelectizeInput for compose_name_server()
#'
#' Internal function
#'
#' @param session The session object passed to function given to shinyServer
#' @param inputId The id of the input object.
#' @param choices Selection choices to include in the selectize input
#' @param placeholder Text to display before selection is made.
#' @return Output of updateSelectizeInput()
#' @noRd
update_selectize_compose_name <- function(
    session, inputId, choices, placeholder) {
  updateSelectizeInput(
    session = session,
    inputId = inputId,
    choices = choices,
    selected = "",
    server = TRUE,
    options = list(
      placeholder = placeholder,
      onInitialize = I('function() { this.setValue(""); }')
    )
  )
}

#' Check if multiple, or zero, rows are selected
#'
#' Internal function
#'
#' @param rows_selected A reactive value: currently selected rows
#' @return A reactive value
#' @noRd
check_mult_or_no_rows_selected <- function(rows_selected) {
  reactive({
    is.null(rows_selected()) ||
      length(rows_selected()) == 0 ||
      length(rows_selected()) > 1
  })
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

#' Initialize a select menu of input items
#'
#' Internal function used in autocomplete_server()
#'
#' @param session Current session
#' @param choices Input choices
#' @param placeholder Default value to display
#' @param selected Value to select
#'
#' @noRd
initialize_selectize_input <- function(
    session, choices, placeholder, selected) {
  updateSelectizeInput(
    session,
    inputId = "autocomp_col",
    choices = choices,
    selected = selected,
    server = TRUE,
    options = list(
      placeholder = placeholder,
      onInitialize = I('function() { this.setValue(""); }')
    )
  )
}

#' Check if PPG data are valid or not, and return either TRUE or FALSE
#' but no error
#'
#' @param ppg PPG dataframe
#'
#' @noRd
initial_validate <- function(ppg) {
  tryCatch(
    {
      res <- dwctaxon::dct_validate(
        ppg,
        on_success = "logical",
        on_fail = "error"
      )
      return(res)
    },
    error = function(e) {
      return(FALSE)
    }
  )
}
