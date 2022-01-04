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
#' Refer to \code{\link{rc}} for details on the Renal Cell Carcinoma Proteomics data set.
#'
#' Contains the "Class", "Histological Type", "Patient ID", "Sample ID" and "Batch" of each sample.
#'
#'
#' @docType data
#' @usage data(rc_metadata)
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


#' Duchenne Muscular Dystrophy (DMD) Microarray Data Set
#'
#' Unprocessed data set (no batch correction performed) formed from the combination
#' of 2 independently-derived DMD data sets, Haslett et al. and Pescatori et al.
#'
#' Both data sets were combined into a single data set with the following procedure:
#' 1.	All probes of both data sets were converted to ENSEMBL IDs using biomaRt.
#' 2.	To ensure a one-to-one mapping between the probes and ENSEMBL IDs in both data
#'    sets, all probes with no ENSEMBL ID were removed. Probes with multiple ENSEMBL
#'    IDs were replaced by the ENSEMBL ID with the smallest value (ENSEMBL IDs were
#'    ordered using the default order function and all ENSEMBL IDs after the first
#'    ENSEMBL ID was removed). We took the median values of probes sharing the same
#'    ENSEMBL ID. After this procedure, both data sets would consist of unique ENSEMBL
#'    ID variables.
#' 3.	To join both data sets without any null values or data imputation (since both
#'    data sets may not have the same number and type of ENSEMBL IDs), we took the
#'    intersection of ENSEMBL IDs between both data sets. This set of ENSEMBL IDs
#'    would be the ENSEMBL IDs of the joined data set.
#' 4.	Both data sets were joined along the shared set of ENSEMBL IDs.
#'
#'
#' @docType data
#' @usage data(dmd)
#' @format A data frame with 60 samples (columns) and 8813 ENSEMBL ID variables (rows):
#' @references Haslett JN, Sanoudou D, Kho AT, Bennett RR, Greenberg SA, Kohane IS, et al. Gene expression comparison of biopsies from Duchenne muscular dystrophy (DMD) and normal skeletal muscle Proceedings of the National Academy of Sciences. 2002; 99:15000-5.
#' @references Pescatori M, Broccolini A, Minetti C, Bertini E, Bruno C, D'amico A, et al. Gene expression profiling in the early phases of DMD: a constant molecular signature characterizes DMD muscle from early postnatal life throughout disease progression The FASEB Journal. 2007; 21:1210-26.
"dmd"


#' Meta Data for Duchenne Muscular Dystrophy (DMD) Microarray Data Set
#'
#' Refer to \code{\link{dmd}} for details on the DMD data set.
#'
#' Contains the "Patient ID","Class" and "Batch" of each sample.
#'
#' @docType data
#' @usage data(dmd_metadata)
#' @format A data frame with 60 samples (rows) and 3 variables (columns):
#' \describe{
#'   \item{Patient_ID}{ID of the Patient}
#'   \item{Class}{Whether the sample is a "DMD" or "NOR" sample}
#'   \item{Batch}{Batch of the Sample (H/P; H stands for Haslett et al., P stands for Pescatori et al.)}
#' }
#' @references Haslett JN, Sanoudou D, Kho AT, Bennett RR, Greenberg SA, Kohane IS, et al. Gene expression comparison of biopsies from Duchenne muscular dystrophy (DMD) and normal skeletal muscle Proceedings of the National Academy of Sciences. 2002; 99:15000-5.
#' @references Pescatori M, Broccolini A, Minetti C, Bertini E, Bruno C, D'amico A, et al. Gene expression profiling in the early phases of DMD: a constant molecular signature characterizes DMD muscle from early postnatal life throughout disease progression The FASEB Journal. 2007; 21:1210-26.
"dmd_metadata"


#' Leukemia Microarry Data Set
#'
#' Unprocessed data set (no batch correction performed) formed from the combination
#' of 2 independently-derived leukemia data sets, Golub et al. and Armstrong et al.
#'
#' Both data sets were combined into a single data set with the following procedure:
#' 1.	All probes of Armstrong et al. were converted to ENSEMBL IDs using biomaRt and
#'    while all probes of Golub et al. were converted to ENSEMBL IDs using hu6800.db.
#' 2.	To ensure a one-to-one mapping between the probes and ENSEMBL IDs in both data
#'    sets, all probes with no ENSEMBL ID were removed. Probes with multiple ENSEMBL
#'    IDs were replaced by the ENSEMBL ID with the smallest value (ENSEMBL IDs were
#'    ordered using the default order function and all ENSEMBL IDs after the first
#'    ENSEMBL ID was removed). We took the median values of probes sharing the same
#'    ENSEMBL ID. After this procedure, both data sets would consist of unique ENSEMBL
#'    ID variables.
#' 3.	To join both data sets without any null values or data imputation (since both
#'    data sets may not have the same number and type of ENSEMBL IDs), we took the
#'    intersection of ENSEMBL IDs between both data sets. This set of ENSEMBL IDs
#'    would be the ENSEMBL IDs of the joined data set.
#' 4.	Both data sets were joined along the shared set of ENSEMBL IDs.
#'
#'
#' @docType data
#' @usage data(leuk)
#' @format A data frame with 120 samples (columns) and 5145 ENSEMBL ID variables (rows):
#' @references Golub TR, Slonim DK, Tamayo P, Huard C, Gaasenbeek M, Mesirov JP, et al. Molecular classification of cancer: class discovery and class prediction by gene expression monitoring Science. 1999; 286:531-7.
#' @references Armstrong SA, Staunton JE, Silverman LB, Pieters R, den Boer ML, Minden MD, et al. MLL translocations specify a distinct gene expression profile that distinguishes a unique leukemia Nat Genet. 2002; 30:41-7.
"leuk"


