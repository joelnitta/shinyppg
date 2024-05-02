#' UI for deleting a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
delete_row_ui <- function(id) {
  tagList(
    actionButton(NS(id, "delete"), "Delete row")
  )
}

#' Server logic to delete a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
delete_row_server <- function(id, ppg, rows_selected) {

  # Check args
  stopifnot(is.reactive(ppg))
  stopifnot(is.reactive(rows_selected))

  moduleServer(id, function(input, output, session) {
    # Wait for button push to delete
    observeEvent(input$delete, {
      # Only delete if >1 row selected
      if (length(rows_selected()) > 0) {
        selected_taxonID <- ppg()[["taxonID"]][rows_selected()] # nolint
        updated_data <- dwctaxon::dct_drop_row(
          ppg(),
          taxonID = selected_taxonID
        )
        ppg(updated_data)
      }
    })
  })

}