CREATE TYPE [dbo].[TestResults] AS TABLE (
	[Test]       NVARCHAR(900) NOT NULL DEFAULT '',
	[Result]     INTEGER       NOT NULL DEFAULT 0,
	[ObjectName] NVARCHAR(128) NOT NULL DEFAULT ''
);

CREATE FUNCTION [dbo].[DisplayTestResults]
(
	@TestData TestResults READONLY
)
RETURNS TABLE AS
RETURN 
	SELECT Test, Result AS ResultCode,
		CASE WHEN Result > 0 THEN 1 ELSE 0 END AS ResultStatus,
		ObjectName
	FROM @TestData AS TestData
GO

CREATE FUNCTION [dbo].[DisplayTestResultFooter]
(
	@TestResults TESTRESULTS READONLY
)
RETURNS TABLE AS
RETURN
	SELECT '' AS ObjectName, 'TOTAL' AS Test, 
		CAST(SUM(Result) AS VARCHAR(4)) + '/' + CAST(COUNT(*) AS VARCHAR(4)) AS ResultCount
	FROM (
		SELECT CASE WHEN Result > 0 THEN 1 ELSE 0 END AS Result
		FROM @TestResults AS Results
	) AS Results

GO
