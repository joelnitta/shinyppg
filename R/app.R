#' PPG app
#'
#' Run a Shiny app to view and edit the Pteridophyte Phylogeny Group (PPG)
#' taxonomic database.
#'
#' @import shiny
#' @returns An object that represents the app. This function is normally called
#' for its side-effect of starting a Shiny app that can be accessed in a web
#' browser window.
#' @export
#' @examples
#' if (interactive()) {
#'   ppg_app()
#' }
ppg_app <- function() {
  ui <- fluidPage(
    data_entry_ui("add_row"),
    data_entry_ui("modify_row"),
    DT::dataTableOutput("results", width = 700)
  )
  server <- function(input, output, session) {
    ppg <- reactiveVal(load_data())
    rows_selected <- reactive(input$results_rows_selected)
    add_row_server("add_row", ppg)
    modify_row_server("modify_row", ppg, rows_selected)
    output$results <- DT::renderDT({
      DT::datatable(ppg(), selection = "single")
    })
  }
  shinyApp(ui, server)
}
