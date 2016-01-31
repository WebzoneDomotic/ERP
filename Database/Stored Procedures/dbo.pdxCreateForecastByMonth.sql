SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-10-14
-- Description:	Create Forcast by Month
-- --------------------------------------------------------------------------------------------
CREATE procedure [dbo].[pdxCreateForecastByMonth] @NumberOfMonth int = 3
as
Begin
  Declare @CurrentDate Datetime
        , @EndOfMonthDate Datetime
        , @BeginningOfNextMonthDate DateTime
        , @BeginningOfNextNextMonthDate DateTime
  Declare @newseed int ;

  Set @CurrentDate                  = dbo.fdxGetDateNoTime ( GetDate())
  Set @EndOfMonthDate               = dbo.fdxGetEndOfMonthDate ( @CurrentDate )
  Set @BeginningOfNextMonthDate     = Dateadd( dd, 1, @EndOfMonthDate)
  Set @BeginningOfNextNextMonthDate = Dateadd( mm, 1, @BeginningOfNextMonthDate)

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
      , Round([dbo].[fdxGetProductWorkDayForecastQuantity] ( pr.PK_dxProduct  ,@CurrentDate ) *
       [dbo].[fdxGetRemainingWorkDaysInMonth]( @CurrentDate ),0)  Forecast
      ,0.0
      ,0.0 as ScheduledReceipt
     , 0.0 as PlannedShipment
     , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
     , 0.0
     , 1
    from dxProduct  pr
   where pr.Active = 1
     and pr.SalesItem = 1
     
   -- Interate for the next month  
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
         ,@BeginningOfNextMonthDate
         ,0.0 as GrossRequirement
         ,Round([dbo].[fdxGetProductWorkDayForecastQuantity] ( pr.PK_dxProduct  ,@BeginningOfNextMonthDate ) *
          [dbo].[fdxGetWorkDaysInMonth]( @BeginningOfNextMonthDate ),0) as Forecast
         ,0.0
         ,0.0 as ScheduledReceipt
        , 0.0 as PlannedShipment
        , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
        , 0.0
        , 1
       from dxProduct  pr
       where  pr.Active = 1
         and  pr.SalesItem = 1

    
   -- Forecast for the Second Next Month
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
         ,@BeginningOfNextNextMonthDate
         ,0.0 as GrossRequirement
         ,Round([dbo].[fdxGetProductWorkDayForecastQuantity] ( pr.PK_dxProduct  ,@BeginningOfNextNextMonthDate ) *
          [dbo].[fdxGetWorkDaysInMonth]( @BeginningOfNextNextMonthDate ),0) as Forecast
         ,0.0
         ,0.0 as ScheduledReceipt
        , 0.0 as PlannedShipment
        , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
        , 0.0
        , 1
       from dxProduct  pr
       where  pr.Active = 1
         and  pr.SalesItem = 1

End
GO
