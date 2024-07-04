sync_ui <- function(id) {
  tagList(
    textAreaInput(NS(id, "summary"), "Summary of changes"),
    actionButton(NS(id, "push"), "Push Branch")
  )
}

sync_server <- function(id, ppg, credentials, dry_run = FALSE) {
  moduleServer(id, function(input, output, session) {
    stopifnot(is.reactive(credentials))
    stopifnot(is.reactive(ppg))

    observeEvent(input$push, {
      submit_changes(
        ppg = ppg(),
        user = credentials()$info$name,
        user_id = credentials()$info$user,
        summary = input$summary,
        dry_run = dry_run
      )
    })
  })
}

sync_app <- function() {
  ui <- fluidPage(
    sync_ui("sync")
  )
  server <- function(input, output, session) {
    ppg <- load_data_server("ppg")
    credentials <- reactive(
      list(
        info = list(
          user = "user",
          name = "Test User"
        )
      )
    )
    sync_server(
      "sync",
      ppg = ppg,
      credentials = credentials,
      dry_run = FALSE
    )
  }
  shinyApp(ui, server)
}