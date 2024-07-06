#' PPG app
#'
#' Run a Shiny app to view and edit the Pteridophyte Phylogeny Group (PPG)
#' taxonomic database.
#'
#' @import shiny
#' @returns An object that represents the app. This function is normally called
#' for its side-effect of starting a Shiny app that can be accessed in a web
#' browser window.
#' @export
#' @examples
#' if (interactive()) {
#'   ppg_app()
#' }
ppg_app <- function() {
  ui <- fluidPage(
    titlePanel("PPG Editor"),
    shiny::div(
      class = "pull-right",
      shinyauthr::logoutUI(id = shiny::NS("logout_module", "logout"))
    ),
    shinyauthr::loginUI(id = shiny::NS("login_module", "login")),
    shiny::uiOutput("main_content")
  )

  server <- function(input, output, session) {
    # Load data from repo (must be running from docker container)
    ppg <- load_data_server("ppg", "repo")
    higher_names <- load_pterido_higher_names()
    epithets <- load_pterido_sp_epithets()
    ipni_authors <- load_authors()

    # Set initial values
    composed_name_add <- reactiveVal("")
    composed_name_modify <- reactiveVal("")
    show_advanced <- reactiveVal(FALSE)
    ppg_remaining <- reactiveVal(data.frame())
    cols_fill <- reactiveVal(cols_select)

    # Call login module
    credentials <- login_server(
      id = "login_module",
      data = user_base,
      user_col = "user",
      pwd_col = "password",
      sodium_hashed = TRUE,
      log_out = shiny::reactive(logout_init())
    )

    # Call logout module
    logout_init <- logout_server(
      id = "logout_module",
      active = shiny::reactive(credentials()$user_auth)
    )

    # Specify UI
    output$main_content <- shiny::renderUI({
      shiny::req(credentials()$user_auth)
      dwctaxon::dct_options(user_name = credentials()$info$name)
      dwctaxon::dct_options(user_id = credentials()$info$user)
      tabsetPanel(
        tabPanel(
          "Data Entry",
          sidebarLayout(
            sidebarPanel(
              tabsetPanel(
                tabPanel(
                  "Add row",
                  compose_name_ui("sci_name_add"),
                  data_entry_ui("add_row", "Add row"),
                  hr(),
                  delete_row_ui("delete_row"),
                  hr(),
                  undo_ui("undo")
                ),
                tabPanel(
                  "Edit row",
                  compose_name_ui("sci_name_modify"),
                  data_entry_ui("modify_row", "Modify row"),
                  hr(),
                  delete_row_ui("delete_row"),
                  hr(),
                  undo_ui("undo")
                ),
                tabPanel(
                  "Subset data",
                  subset_ui("subset")
                )
              ),
            ),
            mainPanel(
              display_ppg_ui("display_ppg")
            )
          )
        ),
        tabPanel("Data Validation", validate_ui("validate")),
        tabPanel("Save and Submit", sync_ui("sync")),
        tabPanel(
          "Settings",
          settings_ui("settings")
        )
      )
    })

    # Other server logic

    # - initial ppg table display
    rows_selected <- display_ppg_server("display_ppg", ppg)
    # - settings
    settings <- settings_server("settings")
    # - name composer for adding a new name
    compose_name_server(
      "sci_name_add", higher_names, epithets, ipni_authors,
      composed_name_add, ppg, rows_selected,
      fill_sci_name = FALSE,
      credentials
    )
    # - name composer for modifying a name
    compose_name_server(
      "sci_name_modify", higher_names, epithets, ipni_authors,
      composed_name_modify, ppg, rows_selected,
      fill_sci_name = TRUE,
      credentials
    )
    # - add a name
    show_advanced <- add_row_server(
      id = "add_row",
      ppg = ppg,
      composed_name = composed_name_add,
      rows_selected = rows_selected,
      show_advanced = show_advanced,
      credentials = credentials
    )
    # - modify a name
    cols_fill(subset_cols_to_fill(settings, cols_fill, cols_select))
    show_advanced <- modify_row_server(
      id = "modify_row",
      ppg = ppg,
      rows_selected = rows_selected,
      composed_name = composed_name_modify,
      show_advanced = show_advanced,
      credentials = credentials,
      cols_fill = cols_fill
    )
    # - delete a name
    delete_row_server("delete_row", ppg, rows_selected)
    # - run validation
    validate_server("validate", ppg)
    # - undo the last change
    undo_server("undo", ppg)
    # - subset data
    subset_server(
      id = "subset",
      ppg = ppg,
      ppg_remaining = ppg_remaining,
      credentials = credentials
    )
    # - submit changes
    sync_server(
      "sync",
      ppg,
      credentials,
      dry_run = FALSE
    )
  }

  shiny::shinyApp(ui, server)
}
