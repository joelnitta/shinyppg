#' UI for undo button
#'
#' Internal function
#'
#' @import shiny
#' @returns UI
#' @noRd
undo_ui <- function(id) {
  tagList(
    shinyjs::useShinyjs(),
    actionButton(NS(id, "undo"), "Undo")
  )
}

#' Server logic to undo a change
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for
#' this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @autoglobal
#' @noRd
undo_server <- function(id, ppg) {
  stopifnot(is.reactive(ppg))
  moduleServer(id, function(input, output, session) {
    # Disable the button at the start
    shinyjs::disable("undo")
    # Since patches are kept in a global env, need to poll this to check value
    num_patches <- reactivePoll(1000, session,
      checkFunc = function() {
        length(get_patch_list())
      },
      valueFunc = function() {
        length(get_patch_list())
      }
    )
    # Enable/Disable undo button based on the number of patches
    observe({
      if (num_patches() == 0) {
        shinyjs::disable("undo")
      } else {
        shinyjs::enable("undo")
      }
    })
    error_msg <- reactiveVal("")
    observeEvent(input$undo, {
      error_msg("")
      tryCatch(
        {
          ppg_reverted <- undo_change(ppg())
          ppg(ppg_reverted)
        },
        error = function(e) {
          showNotification("Nothing to undo", type = "error")
        }
      )
    })
  })
}

# Test app
undo_app <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        delete_row_ui("delete_row"),
        undo_ui("undo")
      ),
      mainPanel(
        display_ppg_ui("display_ppg")
      )
    )
  )

  server <- function(input, output, session) {
    ppg <- load_data_server("ppg")
    rows_selected <- display_ppg_server("display_ppg", ppg)
    delete_row_server("delete_row", ppg, rows_selected)
    undo_server("undo", ppg)
  }
  shinyApp(ui, server)
}
