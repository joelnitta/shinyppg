#' UI to display settings table
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
settings_table_ui <- function(id, cols_select) {
  tagList(
    sortable::rank_list(
      input_id = NS(id, "rank_list_ppg_cols"),
      text = "Drag column names for sorting",
      labels = as.list(cols_select)
    ),
    verbatimTextOutput(NS(id, "settings_result"))
  )
}


#' Server logic to display settings table
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns Server logic
#' @noRd
settings_table_server <- function(id, settings) {
  moduleServer(id, function(input, output, session) {
    output$settings_result <- renderPrint({
      settings(input$rank_list_ppg_cols)
      settings()
    })
  })
}
