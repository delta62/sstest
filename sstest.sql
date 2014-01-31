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
