SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Francois Baillarge
-- Create date: 2012-10-21
-- Description:	Create Pay Periods
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxCreatePayPeriod]  @StartDate date, @LengthInDays int = 14, @PaymentOffset int = 0
AS
  DECLARE @StartDateYear int, @PeriodCount int
  IF @StartDate IS NULL
     SET @StartDate = COALESCE((SELECT TOP 1 DATEADD(D, 1, EndDate) FROM dxPayPeriod ORDER BY StartDate DESC), DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0))

  SET @StartDateYear = DATEPART(YEAR, @StartDate)

  SET @PeriodCount = COALESCE(( SELECT COUNT(1) FROM dxPayPeriod WHERE DATEPART(YEAR, StartDate) = @StartDateYear), 0)
  IF @PeriodCount = 0
  BEGIN
	WITH Periods ([Sequence], [StartDate]) AS
   (SELECT 1 AS [Sequence]
          ,@StartDate AS [StartDate]
    UNION ALL
    SELECT Sequence + 1 AS Sequence
          ,DATEADD(d, @LengthInDays, [StartDate]) AS [StartDate]
    FROM Periods
    WHERE DATEPART(YEAR, DATEADD(d, @LengthInDays, [StartDate])) = @StartDateYear)

	INSERT INTO dxPayPeriod (ID, StartDate, EndDate, PaymentDate)
    SELECT CAST(DATEPART(YEAR, StartDate) AS varchar(4)) + REPLACE(STR(Sequence, 2), SPACE(1), '0') AS ID, StartDate, DATEADD(d, @LengthInDays - 1, StartDate) AS EndDate, DATEADD(d, @LengthInDays - 1 + @PaymentOffset, StartDate) As PaymentDate
    FROM Periods OPTION (MAXRECURSION 366);
  END
GO
