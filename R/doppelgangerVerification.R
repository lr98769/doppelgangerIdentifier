#' Trains 12*numberOfTrainingAndValidationSets KNN classifiers to verify the
#' functionality of PPCC
#'
#' This function verifies the functionality of PPCC
#' @param experimentPlanFilename Name of file containing csv experiment plan
#' @param raw_data Data frame where each column is a sample and each row is a variable
#' @param metadata File containing metadata
#' @param featureSetPortion Proportion of variables to be used for feature set generation
#' @param seednum Seed number for random feature set generation
#' @param separator The character separating the name of the training_validation pair
#' e.g. "0 Doppel" from the "train", "valid" label. Name of each column should be in
#' format "0 Doppel.train" if . is used as separator.
#' @return Validation Accuracies
#' @export
#' @examples
#' doppelgangerVerification()

doppelgangerVerification <- function(experimentPlanFilename,
                                      raw_data,
                                      meta_data,
                                      featureSetPortion=0.1,
                                      seednum = 2021,
                                      separator = "\\."){
  required_columns = c("Class", "Batch")
  # Check that metadata contains "Class", "Batch" columns
  if (!all(required_columns %in% colnames(meta_data))){
    columns_to_be_included = setdiff(required_columns, colnames(meta_data))
    print(paste("Error: The following columns are not found in meta_data: ",
                toString(columns_to_be_included)))
    return()
  }

  return_list = list()

  # 1. Prepocessing (Batch Correction and Min-Max Normalisation)
  print("1. Preprocessing data...")
  batches = meta_data[colnames(raw_data), "Batch"]
  return_list$combat_minmax = sva::ComBat(dat=raw_data, batch=batches)
  return_list$combat_minmax = as.data.frame(apply(return_list$combat_minmax,1, minmax))

  #2. Random Feature Set Selection
  # 1. 10 generated feature sets (Size of 10% of all features)
  print("2. Generating Feature Sets...")
  feature_set_size = floor(featureSetPortion * ncol(return_list$combat_minmax))
  set.seed(seednum)
  return_list$feature_sets=list()
  for (i in 1:10){
    entry_name = paste("random",i)
    return_list$feature_sets[[entry_name]] = sample(
      colnames(return_list$combat_minmax),                                                  feature_set_size)
  }
  # 2. 2 feature set containing features of lowest and highest variance
  feature_selection= t(return_list$combat_minmax)
  feature_selection= cbind(feature_selection , var=apply(feature_selection, 1, FUN=var))
  feature_selection= feature_selection[order(feature_selection[,"var"], decreasing = TRUE),]
  return_list$feature_sets[["top10variance"]] = head(rownames(feature_selection), feature_set_size)
  return_list$feature_sets[["bot10variance"]] = tail(rownames(feature_selection), feature_set_size)

  # 3. Experiment Design: Segregate samples into training (28) and validation (8)
  print("3. Loading Experiment Plan...")
  return_list$experimentPlanList = loadExperimentPlan(experimentPlanFilename,
                                                      raw_data,
                                                      separator=separator)

  # 4. Training: Train KNN Models Compare Accuracies on Validation Set
  print("4. Training KNN models...")
  numTrainValidPairs = length(names(return_list$experimentPlanList))
  numFeatureSets = length(names(return_list$feature_sets))
  # Generate matrix for accuracies of different validation pairs (6) and different feature sets (12)
  return_list$accuracy_mat = matrix(
    nrow = numFeatureSets,
    ncol = numTrainValidPairs+1, #additional 1 is negative control
    dimnames = list(c(names(return_list$feature_sets)),
                    c(names(return_list$experimentPlanList), "Neg_Con")))

  return_list$accuracy_df = as.data.frame(
    matrix(ncol=3,
           nrow=(numTrainValidPairs+1)*numFeatureSets,
           dimnames=list(c(),c("FeatureSet", "Train_Valid", "Accuracy")))
  )
  library(class)


  # Progress bar
  total =(numFeatureSets*numTrainValidPairs)
  pb = txtProgressBar(min = 0, max = 100, initial = 1, label="0% done", style=3)
  i=1
  for (data_pair in names(return_list$experimentPlanList)){
    for (feature_set in names(return_list$feature_sets)){
      features = return_list$feature_sets[[feature_set]]

      x_sample_names = return_list$experimentPlanList[[data_pair]][["train"]]
      x = return_list$combat_minmax[x_sample_names, features]
      y = as.factor(meta_data[x_sample_names, "Class"])

      valid_x_sample_names = return_list$experimentPlanList[[data_pair]][["valid"]]
      valid_x = return_list$combat_minmax[valid_x_sample_names, features]
      valid_y = as.factor(meta_data[valid_x_sample_names, "Class"])

      pred = knn(train=x, test=valid_x, cl=y, k=5)

      #Test performance on validation
      acc = sum(pred==valid_y)/length(valid_y)

      #Save accuracy
      return_list$accuracy_mat[feature_set,data_pair] = acc
      return_list$accuracy_df[i,] = c(feature_set, data_pair, acc)

      info = sprintf("%f%% done", round(i/total *100))
      setTxtProgressBar(pb, i/total *100, label=info)
      i=i+1
    }
  }
  close = close(pb)

  # Binomial negative control
  set.seed(10)
  theoretical_acc = rbinom(numFeatureSets, 8, 0.5)/8
  return_list$accuracy_mat[,"Neg_Con"] = theoretical_acc
  index = 1
  for (feature_set in names(return_list$feature_sets)){
    return_list$accuracy_df[i,] = c(feature_set, "Neg_Con", theoretical_acc[index])
    i=i+1
    index=index+1
  }

  return_list$accuracy_df$Accuracy = as.numeric(return_list$accuracy_df$Accuracy)

  return(return_list)
}
