-- Construct useful SQL queries

-- Find number of cases particular IdentificationID appears in
SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases
FROM PARTICIPANTS
GROUP BY IdentificationID
ORDER BY NumCases DESC;

-- Find number of cases particular IdentificationID appears in
-- With added info
SELECT IdentificationID, Gender, Ethnicity, COUNT(InternalCaseID) AS NumCases
FROM PARTICIPANTS
WHERE Ethnicity IS NOT NULL
GROUP BY IdentificationID, Gender, Ethnicity
ORDER BY NumCases DESC;

-- Find number of cases per CHILD
SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases_Child
FROM PARTICIPANTS
WHERE ServiceRole IN('Child', 'Child Receiving Services')
GROUP BY IdentificationID
ORDER BY NumCases_Child DESC;

-- Find number of cases per ADULT
SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases_Adult
FROM PARTICIPANTS
WHERE ServiceRole NOT IN('Child', 'Child Receiving Services', 
						 'Child Not Receiving Services', 'Child Not Receiving Service')
GROUP BY IdentificationID
ORDER BY NumCases_Adult DESC;

-- Check specific record
SELECT InternalCaseID, IdentificationID, ServiceRole
FROM PARTICIPANTS
WHERE IdentificationID = 10101661791;


-- Number of cases per each IdentificationID per each year
SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases, RecordYear
FROM PARTICIPANTS
GROUP BY RecordYear, IdentificationID
ORDER BY NumCases DESC, IdentificationID, RecordYear;

