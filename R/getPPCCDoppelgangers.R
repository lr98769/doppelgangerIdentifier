#' A function to identify PPCC Data Doppelgangers
#'
#' This function performs the following steps to identify PPCC data dopplgangers between batches:
#' 1. Batch correct batches with sva::ComBat
#' 2. Calculate PPCC values between samples of different batches
#' 3. Label sample pairs according to their patient id and class similarities
#' 4. Calculate PPCC cut off point (maximum PPCC of any "Different Class Different Patient" sample pair)
#' 5. Identify PPCC Data Doppelgangers as sample pairs with "Same Class Different Patient" labels with PPCC values > PPCC cut-off.
#'
#' This function also identifies PPCC data doppelgangers within a batch (if only 1 batch is detected in the metadata document).
#' In this case it performs the following steps:
#' 1. Calculate PPCC values between samples within the batch
#' 2. Label sample pairs according to their patient id and class similarities
#' 3. Calculate PPCC cut off point (maximum PPCC of any "Different Class Different Patient" sample pair)
#' 4. Identify PPCC Data Doppelgangers as sample pairs with "Same Class Different Patient" labels with PPCC values > PPCC cut-off.
#'
#' **Troubleshooting Tips:**
#' 1. Ensure all (rownames) samples in the meta_data can be found in the colnames in the raw_data and vice versa.
#'
#' @param raw_data Data frame where each column is a sample and each row is a variable where rowname of each row is the variable name.
#' @param meta_data Data frame with the columns "Class", "Patient_ID", "Batch"
#' indicating the class, patient id and batch of the sample respectively and each row
#' is a sample name. Ensure the sample names are rownames of the data frame not a separate column in the data set.
#' @param do.batch.corr If False, no batch correction is carried out before doppelgangers are found
#' @return A list containing the PPCC matrix and data frame and a list of
#' doppelgangers identified
#' @export
#' @examples
#' ppccDoppelgangerResults = getPPCCDoppelgangers(rc, rc_metadata)

getPPCCDoppelgangers <- function(raw_data, meta_data, do.batch.corr = TRUE){
  # Check that all column names are found in meta_data
  if (!all(colnames(raw_data) %in% rownames(meta_data))){
    print("Error: Not all samples (colnames) in raw_data are found in (rownames of) meta_data")
    return()
  }

  required_columns = c("Class", "Patient_ID", "Batch")
  # Check that metadata contains "Class", "Patient_ID", "Batch" columns
  if (!all(required_columns %in% colnames(meta_data))){
    columns_to_be_included = setdiff(required_columns, colnames(meta_data))
    print(paste("Error: The following columns are not found in meta_data: ",
                toString(columns_to_be_included)))
    return()
  }

  return_list = list()

  # If there are 2 batches
  if (length(unique(meta_data[["Batch"]]))==2){
    # 1. Batch correct the 2 data sets with sva:ComBat
    if (do.batch.corr){
      print("1. Batch correcting the 2 data sets with sva:ComBat...")
      batches = meta_data[colnames(raw_data), "Batch"]
      return_list$Batch_corrected = sva::ComBat(dat=raw_data, batch=batches)
    } else {
      print("1. Skip batch correction")
      return_list$Batch_corrected = raw_data
    }


    #2. Calculate PPCC between samples of each batch
    # Separate batches
    print("2. Calculating PPCC between samples of each batch...")
    batch_names = unique(meta_data[["Batch"]]) # names of each batch
    batches = list() # Separate samples by batch
    for (batch_name in batch_names){
      samples_in_batch = rownames(meta_data[meta_data[, "Batch"] == batch_name,])
      batches[[batch_name]] = return_list$Batch_corrected[, samples_in_batch]
    }

    # Get ppcc_matrix and ppcc_df (For visualization with graph)
    return_list$PPCC_matrix = matrix(,nrow=ncol(batches[[1]]),
                                     ncol=ncol(batches[[2]]),
                                     dimnames = list(colnames(batches[[1]]),colnames(batches[[2]])))
    return_list$PPCC_df = as.data.frame(
      matrix(nrow=ncol(batches[[1]])*ncol(batches[[2]]), ncol=3,
             dimnames=list(c(), c("Sample1", "Sample2", "PPCC")))
    )
    # Progress bar
    total =(ncol(batches[[1]])*ncol(batches[[2]]))
    pb = txtProgressBar(min = 0, max = 100, initial = 1, label="0% done", style=3)
    index = 1
    for (i in 1:ncol(batches[[1]])){
      for (j in 1:ncol(batches[[2]])){
        ppcc = cor(batches[[1]][,i], batches[[2]][,j])
        return_list$PPCC_matrix[i,j] = ppcc
        return_list$PPCC_df[index,] = c(colnames(batches[[1]])[i],
                                        colnames(batches[[2]])[j], ppcc)

        info = sprintf("%f%% done", round(i/total *100))
        setTxtProgressBar(pb, index/total *100, label=info)
        index=index+1
      }
    }
    close = close(pb)
  }
  # If there is only 1 batches
  else if (length(unique(meta_data[["Batch"]]))==1){
    print("1. No batch correction since there is only 1 batch...")

    print("2. Calculating PPCC between samples of the same dataset...")
    return_list$PPCC_matrix = cor(raw_data)
    return_list$PPCC_matrix[upper.tri(return_list$PPCC_matrix,diag = FALSE)] = NA #to prevent repeated pairs
    numberOfRows = sum(!is.na(return_list$PPCC_matrix))
    return_list$PPCC_df = as.data.frame(
      matrix(nrow=numberOfRows, ncol=3,
             dimnames=list(c(), c("Sample1", "Sample2", "PPCC")))
    )
    index = 1
    for (sample1 in rownames(return_list$PPCC_matrix)){
      for (sample2 in colnames(return_list$PPCC_matrix)){
        ppcc = return_list$PPCC_matrix[sample1, sample2]
        if (!is.na(ppcc)){
          return_list$PPCC_df[index, ] = c(sample1, sample2, ppcc)
          index = index + 1
        }
      }
    }
  }
  else {
    print("Error: There should only be 1 or 2 batches in the \"Batch\" column of meta_data")
    return()
  }

  return_list$PPCC_df$PPCC = as.numeric(return_list$PPCC_df$PPCC)

  #3. Label Sample Pairs according to their Class and Patient Similarities
  print("3. Labelling Sample Pairs according to their Class and Patient Similarities...")
  return_list$PPCC_df$ClassPatient = labelClassPatient(ppcc_df = return_list$PPCC_df,
                                                       meta_data = meta_data)


  # 4. Calculate PPCC cut off to identify PPCC data doppelgangers
  # Cut-off = Maximum PPCC value for sample pairs with different patient and different class
  print("4. Calculating PPCC cut off to identify PPCC data doppelgangers...")
  return_list$cut_off = max(
    return_list$PPCC_df[
      return_list$PPCC_df$ClassPatient=="Different Class\n Different Patient",
      "PPCC"]
  )

  # 5. Identify sample pairs between the same class and different patient with PPCC greater than cut off point as doppelgangers
  print("5. Identifying PPCC data doppelgangers...")
  return_list$PPCC_df$DoppelgangerLabel =
    ifelse(return_list$PPCC_df$PPCC>=return_list$cut_off &
             return_list$PPCC_df$ClassPatient=="Same Class\n Different Patient",
           "Doppelganger","Not Doppelganger")

  return(return_list)
}
