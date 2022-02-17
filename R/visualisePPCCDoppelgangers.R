#' A function to visualize PPCC data doppelgangers on a scatter plot
#'
#' This function visualizes PPCC data doppelgangers from \code{\link{getPPCCDoppelganger}}
#' on adjacent univariate scatter plot.
#'
#' @param ppccDoppelgangerResults List returned from \code{\link{getPPCCDoppelgangers}}
#' @export
#' @examples
#' visualisePPCCDoppelgangers(ppccDoppelgangerResults = ppccDoppelgangerResults)

visualisePPCCDoppelgangers <- function(ppccDoppelgangerResults){
  library(ggplot2)
  if (!("PPCC_df" %in% names(ppccDoppelgangerResults))){
    print("Error: PPCC_df not found in ppccDoppelgangerResults")
    return()
  }

  required_columns = c("ClassPatient", "PPCC", "DoppelgangerLabel")
  # Check that metadata contains "Class", "Patient_ID", "Batch" columns
  if (!all(required_columns %in% colnames(ppccDoppelgangerResults$PPCC_df))){
    columns_to_be_included = setdiff(required_columns,
                                     colnames(ppccDoppelgangerResults$PPCC_df))
    print(paste("Error: The following columns are not found in meta_data: ",
                toString(columns_to_be_included)))
    return()
  }

  qplot(data=ppccDoppelgangerResults$PPCC_df, x=ClassPatient,y=PPCC, colour=DoppelgangerLabel, geom = "jitter", margins = TRUE) +
    scale_y_continuous(breaks = seq(-1, 1, 0.1))+
    ggtitle(label="PPCC Doppelganger Identification") +
    theme(plot.title = element_text(hjust = 0.5)) +
    xlab("Sample Pair Type") +
    scale_color_manual(values=c("#8800ff","#5c5c5c")) +
    geom_hline(yintercept=ppccDoppelgangerResults$cut_off, color = "red")+
    annotate(geom="text", label="Cut Off", x=1, y=ppccDoppelgangerResults$cut_off, vjust=-1, colour="red") +
    guides(colour=guide_legend(title="Doppelganger Label"))
}
