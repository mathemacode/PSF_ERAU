#
# This program was edited from the original repo for this
# new PSF_ERAU repo.  I've made the loop much more condensed,
# and now it is using data from csv files.
#
# This program creates the dataframe "ML_frame"
# which can be used for machine learning.  It is designed
# to have as much information as possible, WITHOUT ANY NA'S
# in order to make the machine learning programs as 
# accurate as possible.
#
# Columns of ML_frame are filled with the appropriate data
# per each case, zip code, or other factor that aligns with info.
# See ~line 105 for the exact columns included.
#
# This program also does some feature engineering to find ages
# of participants, case duration, number of removals, etc.
#

library(pastecs)
library(dplyr)
library(readr)

# Import data from csv files - use combine__.R scripts before running this file
# ========================================================================================#

All_Cases <- read_csv("GitHub/PSF_ERAU/data/csv/All_Cases.csv", 
                      col_types = cols(
                        InternalCaseID = col_double(),
                        CaseClosedDate = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                        CaseOpenDate = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                        CaseType = col_character(), InternalCaseID = col_integer(),
                        Region = col_character(), 
                        Zip = col_integer()), 
                      na = "NA")


All_Participants <- read_csv("GitHub/PSF_ERAU/data/csv/All_Participants.csv", 
                              col_types = cols(
                                AbandonedFlag = col_factor(levels = c("Y", "N")), 
                                AdoptionFlag = col_factor(levels = c("Y", "N")), 
                                AutismFlag = col_factor(levels = c("Y", "N")), 
                                CerebralPalsyFlag = col_factor(levels = c("Y", "N")), 
                                ClinicallyDiagnosedFlag = col_factor(levels = c("Y", "A","N")), 
                                DeafnessFlag = col_factor(levels = c("Y", "N")), 
                                EmotionalDisFlag = col_factor(levels = c("Y", "N")), 
                                EmotionallyDisturbedFlag = col_factor(levels = c("Y", "N")), 
                                Ethnicity = col_character(), 
                                FatherTPRFlag = col_factor(levels = c("Y", "N")),
                                Gender = col_factor(levels = c("Male", "Unknown", "Female")), 
                                Hispanic = col_character(), 
                                IdentificationID = col_double(), 
                                InfirmitiesFlag = col_factor(levels = c("Y", "N")), 
                                InternalCaseID = col_double(), 
                                LegalStatus = col_character(), 
                                MaltreaterFlag = col_factor(levels = c("Y", "N")), 
                                MentalIllnessFlag = col_factor(levels = c("Y", "N")), 
                                MentalLimitationsFlag = col_factor(levels = c("Y", "N")),
                                MentalRetardationFlag = col_factor(levels = c("Y", "N")), 
                                MonthOfBirth = col_date(format = "%m/%Y"), 
                                MotherTPRFlag = col_factor(levels = c("Y", "N")), 
                                OrganicBrainDamageFlag = col_factor(levels = c("Y", "N")), 
                                PhysLimitFlag = col_factor(levels = c("Y", "N")), 
                                PhysicalBDamageFlag = col_factor(levels = c("Y", "N")), 
                                PhysicallyDisabledFlag = col_factor(levels = c("Y", "N")), 
                                PraderFlag = col_factor(levels = c("Y", "N")), 
                                RecordYear = col_double(), 
                                RelinquishmentFlag = col_factor(levels = c("Y", "N")),
                                ResidesAtHomeFlag = col_factor(levels = c("Y", "N")), 
                                RetardationFlag = col_factor(levels = c("Y", "N")), 
                                ServiceRole = col_character(), 
                                SpecialCareFlag = col_factor(levels = c("Y", "N")), 
                                SpinaFlag = col_factor(levels = c("Y", "N")), 
                                TeenParentFlag = col_factor(levels = c("Y", "N")), 
                                VHImpairedFlag = col_factor(levels = c("Y", "N")), 
                                X1 = col_double()), 
                             na = "NA")


All_Placements <- read_csv("GitHub/PSF_ERAU/data/csv/All_Placements.csv", 
                           col_types = cols(
                              EndReason = col_character(), 
                              EndingPurpose = col_character(), 
                              EpisodeType = col_character(), 
                              IdentificationID = col_double(), 
                              InternalCaseID = col_double(), 
                              PlacementBeginDate = col_date(format = "%Y-%m-%d"), 
                              PlacementEndDate = col_date(format = "%Y-%m-%d"), 
                              PlacementID = col_double(), 
                              PlacementSetting = col_character(), 
                              RemovalDate = col_date(format = "%Y-%m-%d"), 
                              Service = col_character()),
                           na = "NA")


