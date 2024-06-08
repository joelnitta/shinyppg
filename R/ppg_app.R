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
                  compose_name_ui("sci_name_add"),
                  data_entry_ui("add_row")
                ),
                tabPanel(
                  "Edit row",
                  compose_name_ui("sci_name_modify"),
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
      tabPanel("Settings")
    ),
  )
  server <- function(input, output, session) {
    # Load data
    ppg <- load_data_server("ppg")
    higher_names <- load_pterido_higher_names()
    epithets <- load_pterido_sp_epithets()
    ipni_authors <- load_authors()

    # Set initial values
    composed_name_add <- reactiveVal("")
    composed_name_modify <- reactiveVal("")
    show_advanced <- reactiveVal(FALSE)

    # Other server logic
    rows_selected <- display_ppg_server("display_ppg", ppg)
    compose_name_server(
      "sci_name_add", higher_names, epithets, ipni_authors,
      composed_name_add, ppg, rows_selected
    )
    compose_name_server(
      "sci_name_modify", higher_names, epithets, ipni_authors,
      composed_name_modify, ppg, rows_selected,
      fill_sci_name = TRUE
    )
    show_advanced <- add_row_server(
      id = "add_row",
      ppg = ppg,
      composed_name = composed_name_add,
      rows_selected = rows_selected,
      show_advanced = show_advanced
    )
    show_advanced <- modify_row_server(
      id = "modify_row",
      ppg = ppg,
      rows_selected = rows_selected,
      composed_name = composed_name_modify,
      show_advanced = show_advanced
    )
    delete_row_server("delete_row", ppg, rows_selected)
    validate_server("validate", ppg)
  }
  shinyApp(ui, server)
}
