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
    checkboxInput(NS(id, "dt_sel"), "Select/Deselect All"),
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

    output$ppg_table <- DT::renderDataTable({
      DT::datatable(
        data = ppg(),
        rownames = FALSE,
        filter = "top",
        selection = "multiple"
      )
    },
    server = TRUE)

    dt_proxy <- DT::dataTableProxy("ppg_table")
    observeEvent(input$dt_sel, {
      if (isTRUE(input$dt_sel)) {
        DT::selectRows(dt_proxy, input$ppg_table_rows_all)
      } else {
        DT::selectRows(dt_proxy, NULL)
      }
    })

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
