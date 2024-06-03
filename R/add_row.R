#' Server logic to add a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @param rows_selected A reactive value: currently selected rows
#' @returns Server logic
#' @autoglobal
#' @noRd
add_row_server <- function(id, ppg, composed_name, rows_selected) {
  stopifnot(is.reactive(ppg))
  stopifnot(is.reactive(rows_selected))
  stopifnot(is.reactive(composed_name))

  moduleServer(id, function(input, output, session) {

    # initiate error message
    error_msg <- reactiveVal("")

    parentNameUsage <- autocomplete_server(
      id = "parentNameUsage",
      ppg = ppg,
      rows_selected = rows_selected,
      placeholder = "Select parent name",
      col_select = "parentNameUsage",
      fill_name = FALSE,
      !taxonRank %in% c("form", "subspecies", "variety")
    )

    observeEvent(input$apply, {

      # Reset error message each time apply is clicked
      error_msg("")

      # Add one row, catching any errors in error_msg
      tryCatch({
        updated_data <- dwctaxon::dct_add_row(
          ppg(),
          taxonID = null_if_blank(input$taxonID),
          scientificName = null_if_blank(composed_name()),
          namePublishedIn = null_if_blank(input$namePublishedIn),
          taxonRank = null_if_blank(input$taxonRank),
          taxonomicStatus = null_if_blank(input$taxonomicStatus),
          taxonRemarks = null_if_blank(input$taxonRemarks),
          acceptedNameUsageID = null_if_blank(input$acceptedNameUsageID),
          acceptedNameUsage = null_if_blank(input$acceptedNameUsage),
          parentNameUsageID = null_if_blank(input$parentNameUsageID),
          parentNameUsage = null_if_blank(parentNameUsage())
        )
        ppg(updated_data)
      }, error = function(e) {
        error_msg(paste("Error:", e$message))
      })

      output$error_msg <- renderText(error_msg())
    })
  })
}
