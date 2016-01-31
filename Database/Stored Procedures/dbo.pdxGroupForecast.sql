SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[pdxGroupForecast] 
as
Begin
    Insert INTO [dbo].[dxProjectedStock]
             ([Document]
             ,[FK_dxProduct]
             ,[PeriodDate]
             ,[Forecast]
             ,[CumulativeGrossRequirements]
             ,[ScheduledReceipts]
             ,[PlannedExpedition]
             ,[Stock]
             ,[ProjectedStock]
             ,[Level])
     Select
           'PR (Groupé)'
         , wo.FK_dxProduct
         , wo.PeriodDate
         , Round(Sum(wo.[Forecast]),4)
         , 0.0
         , Round(Sum(wo.[ScheduledReceipts]),4)
         , Round(Sum(wo.[PlannedExpedition]),4)
         , Round(Max(wo.[Stock]),4)
         , 0.0
         , 99
      from dxProjectedStock wo WITH(NOLOCK)
      where [Document] like 'FC %'
        
     Group by   wo.FK_dxProduct
              , wo.PeriodDate

     Delete from dxProjectedStock where [Document] like 'FC %'
 
End
GO