All_Removals <- read_csv("GitHub/PSF_ERAU/data/csv/All_Removals.csv", 
                         col_types = cols(
                          IdentificationID = col_double(), 
                          InternalCaseID = col_double(), 
                          RemovalDate = col_date(format = "%Y-%m-%d"), 
                          RemovalID = col_double(), 
                          RemovalManner = col_character()), 
                        na = "NA")


IRS_Income <- read_csv("GitHub/PSF_ERAU/data/irs/18zpallagi.csv", 
                        col_types = cols(
                          A00100 = col_double(), 
                          STATE = col_character(), 
                          zipcode = col_double()))


ML_frame = data.frame(id = double(),
                      zip = integer(),
                      zip_count = integer(),
                      number_removals = double(),
                      number_placements = double(),
                      number_participants = double(),
                      case_duration_yrs = double(),
                      number_caregivers = integer(),
                      age_child = double(),
                      avg_age_caregiver = double(),
                      avg_gross_income_zip = double(),
                      first_placement = factor(levels=c("1", "2", "3", "4")),
                      multiple_removals = factor(levels=c("1", "0")),
                      gender = factor(levels=c("0", "1")),
                      ethnicity = factor(levels=c("0", "1", "2", "3")),
                      perc_life = double(),
                      first_place_duration = double(),
                      stringsAsFactors=FALSE) 


# Reduce data size down to only cases that have all details we need
cases <- filter(All_Cases, All_Cases$`InternalCaseID` %in% All_Placements$`InternalCaseID`)
cases <- filter(cases, !is.na(cases$Zip))
participants <- filter(All_Participants, All_Participants$`InternalCaseID` %in% cases$`InternalCaseID`)
removals <- filter(All_Removals, All_Removals$`InternalCaseID` %in% cases$`InternalCaseID`)
placements <- filter(All_Placements, All_Placements$`InternalCaseID` %in% cases$`InternalCaseID`)
income <- filter(IRS_Income, IRS_Income$STATE == "FL")

# Sort so that I can easily find first/second case, person, placement etc
cases <- data.frame(cases[order(cases$CaseOpenDate),])
removals <- data.frame(removals[order(removals$RemovalDate),])
placements <- data.frame(placements[order(placements$PlacementBeginDate),])
participants <- data.frame(participants[order(participants$RecordYear, participants$InternalCaseID, participants$IdentificationID),])

# ===================================================================================

# Load all participant ID's into empty ML_frame
# for testing purposes isolate specific case, use --> ML_frame[1,"id"] <- 10006247892

children <- filter(participants, participants$ServiceRole == "Child")

