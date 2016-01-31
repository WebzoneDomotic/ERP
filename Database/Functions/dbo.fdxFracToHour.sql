SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxFracToHour] ( @Time Datetime )
RETURNS Float
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Hours float
    Set @Hours = DATEPART(hh,@TIME)+DATEPART(mi,@TIME)/60.0+DATEPART(ss,@TIME)/3600.00
    -- Return the result of the function
    RETURN @Hours
END
GO
