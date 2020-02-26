# Combine Removals files, export as csv

library(readxl)

# Create empty dataframe
AllRemovals = data.frame(RemovalID=NA,InternalCaseID=NA,IdentificationID=NA,
                         RemovalDate=NA,RemovalManner=NA)[-1,]

# Path of cases files
path = "~/GitHub/PSF_ERAU/data/xlsx_reviewed/removals"

# Path to export csv of concatenated cases file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# Loop to make RecordYear column in each Participant file
for (filename in list.files(path = path)) {
  
  # Read all files, set column names
  df <- read_excel(paste0(path, '/', filename),
                   col_names = c("RemovalID","InternalCaseID","IdentificationID", 
                                 "RemovalDate","RemovalManner"),skip=1)
  
  
  # Bind data with AllCases dataframe
  AllRemovals <- rbind(AllRemovals, df)
  
}

write.csv(AllRemovals, paste0(exportpath,'/','All_Removals.csv'), row.names = FALSE)

# Clean up R Studio
remove(path, exportpath, filename, df)