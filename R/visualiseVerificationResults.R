#' Displays accuracies from functionality analysis
#'
#' Displays results from \code{\link{verifyDoppelgangers}}
#'
#' @param verification_results List returned from  \code{\link{verifyDoppelgangers}}
#' @param original_train_valid_names Original names of training and validation pairs
#' @param new_train_valid_names New names of training and validation pairs
#' @export
#' @examples
#' \dontrun{
#' ori_train_valid_names = c("Doppel_0","Doppel_2", "Doppel_4", "Doppel_6", "Doppel_8", "Neg_Con", "Pos_Con")
#'
#' new_train_valid_names = c("0 Doppel", "2 Doppel", "4 Doppel", "6 Doppel", "8 Doppel", "Binomial", "Perfect Leakage")
#'
#' visualiseVerificationResults( verification_results,
#'                               ori_train_valid_names,
#'                               new_train_valid_names)
#' }

visualiseVerificationResults <- function(verification_results,
                                        original_train_valid_names=c(),
                                        new_train_valid_names=c()){
  library(ggplot2)
  # Ensure it is in the right order
  verification_results$accuracy_df$Train_Valid = factor(
    verification_results$accuracy_df$Train_Valid,
    levels = unique(verification_results$accuracy_df$Train_Valid))
  # If no new name is given
  if (length(original_train_valid_names)==0 || length(new_train_valid_names)==0){
    original_train_valid_names = unique(verification_results$accuracy_df$Train_Valid)
    new_train_valid_names = original_train_valid_names
  }
  ggplot(verification_results$accuracy_df, aes(x = Train_Valid, y = Accuracy,color=ifelse(FeatureSet=="top10variance", "Top 10% Variance", ifelse(FeatureSet=="bot10variance", "Bottom 10% Variance", "Random")))) +
    geom_violin(adjust =4, color=rgb(1,1,1))+ #69faff
    ggtitle("Accuracy of KNN Models") +
    scale_color_manual(values=c("#ff00ff", "#00ff54", "808A84"),breaks = c("Top 10% Variance", "Bottom 10% Variance","Random")) +
    labs(color = "Feature Set") +
    geom_jitter(size=4,shape=16, position=position_jitter(0.2),  alpha=0.9) +
    theme(plot.title = element_text(hjust = 0.5)) +
    xlab("Training-Validation Set") +
    ylab("Accuracy") +
    scale_x_discrete(breaks=original_train_valid_names,
                     labels=new_train_valid_names)
}
