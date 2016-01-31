SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxClientProductDate] as 
select 
  cp.FK_dxClient,
  cp.FK_dxProduct, 
  pm.Lot, 
  cp.NumberOfDaysBeforeEndOfSales,
  pm.ProductionDate,
  DateADD( Day, pr.LifeSpanInDays , pm.ProductionDate ) BestBeforeDate,
  DateADD( Day, pr.LifeSpanInDays-cp.NumberOfDaysBeforeEndOfSales ,  pm.ProductionDate ) as EndOfSalesDate

from dxClientProduct cp
join dxProductProductionDate pm on ( cp.FK_dxProduct = pm.FK_dxProduct )
left outer join dxProduct pr on ( cp.FK_dxProduct = pr.PK_dxProduct )
GO
