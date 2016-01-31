SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxProductDate] as 
select 
  pm.FK_dxProduct, 
  pm.Lot, 
  pr.NumberOfDaysBeforeEndOfSales,
  pm.ProductionDate,
  DateADD( Day, pr.LifeSpanInDays , pm.ProductionDate ) BestBeforeDate,
  DateADD( Day, pr.LifeSpanInDays-pr.NumberOfDaysBeforeEndOfSales ,  pm.ProductionDate ) as EndOfSalesDate

from dxProductProductionDate pm 
left outer join dxProduct pr on ( pm.FK_dxProduct = pr.PK_dxProduct )
GO
