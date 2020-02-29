# Combine Placements files, export as csv
#
# I already created the indexes on the placements files,
# if this has not been done, set row.names=TRUE in write.csv 
# line
#

library(readxl)

# Create empty dataframe
AllPlacements = data.frame(PlacementID=NA,InternalCaseID=NA,IdentificationID=NA,RemovalDate=NA,PlacementBeginDate=NA,
                           PlacementEndDate=NA,Service=NA,EpisodeType=NA,
                           PlacementSetting=NA,EndingPurpose=NA,EndReason=NA)[-1,]

# Path of cases files
path = "~/GitHub/PSF_ERAU/data/xlsx_reviewed/placements"

# Path to export csv of concatenated cases file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# Loop to make RecordYear column in each Participant file
for (filename in list.files(path = path)) {
  
  # Read all files, set column names
  df <- read_excel(paste0(path, '/', filename),
                   col_names = c("PlacementID","InternalCaseID","IdentificationID", "RemovalDate","PlacementBeginDate",
                                 "PlacementEndDate","Service","EpisodeType","PlacementSetting",
                                 "EndingPurpose","EndReason"),skip=1)
  
  
  # Bind data with AllCases dataframe
  AllPlacements <- rbind(AllPlacements, df)
  
}

# Remove rows with InternalCaseID's that are NOT IN Cases
AllPlacements_inCases <- filter(AllPlacements, AllPlacements$InternalCaseID %in% AllCasesUQ$InternalCaseID)

# Write to csv
write.csv(AllPlacements, paste0(exportpath,'/','All_Placements.csv'), row.names = FALSE)

# Clean up R Studio
remove(path, exportpath, filename, df)
