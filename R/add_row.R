#' Server logic to add a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
add_row_server <- function(id, ppg) {
  stopifnot(is.reactive(ppg))
  moduleServer(id, function(input, output, session) {
    observeEvent(input$apply, {
      # Add one row
      updated_data <- dwctaxon::dct_add_row(
        ppg(),
        taxonID = null_if_blank(input$taxonID),
        scientificName = null_if_blank(input$scientificName),
        namePublishedIn = null_if_blank(input$namePublishedIn),
        taxonRank = null_if_blank(input$taxonRank),
        taxonomicStatus = null_if_blank(input$taxonomicStatus),
        taxonRemarks = null_if_blank(input$taxonRemarks),
        acceptedNameUsageID = null_if_blank(input$acceptedNameUsageID),
        acceptedNameUsage = null_if_blank(input$acceptedNameUsage),
        parentNameUsageID = null_if_blank(input$parentNameUsageID),
        parentNameUsage = null_if_blank(input$parentNameUsage)
      )
      ppg(updated_data)
    })
  })
}
