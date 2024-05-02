#' Server logic to modify a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
modify_row_server <- function(id, ppg, rows_selected) {

  # Check args
  stopifnot(is.reactive(ppg))
  stopifnot(is.reactive(rows_selected))

  moduleServer(id, function(input, output, session) {
    # Modify one row
    observeEvent(input$apply, {
      updated_data <- dwctaxon::dct_modify_row(
        ppg(),
        taxonID = null_if_blank(input$taxonID),
        scientificName = null_if_blank(input$scientificName),
        namePublishedIn = null_if_blank(input$namePublishedIn),
        taxonRank = null_if_blank(input$taxonRank),
        taxonomicStatus = null_if_blank(input$taxonomicStatus),
        taxonRemarks = null_if_blank(input$taxonRemarks),
        acceptedNameUsageID = null_if_blank(input$acceptedNameUsageID),
        acceptedNameUsage = null_if_blank(input$acceptedNameUsage),
        parentNameUsageID = null_if_blank(input$parentNameUsageID),
        parentNameUsage = null_if_blank(input$parentNameUsage)
      )
      ppg(updated_data)
    })
    # Fill in row editing text boxes with data from selected row
    observeEvent(rows_selected(), {
      if (length(rows_selected()) == 1) {
        selected_row <- ppg()[rows_selected(), ]
        purrr::walk(
          cols_select,
          ~fill_data_entry_from_row(
            session = session,
            item = .x,
            selected_row = selected_row
          )
        )
      }
    })
    # Reset row editing text boxes when zero or >1 rows selected
    mult_or_no_rows_selected <- reactive({
      is.null(rows_selected()) ||
        length(rows_selected()) == 0 ||
        length(rows_selected()) > 1
    })
    observeEvent(mult_or_no_rows_selected(), {
      if (mult_or_no_rows_selected()) {
        purrr::walk(
          cols_select,
          ~reset_data_entry(session = session, item = .x)
        )
      }
    })
  })
}
