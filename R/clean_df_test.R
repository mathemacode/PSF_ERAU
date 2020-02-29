# Is the dataframe clean and ready for PK/FK in database?

df <- AllCases
PK <- 'InternalCaseID'
# PK <- 'IdentificationID'

# Number of unique PKs, and length of PK column should be the same
print(paste0("Unique PKs: ", length(unique(df[, c(PK)]))))
print(paste0("Number PKs: ", length(df[, c(PK)])))

# Find duplicated PKs
duplicates <- df[df[, c(PK)] %in% df[, c(PK)][duplicated(df[, c(PK)])],]


remove(df, PK, duplicates)
