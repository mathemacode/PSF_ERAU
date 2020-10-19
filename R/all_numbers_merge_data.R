# This program creates the dataframe "all_numbers"
# which can be used for machine learning.  It is designed
# to have as much information as possible, WITHOUT ANY NA'S
# in order to make the machine learning programs as 
# accurate as possible.

# Data is pulled from these dfs:
#       ALL_PARTICIPANTS (2010-2017 merged together, LONG)
#       case_rem_place
#       cases
#       crime
#
# Columns of all_numbers are filled with the appropriate data
# per each case, zip code, or other factor that aligns with info

library(dplyr)
cases_relevant <- filter(cases, cases$`InternalCaseID` %in% case_rem_place$`InternalCaseID`)

# ===================================================================================

# Put caseID into all_numbers
i <- 1
for (ID in all_numbers$`Identification ID`){
  
  spot <- which(case_rem_place$`Identification ID` == ID)
  all_numbers[i,1] <- case_rem_place[spot[1], 1]
  
  i = i+1
  
}

# ===================================================================================

# Put zip code into all_numbers (some do not have zips)
i <- 1
for (caseID in all_numbers$`InternalCaseID`){
  
  spot <- which(cases_relevant$`InternalCaseID` == caseID)
  all_numbers[i,4] <- as.double(cases_relevant[spot[1], 5])
  
  i = i+1
  
}

# Remove data without zip code
all_numbers <- filter(all_numbers, !is.na(all_numbers$Zip))

# ===================================================================================

# Is zip code in top 7 highest cases/popdens area or out?
# 1 = in, 0 = out
i <- 1
zips <- c(32331, 32359, 32060, 32680, 32626, 32348, 32055)

for (zipcode in all_numbers$`Zip`){
  
  spot <- which(cases_relevant$`zip5` == zipcode)
  
  if (zipcode %in% zips) {
    all_numbers[i,5] <- 1
    
  }
  else {
    all_numbers[i,5] <- 0
  }
  
 
  i = i+1
  
}

# ===================================================================================

# Find number of participants per child's case
i <- 1

uniqueIDs <- unique(all_numbers$`Identification ID`)

for (ID in uniqueIDs) {
  
  spot <- which(all_numbers$`Identification ID` == ID)
  caseID <- as.double(all_numbers[spot[1], 1])
  
  one_case <- filter(ALL_PARTICIPANTS, ALL_PARTICIPANTS$`PseudoCaseID` == caseID)
  number_of_participants <- length(unique(one_case$`Identification ID`))
  
  for (place in spot) {
    all_numbers[place,7] <- number_of_participants
  }
  
  i = i+1
  
}

# ===================================================================================

# Add Zip Count (number of cases in Zip) to all_numbers
i <- 1
for (zip in all_numbers$Zip) {
  
  all_numbers[i,9] <- nrow(filter(cases, cases$zip5 == zip))
  
  i = i+1
  
}

# Convert these character strings into doubles before moving on
all_numbers$ZipCount <- as.double(all_numbers$ZipCount)

# ===================================================================================

# Add Zip Density (Pop Density of Zip) to all_numbers
i <- 1
for (zip in all_numbers$Zip) 
  {
  spot <- which(PopDensity$`Zip/ZCTA` == zip)
  all_numbers[i,10] <- (PopDensity[spot[1], 4])
  
  i = i+1
  }

# ZipDens is a number --> make it a double
all_numbers$ZipDens <- as.double(all_numbers$ZipDens)

# Remove data that does not have ZipDens (missing Zip or density in calculation)
all_numbers <- filter(all_numbers, !is.na(all_numbers$ZipDens))

# ===================================================================================

# Case Duration
i <- 1
for (caseID in all_numbers$`InternalCaseID`){
  
  spot <- which(cases$`InternalCaseID` == caseID)
  
  all_numbers[i,11] <- (cases[spot[1], 4] - cases[spot[1], 3])
  
  i = i+1
  
}

all_numbers <- filter(all_numbers, !is.na(all_numbers$CaseDuration))

# ===================================================================================

# Age of child
copy <- filter(ALL_PARTICIPANTS, ALL_PARTICIPANTS$MonthOfBirth != "/")
copy$Year <- gsub("^", "01/01/", copy$Year)
copy$Year <- as.Date.character(copy$Year, format="%d/%m/%Y")

