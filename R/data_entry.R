#' UI to display data entry fields
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
data_entry_ui <- function(id) {
  tagList(
    shinyjs::useShinyjs(),
    selectInput(
      NS(id, "taxonRank"),
      label = "taxonRank",
      choices = valid_tax_rank
    ),
    helpText("Taxonomic rank"),
    selectInput(
      NS(id, "taxonomicStatus"),
      label = "taxonomicStatus",
      choices = valid_tax_status
    ),
    helpText("Taxonomic status"),
    textInput(
      NS(id, "namePublishedIn"),
      label = "namePublishedIn"
    ),
    helpText("Name of publication of taxon"),
    textInput(
      NS(id, "taxonRemarks"),
      label = "taxonRemarks"
    ),
    helpText("Notes about taxon"),
    autocomplete_ui(
      NS(id, "acceptedNameUsage"),
      col_select = "acceptedNameUsage",
      help_text = "Accepted scientific name"
    ),
    autocomplete_ui(
      NS(id, "parentNameUsage"),
      col_select = "parentNameUsage",
      help_text = "Scientific name of parent taxon"
    ),
    actionButton(NS(id, "advanced_options"), "Show advanced options"),
    shinyjs::hidden(textInput(
      NS(id, "taxonID"),
      label = "taxonID"
    )),
    shinyjs::hidden(textInput(
      NS(id, "acceptedNameUsageID"),
      label = "acceptedNameUsageID"
    )),
    shinyjs::hidden(textInput(
      NS(id, "parentNameUsageID"),
      label = "parentNameUsageID"
    )),
    hr(),
    actionButton(NS(id, "apply"), "Apply"),
    textOutput(NS(id, "error_msg"))
  )
}
