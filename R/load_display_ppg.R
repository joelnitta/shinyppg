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
    DT::dataTableOutput(NS(id, "ppg_table"), width = "100%"),
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
#' @returns List of metadata about current table
#' @noRd
display_ppg_server <- function(id, ppg) {
  # Check args
  stopifnot(is.reactive(ppg))

  moduleServer(id, function(input, output, session) {

    # Define default settings for column sorting
    default_columns <- list(
      modified = reactable::colDef(defaultSortOrder = "desc")
    )
    default_sorted <- c("modified", "scientificName")
    # Make reactive
    columns_state <- reactiveVal(default_columns)
    sorted_state <- reactiveVal(default_sorted)

    output$ppg_table <- DT::renderDataTable({
      DT::datatable(
        data = ppg(),
        rownames = FALSE,
        filter = "top",
        selection = "multiple"
      )
    },
    server = TRUE)

    selected_rows <- reactive(
      input$ppg_table_rows_selected
    )
    output$selected_rows_message <- renderText({
      num_selected <- length(selected_rows())
      paste("Number of rows selected:", num_selected)
    })
    return(selected_rows)
  })
}

# test app
display_ppg_app <- function() {
  ui <- fluidPage(
    display_ppg_ui("ppg_table")
  )
  server <- function(input, output, session) {
    # Load data
    ppg <- load_data_server("ppg")
    display_ppg_server("ppg_table", ppg)
  }
  shinyApp(ui, server)
}
