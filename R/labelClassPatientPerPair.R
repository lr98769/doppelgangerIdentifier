#' A function to label a pair of samples to their class and patient id
#'
#' This function labels a pair of samples to their class and patient id
#' @param sample1Class Class of sample 1
#' @param sample2Class Class of sample 2
#' @param sample1Patient Patient_ID of sample 1
#' @param sample2Patient Patient_ID of sample 2
#' @return Class Patient Label of the Sample Pair
#' labelClassPatientPerPair()

labelClassPatientPerPair <- function(sample1Class, sample1Patient,
                                     sample2Class, sample2Patient){
  #if same class
  if (sample1Class==sample2Class){
    #If Same Patient
    if (sample1Patient == sample2Patient){
      return("Same Class\n Same Patient")
    } 
    else { #Different Patient
      return("Same Class\n Different Patient")
    }
  } 
  else{ #Different class
    #If Same Patient
    if (sample1Patient == sample2Patient){
      return("Different Class\n Same Patient")
    } 
    else { #Different Patient
      return("Different Class\n Different Patient")
    }
  }
}