
#' Read `.mat` file into `hyperSpec` object
#'
#'
#' @param file File name.
#'
# @concept io
#' @concept moved to hySpc.read.txt
#' @concept moved to hySpc.read.mat
#'
#' @importFrom utils maintainer
#' @export

read_mat_Witec <- function(file = stop("filename or connection needed")) {
  if (!requireNamespace("R.matlab")) {
    stop("package 'R.matlab' needed.")
  }

  data <- R.matlab::readMat(file)

  if (length(data) > 1L) {
    stop(
      "Matlab file contains more than 1 object. This should not happen.\n",
      "If it is nevertheless a WITec exported .mat file, please contact the ",
      "maintainer (", maintainer("hyperSpec"), ") with\n",
      "- output of `sessionInfo ()` and\n",
      "- an example file"
    )
  }
  spcname <- names(data)
  #peel off outer layer of data structure, which only contains filename
  data <- data[[1]]
  #WITec software can export Matlab files in two different formats
  #the first is the so called DSO format, the other they simply call the Matlab format
  #The DSO format has more fields, many of which are empty
  #the names of the fields are not imported correctly in R ("axisscale" for example) when using the non-DSO format

  #check whether it is DSO or not
  DSOversion <- data[["datasetversion"]] #this will be NULL for non-DSO files
  if (!is.null(DSOversion))
  {
    spc <- new("hyperSpec", spc = data$data)
    spc$spcname <- spcname
    spc@wavelength <- as.vector(data[["axisscale"]][[2]][[1]])  #get wavelengths
    spc@label$.wavelength <- data[["axisscale"]][[4]][[1]][[1]] #get units for x-axis
  }
  else
  {
    #non-DSO file
    #data is found in [[3]]
    spc <-  new("hyperSpec", spc = data[[3]])
    #axisscale is [[4]]
    spc@wavelength<-as.vector(data[[4]][[2]][[1]])    #get wavelengths
    spc@label$.wavelength <- data[[4]][[4]][[1]][[1]] #get units for x-axis
  }
  ## consistent file import behavior across import functions
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
