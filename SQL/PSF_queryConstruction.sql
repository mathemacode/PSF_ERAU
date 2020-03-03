-- Construct useful SQL queries

-- Find number of cases per CHILD
SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases_Child
FROM PARTICIPANTS
WHERE ServiceRole = 'Child'
GROUP BY IdentificationID
ORDER BY NumCases_Child DESC;

-- Find number of cases per ADULT
SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases_Adult
FROM PARTICIPANTS
WHERE ServiceRole NOT IN('Child', 'Child Not Receiving Service')
GROUP BY IdentificationID
ORDER BY NumCases_Adult DESC;
