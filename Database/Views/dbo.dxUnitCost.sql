SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxUnitCost] as 
select * from dxUnitCostProduct
Union 
select * from dxUnitCostList
GO
