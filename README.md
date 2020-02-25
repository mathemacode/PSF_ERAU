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
 
 ## Entity-Relationship Diagram
 I will not be editing the format of this database, as it's given to me in this format and thus would
 require much unnecessary effort to make adjustments.  I have made this ERD specifically for Postgres 
 implementation.
 ![ERD](./docs/PSF_ERD.png)
