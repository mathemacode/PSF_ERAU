# Populate RecordYear column for Participants
#
# I had already created a blank column for the RecordYear,
# if this has not been done then edit this script to CREATE
# that column and then populate it.
#

library(readxl)
library(stringr)
library(dplyr)

# Create empty dataframe
AllParticipants = data.frame(InternalCaseID=NA,IdentificationID=NA,RecordYear=NA,Gender=NA,Ethnicity=NA,
                             Hispanic=NA,MonthOfBirth=NA,AdoptionFlag=NA,ServiceRole=NA,LegalStatus=NA,
                             MaltreaterFlag=NA,FatherTPRFlag=NA,MotherTPRFlag=NA,ResidesAtHomeFlag=NA,
                             TeenParentFlag=NA,AbandonedFlag=NA,ClinicallyDiagnosedFlag=NA,
                             MentalRetardationFlag=NA,PhysicallyDisabledFlag=NA,VHImpairedFlag=NA,
                             EmotionallyDisturbedFlag=NA,SpecialCareFlag=NA,RelinquishmentFlag=NA,
                             AutismFlag=NA,OrganicBrainDamageFlag=NA,CerebralPalsyFlag=NA,PhysicalBDamageFlag=NA,
                             DeafnessFlag=NA,PhysLimitFlag=NA,EmotionalDisFlag=NA,PraderFlag=NA,InfirmitiesFlag=NA,
                             RetardationFlag=NA,MentalIllnessFlag=NA,SpinaFlag=NA,MentalLimitationsFlag=NA)[-1,]

# Path of participants files
path = "~/GitHub/PSF_ERAU/data/xlsx_reviewed/participants"

# Path to export csv of concatenated participants file
exportpath = "~/GitHub/PSF_ERAU/data/csv"

# Loop to make RecordYear column in each Participant file
for (filename in list.files(path = path)) {
  
  # Extract year from filename
  year <- as.integer(str_sub(regmatches(filename, regexpr("[0-9].*[0-9]", filename)), end=4)) 
  
  # Read all files, set column names
  df <- read_excel(paste0(path, '/', filename),
                   col_names = c("InternalCaseID","IdentificationID","RecordYear","Gender","Ethnicity",
                                 "Hispanic","MonthOfBirth","AdoptionFlag","ServiceRole","LegalStatus",
                                 "MaltreaterFlag","FatherTPRFlag","MotherTPRFlag","ResidesAtHomeFlag",
                                 "TeenParentFlag","AbandonedFlag","ClinicallyDiagnosedFlag",
                                 "MentalRetardationFlag","PhysicallyDisabledFlag","VHImpairedFlag",
                                 "EmotionallyDisturbedFlag","SpecialCareFlag","RelinquishmentFlag",
                                 "AutismFlag","OrganicBrainDamageFlag","CerebralPalsyFlag","PhysicalBDamageFlag",
                                 "DeafnessFlag","PhysLimitFlag","EmotionalDisFlag","PraderFlag","InfirmitiesFlag",
                                 "RetardationFlag","MentalIllnessFlag","SpinaFlag","MentalLimitationsFlag"),skip=1)
  
  # Set RecordYear as the year in filename
  df$RecordYear = year
  
  # Bind new data with AllParticipants dataframe
  AllParticipants <- rbind(AllParticipants, df)
  
}

# Find duplicate people
# AP <- AllParticipants
# duplicates <- AP[AP$IdentificationID %in% AP$IdentificationID[duplicated(AP$IdentificationID)],]

# Remove rows with InternalCaseID's that are NOT IN Cases
AllParticipants_inCases <- filter(AllParticipants, AllParticipants$InternalCaseID %in% AllCasesUQ$InternalCaseID)

# Write to csv
write.csv(AllParticipants_inCases, paste0(exportpath,'/','All_Participants.csv'), row.names = TRUE)

# Clean up R Studio
remove(path, exportpath, filename, year, df, AP, duplicates, PK)
