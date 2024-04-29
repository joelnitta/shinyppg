library(shiny)
library(dwctaxon)
library(tibble)
library(readr)
library(DT)
library(dplyr)

load_data <- function() {
  read_csv("ppg.csv")
}

ui <- fluidPage(
  textInput("scientificName", label = "Scientific Name"),
  actionButton("apply", "Apply"),
  dataTableOutput("results", width = 700)
)

server <- function(input, output, session) {

  ppg <- reactiveVal(load_data())

  observeEvent(input$apply, {
    updated_data <- dct_add_row(
      ppg(),
      scientificName = input$scientificName)
    ppg(updated_data)
  })

  output$results <- renderDataTable({
    ppg() |>
      arrange(desc(modified))
  })
}

shinyApp(ui, server)