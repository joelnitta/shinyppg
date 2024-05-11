
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
    DT::dataTableOutput(NS(id, "ppg_table"), width = 700)
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
    output$ppg_table <- DT::renderDT({
      DT::datatable(ppg(),
        filter = "top",
        selection = "multiple"
      )
    })
    reactive(input$ppg_table_rows_selected)
  })
}
