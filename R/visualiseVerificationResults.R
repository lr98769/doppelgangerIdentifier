#' Displays accuracies from functionality analysis
#'
#' Displays results from \code{\link{verifyDoppelgangers}}
#'
#' @param verificationResults List returned from  \code{\link{verifyDoppelgangers}}
#' @param originalTrainVaidNames Original names of training and validation pairs
#' @param newTrainVaidNames New names of training and validation pairs
#' @export
#' @examples
#' ori_train_valid_names = c("Doppel_0","Doppel_2", "Doppel_4", "Doppel_6", "Doppel_8", "Neg_Con", "Pos_Con")
#'
#' new_train_valid_names = c("0 Doppel", "2 Doppel", "4 Doppel", "6 Doppel", "8 Doppel", "Binomial", "Perfect Leakage")
#'
#' visualiseVerificationResults( verificationResults,
#'                               ori_train_valid_names,
#'                               new_train_valid_names)

visualiseVerificationResults <- function(verificationResults,
                                        originalTrainValidNames=c(),
                                        newTrainValidNames=c()){
  library(ggplot2)
  # Ensure it is in the right order
  verificationResults$accuracy_df$Train_Valid = factor(
    verificationResults$accuracy_df$Train_Valid,
    levels = unique(verificationResults$accuracy_df$Train_Valid))
  # If no new name is given
  if (length(originalTrainValidNames)==0 || length(newTrainValidNames)==0){
    originalTrainValidNames = unique(verificationResults$accuracy_df$Train_Valid)
    newTrainValidNames = originalTrainValidNames
  }
  ggplot(verificationResults$accuracy_df, aes(x = Train_Valid, y = Accuracy,color=ifelse(FeatureSet=="top10variance", "Top 10% Variance", ifelse(FeatureSet=="bot10variance", "Bottom 10% Variance", "Random")))) +
    geom_violin(adjust =4, color=rgb(1,1,1))+ #69faff
    ggtitle("Accuracy of KNN Models") +
    scale_color_manual(values=c("#ff00ff", "#00ff54", "808A84"),breaks = c("Top 10% Variance", "Bottom 10% Variance","Random")) +
    labs(color = "Feature Set") +
    geom_jitter(size=4,shape=16, position=position_jitter(0.2),  alpha=0.9) +
    theme(plot.title = element_text(hjust = 0.5)) +
    xlab("Training-Validation Set") +
    ylab("Accuracy") +
    scale_x_discrete(breaks=originalTrainValidNames,
                     labels=newTrainValidNames)
}
