SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-10-14
-- Description:	Create Requirements for sub Level 2...n
-- -------------------------------------------------------------------------------------------- 
Create procedure [dbo].[pdxCreateSubLevelRequirements] @Level int 
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
           Document
         , ad.FK_dxProduct
         , wo.PeriodDate
         , Round( wo.[Forecast] * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,4)  
         , 0.0
         , 0.0 ScheduledReceipt
         , 0.0 PlannedExpedition
         , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
         , 0.0
         , @Level
      from dxProjectedStock       wo WITH(NOLOCK)
      inner join dxAssembly       aa WITH(NOLOCK) on ( aa.FK_dxProduct  = wo.FK_dxProduct  )
      inner join dxAssemblyDetail ad WITH(NOLOCK) on ( aa.PK_dxAssembly = ad.FK_dxAssembly )
      inner join dxProduct        pr WITH(NOLOCK) on ( pr.PK_dxProduct  = ad.FK_dxProduct  )
      where aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  wo.FK_dxProduct , wo.PeriodDate )
        and ad.NetQuantity   > 0.0
        and wo.[Forecast]    > 0.0
        and wo.Level         = (@Level - 1)
     Order by wo.PeriodDate asc
End
GO
