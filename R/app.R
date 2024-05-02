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
    titlePanel("PPG Editor"),
    sidebarLayout(
      sidebarPanel(
        tabsetPanel(
          tabPanel(
            "Add row",
            data_entry_ui("add_row")
          ),
          tabPanel(
            "Edit row",
            data_entry_ui("modify_row")
          )
        ),
        hr(),
        delete_row_ui("delete_row")
      ),
      mainPanel(
        DT::dataTableOutput("results", width = 700)
      )
    )
  )
  server <- function(input, output, session) {
    ppg <- reactiveVal(load_data())
    rows_selected <- reactive(input$results_rows_selected)
    add_row_server("add_row", ppg)
    modify_row_server("modify_row", ppg, rows_selected)
    delete_row_server("delete_row", ppg, rows_selected)
    output$results <- DT::renderDT({
      DT::datatable(ppg(),
        filter = "top",
        selection = "multiple"
      )
    })
  }
  shinyApp(ui, server)
}
