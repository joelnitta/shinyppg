test_that("Loading data works", {
  skip("Skip until upgrade to new version of PPG including modifiedBy cols")
  testServer(
    load_data_server, {
      data <- head(load_data())
      expect_equal(
        cols_select,
        colnames(data)
      )
      expect_s3_class(data, "data.frame")
    })
})
