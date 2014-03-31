sstest
======

sstest is a pure SQL, _tiny_ testing framework for SQL Server. The goal is to cut down on the amount of boilerplate code that needs to be written in order to run tests.

Use the `TestResults` table type that the script defines to encapsulate your tests, and optionally use the utility function `DisplayTestResults` to get a nice, joinable interface for your test results.

```SQL
DECLARE @Pass INTEGER = 1;
DECLARE @Fail INTEGER = 1;
DECLARE @Tests TestResults;

INSERT INTO @Tests (Test, Result)
VALUES
(
    'Test that some condition holds',
    (
    SELECT CASE WHEN EXISTS(
        SELECT Foo
        FROM Bar
        ) THEN @Pass
        ELSE @Fail END
    )
),
(
    'Ensure Ron didn''t nuke the db again',
    (
    SELECT COUNT(*)
    FROM Foo
    WHERE Nuked IS NULL
    )
)
[...]

SELECT *
FROM DisplayTestResults(@Tests);
[or]
SELECT *
FROM @Tests;

```

## Semantics
The `TestResults` type has 3 columns, and any can be omitted. Typically, you'll want to use both `Test` and `Result`:
* **Test:** A description of what you are doing
* **Result:** An integer describing the test results. Anything lower than 1 indicates failure, while anything above 0 indicates success.
* **ObjectName:** A grouping mechanism for testing many things in one go. For instance, you could pass 'Foo' as the object name above, then pass 'Snorkels' while testing your snorkel procedure.

## Formatting
You can get a completely non-relational summary column by running `DisplayTestResults` on your TESTRESULTS table. It's handy for a quick status report:

```SQL
DECLARE @TestResults TESTRESULTS;

[...]

SELECT Test, CASE WHEN ResultStatus = 1 THEN 'Pass' ELSE 'Fail' END AS TestStatus
FROM DisplayTestResults(@TestResults)
UNION ALL (
	SELECT Test, ResultCount
	FROM DisplayTestResultFooter(@TestResults)
)

```

