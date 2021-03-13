# Number of unique cases
length(unique(All_Cases$InternalCaseID))

# Number of unique children
nrow(filter(All_Participants, All_Participants$ServiceRole == 'Child'))
#... in ML_frame:
# count(unique(ML_frame$id))

# Number of unique participants
length(unique(All_Participants$IdentificationID))

# Male vs. Female Children Distribution
nrow(filter(All_Participants, All_Participants$ServiceRole == 'Child' & All_Participants$Gender == 'Male'))
nrow(filter(All_Participants, All_Participants$ServiceRole == 'Child' & All_Participants$Gender == 'Female'))

# Record Year Distribution
barplot(table(All_Participants$RecordYear), 
        main="Record Year Distribution",
        beside=TRUE,
        xlab="Year",
        ylab="Number of Records",
        ylim=c(0, 50000),
        col="darkblue")

mean(table(All_Participants$RecordYear))

# Ethnicities
sort(table(All_Participants$Ethnicity), decreasing=TRUE)[1:10]

