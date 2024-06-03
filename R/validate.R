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
    uiOutput(NS(id, "validate_output"))
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
      # First do an inital check to see if results are valid or not
      # (stops on first error)
      initial_validate_res <- reactive(initial_validate(ppg()))

      output$validate_output <- renderUI({
        if (isTRUE(initial_validate_res())) {
          shiny::showNotification("Validation passed", type = "message")
          NULL
        } else {
          DT::dataTableOutput(NS(id, "validate_res"))
        }
      })

      # If initial pass fails, run full validation
      output$validate_res <- DT::renderDT({
        dwctaxon::dct_validate(ppg(), on_fail = "summary")
      })
    })
  })
}
