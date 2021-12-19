#' Displays accuracies from functionality analysis
#'
#' Displays results from \code{\link{doppelgangerFunctionalityVerification}}
#' @param ppccDoppelgangerResults List returned from  \code{\link{doppelgangerFunctionalityVerification}}
#' @param originalTrainVaidNames Original names of training and validation pairs
#' @param newTrainVaidNames New names of training and validation pairs
#' @export
#' @examples
#' displayVerificationResults()

displayVerificationResults <- function(functionalityResults,
                                        originalTrainValidNames,
                                        newTrainValidNames){
  library(ggplot2)
  functionalityResults$accuracy_df$Train_Valid = factor(
    functionalityResults$accuracy_df$Train_Valid,
    levels = unique(functionalityResults$accuracy_df$Train_Valid))
  ggplot(functionalityResults$accuracy_df, aes(x = Train_Valid, y = Accuracy,color=ifelse(FeatureSet=="top10variance", "Top 10% Variance", ifelse(FeatureSet=="bot10variance", "Bottom 10% Variance", "Random")))) +
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
