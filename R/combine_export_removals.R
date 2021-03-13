# Combine Removals files, export as csv
#
# I already created the indexes on the removals files,
# if this has not been done, set row.names=TRUE in write.csv 
# line
#

library(readxl)
library(dplyr)

# Path of cases files
path = "~/GitHub/PSF_ERAU/data/xlsx_reviewed/_erproj_case_removals.xlsx"

# Path to export csv of concatenated cases file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# Read all files, set column names
AllRemovals <- read_excel(path,
                 col_names = c("RemovalID","InternalCaseID","IdentificationID", 
                               "RemovalDate","RemovalManner"),skip=1)


# Remove rows with InternalCaseID's that are NOT IN Cases
AllRemovals_inCases <- filter(AllRemovals, AllRemovals$InternalCaseID %in% AllCasesUQ$InternalCaseID)

# Write to csv
write.csv(AllRemovals_inCases, paste0(exportpath,'/','All_Removals.csv'), row.names = FALSE)

# Clean up R Studio
remove(path, exportpath)
