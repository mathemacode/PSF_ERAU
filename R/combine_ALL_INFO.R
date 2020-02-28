# Wide file with all data on every single person, every case, removal, placement
# AllCases, AllParticipants, AllPlacements, and AllRemovals MUST be loaded in R environment

library(dplyr)

# Path to export csv of concatenated participants file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# For AllCases, added 1 to InternalCaseID if Region not blank
# For AllParticipants, added 1 to InternalCaseID if in 2017_2, 2018, or 2019
# For AllRemovals, added 1 to InternalCaseID if in _2 file
# For AllPlacements, added 1 to InternalCaseID if in _2 file

# Redo ingestion from addone folder


# merge_cases_removals <- 


write.csv(AllParticipants, paste0(exportpath,'/','ALL_JOINED.csv'), row.names = TRUE)

# Clean up R Studio
remove(exportpath, filename, year, df)