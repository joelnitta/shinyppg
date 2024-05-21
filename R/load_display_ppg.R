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

    output$ppg_table <- reactable::renderReactable({
      reactable::reactable(
        ppg(),
        filterable = TRUE,
        searchable = TRUE,
        selection = "multiple",
        resizable = TRUE,
        fullWidth = TRUE,
        columns = columns_state(),
        defaultSorted = sorted_state()
      )
    })

    # Update column sorting so we don't lose it when the table gets re-created
    current_sorted <- reactive(
      reactable::getReactableState("ppg_table", "sorted")
    )
    observe({
      current_sorted_names <- names(current_sorted())
      current_sorted_asc_desc <- set_asc_desc(current_sorted())
      if (!is.null(current_sorted_names)) {
        sorted_state(current_sorted_names)
        columns_state(current_sorted_asc_desc)
      }
    })

    selected_rows <- reactive(
      reactable::getReactableState("ppg_table", "selected")
    )
    output$selected_rows_message <- renderText({
      num_selected <- length(selected_rows())
      paste("Number of rows selected:", num_selected)
    })
    return(selected_rows)
  })
}
