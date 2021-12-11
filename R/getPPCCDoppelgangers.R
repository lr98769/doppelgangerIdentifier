#' A function to get PPCC correlation matrix and data frame and list of doppelgangers
#'
#' This function gets PPCC between a samples of 2 different data sets/batches and
#' identifies doppelgangers between them
#' @param raw_data Data frame where each column is a sample and each row is a variable
#' @param meta_data Data frame with the columns "Class", "Patient_ID", "Batch"
#' indicating the class, patient id and batch of the sample respectively and each row
#' is a sample
#' @return A list containing the PPCC matrix and data frame and a list of 
#' doppelgangers identified
#' @export
#' @examples
#' getPPCCDoppelgangers()

getPPCCDoppelgangers <- function(raw_data, meta_data){
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
    print("1. Batch correcting the 2 data sets with sva:ComBat...")
    batches = meta_data[colnames(raw_data), "Batch"]
    return_list$Batch_corrected = sva::ComBat(dat=raw_data, batch=batches) 
    
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
    return_list$PPCC_matrix = matrix(,ncol=ncol(batches[[1]]), nrow=ncol(batches[[2]]), 
                                     dimnames = list(colnames(batches[[1]]),colnames(batches[[2]])))
    return_list$PPCC_df = as.data.frame(
      matrix(nrow=ncol(batches[[1]])*ncol(batches[[2]]), ncol=3,
             dimnames=list(c(), c("Sample1", "Sample2", "PPCC")))
    )
    index = 1
    for (i in 1:ncol(batches[[1]])){
      for (j in 1:ncol(batches[[2]])){
        ppcc = cor(batches[[1]][,i], batches[[2]][,j])
        return_list$PPCC_matrix[i,j] = ppcc
        return_list$PPCC_df[index,] = c(colnames(batches[[1]])[i],
                                        colnames(batches[[2]])[j], ppcc)
        index=index+1
      }
    }
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