i <- 1
for (id in unique(children$IdentificationID)){
  
  ML_frame[i,] <- c(id, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  
  i = i+1
}


# ===================================================================================

# Add all details; feature engineering per each row included 

i <- 1
for (id in ML_frame$id){
  
  # first zip code in system for individual's case, use to find CaseID in cases df
  case_id_of_participant <- filter(participants, participants$IdentificationID == id)$InternalCaseID[1]
  zip_code <- filter(cases, cases$InternalCaseID == case_id_of_participant)$Zip
  ML_frame[i,"zip"] <- zip_code
  
  # Zip count
  zip_count <- nrow(filter(cases, cases$Zip == zip_code))
  ML_frame[i,"zip_count"] <- zip_count
  
  # Number of removals
  num_removals <- length(unique((filter(placements, placements$IdentificationID == id)$RemovalDate)))
  ML_frame[i,"number_removals"] <- num_removals
  
  # Number of placements
  num_placements <- length(unique((filter(placements, placements$IdentificationID == id)$PlacementBeginDate)))
  ML_frame[i,"number_placements"] <- num_placements
  
  # Number of participants
  one_case <- filter(participants, participants$InternalCaseID == case_id_of_participant)
  num_participants <- (length(unique(one_case$IdentificationID)) - 1)  # Note that other children may be included
  ML_frame[i,"number_participants"] <- num_participants
  
  # Case Duration -- if this is "NA", it's probably still an open case, so use current date to find case duration thus far
  case_details <- filter(cases, cases$InternalCaseID == case_id_of_participant)
  duration <- as.double(case_details$CaseClosedDate - case_details$CaseOpenDate) / 365
  ML_frame[i,"case_duration_yrs"] <- round(duration,1)
  
  if (is.na(duration)) {
    duration_sofar <- as.double(Sys.Date() - as.Date(case_details$CaseOpenDate)) / 365
    ML_frame[i,"case_duration_yrs"] <- round(duration_sofar,1)
  }
  
  # Number of Caregivers
  case_part <- filter(participants, participants$InternalCaseID == case_id_of_participant)
  caregivers <- filter(case_part, case_part$ServiceRole == "Primary Caregiver" | case_part$ServiceRole == "Secondary Caregiver" |
                         case_part$ServiceRole == "Parent In The Home" | case_part$ServiceRole == "Parent Not In The Home")
  num_caregivers <- length(unique(caregivers$IdentificationID))
  ML_frame[i,"number_caregivers"] <- num_caregivers
  
  # Average age of caregiver
  avg_age_caregiver <- (as.double(mean(as.Date(ISOdate(caregivers$RecordYear, 1, 1)) - caregivers$MonthOfBirth))/365)
  ML_frame[i,"avg_age_caregiver"] <- round(avg_age_caregiver, 1)
  
  # Age of child
  month_of_birth_child <- filter(participants, participants$IdentificationID == id)$MonthOfBirth[1]
  date_of_case_child <- filter(cases, cases$InternalCaseID == case_id_of_participant)$CaseOpenDate
  age_of_child <- as.double(as.Date(date_of_case_child)  - as.Date(month_of_birth_child)) / 365
  ML_frame[i,"age_child"] <- round(age_of_child, 1)
  
  # Average income in zip code of case
  zip_income <- round(mean(filter(income, income$zipcode == zip_code)$`A00100`), 0)
  ML_frame[i, "avg_gross_income_zip"] <- zip_income
  
  # First case factor
  first_case <- filter(placements, placements$IdentificationID == id)$Service[1]
  first_place <- filter(placements, placements$IdentificationID == id)$PlacementSetting[1]
  
  if (isTRUE(first_place == "Pre-Adoptive Home")) {
    fact = 4
  }
  else if (isTRUE(first_case == "Relative Placement")) {
    fact = 3
  } 
  else if (isTRUE(first_case == "Non-relative Placement")) {
    fact = 2
  }
  else {
    fact = 1
  }
  
  ML_frame[i, "first_placement"] <- fact
  
  
  # Multiple removals factor
  if (ML_frame[i, "number_removals"] > 1) {
    ML_frame[i, "multiple_removals"] <- "1"
  }
  else {
    ML_frame[i, "multiple_removals"] <- "0"
  }
  
  # Gender
  gender <- filter(participants, participants$IdentificationID == id)$Gender[1]
  
  if (isTRUE(gender == "Female")) {
    gender_num <- 1
  }
  else if (isTRUE(gender == "Male")) {
    gender_num <- 0
  }
  else {
    gender_num <- NA
  }
  ML_frame[i, "gender"] <- gender_num
  
  # Ethnicity
  ethnicity <- filter(participants, participants$IdentificationID == id)$Ethnicity[1]
  if (isTRUE(ethnicity == "African American/Black")) {
    eth_num <- 3
  }
  else if (isTRUE(ethnicity == "Hispanic/Latino")) {
    eth_num <- 2
  }
  else if (isTRUE(ethnicity == "Eastern European")) {
    eth_num <- 1
  }
  else {
    eth_num <- 0
  }
  ML_frame[i, "ethnicity"] <- eth_num
  
  
  # Percent of life in system
  duration_perc <- ((as.double(case_details$CaseClosedDate - case_details$CaseOpenDate) / 365) / age_of_child)
  ML_frame[i,"perc_life"] <- round(duration_perc,1)
  
  if (is.na(duration_perc)) {
    duration_perc_sofar <- ((as.double(Sys.Date() - as.Date(case_details$CaseOpenDate)) / 365) / age_of_child)
    ML_frame[i,"perc_life"] <- round(duration_perc_sofar,1)
  }
  
  # First placement duration (years)
  first_place_start <- as.Date(filter(placements, placements$IdentificationID == id)$PlacementBeginDate[1])
  first_place_end <- as.Date(filter(placements, placements$IdentificationID == id)$PlacementEndDate[1])
  
  first_place_length <- round(((first_place_end - first_place_start) / 365), 1)
  
  ML_frame[i, "first_place_duration"] <- first_place_length
  
  
  i = i+1
}

# Remove any records missing removals or placements
ML_frame <- filter(ML_frame, ML_frame$number_removals > 0)
ML_frame <- filter(ML_frame, ML_frame$number_placements > 0)
ML_frame <- filter(ML_frame, ML_frame$age_child > 0)
ML_frame <- filter(ML_frame, ML_frame$avg_age_caregiver > 0)

# Incomplete rows for debugging:
incomplete <- ML_frame[!complete.cases(ML_frame),]

# Only include complete rows with all data for ML models
ML_frame <- ML_frame[complete.cases(ML_frame),]

# Summary of ML_frame
summary_df <- stat.desc(ML_frame)

# Write to file
write.csv(ML_frame, "GitHub/PSF_ERAU/data/ml/ML_frame.csv", row.names=FALSE)
