# Is the dataframe clean and ready for PK/FK in database?

df <- data.frame(AllCasesUQ)
PK <- 'InternalCaseID'
# PK <- 'IdentificationID'

# Number of unique PKs, and length of PK column should be the same
print(paste0("Unique PKs: ", length(unique(df[, c(PK)]))))
print(paste0("Number PKs: ", length(df[, c(PK)])))


# If the number of unique PKs is the same length as the column
# (all rows in column have a unique value in the PK column)

if ((length(df[, c(PK)]) - length(unique(df[, c(PK)]))) == 0) {
  print("SUCCESS!  PK IS VERIFIED")
} else {
  print("WILL NOT WORK AS PK")
}

# Find duplicated PKs
duplicates <- df[df[, c(PK)] %in% df[, c(PK)][duplicated(df[, c(PK)])],]

# Remove duplicates from df
# no_duplicates <- df[ !(df[, c(PK)] %in% df[, c(PK)][duplicated(df[, c(PK)])]),]

remove(df, PK, duplicates)
