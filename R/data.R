#' Renal Cell Carcinoma Proteomics Data Set
#'
#' A benchmark proteomics data taken from the NetProt software library.The renal cell carcinoma (RCC) study of Guo et al.
#' comprises 24 proteomics runs originating from 6 pairs of non-tumorous and tumorous clear-cell renal carcinoma (ccRCC)
#' tissues, 4 proteomics runs originating from a pair of non-tumorous and tumorous chromophobe renal carcinoma (chRCC)
#' tissues and 8 proteomics run originating from two pairs of non-tumorous and tumorous papillary renal carcinoma (ppRCC)
#' tissues, in duplicates.
#'
#'
#' @docType data
#' @usage data(rc)
#' @format A data frame with 36 samples (columns) and 3126 UniProt ID variables (rows):
#' @references Guo T, Kouvonen P, Koh CC et al. Rapid mass spectrometric conversion of tissue biopsy samples into permanent quantitative digital proteome maps, Nature medicine 2015;21:407-413.
#' @source \url{https://dx.doi.org/10.1038%2Fnm.3807}
"rc"

#' Meta Data for Renal Cell Carcinoma Proteomics Data Set
#'
#' Contains the "Class"
#'
#'
#' @docType data
#' @usage data(rc)
#' @format A data frame with 36 samples (rows) and 5 variables (columns):
#' \describe{
#'   \item{Class}{Whether the sample is a "Tumor" or "Normal" tissue sample}
#'   \item{Tumour_Histological_Type}{Histological Type of the Tumour; (cc: Clear cell, p: Papillary, ch: Chromophobe)}
#'   \item{Patient_ID}{ID of the Patient (1-8)}
#'   \item{Sample_ID}{ID of the Sample (1-36)}
#'   \item{Batch}{Batch number of the Sample (1-2)}
#' }
#' @references Guo T, Kouvonen P, Koh CC et al. Rapid mass spectrometric conversion of tissue biopsy samples into permanent quantitative digital proteome maps, Nature medicine 2015;21:407-413.
#' @source \url{https://dx.doi.org/10.1038%2Fnm.3807}
"rc_metadata"

