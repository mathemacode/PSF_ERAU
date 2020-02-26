-- Build PostgreSQL database for PSF data
-- Set PK/FK, indexes, etc

-- Drop tables to re-run if necessary
DROP TABLE CASES CASCADE;
DROP TABLE PARTICIPANTS CASCADE;
DROP TABLE REMOVALS CASCADE;
DROP TABLE PLACEMENTS CASCADE;

-- Create tables
CREATE TABLE CASES (
	  "InternalCaseID" NUMERIC PRIMARY KEY NOT NULL,
	  "CaseType" VARCHAR(50),
	  "Region" VARCHAR(50) NULL,
	  "CaseOpenDate" DATE,
	  "CaseCloseDate" DATE NULL,
	  "Zip" CHAR(5)
);

CREATE TABLE PARTICIPANTS (
	"InternalCaseID" NUMERIC NOT NULL,
	"IdentificationID" NUMERIC PRIMARY KEY NOT NULL,
	"RecordYear" INTEGER,
	"Gender" VARCHAR(7),
	"Ethnicity" VARCHAR(50),
	"Hispanic" VARCHAR(12),
	"MonthOfBirth" VARCHAR(7),
	"AdoptionFlag" CHAR(1),
	"ServiceRole" VARCHAR(50),
	"LegalStatus" VARCHAR(50),
	"MaltreaterFlag" CHAR(1),
	"FatherTPRFlag" CHAR(1),
	"MotherTPRFlag" CHAR(1),
	"ResidesAtHomeFlag" CHAR(1),
	"TeenParentFlag" CHAR(1),
	"AbandonedFlag" CHAR(1),
	"ClinicallyDiagnosedFlag" CHAR(1),
	"MentalRetardationFlag" CHAR(1),
	"PhysicallyDisabledFlag" CHAR(1),
	"VHImpairedFlag" CHAR(1),
	"EmotionallyDisturbedFlag" CHAR(1),
	"SpecialCareFlag" CHAR(1),
	"RelinquishmentFlag" CHAR(1),
	"AutismFlag" CHAR(1),
	"OrganicBrainDamageFlag" CHAR(1),
	"CerebralPalsyFlag" CHAR(1),
	"PhysicalBDamageFlag" CHAR(1),
	"DeafnessFlag" CHAR(1),
	"PhysLimitFlag" CHAR(1),
	"EmotionalDisFlag" CHAR(1),
	"PraderFlag" CHAR(1),
	"InfirmitiesFlag" CHAR(1),
	"RetardationFlag" CHAR(1),
	"MentalIllnessFlag" CHAR(1),
	"SpinaFlag" CHAR(1),
	"MentalLimitationsFlag" CHAR(1)
);

CREATE TABLE REMOVALS (
	"RemovalID" INTEGER PRIMARY KEY NOT NULL,
	"InternalCaseID" NUMERIC,
	"IdentificationID" NUMERIC,
	"RemovalDate" DATE,
	"RemovalManner" VARCHAR(100)
);

CREATE TABLE PLACEMENTS (
	"PlacementID" INTEGER PRIMARY KEY NOT NULL,
	"InternalCaseID" NUMERIC,
	"IdentificationID" NUMERIC,
	"RemovalDate" DATE,
	"PlacementBegin" DATE,
	"PlacementEnd" DATE,
	"Service" VARCHAR(100),
	"EpisodeType" VARCHAR(100),
	"PlacementSetting" VARCHAR(100),
	"EndingPurpose" VARCHAR(100),
	"EndReason" VARCHAR(100)
);


-- Import data from .csv files
COPY CASES FROM 'C:/Users/dell/Documents/GitHub/PSF_ERAU/data/csv/All_Cases.csv' (FORMAT CSV, DELIMITER(','), HEADER);
COPY PARTICIPANTS FROM 'C:/Users/dell/Documents/GitHub/PSF_ERAU/data/csv/All_Participants.csv' (FORMAT CSV, DELIMITER(','), HEADER);
COPY REMOVALS FROM 'C:/Users/dell/Documents/GitHub/PSF_ERAU/data/csv/All_Removals.csv' (FORMAT CSV, DELIMITER(','), HEADER);
COPY PLACEMENTS FROM 'C:/Users/dell/Documents/GitHub/PSF_ERAU/data/csv/All_Placements.csv' (FORMAT CSV, DELIMITER(','), HEADER);


-- Foreign keys
ALTER TABLE PARTICIPANTS
ADD CONSTRAINT fk_caseid
FOREIGN KEY (InternalCaseID)
REFERENCES CASES(InternalCaseID);

ALTER TABLE REMOVALS
ADD CONSTRAINT fk_caseid
FOREIGN KEY (InternalCaseID)
REFERENCES CASES(InternalCaseID);

ALTER TABLE PLACEMENTS
ADD CONSTRAINT fk_caseid
FOREIGN KEY (InternalCaseID)
REFERENCES CASES(InternalCaseID);

ALTER TABLE REMOVALS
ADD CONSTRAINT fk_identid
FOREIGN KEY (IdentificationID)
REFERENCES PARTICIPANTS(IdentificationID);

ALTER TABLE PLACEMENTS
ADD CONSTRAINT fk_identid
FOREIGN KEY (IdentificationID)
REFERENCES PARTICIPANTS(IdentificationID);

