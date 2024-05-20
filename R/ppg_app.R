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
    tabsetPanel(
      tabPanel(
        "Data Entry",
        {
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
              display_ppg_ui("display_ppg")
            )
          )
        }
      ),
      tabPanel("Data Validation", validate_ui("validate")),
      tabPanel(
        "Settings",
        {
          mainPanel(
            settings_table_ui("settings_module", cols_select)
          )
        })
    ),
  )
  server <- function(input, output, session) {
    ppg <- load_data_server("ppg")
    rows_selected <- display_ppg_server("display_ppg", ppg)
    add_row_server("add_row", ppg)
    modify_row_server("modify_row", ppg, rows_selected)
    delete_row_server("delete_row", ppg, rows_selected)
    validate_server("validate", ppg)
    settings <- reactiveVal(cols_select)
    settings_table_server("settings_module", settings)
  }
  shinyApp(ui, server)
}
