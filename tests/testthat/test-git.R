library(testthat)

# Set up test data ----
commit_msg_1 <- paste0(
  "Synonymize Homalosorus\n\nuser_name: Joel Nitta\nuser_id: joelnitta",
  "\nsummary: Fixes this issue")
commit_msg_2 <- paste0(
  "Recognize Bosmania\n\nuser_name: Joel Nitta\nuser_id: joelnitta",
  "\nsummary: Fixes this other issue")
commit_msg <- c(commit_msg_1, commit_msg_2)

# Run tests ----
test_that("Setting up a repo works", {
  # Need GITHUB_USER and GITHUB_TOKEN env vars to be
  # correctly set
  skip_if(Sys.getenv("GITHUB_USER") == "")
  skip_if(Sys.getenv("GITHUB_TOKEN") == "")
  skip_if_offline()
  temp_repo_dir <- tempdir() |>
    fs::path("temp-ppg")
  if (fs::dir_exists(temp_repo_dir)) {
    fs::dir_delete(temp_repo_dir)
  }
  setup_repo(ppg_repo = temp_repo_dir)
  # If cloning works, should be able to read git log
  expect_no_error(gert::git_log(repo = temp_repo_dir))
  if (fs::dir_exists(temp_repo_dir)) {
    fs::dir_delete(temp_repo_dir)
  }
})

test_that("Commit messages for working sessions are correctly formatted", {
  expect_equal(
    commit_msg_1,
    make_commit_msg(
      "Joel Nitta", "joelnitta",
      "Synonymize Homalosorus",
      "Fixes this issue"
    )
  )
})

test_that("Extracting session title works", {
  expect_equal(
    c("Synonymize Homalosorus", "Recognize Bosmania"),
    extract_session_title(commit_msg)
  )
})

test_that("Extracting session summary works", {
  expect_equal(
    c("Fixes this issue", "Fixes this other issue"),
    extract_session_summary(commit_msg)
  )
})