#' Meta Data for Leukemia Microarry Data Set
#'
#' Refer to \code{\link{leuk}} for details on the Leukemia Microarry data set.
#'
#' Contains the "Patient ID","Class" and "Batch" of each sample.
#'
#' @docType data
#' @usage data(leuk_metadata)
#' @format A data frame with 60 samples (rows) and 3 variables (columns):
#' \describe{
#'   \item{Patient_ID}{ID of the Patient}
#'   \item{Class}{Whether the sample is a "ALL" or "AML" sample; "ALL" stands for Acute Lymphoblastic
#'                Leukaemia while "AML" stands for Acute Myeloid Leukaemia}
#'   \item{Batch}{Batch of the Sample (A/G; A stands for Armstrong et al., G stands for Golub et al.)}
#' }
#' @references Golub TR, Slonim DK, Tamayo P, Huard C, Gaasenbeek M, Mesirov JP, et al. Molecular classification of cancer: class discovery and class prediction by gene expression monitoring Science. 1999; 286:531-7.
#' @references Armstrong SA, Staunton JE, Silverman LB, Pieters R, den Boer ML, Minden MD, et al. MLL translocations specify a distinct gene expression profile that distinguishes a unique leukemia Nat Genet. 2002; 30:41-7.
"leuk_metadata"


#' Acute Lymphoblastic Leukaemia (ALL) Microarray Data Set
#'
#' Unprocessed data set (no batch correction performed) formed from the combination
#' of 2 independently-derived ALL data sets, Ross et al. and Yeoh et al.

#'
#' Both data sets were combined into a single data set with the following procedure:
#' 1.	All probes of both data sets were converted to ENSEMBL IDs using biomaRt.
#' 2.	To ensure a one-to-one mapping between the probes and ENSEMBL IDs in both data
#'    sets, all probes with no ENSEMBL ID were removed. Probes with multiple ENSEMBL
#'    IDs were replaced by the ENSEMBL ID with the smallest value (ENSEMBL IDs were
#'    ordered using the default order function and all ENSEMBL IDs after the first
#'    ENSEMBL ID was removed). We took the median values of probes sharing the same
#'    ENSEMBL ID. After this procedure, both data sets would consist of unique ENSEMBL
#'    ID variables.
#' 3.	To join both data sets without any null values or data imputation (since both
#'    data sets may not have the same number and type of ENSEMBL IDs), we took the
#'    intersection of ENSEMBL IDs between both data sets. This set of ENSEMBL IDs
#'    would be the ENSEMBL IDs of the joined data set.
#' 4.	Both data sets were joined along the shared set of ENSEMBL IDs.
#'
#'
#' @docType data
#' @usage data(all)
#' @format A data frame with 75 samples (columns) and 8813 ENSEMBL ID variables (rows):
#' @references Ross ME, Mahfouz R, Onciu M, Liu H-C, Zhou X, Song G, et al. Gene expression profiling of pediatric acute myelogenous leukemia Blood. 2004; 104:3679-87.
#' @references Yeoh E-J, Ross ME, Shurtleff SA, Williams WK, Patel D, Mahfouz R, et al. Classification, subtype discovery, and prediction of outcome in pediatric acute lymphoblastic leukemia by gene expression profiling Cancer Cell. 2002; 1:133-43.
"all"


#' Meta Data for Acute Lymphoblastic Leukaemia (ALL) Microarry Data Set
#'
#' Refer to \code{\link{all}} for details on the Acute Lymphoblastic Leukaemia (ALL) microarry data set.
#'
#' Contains the "Patient ID","Class" and "Batch" of each sample.
#'
#' @docType data
#' @usage data(all_metadata)
#' @format A data frame with 75 samples (rows) and 3 variables (columns):
#' \describe{
#'   \item{Patient_ID}{ID of the Patient}
#'   \item{Class}{Whether the sample is a "BCR" or "E2A" sample; "BCR" stands for the BCR-ABL leukemia subtype
#'                while "E2A" stands for the E2A-PBX1 leukemia subtype}
#'   \item{Batch}{Batch of the Sample (R/Y; R stands for Ross et al., Y stands for Yeoh et al.)}
#' }
#' @references Ross ME, Mahfouz R, Onciu M, Liu H-C, Zhou X, Song G, et al. Gene expression profiling of pediatric acute myelogenous leukemia Blood. 2004; 104:3679-87.
#' @references Yeoh E-J, Ross ME, Shurtleff SA, Williams WK, Patel D, Mahfouz R, et al. Classification, subtype discovery, and prediction of outcome in pediatric acute lymphoblastic leukemia by gene expression profiling Cancer Cell. 2002; 1:133-43.
"all_metadata"