# Change format of birthdates to MM/DD/YYYY instead of MM/YYY
copy$MonthOfBirth <- gsub("/", "/01/", copy$MonthOfBirth)
copy$MonthOfBirth <- as.Date.character(copy$MonthOfBirth, format="%d/%m/%Y")

# Subtract case date and birth date to find age of child during case
i <- 1
for (ID in all_numbers$`Identification ID`){
  
  spot <- which(copy$`Identification ID` == ID)
  all_numbers[i,12] <- (copy[spot[1], 36] - copy[spot[1], 6])
  
  i = i+1
  
}

# Divide by 365 to convert age in days to age in years
all_numbers$Age <- all_numbers$Age / 365

# ===================================================================================

# Number of caregivers in case and the average age of them
# Start by making columns, fill with 1's before overwriting

all_numbers <- mutate(all_numbers, "NumCaregivers" = 1)
all_numbers <- mutate(all_numbers, "CareAge" = 1)

i <- 1
uniqueIDs <- unique(all_numbers$`Identification ID`)

for (ID in uniqueIDs) {
  
  spot <- which(all_numbers$`Identification ID` == ID)
  caseID <- as.double(all_numbers[spot[1], 1])
  
  one_case <- filter(copy, copy$`PseudoCaseID` == caseID)
  caregivers <- filter(one_case, one_case$`Service Role` == "Primary Caregiver" | one_case$`Service Role` == "Secondary Caregiver")
  
  number_of_caregivers <- length(unique(caregivers$`Identification ID`))
  
  # Find ages of each caregiver, sum them / number_of_caregivers = average age of caregiver in case
  # Add this number to the same record in additional column in all_numbers
  
  average <- mean(caregivers$`Year` - caregivers$`MonthOfBirth`)
  
  for (careID in caregivers$`Identification ID`){
    
    all_numbers[i,14] <- average / 365
    
  }
  
  
  for (careID in caregivers$`Identification ID`) {
    all_numbers[i,13] <- number_of_caregivers
  }
  
  i = i+1
  
}

# Remove any records that have no caregivers on record
# This means that number of caregivers = 0 and age of caregivers = 0 or INF (div 0)
all_numbers <- filter(all_numbers, all_numbers$NumCaregivers != 0)
all_numbers <- filter(all_numbers, !is.na(all_numbers$CareAge))


# Merge in dataset with crime information
# ===================================================================================

all_numbers <- mutate(all_numbers, "Per-Capita-Income" = 1)
all_numbers <- mutate(all_numbers, "Median-Household-Income"  = 1)
all_numbers <- mutate(all_numbers, "VC-(1-to-100)"  = 1)
all_numbers <- mutate(all_numbers, "PC (1 to 100)"  = 1)
all_numbers <- mutate(all_numbers, "Avg-Home-$$$"  = 1)
all_numbers <- mutate(all_numbers, "Infant-Mortailiy-Rate"  = 1)
all_numbers <- mutate(all_numbers, "Percent-of-Population-Under-18"  = 1)
all_numbers <- mutate(all_numbers, "Low-Birth-Weight"  = 1)
all_numbers <- mutate(all_numbers, "Juvenile-Dilquency-(Arrests-per-1000-Juvineles)"  = 1)


i <- 1
for (zipcode in all_numbers$`Zip`){
  
  spot <- which(crime$`ZIP` == zipcode)
  
  all_numbers[i,15] <- (crime[spot[1], 4])
  all_numbers[i,16] <- (crime[spot[1], 5])
  all_numbers[i,17] <- (crime[spot[1], 6])
  all_numbers[i,18] <- (crime[spot[1], 7])
  all_numbers[i,19] <- (crime[spot[1], 8])
  all_numbers[i,20] <- (crime[spot[1], 9])
  all_numbers[i,21] <- (crime[spot[1], 10])
  all_numbers[i,22] <- (crime[spot[1], 11])
  all_numbers[i,23] <- (crime[spot[1], 12])
  
  i = i+1
  
}

# ===================================================================================

# Remove records that did not have per capita income OR case start/end dates (end-start would be 0)
all_numbers <- filter(all_numbers, !is.na(all_numbers$"Per-Capita Income"))
all_numbers <- filter(all_numbers, !is.na(all_numbers$CaseDuration))

# ===================================================================================

# Clean up R Studio
remove(uniqueIDs, zips, zipcode, spot, i, ID, caseID, number_of_participants, one_case, place, zip, caregivers, number_of_caregivers)

# Write to file
write.csv(all_numbers, "all_numbers.csv")
