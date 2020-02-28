# Combine Cases files, export as csv

library(readxl)

# Create empty dataframe
AllCases = data.frame(InternalCaseID=NA,CaseType=NA,Region=NA,CaseOpenDate=NA,
                      CaseClosedDate=NA,Zip=NA)[-1,]

# Path of cases files
path = "~/GitHub/PSF_ERAU/data/csv/add_one/cases"


X_erproj_cases_2 <- read_excel("~/GitHub/PSF_ERAU/data/csv/add_one/cases/_erproj_cases_2.xlsx")
X_erproj_cases_2$InternalCaseID <- X_erproj_cases_2[, 1] + 1

write.csv(X_erproj_cases_2, "~/GitHub/PSF_ERAU/data/csv/add_one/cases/_erproj_cases_2.csv", row.names = FALSE)

# Loop to make RecordYear column in each Participant file
for (filename in list.files(path = path)) {
  
  # Read all files, set column names
  df <- read_xlsx(paste0(path, '/', filename),
                   col_names = c("InternalCaseID","CaseType","Region","CaseOpenDate",
                                 "CaseClosedDate","Zip"),skip=1)

  
  # Bind data with AllCases dataframe
  AllCases <- rbind(AllCases, df)
  
}

AllCases$Zip[AllCases$Zip == '#MULTIVALUE'] <- NA

# Clean up R Studio
remove(path, exportpath, filename, df)