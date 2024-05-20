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
    # scientificName
    textInput(
      NS(id, "scientificName"),
      label = "scientificName"
    ),
    helpText("Scientific name, including author"),
    # taxonRank
    selectInput(
      NS(id, "taxonRank"),
      label = "taxonRank",
      valid_tax_rank
    ),
    helpText("Taxonomic rank"),
    # taxonomicStatus
    selectInput(
      NS(id, "taxonomicStatus"),
      label = "taxonomicStatus",
      valid_tax_status
    ),
    helpText("Taxonomic status"),
    # namePublishedIn
    textInput(
      NS(id, "namePublishedIn"),
      label = "namePublishedIn"
    ),
    helpText("Name of publication of taxon"),
    # taxonRemarks
    textInput(
      NS(id, "taxonRemarks"),
      label = "taxonRemarks"
    ),
    helpText("Notes about taxon"),
    # acceptedNameUsage
    textInput(
      NS(id, "acceptedNameUsage"),
      label = "acceptedNameUsage"
    ),
    helpText("Accepted scientific name"),
    # parentNameUsage
    textInput(
      NS(id, "parentNameUsage"),
      label = "parentNameUsage"
    ),
    helpText("Scientific name of parent taxon"),
    # Put all 'advanced' cols dealing with taxonID at end
    # as they should generally not be edited by user
    # taxonID
    textInput(
      NS(id, "taxonID"),
      label = "taxonID"
    ),
    helpText("Taxon ID (advanced)"),
    # acceptedNameUsageID
    textInput(
      NS(id, "acceptedNameUsageID"),
      label = "acceptedNameUsageID"
    ),
    helpText("Taxon ID of accepted name (advanced)"),
    # parentNameUsageID
    textInput(
      NS(id, "parentNameUsageID"),
      label = "parentNameUsageID"
    ),
    helpText("Taxon ID of parent name (advanced)"),
    actionButton(NS(id, "apply"), "Apply"),
    textOutput(NS(id, "error_msg"))
  )
}
