SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetCurrentPeriodStartDate] () 
--Returns current period start date.
returns datetime
as
BEGIN
  RETURN ( Select Coalesce(StartDate, dbo.fdxGetDate()) from dxPeriod where dbo.fdxGetDate() between StartDate and EndDate )
END
GO
