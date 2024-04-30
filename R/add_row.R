#' UI for adding a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @returns UI
add_row_ui <- function(id) {
  tagList(
    textInput(NS(id, "scientificName"), label = "Scientific Name"),
    actionButton(NS(id, "apply"), "Apply")
  )
}

#' Server logic to add a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
add_row_server <- function(id, ppg) {
  stopifnot(is.reactive(ppg))
  moduleServer(id, function(input, output, session) {
    observeEvent(input$apply, {
      updated_data <- dwctaxon::dct_add_row(
        ppg(),
        scientificName = input$scientificName
      )
      ppg(updated_data)
    })
  })
}
