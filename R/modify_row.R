#' UI for modifying a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @returns UI
#' @noRd
modify_row_ui <- function(id) {
  tagList(
    textInput(NS(id, "taxonID"), label = "Taxon ID"),
    textInput(NS(id, "scientificName"), label = "Scientific name"),
    textInput(NS(id, "taxonomicStatus"), label = "Taxonomic status"),
    textInput(
      NS(id, "acceptedNameUsageID"),
      label = "Taxon ID of accepted name"
    ),
    textInput(
      NS(id, "acceptedNameUsage"),
      label = "Accepted name"
    ),
    actionButton(NS(id, "apply"), "Apply")
  )
}

#' Server logic to modify a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
modify_row_server <- function(id, ppg) {
  stopifnot(is.reactive(ppg))
  moduleServer(id, function(input, output, session) {
    observeEvent(input$apply, {
      updated_data <- dwctaxon::dct_modify_row(
        ppg(),
        taxonID = null_if_blank(input$taxonID),
        scientificName = null_if_blank(input$scientificName),
        taxonomicStatus = null_if_blank(input$taxonomicStatus),
        acceptedNameUsageID = null_if_blank(input$acceptedNameUsageID),
        acceptedNameUsage = null_if_blank(input$acceptedNameUsage)
      )
      ppg(updated_data)
    })
  })
}

