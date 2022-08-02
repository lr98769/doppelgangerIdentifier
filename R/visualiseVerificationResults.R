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
  library(dplyr)
  # Ensure it is in the right order
  verification_results$accuracy_df$Train_Valid = factor(
    verification_results$accuracy_df$Train_Valid,
    levels = unique(verification_results$accuracy_df$Train_Valid))
  # If no new name is given
  if (length(original_train_valid_names)==0 || length(new_train_valid_names)==0){
    original_train_valid_names = unique(verification_results$accuracy_df$Train_Valid)
    new_train_valid_names = original_train_valid_names
  }

  feature_set_type = verification_results$accuracy_df$FeatureSet
  feature_set_type[grepl("Random", feature_set_type)] = "Random"

  top_feature_set_name = feature_set_type[grepl("Top", feature_set_type)][1]
  bot_feature_set_name = feature_set_type[grepl("Bottom", feature_set_type)][1]

  colour_vector = c("#ff00ff", "#00ff54", "#808A84")
  name_vector = c(top_feature_set_name, bot_feature_set_name, "Random")

  colour_named_vector =  setNames(colour_vector,
                                  name_vector)

  acc_df = verification_results$accuracy_df

  plot = ggplot() +
    geom_violin(data = acc_df %>% filter(grepl("Random", FeatureSet)),
                adjust = 4,
                color=rgb(1,1,1),
                aes(x = Train_Valid, y = Accuracy)) +
    geom_jitter(data = acc_df,
                size=4,
                shape=16,
                position=position_jitter(0.2),
                alpha=0.9,
                aes(x = Train_Valid, y = Accuracy,
                    color=feature_set_type)) +
    ggtitle("Accuracy of KNN Models") +
    theme(plot.title = element_text(hjust = 0.5)) +
    xlab("Training-Validation Set") +
    ylab("Accuracy") +
    labs(color = "Feature Set") +
    scale_color_manual(values=colour_named_vector,
                       breaks=name_vector) +
    scale_x_discrete(breaks=original_train_valid_names,
                     labels=new_train_valid_names)+
    stat_summary(data = acc_df,
                 aes(x = Train_Valid, y = Accuracy),
                 fun = function(x){
                   ran_acc_mean = mean(head(x, length(x)-2))
                   return(ran_acc_mean)},
                 geom = "crossbar",
                 width = 0.3,
                 size=0.3,
                 colour = "#333333")
  return(plot)
}
