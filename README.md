# PSF ERAU Foster Care Project
 PostgreSQL database for PSF data, ingestion, querying, etc.
 
 ## Focus
 The focus of this project now is to ingest the data into a database and use SQL to query
 the records, possibly to create subsets / query for specific ML subsets, then export and
 continue analysis in Python or R.  This is a continuation of the PSF project documented in
 [the FosterCare_Proj repository](https://github.com/mathemacode/FosterCare_Project), with goals
 to make the database and analysis process clean and either confirm existing insights or
 potentially find new ones.  I also want to document this well for future students who want to
 take on this project.
 
 ## TODO
 - Concat files in R (or other method?)
 - Ingest into PGAdmin PostgreSQL database
 - Build all relationships (PK, FK)
 - Indexes if needed
 - Queries to validate data
 
 ## Plan
 1. Check column name consistency, fix if needed
 2. Make all participant files same format (including adding empty columns)
 3. Merge participants files (pending 2018 fixes)
 4. Make cases files same format
 5. Merge together and add indexes to placements files
 6. Merge together and add indexes to removals files
 7. Upload all into Postgres DB
 
 ## Entity-Relationship Diagram
 I will be adding a RemovalID and PlacementID to use as Primary Keys to this database design.
 I have made this ERD specifically for Postgres implementation.  The structure is otherwise unchanged
 from how it is provided.
 ![ERD](./docs/PSF_ERD.png)
