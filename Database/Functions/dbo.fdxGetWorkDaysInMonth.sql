SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetWorkDaysInMonth](@currentDate datetime)
returns int
as
begin

declare @dateRange int
declare @beginningOfMonthDate datetime, @endOfMonthDate datetime

-- Get the beginning of the month
set @beginningOfMonthDate = dateadd(month, -1, dateadd(day, -1, dateadd(month, datediff(month, 0, @currentDate) + 1, 1)))

-- Get the the beginning date of the next month
set @endOfMonthDate = dateadd(day, -2, dateadd(month, datediff(month, 0, @currentDate) + 1, 1))

-- Get the date range between the beginning and the end of the month
set @dateRange = datediff(day, @beginningOfMonthDate, @endOfMonthDate)

return
(
	-- Get the number of business days by getting the number
	-- of full weeks * 5 days a week plus the number days remaining
	-- minus any days from the remaining days that are a weekend day
	select	@dateRange / 7 * 5 + @dateRange % 7 -  
	(
	        select	count(*)
		from
	        (
	            select 1 as d
	            union
	            select 2
	            union
	            select 3
	            union
	            select 4
	            union
	            select 5
	            union
	            select 6
	            union
	            select 7
	        ) weekdays
	        where	d <= @dateRange % 7
		        and
			datename(weekday, dateadd(day, -1, @endOfMonthDate) - d)
		        in ('Saturday', 'Sunday')
	)
)
end
GO
