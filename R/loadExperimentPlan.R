#' A function to load a csv experiment plan into list form
#'
#' This function load a csv experiment plan into list form
#' @param filename Name of csv file
#' @param raw_data Data frame where each column is a sample and each row is a variable
#' @param separator The character separating the name of the training_validation pair 
#' e.g. "0 Doppel" from the "train", "valid" label. Name of each column should be in 
#' format "0 Doppel.train" if . is used as separator
#' @return Experiment plan in list form
#' loadExperimentPlan()

loadExperimentPlan <-function(filename, raw_data, separator="\\."){
  experimentCSV = read.csv(filename)
  all_sample_names = c()
  labels = c("train", "valid")
  experimentPlanList = list()
  for (col in colnames(experimentCSV)){
    split_col = strsplit(col, separator)[[1]] #c("0 Doppel", "train")
    if (!split_col[2] %in% labels){
      print(paste(split_col[2], "is not a valid label e.g. \"train\", \"valid\""))
      return()
    }
    column_vector = experimentCSV[[col]]
    column_vector = column_vector[column_vector != ""] #remove empty values
    experimentPlanList[[split_col[1]]][[split_col[2]]] = column_vector
    all_sample_names = c(all_sample_names, column_vector)
  }
  # Get unique sample names
  all_sample_names = unique(all_sample_names)
  if (all(all_sample_names %in% colnames(raw_data))){
    return(experimentPlanList)
  }
  else {
    print("Not all sample names in the plan can be found in the columns of raw_data")
    return()
  }
}