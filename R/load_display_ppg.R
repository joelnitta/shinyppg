#' UI to display PPG
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
display_ppg_ui <- function(id) {
  tagList(
    reactable::reactableOutput(NS(id, "ppg_table"), width = "100%"),
    textOutput(NS(id, "selected_rows_message"))
  )
}

#' Server logic to load PPG
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns Server logic
#' @noRd
load_data_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactiveVal(load_data())
  })
}

#' Server logic to display PPG
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
display_ppg_server <- function(id, ppg) {
  # Check args
  stopifnot(is.reactive(ppg))

  moduleServer(id, function(input, output, session) {
    output$ppg_table <- reactable::renderReactable({
      reactable::reactable(ppg(),
        filterable = TRUE,
        searchable = TRUE,
        selection = "multiple",
        resizable = TRUE,
        fullWidth = TRUE
      )
    })
    selected_rows <- reactive(
      reactable::getReactableState("ppg_table", "selected")
    )
    output$selected_rows_message <- renderText({
      num_selected <- length(selected_rows())
      paste("Number of rows selected:", num_selected)
    })
    selected_rows
  })
}
