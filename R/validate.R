#' UI for validating a DWC dataframe
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
validate_ui <- function(id) {
  tagList(
    actionButton(NS(id, "validate"), label = "Validate"),
    DT::dataTableOutput(NS(id, "validate_res"), width = 700)
  )
}

#' Server logic to validate a DWC dataframe
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
validate_server <- function(id, ppg) {
  # Check args
  stopifnot(is.reactive(ppg))

  moduleServer(id, function(input, output, session) {
    observeEvent(input$validate, {
      output$validate_res <- DT::renderDT({
        DT::datatable(
          dwctaxon::dct_validate(
            ppg(),
            on_success = "logical",
            on_fail = "summary"
          )
        )
      })
    })
  })
}
