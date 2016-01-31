SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetCurrentPeriodEndDate] () 
--Returns current period start date.
returns datetime
as
BEGIN
  DECLARE @d Datetime
  SET @d= ( Select Coalesce(EndDate, dbo.fdxGetDate()) from dxPeriod where dbo.fdxGetDate() between StartDate and EndDate )
  RETURN  @d
END
GO
