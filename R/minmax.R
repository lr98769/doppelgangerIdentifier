#' Min-max normalize a row
#'
#' This function min-max normalizes a row
#' @param x Row
#' @return Min-Max Normalised Row
#' minmax()

minmax <- function(x) {
  return((x- min(x)) /(max(x)-min(x)))
}