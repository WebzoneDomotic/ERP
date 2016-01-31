SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxUnitPrice] as 
select * from dxUnitPriceProduct
Union 
select * from dxUnitPriceList
GO
