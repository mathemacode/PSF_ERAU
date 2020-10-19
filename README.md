# PSF ERAU Foster Care Project
 More ML modeling of PSF data, and building a PostgreSQL database for PSF data, ingestion, querying, etc.
 
 ## Main idea
 The focus of this project now is to ingest the data into a database and use SQL to query
 the records, possibly to create subsets / query for specific ML subsets, then export and
 continue analysis in Python or R.  This is a continuation of the PSF project documented in
 [the FosterCare_Proj repository](https://github.com/mathemacode/FosterCare_Project), with goals
 to make the database and analysis process clean and either confirm existing insights or
 potentially find new ones.  I also want to document this well for future students who want to
 take on this project.
 
 
 ## Update Fall 2020
 There is now an easy way to start building ML models using `./Python/ml_modeling.py`, which uses
 the dataframe output by `all_numbers_merge_data.R`.  **This is not the same file in the original
 repo!  It has been heavily modified.**
 
 
 ## Getting Started
 1. Manually check `.xlsx` files, edit yearly files of same type to have same number of columns (even if blank)
 2. Add column (manual or R) to Participants, Removals, and Placements for indexes used as Primary Key
 3. Run `combine_export_cases.R` first, then the other three `combine_export______.R` files
 4. Run `PSF_buildDB.sql` to build the Postgres locally hosted database
 5. Use `PSF_testQueries.sql` to verify imports worked and as a base for beginning querying
 
 If desired, use `df_PK_test.R` to verify that the PK column of a dataframe in R is, in fact, unique, and
 suitable to be used as a PK.  If not, a `duplicates` table is available for debugging.
 
 
 ### To get df ready for ML models after the above steps:
 1. Run `all_numbers_merge_data.R`, which outputs the file `ML_frame.csv` into ./data/ml (hidden on this repo)
 2. Open `./Python/ml_modeling.py` for some pre-built models (currently Random Forest & XGBoost)
 
 
 #### Entity-Relationship Diagram
 I will be adding a ParticipantID, RemovalID and PlacementID to use as Primary Keys to this database design.  
 I also added a "RecordYear" column to the Participants files. I have made this ERD specifically for Postgres 
 implementation.  The structure is otherwise unchanged from how it is provided.  If yearly tables that were
 concatenated together were missing columns that the others had, these were added as blank columns to maintain
 a standard throughout.
 ![ERD](./docs/PSF_ERD_small.png)
