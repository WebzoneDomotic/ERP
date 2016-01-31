SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetBeginningOfMonthDate](@currentDate datetime)
returns datetime
as
begin
   Return  dateadd(month, -1, dateadd(day, -1, dateadd(month, datediff(month, 0, @currentDate) + 1, 1)))
End
GO
