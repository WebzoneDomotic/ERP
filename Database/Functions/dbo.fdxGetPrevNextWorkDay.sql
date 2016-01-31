SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create Function [dbo].[fdxGetPrevNextWorkDay] (@dtDate DATETIME, @PrevNext int)
RETURNS DATETIME
AS
BEGIN
  DECLARE @intDay INT
  DECLARE @rtResult DATETIME
  SET @intDay = DATEPART(weekday,@dtDate)
  --To find Previous working day
  IF @PrevNext < 0
    IF @intDay = 1
      SET @rtResult = DATEADD(d,-2,@dtDate)
    ELSE
      IF @intDay = 2
        SET @rtResult = DATEADD(d,-3,@dtDate)
      ELSE
        SET @rtResult = DATEADD(d,-1,@dtDate)
  --To find Next working day
  ELSE
    IF @PrevNext > 0
      IF @intDay = 6
        SET @rtResult = DATEADD(d,3,@dtDate)
      ELSE
        IF @intDay = 7
           SET @rtResult = DATEADD(d,2,@dtDate)
        ELSE
           SET @rtResult = DATEADD(d,1,@dtDate)
        --Default case returns date passed to function
    ELSE
       SET @rtResult = @dtDate
  RETURN @rtResult
END
GO
