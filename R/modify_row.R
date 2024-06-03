#' Server logic to modify a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @autoglobal
#' @noRd
modify_row_server <- function(id, ppg, rows_selected, composed_name) {

  # Check args
  stopifnot(is.reactive(ppg))
  stopifnot(is.reactive(rows_selected))
  stopifnot(is.reactive(composed_name))

  moduleServer(id, function(input, output, session) {

    # initiate error message
    error_msg <- reactiveVal("")

    acceptedNameUsage <- autocomplete_server(
      id = "acceptedNameUsage",
      ppg = ppg,
      rows_selected = rows_selected,
      placeholder = "Select parent name",
      col_select = "acceptedNameUsage",
      fill_name = TRUE,
      TRUE
    )

    parentNameUsage <- autocomplete_server(
      id = "parentNameUsage",
      ppg = ppg,
      rows_selected = rows_selected,
      placeholder = "Select parent name",
      col_select = "parentNameUsage",
      fill_name = TRUE,
      !taxonRank %in% c("form", "subspecies", "variety")
    )

    # Modify one row
    observeEvent(input$apply, {
      # Reset error message each time apply is clicked
      error_msg("")
      # Catch errors when modifying
      tryCatch({
        updated_data <- dwctaxon::dct_modify_row(
          ppg(),
          taxonID = null_if_blank(input$taxonID),
          scientificName = null_if_blank(composed_name()),
          namePublishedIn = null_if_blank(input$namePublishedIn),
          taxonRank = null_if_blank(input$taxonRank),
          taxonomicStatus = null_if_blank(input$taxonomicStatus),
          taxonRemarks = null_if_blank(input$taxonRemarks),
          acceptedNameUsageID = null_if_blank(input$acceptedNameUsageID),
          acceptedNameUsage = null_if_blank(acceptedNameUsage()),
          parentNameUsageID = null_if_blank(input$parentNameUsageID),
          parentNameUsage = null_if_blank(parentNameUsage())
        )
        ppg(updated_data)
      }, error = function(e) {
        error_msg(paste("Error:", e$message))
      })
      output$error_msg <- renderText(error_msg())
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
    mult_or_no_rows_selected <- check_mult_or_no_rows_selected(rows_selected)
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
