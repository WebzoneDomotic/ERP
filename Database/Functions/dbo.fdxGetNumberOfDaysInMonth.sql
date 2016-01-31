SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxGetNumberOfDaysInMonth] ( @date datetime )
RETURNS int
AS
BEGIN

DECLARE @month int
DECLARE @year int
SET @month = MONTH(@date)
SET @year = YEAR(@date) RETURN
    CASE
        WHEN @month IN (1,3,5,7,8,10,12)
            THEN 31
        WHEN @month IN (4,6,9,11)
            THEN 30
        WHEN @month = 2
            THEN
                CASE
                    WHEN (@year % 4 = 0 AND @year % 100 <> 0) OR @year % 400 = 0
                        THEN 29
                    ELSE 28
                END
        END

END
GO
