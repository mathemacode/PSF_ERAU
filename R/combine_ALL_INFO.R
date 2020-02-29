# Wide file with all data on every single person, every case, removal, placement
# AllCases, AllParticipants, AllPlacements, and AllRemovals MUST be loaded in R environment

library(dplyr)

# Path to export csv of concatenated participants file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# Need to add surrogate keys for unique set of values per each df
# Swap these with current index?


# merge_cases_removals <- 


write.csv(AllParticipants, paste0(exportpath,'/','ALL_JOINED.csv'), row.names = TRUE)

# Clean up R Studio
remove(exportpath, filename, year, df)