#' Import Matlab (`.mat`) file exported by Witec Project software
#' 
#' Read `.mat` by Witec Project software file into `hyperSpec` object.
#'
#' @param file Path to file or connection from which to import
#'
#' @importClassesFrom hyperSpec hyperSpec
#' @importFrom methods new
#' @importFrom utils packageDescription
#' @import hyperSpec
#'
#' @export
read_mat_Witec <- function(file = stop("filename or connection needed")) {
  if (!requireNamespace("R.matlab")) {
    stop("package 'R.matlab' needed.")
  }

  data <- R.matlab::readMat(file)

  if (length(data) > 1L) {
    stop(
      "Matlab file contains more than 1 object. This should not happen.\n",
      "If it is nevertheless a WITec exported .mat file, ",
      "please open an issue at ",
      packageDescription("hySpc.read.mat")$BugReports,
      " with\n",
      "- output of `sessionInfo ()` and\n",
      "- an example file"
    )
  }
  spcname <- names(data)
  data <- data[[1]]

  spc <- new("hyperSpec", spc = data$data)

  spc$spcname <- spcname

  ## consistent file import behaviour across import functions
  .spc_io_postprocess_optional(spc, file)
}

#' @import hySpc.testthat
#' @import testthat
hySpc.testthat::test(read_mat_Witec) <- function() {
  time_series_Witec <- system.file("extdata/mat.Witec", "time-series.mat", package = "hySpc.read.mat")

  # unit tests for `read_mat_Witec` itself
  ##################################
  test_that("read_mat_Witec correctly extracts spectral data from MAT file", {
    spc <- read_mat_Witec(time_series_Witec)

    expect_equal(spc$spc[[6, 231]], 1095)
    expect_equal(spc$spc[[4, 457]], 995)

    expect_equal(spc@wavelength[651], 651)
    expect_equal(spc@wavelength[379], 379)
  })
}
