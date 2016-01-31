SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[fdxGetNewLeadtime] (@CurrentDate Datetime, @Lt float) returns Int as begin
  Declare @Day int
  Declare @StartDate Datetime

  set @StartDate = @CurrentDate

  set @Day = DATEPART ( dw, @CurrentDate )
  -- if Sunday set date to Friday
  if @Day = 1 set @CurrentDate = Dateadd(Day,-2,@CurrentDate)
  -- if Saturday set date to Friday
  if @Day = 7 set @CurrentDate = Dateadd(Day,-1,@CurrentDate)

  -- Add weekend days to leadtime
  set @Lt = @Lt + (Convert(int,Ceiling(@Lt))/5 * 2)
  set @CurrentDate = Dateadd(Day,-1 * @Lt,@CurrentDate)

  set @Day = DATEPART ( dw, @CurrentDate )
  -- if Sunday set date to Friday
  if @Day = 1 set @CurrentDate = Dateadd(Day,-2,@CurrentDate)
  -- if Saturday set date to Friday
  if @Day = 7 set @CurrentDate = Dateadd(Day,-1,@CurrentDate)

  Return ABS(DateDiff ( dd, @CurrentDate,@StartDate ))
end
GO
