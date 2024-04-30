add_row_ui <- function(id) {
  tagList(
    textInput(NS(id, "scientificName"), label = "Scientific Name"),
    actionButton(NS(id, "apply"), "Apply")
  )
}

add_row_server <- function(id, ppg) {
  stopifnot(is.reactive(ppg))
  moduleServer(id, function(input, output, session) {
      observeEvent(input$apply, {
        updated_data <- dct_add_row(
          ppg(),
          scientificName = input$scientificName
        )
        ppg(updated_data)
      })
  })
}