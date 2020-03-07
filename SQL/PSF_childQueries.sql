-- How many children have X number of CASES?
with CTE_caseNum AS (
	SELECT IdentificationID, COUNT(DISTINCT(InternalCaseID)) AS NumCases_Child
	FROM PARTICIPANTS
	WHERE ServiceRole IN('Child', 'Child Receiving Services')
	GROUP BY IdentificationID
	ORDER BY NumCases_Child DESC
)
SELECT COUNT(*) FROM CTE_caseNum
WHERE NumCases_Child >= 2;

-- How many children have X number of REMOVALS?
with CTE_caseRemovals AS (
	SELECT PARTICIPANTS.IdentificationID, COUNT(DISTINCT(RemovalDate)) AS NumRemovals
	FROM PARTICIPANTS
	INNER JOIN REMOVALS USING(InternalCaseID)
	WHERE ServiceRole IN('Child', 'Child Receiving Services')
	GROUP BY PARTICIPANTS.IdentificationID
	ORDER BY NumRemovals DESC
)
SELECT COUNT(*) FROM CTE_caseRemovals
WHERE NumRemovals >= 2;

-- Removal, Placement Begin/End Dates for each CaseID & Child IdentificationID
SELECT InternalCaseID, PARTICIPANTS.IdentificationID, PlacementID, RemovalDate, PlacementBegin, PlacementEnd, PlacementSetting, EndReason
FROM PARTICIPANTS
INNER JOIN PLACEMENTS USING (InternalCaseID)
WHERE ServiceRole IN('Child', 'Child Receiving Services')
GROUP BY InternalCaseID, PARTICIPANTS.IdentificationID, RemovalDate, PlacementID, PlacementBegin, PlacementEnd, PlacementSetting, EndReason
ORDER BY IdentificationID, PARTICIPANTS.IdentificationID, PlacementID DESC, RemovalDate DESC;
