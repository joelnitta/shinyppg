library(shiny)
library(dwctaxon)
library(tibble)
library(readr)
library(DT)
library(dplyr)

ppg_app <- function() {
  ui <- fluidPage(
    add_row_ui("add_row"),
    dataTableOutput("results", width = 700)
  )
  server <- function(input, output, session) {
    ppg <- reactiveVal(load_data())
    add_row_server("add_row", ppg)
    output$results <- renderDataTable({
        ppg()
      })
  }
  shinyApp(ui, server)
}
