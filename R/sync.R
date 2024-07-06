#' UI for syncing
#' @autoglobal
#' @noRd
sync_ui <- function(id) {
  tagList(
    textAreaInput(NS(id, "summary"), "Summary of changes"),
    actionButton(NS(id, "push"), "Push Branch"),
    textOutput(NS(id, "gh_token")),
    textOutput(NS(id, "gh_user"))
  )
}

#' Server for syncing
#' @autoglobal
#' @noRd
sync_server <- function(id, ppg, credentials, dry_run = FALSE) {
  moduleServer(id, function(input, output, session) {
    stopifnot(is.reactive(credentials))
    stopifnot(is.reactive(ppg))

    observeEvent(input$push, {
      submit_changes(
        ppg = ppg(),
        user_name = credentials()$info$name,
        user_id = credentials()$info$user,
        summary = input$summary,
        dry_run = dry_run,
        ppg_path = "/home/shiny/ppg/data/ppg.csv",
        ppg_repo = "/home/shiny/ppg"
      )
    })
    token_check <- reactive(Sys.getenv("GITHUB_TOKEN"))
    gh_user_check <- reactive(Sys.getenv("GITHUB_USER"))

    output$gh_token <- renderText(token_check())
    output$gh_user <- renderText(gh_user_check())

  })
}


#' Demo app for syncing
#' @autoglobal
#' @noRd
sync_app <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        delete_row_ui("delete_row"),
        undo_ui("undo"),
        sync_ui("sync")
      ),
      mainPanel(
        display_ppg_ui("display_ppg")
      )
    )
  )
  server <- function(input, output, session) {
    ppg <- load_data_server("ppg", "repo")
    rows_selected <- display_ppg_server("display_ppg", ppg)
    delete_row_server("delete_row", ppg, rows_selected)
    undo_server("undo", ppg)
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
