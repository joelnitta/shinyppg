#' Clone the ppg repo (including the ppg dataset)
#'
#' @param ppg_repo Path to clone the ppg repo.
#' @param github_user Github username for the remote.
#' @param repo_name Repo name of the remote.
#'
#' @return Nothing; called for its side-effect
#' @noRd
setup_repo <- function(
    ppg_repo = "/home/shiny/ppg",
    github_user = "joelnitta",
    repo_name = "ppg-test") {
  assertthat::assert_that(
    isTRUE(Sys.getenv("GITHUB_USER") != ""),
    msg = "GITHUB_USER missing"
  )
  assertthat::assert_that(
    isTRUE(Sys.getenv("GITHUB_TOKEN") != ""),
    msg = "GITHUB_TOKEN missing"
  )
  assertthat::assert_that(
    !fs::dir_exists(repo_name),
    msg = "Target repo already exists; can't clone"
  )
  gert::git_clone(
    url = glue::glue(
      "https://{Sys.getenv('GITHUB_USER')}:{Sys.getenv('GITHUB_TOKEN')}\\
      @github.com/{github_user}/{repo_name}.git"
    ),
    path = ppg_repo,
    password = Sys.getenv("GITHUB_TOKEN")
  )
  # Set user
  gert::git_config_set(
    "user.email", "ourPPG@googlegroups.com",
    repo = ppg_repo
  )
  # Set user
  gert::git_config_set(
    "user.name", "PPG Bot",
    repo = ppg_repo
  )
  return(invisible())
}

#' Make a commit message for a user's working session
#'
#' @noRd
#' @autoglobal
make_commit_msg <- function(
    user_name = "Test User", user_id = "test123",
    title = "A title",
    summary = "Added a new name") {
  paste(
    title,
    "\n\n",
    "user_name: ", user_name,
    "\n",
    "user_id: ", user_id,
    "\n",
    "summary: ", summary,
    sep = ""
  )
}

#' Helper function for summarize_branches()
#'
#' The session title should be the first line of the commit message
#'
#' @param message Character vector; the commit message(s)
#'
#' @return Title of the commit message(s)
#' @noRd
#' @autoglobal
extract_session_title <- function(message) {
  stringr::str_match_all(
    message,
    "^(.*)\n"
  ) |>
    purrr::map_chr(2)
}

#' Helper function for summarize_branches()
#'
#' The session title should be the last part of the commit message, after
#' 'summary:'
#' @noRd
#' @autoglobal
extract_session_summary <- function(message) {
  stringr::str_match_all(
    message,
    "\nsummary: (.*)$"
  ) |>
    purrr::map_chr(2)
}

# Summarize the branches opened by a particular user
#' @noRd
#' @autoglobal
summarize_branches <- function(user_id, ppg_repo = "/home/shiny/ppg") {
  # Fetch remote branches and prune
  gert::git_fetch(
    repo = ppg_repo,
    prune = TRUE
  )

  user_branch_pattern <- paste0(
    user_id,
    "-\\d{6}-\\d{6}$"
  )

  # Get list of branches on the remote
  user_branches <- gert::git_branch_list(repo = ppg_repo) |>
    dplyr::filter(local == FALSE) |>
    dplyr::mutate(name = stringr::str_remove_all(name, "origin/")) |>
    dplyr::filter(stringr::str_detect(name, user_branch_pattern))

  # Return an empty tibble if no matching branches
  if (nrow(user_branches) == 0) {
    return(tibble::tibble())
  }

  # For each branch, get and parse latest commit
  purrr::map_df(
    user_branches$ref, ~ gert::git_log(ref = ., repo = ppg_repo, max = 1)
  ) |>
    dplyr::mutate(
      branch = user_branches$name,
      session_title = extract_session_title(message),
      session_summary = extract_session_summary(message),
    ) |>
    dplyr::select(branch, session_title, session_summary)
}

# Make a unique branch name based on the user ID and timestamp
#' @noRd
#' @autoglobal
make_shinyppg_branch_name <- function(user_id) {
  # Make sure time is UTC
  current_time_utc <- Sys.time()
  attr(current_time_utc, "tzone") <- "UTC"

  glue::glue("{user_id}-{format(current_time_utc, '%y%m%d-%H%M%S')}")
}

#' Submit changes to GitHub
#' @noRd
#' @autoglobal
submit_changes <- function(
    ppg, ppg_path = "/home/shiny/ppg/data/ppg.csv",
    ppg_repo = "/home/shiny/ppg",
    user_name, user_id, title, summary, dry_run = FALSE) {
  # Always write out in sci name alphabetic order
  ppg <- dplyr::arrange(ppg, scientificName, taxonID)

  # Switch back to main when done
  on.exit(
    gert::git_branch_checkout(
      "main",
      repo = ppg_repo
    )
  )

  # Define paths
  ppg_rel_path <- fs::path_rel(ppg_path, ppg_repo)

  # Check out new branch
  shinyppg_branch <- make_shinyppg_branch_name(user_id)

  branch_already_exists <- gert::git_branch_exists(
    shinyppg_branch,
    local = TRUE, repo = ppg_repo
  )

  if (!branch_already_exists) {
    gert::git_branch_create(
      shinyppg_branch,
      checkout = TRUE,
      repo = ppg_repo
    )
  } else {
    gert::git_branch_checkout(
      shinyppg_branch,
      repo = ppg_repo
    )
  }

  # Write out updated ppg file
  readr::write_csv(ppg, ppg_path)

  # Stage file for pushing
  ppg_staged <- gert::git_add(ppg_rel_path, repo = ppg_repo) |>
    dplyr::pull("staged") |>
    dplyr::first()
  assertthat::assert_that(
    isTRUE(ppg_staged),
    msg = "Could not stage ppg; maybe the data haven't changed"
  )

  # Make commit
  ppg_commited <- gert::git_commit(
    message = make_commit_msg(
      user_name = user_name,
      user_id = user_id,
      title = title,
      summary = summary
    ),
    repo = ppg_repo
  )

  # Push branch
  if (dry_run) {
    message("Everything looks good, resetting repo now")
    gert::git_branch_checkout("main", repo = ppg_repo)
    gert::git_branch_delete(shinyppg_branch, repo = ppg_repo)
    return(invisible())
  }

  assertthat::assert_that(
    isTRUE(Sys.getenv("GITHUB_TOKEN") != ""),
    msg = "Must provide GITHUB_TOKEN as an environmental variable to push"
  )

  gert::git_push(
    repo = ppg_repo,
    password = Sys.getenv("GITHUB_TOKEN"),
  )
}
