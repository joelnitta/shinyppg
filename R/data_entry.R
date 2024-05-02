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
    textInput(
      NS(id, "taxonRank"),
      label = "taxonRank"
    ),
    helpText("Taxonomic rank"),
    # taxonomicStatus
    textInput(
      NS(id, "taxonomicStatus"),
      label = "taxonomicStatus"
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
    actionButton(NS(id, "apply"), "Apply")
  )
}
