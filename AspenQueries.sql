IF OBJECT_ID('tempdb..#degreeseekingFall2015') IS NOT NULL
	DROP TABLE #degreeseekingFall2015
IF OBJECT_ID('tempdb..#nondegreeseekingFall2015') IS NOT NULL
	DROP TABLE #nondegreeseekingFall2015
IF OBJECT_ID('tempdb..#fulltimedegreeseeking') IS NOT NULL
	DROP TABLE #fulltimedegreeseeking
IF OBJECT_ID('tempdb..#parttimedegreeseeking') IS NOT NULL
	DROP TABLE #parttimedegreeseeking
IF OBJECT_ID('tempdb..#fulltimenondegreeseeking') IS NOT NULL
	DROP TABLE #fulltimenondegreeseeking
IF OBJECT_ID('tempdb..#parttimenondegreeseeking') IS NOT NULL
	DROP TABLE #parttimenondegreeseeking


SELECT DISTINCT 
	r1.[STUDENT-ID]
INTO
	#degreeseekingFall2015
FROM
	StateSubmission.SDB.RecordType1 r1
	INNER JOIN StateSubmission.SDB.RecordType4 r4 ON r4.DE1021 = r1.[STUDENT-ID]
WHERE
	r1.[DE1005-FTIC-FLG] = 'Y'
	AND r1.[TERM-ID] = '214'
	AND r4.DE2001 NOT IN ('9','H')
	AND r4.DE1028 = '214'

SELECT DISTINCT
	r1.[STUDENT-ID]
INTO
	#nondegreeseekingFall2015
FROM
	StateSubmission.SDB.RecordType1 r1
	INNER JOIN StateSubmission.SDB.RecordType4 r4 ON r4.DE1021 = r1.[STUDENT-ID]
WHERE
	r1.[DE1005-FTIC-FLG] = 'Y'
	AND r1.[TERM-ID] = '214'
	AND r4.DE2001 = '9'
	AND r4.DE1028 = '214'

SELECT
	d.[STUDENT-ID]
INTO
	#fulltimedegreeseeking
FROM
	#degreeseekingFall2015 d
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = d.[STUDENT-ID]
WHERE
	r6.DE1028 = '214'
	AND r6.SubmissionType = 'E'
GROUP BY
	d.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'C' THEN CAST(LEFT(r6.DE3012,4) AS INT)
			ELSE CAST(LEFT(r6.DE3012,4) AS INT) * 2
		END) >= 24

SELECT
	*
FROM
	#fulltimedegreeseeking

SELECT
	d.[STUDENT-ID]
INTO
	#parttimedegreeseeking
FROM
	#degreeseekingFall2015 d
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = d.[STUDENT-ID]
WHERE
	r6.DE1028 = '214'
	AND r6.SubmissionType = 'E'
GROUP BY
	d.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'C' THEN CAST(LEFT(r6.DE3012,4) AS INT)
			ELSE CAST(LEFT(r6.DE3012,4) AS INT) * 2
		END) <= 24

SELECT
	*
FROM
	#parttimedegreeseeking


SELECT
	d.[STUDENT-ID]
INTO
	#fulltimenondegreeseeking
FROM
	#nondegreeseekingFall2015 d
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = d.[STUDENT-ID]
WHERE
	r6.DE1028 = '214'
	AND r6.SubmissionType = 'E'
GROUP BY
	d.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'C' THEN CAST(LEFT(r6.DE3012,4) AS INT)
			ELSE CAST(LEFT(r6.DE3012,4) AS INT) * 2
		END) >= 24

SELECT
	d.[STUDENT-ID]
INTO
	#parttimenondegreeseeking
FROM
	#nondegreeseekingFall2015 d
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = d.[STUDENT-ID]
WHERE
	r6.DE1028 = '214'
	AND r6.SubmissionType = 'E'
GROUP BY
	d.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'C' THEN CAST(LEFT(r6.DE3012,4) AS INT)
			ELSE CAST(LEFT(r6.DE3012,4) AS INT) * 2
		END) <= 24

SELECT
	*
FROM
	#fulltimenondegreeseeking

UNION

SELECT
	*
FROM
	#parttimenondegreeseeking

SELECT
	f.[STUDENT-ID]
	,SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END)
FROM
	#fulltimedegreeseeking f
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('214','315','115')
GROUP BY
	f.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END) >= 24

SELECT
	f.[STUDENT-ID]
	,SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END)
FROM
	#parttimedegreeseeking f
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('214','315','115')
GROUP BY
	f.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END) >= 12

SELECT
	f.[STUDENT-ID]
	,SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END)
FROM
	#fulltimenondegreeseeking f 
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('214','315','115')
GROUP BY
	f.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END) >= 24

UNION

SELECT
	f.[STUDENT-ID]
	,SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END)
FROM
	#parttimenondegreeseeking f 
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('214','315','115')
GROUP BY
	f.[STUDENT-ID]
HAVING
	SUM(CASE
			WHEN r6.DE3011 = 'S' THEN CAST(LEFT(r6.DE3012, 4) AS INT)
			ELSE 0
		END) >= 12

SELECT
	DISTINCT [STUDENT-ID]
FROM
	#fulltimedegreeseeking f
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('215','316','116')

SELECT
	DISTINCT [STUDENT-ID]
FROM
	#parttimedegreeseeking f
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('215','316','116')

SELECT
	DISTINCT [STUDENT-ID]
FROM
	#fulltimenondegreeseeking f
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('215','316','116')

UNION

SELECT
	DISTINCT [STUDENT-ID]
FROM
	#parttimenondegreeseeking f
	INNER JOIN StateSubmission.SDB.RecordType6 r6 ON r6.DE1021 = f.[STUDENT-ID]
WHERE
	r6.SubmissionType =  'E'
	AND r6.DE1028 IN ('215','316','116')