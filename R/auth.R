# Login UI Module
login_ui <- function(id) {
  shiny::tagList(
    shinyauthr::loginUI(id = shiny::NS(id, "login"))
  )
}

# Login Server Module
login_server <- function(
    id, data, user_col, pwd_col, log_out,
    sodium_hashed = FALSE) {
  shiny::moduleServer(id, function(input, output, session) {
    credentials <- shinyauthr::loginServer(
      id = "login",
      data = data,
      user_col = !!rlang::ensym(user_col),
      pwd_col = !!rlang::ensym(pwd_col),
      log_out = log_out,
      sodium_hashed = sodium_hashed
    )
    return(credentials)
  })
}

# Logout UI Module
logout_ui <- function(id) {
  shiny::tagList(
    shiny::div(
      class = "pull-right", shinyauthr::logoutUI(id = shiny::NS(id, "logout"))
    )
  )
}

# Logout Server Module
logout_server <- function(id, active) {
  shiny::moduleServer(id, function(input, output, session) {
    shinyauthr::logoutServer(
      id = "logout",
      active = active
    )
  })
}

# test app
auth_app <- function() {
  # UI
  ui <- shiny::fluidPage(
    logout_ui("logout_module"),
    login_ui("login_module"),
    shiny::tableOutput("user_table")
  )

  # Main Server
  server <- function(input, output, session) {
    # Define a database with some user names and passwords
    user_base <- data.frame(
      user = c("user1", "user2"),
      password = c("pass1", "pass2"),
      permissions = c("admin", "standard"),
      name = c("User One", "User Two")
    )

    # Call login module
    credentials <- login_server(
      id = "login_module",
      data = user_base,
      user_col = "user",
      pwd_col = "password",
      log_out = shiny::reactive(logout_init())
    )

    # Call logout module
    logout_init <- logout_server(
      id = "logout_module",
      active = shiny::reactive(credentials()$user_auth)
    )

    output$user_table <- shiny::renderTable({
      shiny::req(credentials()$user_auth)
      credentials()$info
    })
  }

  shiny::shinyApp(ui = ui, server = server)
}
