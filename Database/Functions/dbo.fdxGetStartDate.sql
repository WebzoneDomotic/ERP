SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-12
-- Description:	Calcul de la data réel de début avec les contraintes des weekend et plage horaire 
-- --------------------------------------------------------------------------------------------
Create Function [dbo].[fdxGetStartDate] ( @FinishDate Datetime, @Duration Float )
Returns Datetime
as
Begin
  
  Declare  @StartDate Datetime
         , @StartTime  Datetime 
         , @WorkStart  Float
         , @WorkFinish Float
         , @StartDateTime Datetime
         , @RealStartDateTime Datetime
         , @DayWorkHours Float
         , @DurationInWorkDays Float
         , @RemainingHours Float
       
   Set @WorkStart  = 8.0
   Set @WorkFinish = 17.0
    
   Set @DayWorkHours =  @WorkFinish-@WorkStart 
   Set @DurationInWorkDays = (Select (Floor(@Duration / @DayWorkHours)))
   Set @RemainingHours = (Select ((@Duration / @DayWorkHours) - @DurationInWorkDays) * @DayWorkHours) 
   Set @StartDate         = (Select dateadd( dd, -1.0 * @DurationInWorkDays, @FinishDate ))

   -- Exclude Sat and Sun
   Set @StartDate = [dbo].[fdxGetPrevNextWorkDay] ( @StartDate +1.0, -1)
   Set @StartDateTime     = DateAdd(hh, @WorkStart, ( SELECT DATEADD(D, 0, DATEDIFF(D, 0, @StartDate))))
     
   Set @RealStartDateTime = Case when DateAdd(hh,-1.0*@RemainingHours, @StartDate) < @StartDateTime then 
                               DateAdd(hh, @WorkFinish,( SELECT DATEADD(D, 0, DATEDIFF(D, 0, DateAdd(dd,-1.0,@StartDate)))))
                             else 
                               DateAdd(hh,-1.0* @RemainingHours, @StartDate)
                             end    
   Return  @RealStartDateTime                         
end;
GO
