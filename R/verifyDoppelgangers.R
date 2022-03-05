#' Verifies the functionality of Doppelgangers
#'
#' The user constructs a csv file with with training-validation set pairs
#' ideally incrementing the number of Doppelgangers between training and validation sets.
#' For each training-validation set pair, 12 models with different feature sets will be trained.
#' 10 random feature sets and 2 features sets of highest and lowest variance would be generated.
#' If an increase in validation accuracy of the 10 random models with increasing number of doppelgangers
#' can be observed, we can conclude that the doppelgangers included are functional doppelgangers.
#'
#' **Troubleshooting tips:**
#' - Ensure all the headers have no spaces.
#' - If excel is used for planning, save the spreadsheet as "CSV (MS-DOS) (*.csv)"
#' - Use the exact label "train" and "valid" (take note of capital letters)
#' - Ensure the separator does not exist in the name of the training-validation set (E.g. Doppel.0 is not allowed)
#' - Try to put both training-validation columns beside each other and leave no column gaps
#' - Refer to the csv file in the tutorial on the GitHub README.
#'
#' @param experiment_plan_filename Name of file containing csv experiment plan.
#' The csv file has a header with the names of the training_validation sets (e.g. "Doppel_0.train" or "Doppel_0.valid").
#' In each column (e.g. "Doppel_0.train" column), we include the names of all samples included in this training/validation set.
#' @param raw_data Dataframe of count matrix before batch correction
#' @param meta_data Dataframe of meta data
#' @param feature_set_portion Proportion of variables to be used for feature set generation
#' @param seed_num Seed number for random feature set generation
#' @param separator The character separating the name of the training_validation pair
#' e.g. "0 Doppel" from the "train", "valid" label. Name of each column should be in
#' format "0 Doppel.train" if . is used as separator
#' @param do_batch_corr If False, no batch correction is carried out
#' @param k k hyperparamter for KNN classification models
#' @param num_random_feature_sets Number of random feature sets for each training-validation set
#' @param size_of_val_set Size of each validation set (We assume the size of each validation set
#'                        is the same, this is used for the binomial model)
#' @param batch_corr_method Batch correlation method used. Only 2 options are accepted "ComBat" or "ComBat_seq".
#' @param neg_con_seed Seed used for negative control
#' @return Validation Accuracies
#' @export
#' @examples
#' \dontrun{
#' verificationResults = verifyDoppelgangers(
#' experiment_plan_filename = "tutorial/experimentPlan.csv",
#' raw_data = rc,
#' meta_data = rc_metadata)
#' }

verifyDoppelgangers <- function(experiment_plan_filename,
                                raw_data,
                                meta_data,
                                feature_set_portion=0.1,
                                seed_num = 2021,
                                separator = "\\.",
                                do_batch_corr=TRUE,
                                k=5,
                                num_random_feature_sets=10,
                                size_of_val_set=8,
                                batch_corr_method="ComBat",
                                neg_con_seed=10){
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
  if (do_batch_corr){
    if (batch_corr_method=="ComBat"){
      print("- Batch correcting with sva:ComBat...")
      batches = meta_data[colnames(raw_data), "Batch"]
      return_list$combat_minmax = sva::ComBat(dat=raw_data, batch=batches)
    }
    else if (batch_corr_method=="ComBat_seq"){
      print("- Batch correcting with sva:ComBat_seq...")
      batches = meta_data[colnames(raw_data), "Batch"]
      return_list$combat_minmax = sva::ComBat_seq(counts=as.matrix(raw_data), batch=batches)
    }
    else {
      print("Error: Invalid batch correction method is specified.")
      print("Only ComBat and ComBat_seq batch correction methods are available.")
      return()
    }
  }
  else {
    print("- Skip batch correction")
    return_list$combat_minmax = raw_data
  }
  print("- Carrying out min-max normalisation")
  return_list$combat_minmax = as.data.frame(apply(return_list$combat_minmax,1, minmax))

  #2. Random Feature Set Selection
  # 1. 10 generated feature sets (Size of 10% of all features)
  print("2. Generating Feature Sets...")
  feature_set_size = floor(feature_set_portion * ncol(return_list$combat_minmax))
  set.seed(seed_num)
  return_list$feature_sets=list()
  for (i in 1:num_random_feature_sets){
    entry_name = paste("Random",i)
    return_list$feature_sets[[entry_name]] = sample(
      colnames(return_list$combat_minmax),                                                  feature_set_size)
  }
  percent = feature_set_portion * 100

  # 2. 2 feature set containing features of lowest and highest variance
  feature_selection= t(return_list$combat_minmax)
  feature_selection= cbind(feature_selection , var=apply(feature_selection, 1, FUN=var))
  feature_selection= feature_selection[order(feature_selection[,"var"], decreasing = TRUE),]

  top_feature_set_name = paste("Top", percent, "%","Variance")
  bot_feature_set_name = paste("Bottom", percent, "%","Variance")

  return_list$feature_sets[[top_feature_set_name]] = head(rownames(feature_selection), feature_set_size)
  return_list$feature_sets[[bot_feature_set_name]] = tail(rownames(feature_selection), feature_set_size)

  # 3. Experiment Design: Segregate samples into training and validation
  print("3. Loading Experiment Plan...")
  return_list$experimentPlanList = loadExperimentPlan(experiment_plan_filename,
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

      pred = knn(train=x, test=valid_x, cl=y, k=k)

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
  set.seed(neg_con_seed)
  theoretical_acc = rbinom(numFeatureSets, size_of_val_set, 0.5)/size_of_val_set
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
