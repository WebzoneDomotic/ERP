SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-12
-- Description:	Calcul de la data réel de fin avec les contraintes des weekend et plage horaire 
-- --------------------------------------------------------------------------------------------
Create Function [dbo].[fdxGetFinishDate] ( @StartDate Datetime, @Duration Float )
Returns Datetime
as
Begin
 
   Declare @FinishDate Datetime
         , @StartTime  Datetime 
         , @WorkStart  Float
         , @WorkFinish Float
         , @FinishDateTime Datetime
         , @RealFinishDateTime Datetime
         , @DayWorkHours Float
         , @DurationInWorkDays Float
         , @RemainingHours Float
       
   SET @WorkStart  = 8.0
   SET @WorkFinish = 17.0
    
   SET @DayWorkHours =  @WorkFinish-@WorkStart 
   
   Set @DurationInWorkDays = (Select (Floor(@Duration / @DayWorkHours)))
   Set @RemainingHours = (Select ((@Duration / @DayWorkHours) - Floor(@Duration / @DayWorkHours)) * @DayWorkHours) 
    
   Set @FinishDate         = (Select dateadd( dd, @DurationInWorkDays, @StartDate ))
   -- Exclude Sat and Sun
   Set @FinishDate = [dbo].[fdxGetPrevNextWorkDay] ( @FinishDate -1.0, 1)
   
   Set @FinishDateTime     = DateAdd(hh, @WorkFinish, ( SELECT DATEADD(D, 0, DATEDIFF(D, 0, @FinishDate))))
   Set @RealFinishDateTime = Case when DateAdd(hh,@RemainingHours, @FinishDate) > @FinishDateTime then 
                               DateAdd(hh, @WorkStart,( SELECT DATEADD(D, 0, DATEDIFF(D, 0, DateAdd(dd,1,@FinishDate)))))
                             else 
                               DateAdd(hh,@RemainingHours, @FinishDate)
                             end  
 
    Return @RealFinishDateTime
end;
GO
