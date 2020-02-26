# Combine Cases files, export as csv

library(readxl)

# Create empty dataframe
AllCases = data.frame(InternalCaseID=NA,CaseType=NA,Region=NA,CaseOpenDate=NA,
                      CaseClosedDate=NA,Zip=NA)[-1,]

# Path of cases files
path = "~/GitHub/PSF_ERAU/data/xlsx_reviewed/cases"

# Path to export csv of concatenated cases file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# Loop to make RecordYear column in each Participant file
for (filename in list.files(path = path)) {
  
  # Read all files, set column names
  df <- read_excel(paste0(path, '/', filename),
                   col_names = c("InternalCaseID","CaseType","Region","CaseOpenDate",
                                 "CaseClosedDate","Zip"),skip=1)

  
  # Bind data with AllCases dataframe
  AllCases <- rbind(AllCases, df)
  
}

write.csv(AllCases, paste0(exportpath,'/','All_Cases.csv'), row.names = FALSE)

# Clean up R Studio
remove(path, exportpath, filename, df)