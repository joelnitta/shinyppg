test_that("Loading data works", {
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
