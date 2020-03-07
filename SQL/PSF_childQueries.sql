-- How many children have X number of cases?
with CTE_caseNum AS (
	SELECT IdentificationID, COUNT(InternalCaseID) AS NumCases_Child
	FROM PARTICIPANTS
	WHERE ServiceRole IN('Child', 'Child Receiving Services')
	GROUP BY IdentificationID
	ORDER BY NumCases_Child DESC
)
SELECT COUNT(*) FROM CTE_caseNum
WHERE NumCases_Child >= 2;


-- Removal, Placment Begin/End Dates for each CaseID & Child IdentificationID
SELECT InternalCaseID, PARTICIPANTS.IdentificationID, RemovalDate, PlacementBegin, PlacementEnd
FROM PARTICIPANTS
INNER JOIN PLACEMENTS USING (InternalCaseID)
WHERE ServiceRole IN('Child', 'Child Receiving Services')
GROUP BY RecordYear, InternalCaseID, PARTICIPANTS.IdentificationID, RemovalDate, PlacementBegin, PlacementEnd
ORDER BY IdentificationID, RemovalDate DESC;
