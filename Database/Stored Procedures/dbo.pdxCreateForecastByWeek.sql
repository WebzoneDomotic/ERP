SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-10-14
-- Description:	Create Forcast by Week
-- -------------------------------------------------------------------------------------------- 
Create procedure [dbo].[pdxCreateForecastByWeek] @NumberOfWeek int = 12
as
Begin 
  Declare @CurrentDate Datetime
        , @MondayDate Datetime
        , @N int = 0
  
  -- Monday of this week     
  Set @CurrentDate = ( SELECT DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0) )
 
 
  While @N < @NumberOfWeek 
  begin
   
   -- Forecast for the remaining days of the month
   Insert INTO [dbo].[dxProjectedStock]
             ([Document]
             ,[FK_dxProduct]
             ,[PeriodDate]
             ,[GrossRequirements]
             ,[Forecast]
             ,[CumulativeGrossRequirements]
             ,[ScheduledReceipts]
             ,[PlannedExpedition]
             ,[Stock]
             ,[ProjectedStock]
             ,[Level])
   Select
      'FC '+convert(varchar(10),pr.ID)
      ,pr.PK_dxProduct
      ,@CurrentDate
      ,0.0 as GrossRequirement
      ,Round([dbo].[fdxGetProductWorkDayForecastQuantity] ( pr.PK_dxProduct  ,@CurrentDate ) * 5.0 ,4 )  Forecast
      ,0.0
      ,0.0 as ScheduledReceipt
     , 0.0 as PlannedShipment
     , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
     , 0.0
     , 1
    from dxProduct  pr
   where pr.Active = 1
     and pr.SalesItem = 1

   set @N = @N + 1
   set @CurrentDate = DateAdd (wk, 1,@CurrentDate)

 end
End
GO
