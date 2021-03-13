# Combine Cases files, export as csv
# Note "Regions" removed

library(readxl)

# Path of cases files
path = "~/GitHub/PSF_ERAU/data/xlsx_reviewed/_erproj_cases.xlsx"

# Path to export csv of concatenated cases file
exportpath = "~/GitHub/PSF_ERAU/data/csv"


# Read file, set column names
AllCases <- read_excel(path,
            col_names = c("InternalCaseID","CaseType","CaseOpenDate",
                          "CaseClosedDate","Zip"),skip=1)


# Change #MULTIVALUE to NA
AllCases$Zip[AllCases$Zip == '#MULTIVALUE'] <- NA

# Remove duplicate values
df <- data.frame(AllCases)
PK <- 'InternalCaseID'

duplicates <- df[df[, c(PK)] %in% df[, c(PK)][duplicated(df[, c(PK)])],]
AllCasesUQ <- df[!(df[, c(PK)] %in% df[, c(PK)][duplicated(df[, c(PK)])]),]

# Write to csv file
write.csv(AllCasesUQ, paste0(exportpath,'/','All_Cases.csv'), row.names = FALSE)

# Clean up R Studio
remove(path, exportpath, df, PK)
