# Custom HTML for the on-off switch
switch_tag <- tags$style(
  HTML(
    "
      .custom-switch {
        display: flex;
        align-items: center;
      }
      .custom-switch label {
        margin-right: 10px;
        font-weight: normal;  # Remove bold
        display: flex;
        align-items: center;  # Vertically center
      }
      .custom-switch input[type='checkbox'] {
        width: 40px;
        height: 20px;
        appearance: none;
        background-color: #ccc;
        outline: none;
        cursor: pointer;
        position: relative;
        border-radius: 20px;
        transition: background-color 0.2s;
      }
      .custom-switch input[type='checkbox']:checked {
        background-color: #66bb6a;
      }
      .custom-switch input[type='checkbox']:before {
        content: '';
        position: absolute;
        width: 18px;
        height: 18px;
        background-color: white;
        border-radius: 50%;
        top: 1px;
        left: 1px;
        transition: transform 0.2s;
      }
      .custom-switch input[type='checkbox']:checked:before {
        transform: translateX(20px);
      }
    "
  )
)

#' UI to display settings for the app
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param col_select Name of the column to use for auto-populating select values
#' @returns UI
#' @noRd
settings_ui <- function(id) {
  tagList(
    shinyjs::useShinyjs(), # Initialize shinyjs
    switch_tag,
    h3("Modify row"),
    div(
      class = "custom-switch",
      tags$label(`for` = NS(id, "autofill_id_switch"), "Autofill ID values"),
      tags$input(id = NS(id, "autofill_id_switch"), type = "checkbox"),
    ),
    helpText(
        paste(
          "Automatically fill in acceptedNameUsageID and parentNameUsageID",
          "from the selected row")
    ),
    hr()
  )
}

#' Server logic to fill a select menu with options created from ppg data
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @param rows_selected Reactive value; index of selected rows
#' @param fill_name Logical; should the selected value in the menu be
#'   auto-filled from the selected row?
#' @param credentials List; credentials passed from login
#' @param ... Passed to a filter() call to filter the rows of the ppg dataframe
#'   to only the rows that should be used for providing items in the selectize
#'   menu
#' @returns Server logic
#' @autoglobal
#' @noRd
settings_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    return(
      list(
        autofill_id = reactive(input$autofill_id_switch)
      )
    )
  })
}

#' Simple app for testing
#'
#'  internal function
#'
#' @import shiny
#' @autoglobal
#' @noRd
settings_app <- function() {
  ui <- fluidPage(
    settings_ui("settings"),
    textOutput("result")
  )
  server <- function(input, output, session) {
    settings <- settings_server("settings")
    cols_fill <- reactiveVal(cols_select)
    cols_fill(subset_cols_to_fill(
      settings, cols_fill, cols_select
    ))
    output$result <- renderText(cols_fill())
  }
  shinyApp(ui, server)
}
