SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 26 juillet 2012
-- Description:	Récupérer la consommation d'un produit
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxGetProductConsumption] @FK_dxProduct int
as
Begin
  Select
       ID
      ,OtherID
      ,Description

      ,[FK_dxLotSizing]
      ,[FixedLotSize]
      ,[MinLotSize]
      ,[EconomicLotSize]
      ,[MinimumLevelQuantity]
      ,[MinimumBatchSize]
      ,[MaximumBatchSize]
      ,dbo.fdxGetProductSafetyStock ( pr.PK_dxProduct, getdate())SafetyStock
      -- Consumption Last Week
      ,Round(Coalesce((select sum(Quantity) from dxDeclarationConsumption dc
        left join dxDeclaration de on ( de.PK_dxDeclaration = dc.FK_dxDeclaration)
        left join dxWorkOrder   wo on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
        where dc.FK_dxProduct = pr.PK_dxProduct and de.Posted = 1
          and wo.WorkOrderDate >= getdate()-7 ),0.0)
      +Coalesce((select sum(Quantity) from dxShippingDetail sd
        left join dxShipping sh on ( sh.PK_dxShipping = sd.FK_dxShipping)
        where sd.FK_dxProduct = pr.PK_dxProduct and sh.Posted = 1
          and sh.TransactionDate >= getdate()-7 ),0.0),2) as LastWeek

      -- Consumption For Last Month
      ,Round(Coalesce((select sum(Quantity) from dxDeclarationConsumption dc
        left join dxDeclaration de on ( de.PK_dxDeclaration = dc.FK_dxDeclaration)
        left join dxWorkOrder   wo on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
        where dc.FK_dxProduct = pr.PK_dxProduct and de.Posted = 1
          and wo.WorkOrderDate >= getdate()-31 ),0.0)
      +Coalesce((select sum(Quantity) from dxShippingDetail sd
        left join dxShipping sh on ( sh.PK_dxShipping = sd.FK_dxShipping)
        where sd.FK_dxProduct = pr.PK_dxProduct and sh.Posted = 1
          and sh.TransactionDate >= getdate()-31 ),0.0),2) as LastMonth

      -- Consumption For Last Quarter
      ,Round(Coalesce((select sum(Quantity) from dxDeclarationConsumption dc
        left join dxDeclaration de on ( de.PK_dxDeclaration = dc.FK_dxDeclaration)
        left join dxWorkOrder   wo on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
        where dc.FK_dxProduct = pr.PK_dxProduct and de.Posted = 1
          and wo.WorkOrderDate >= getdate()-92 ),0.0)
      +Coalesce((select sum(Quantity) from dxShippingDetail sd
        left join dxShipping sh on ( sh.PK_dxShipping = sd.FK_dxShipping)
        where sd.FK_dxProduct = pr.PK_dxProduct and sh.Posted = 1
          and sh.TransactionDate >= getdate()-92 ),0.0),2) as LastQuarter

       -- Consumption For Last Six Month
      ,Round(Coalesce((select sum(Quantity) from dxDeclarationConsumption dc
        left join dxDeclaration de on ( de.PK_dxDeclaration = dc.FK_dxDeclaration)
        left join dxWorkOrder   wo on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
        where dc.FK_dxProduct = pr.PK_dxProduct and de.Posted = 1
          and wo.WorkOrderDate >= getdate()-183 ),0.0)
      +Coalesce((select sum(Quantity) from dxShippingDetail sd
        left join dxShipping sh on ( sh.PK_dxShipping = sd.FK_dxShipping)
        where sd.FK_dxProduct = pr.PK_dxProduct and sh.Posted = 1
          and sh.TransactionDate >= getdate()-183 ),0.0),2) as LastSixMonth

      -- Consumption For Last Year
      ,Round(Coalesce((select sum(Quantity) from dxDeclarationConsumption dc
        left join dxDeclaration de on ( de.PK_dxDeclaration = dc.FK_dxDeclaration)
        left join dxWorkOrder   wo on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
        where dc.FK_dxProduct = pr.PK_dxProduct and de.Posted = 1
          and wo.WorkOrderDate >= getdate()-365 ),0.0)
      +Coalesce((select sum(Quantity) from dxShippingDetail sd
        left join dxShipping sh on ( sh.PK_dxShipping = sd.FK_dxShipping)
        where sd.FK_dxProduct = pr.PK_dxProduct and sh.Posted = 1
          and sh.TransactionDate >= getdate()-365 ),0.0),2) as LastYear

      , Round( Coalesce(( Select SUM(InStockQuantity) from dxProductLot where FK_dxProduct = pr.PK_dxProduct),0),2) InStockQuantity

      , Round( Coalesce(( Select SUM(InStockQuantity) from dxProductLot pl
                           left join dxWarehouse wh on ( wh.PK_dxWarehouse = pl.FK_dxWarehouse)
                          where pl.FK_dxProduct = pr.PK_dxProduct
                            and wh.ExternalWarehouse = 1
                           ),0),2) ExternalStockQuantity

      , Round( Coalesce(( Select SUM(InStockQuantity) from dxProductLot pl
                          left join dxLocation lo on ( lo.PK_dxLocation = pl.FK_dxLocation )
                          left join dxWarehouse wa on ( wa.PK_dxWarehouse = pl.FK_dxWarehouse )
                           where pl.FK_dxProduct = pr.PK_dxProduct
                             and (lo.ReservedArea = 1 or wa.Quarantine = 1) ) ,0),2) StockInQuarantineOrReserved

     , Coalesce((Select sum(
       Round((QuantityToProduce-ProducedQuantity) * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,4) )
      from dxWorkOrder           wo
      left join dxAssembly       aa  on (aa.FK_dxProduct  = wo.FK_dxProduct )
      left join dxAssemblyDetail ad  on (aa.PK_dxAssembly = ad.FK_dxAssembly)
      left join dxProduct        ps  on (ps.PK_dxProduct  = ad.FK_dxProduct )
      where  aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , wo.WorkOrderDate )
        and  ad.NetQuantity > 0.0
        and  wo.WorkOrderStatus between 0 and 3
        and (wo.QuantityToProduce - wo.ProducedQuantity) > 0
        and  ad.FK_dxProduct = pr.PK_dxProduct
            ) ,0.0)  RequirementsForAllWO


      , FK_dxScaleUnit

   From dxProduct pr

  Where pr.PK_dxProduct = @FK_dxProduct
End
GO
