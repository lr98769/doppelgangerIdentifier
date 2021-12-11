#' A function to label rows of PPCC data frame according to their class and patient id
#'
#' This function labels PPCC data frame rows according to their class and patient 
#' similarity
#' @param ppcc_df Data frame with "Sample1", "Sample2", "PPCC" as column names
#' @param meta_data Data frame with the columns "Class" and "Patient_ID"
#' indicating the class and patient id of the sample respectively and each row
#' is a sample
#' @return Labeled PPCC data frame
#' labelClassPatient()

labelClassPatient <- function(ppcc_df, meta_data){
  #Check that ppcc_df has columns "Sample1", "Sample2", "PPCC"
  required_columns = c("Sample1", "Sample2", "PPCC")
  if (!all(required_columns %in% colnames(ppcc_df))){
    columns_to_be_included = setdiff(required_columns, colnames(ppcc_df))
    print(paste("Error: The following columns are not found in ppcc_df: ", 
                toString(columns_to_be_included)))
    return()
  }
  
  # Check that all sample1 and sample2 sample names are found in meta_data
  if (!all(c(ppcc_df$Sample1, ppcc_df$Sample2) %in% rownames(meta_data))){
    print("Error: Not all samples in Sample1 and Sample2 of ppcc_df are found in (rownames of) meta_data")
    return()
  }
  
  # Check that metadata contains "Class", "Patient_ID" columns
  required_columns = c("Class", "Patient_ID")
  if (!all(required_columns %in% colnames(meta_data))){
    columns_to_be_included = setdiff(required_columns, colnames(meta_data))
    print(paste("Error: The following columns are not found in meta_data: ", 
                toString(columns_to_be_included)))
    return()
  }
  
  sample1Classes = meta_data[ppcc_df$Sample1, "Class"]
  sample1Patient = meta_data[ppcc_df$Sample1, "Patient_ID"]
  sample2Classes = meta_data[ppcc_df$Sample2, "Class"]
  sample2Patient = meta_data[ppcc_df$Sample2, "Patient_ID"]
  
  labels = mapply(labelClassPatientPerPair, 
                  sample1Classes, sample1Patient,
                  sample2Classes,sample2Patient)
  return(labels)
}