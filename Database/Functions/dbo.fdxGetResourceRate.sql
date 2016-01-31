SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxGetResourceRate] ( @PK_dxResource int, @Date Datetime )
RETURNS Float
-- Return de rate for a resource at a specific date
AS
BEGIN
   -- Declare the return variable here
   DECLARE @HourlyRate float
   set @HourlyRate= Coalesce(( select top 1  HourlyRate from dxResourceRate 
                        where FK_dxResource = @PK_dxResource 
                          and EffectiveDate <= @Date order by EffectiveDate desc),0.0)
   -- Return the result of the function
   RETURN @HourlyRate
END
GO
