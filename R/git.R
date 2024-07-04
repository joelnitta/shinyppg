make_commit_msg <- function(
  user_name = "Test User", user_id = "test123", summary = "Added a new name") {
  paste(
    "Update from shinyppg",
    "\n\n",
    "user_name: ", user_name,
    "\n",
    "user_id: ", user_id,
    "\n",
    "summary: ", summary,
    sep = ""
  )
}

make_shinyppg_branch_name <- function(ppg_repo = "/ppg") {
  # Get list of branches on the remote
  shinyppg_branches <- gert::git_branch_list(repo = ppg_repo) |>
    dplyr::filter(local == FALSE) |>
    dplyr::mutate(name = stringr::str_remove_all(name, "origin/")) |>
    dplyr::filter(stringr::str_detect(name, "shinyppg-update-")) |>
    dplyr::select(name)

  # Early exit if no existing branches pushed by shinyppg
  if (nrow(shinyppg_branches) == 0) {
    return("shinyppg-update-1")
  }

  # Otherwise, get most recent number and increment
  most_recent_number <-
    shinyppg_branches |>
    dplyr::mutate(
      number = stringr::str_remove_all(name, "shinyppg-update-") |>
        as.integer()
      ) |>
    dplyr::arrange(number) |>
    dplyr::pull(number) |>
    dplyr::last()
  
  paste0("shinyppg-update-", most_recent_number + 1)
}

submit_changes <- function(
  ppg, ppg_path = "/ppg/data/ppg.csv", ppg_repo = "/ppg",
  user_name, user_id, summary, dry_run = FALSE) {

  # Check out new branch
  shinyppg_branch <- make_shinyppg_branch_name()
  gert::git_branch_create(
    shinyppg_branch,
    checkout = TRUE,
    repo = ppg_repo)

  # Write out updated ppg file
  readr::write_csv(ppg, ppg_path)

  # Stage file for pushing
  ppg_rel_path <- fs::path_rel(ppg_path, ppg_repo)
  ppg_staged <- gert::git_add(ppg_rel_path, repo = ppg_repo) |>
    dplyr::pull("staged") |>
    dplyr::first()
  assertthat::assert_that(
    isTRUE(ppg_staged),
    msg = "Could not stage ppg"
  )

  # Make commit
  ppg_commited <- gert::git_commit(
    message = make_commit_msg(user_name, user_id, summary),
    repo = ppg_repo
  )

  # Push branch
  if (dry_run) {
    return("Successfully committed and ready to push")
  }

  gert::git_push(
    repo = ppg_repo,
    password = Sys.getenv("GITHUB_TOKEN"),
  )
}