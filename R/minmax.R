#' Min-max normalize a row
#'
#' This function min-max normalizes a row
#' @param x Row
#' @return Min-Max Normalised Row
#' minmax()

minmax <- function(x) {
  # Prevent divide by zero error
  if ((max(x)-min(x)) == 0){
    return(0)
  }
  return((x- min(x)) /(max(x)-min(x)))
}
