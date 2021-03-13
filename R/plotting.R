# Number of unique cases
length(unique(All_Cases$InternalCaseID))

# Number of unique participants
length(unique(All_Participants$IdentificationID))

# After filtering, number of unique participants
length(unique(participants$IdentificationID))

# Number of unique children (before filtering) (after filtering = nrow(ML_frame))
children <- filter(All_Participants, All_Participants$ServiceRole == 'Child')
length(unique(children$IdentificationID))

# Male vs. Female Children Distribution
nrow(filter(All_Participants, All_Participants$ServiceRole == 'Child' & All_Participants$Gender == 'Male'))
nrow(filter(All_Participants, All_Participants$ServiceRole == 'Child' & All_Participants$Gender == 'Female'))

# Male vs. Female Caregiver Distribution
male_careg <- nrow(filter(All_Participants, All_Participants$ServiceRole == 'Primary Caregiver' & All_Participants$Gender == 'Male'))
female_careg <- nrow(filter(All_Participants, All_Participants$ServiceRole == 'Primary Caregiver' & All_Participants$Gender == 'Female'))

percent_female_careg <- (female_careg / (female_careg + male_careg))*100

# Record Year Distribution
barplot(table(All_Participants$RecordYear), 
        main="Record Year Distribution",
        beside=TRUE,
        xlab="Year",
        ylab="Number of Records",
        ylim=c(0, 50000),
        col="darkblue")

mean(table(All_Participants$RecordYear))

# Ethnicities Percentages
ethn_perc <- sort((sort(table(All_Participants$Ethnicity), decreasing=TRUE)[1:10] / 
                      sum(table(All_Participants$Ethnicity))) * 100, decreasing=TRUE)

