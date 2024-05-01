#' UI for entering data for adding or modifying a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
data_entry_ui <- function(id) {
  tagList(
    textInput(
      NS(id, "taxonID"),
      label = "Taxon ID"
    ),
    textInput(
      NS(id, "scientificName"),
      label = "Scientific name"
    ),
    textInput(
      NS(id, "namePublishedIn"),
      label = "Name published in"
    ),
    textInput(
      NS(id, "taxonRank"),
      label = "Taxonomic rank"
    ),
    textInput(
      NS(id, "taxonomicStatus"),
      label = "Taxonomic status"
    ),
    textInput(
      NS(id, "taxonRemarks"),
      label = "Taxon remarks"
    ),
    textInput(
      NS(id, "acceptedNameUsageID"),
      label = "Taxon ID of accepted name"
    ),
    textInput(
      NS(id, "acceptedNameUsage"),
      label = "Accepted name"
    ),
    textInput(
      NS(id, "parentNameUsageID"),
      label = "Taxon ID of parent name"
    ),
    textInput(
      NS(id, "parentNameUsage"),
      label = "Parent name"
    ),
    actionButton(NS(id, "apply"), "Apply")
  )
}
