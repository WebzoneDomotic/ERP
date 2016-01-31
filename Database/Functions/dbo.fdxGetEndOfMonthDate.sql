SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetEndOfMonthDate](@currentDate datetime)
returns datetime
as
begin
   Return  dateadd(day, -2, dateadd(month, datediff(month, 0, @currentDate)+1, 1))
End
GO
