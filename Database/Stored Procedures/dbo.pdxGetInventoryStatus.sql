SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Get Inventory Status
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxGetInventoryStatus] @TransactionDate Datetime
as
Begin 
    --Declare @TransactionDate Datetime
    set @TransactionDate = Coalesce( @TransactionDate, GetDate())
    SELECT 
        pt.[FK_dxWarehouse][FK_dxWarehouse]
      , pt.[FK_dxLocation] [FK_dxLocation]
      , pt.[FK_dxProduct]  [FK_dxProduct]
      , pt.Lot             [Lot]  
      , Round(sum( Coalesce(pt.Quantity, 0.0 )),4)  as [InStock] 
      , 0.0  as [OnPurchaseOrder] 
      , 0.0  as [OnClientOrder] 
      , 0.0  as [OnWorkOrder] 
               
    FROM [dbo].[dxProductTransaction] pt
    where pt.TransactionDate <= @TransactionDate
    Group by  
         pt.[FK_dxWarehouse]
       , pt.[FK_dxLocation]
       , pt.[FK_dxProduct]  
       , pt.Lot            
    Having  Round(sum( Coalesce(pt.Quantity, 0.0 )),4)  <> 0.0

    Union all

    SELECT 
        pt.[FK_dxWarehouse][FK_dxWarehouse]
      , pt.[FK_dxLocation] [FK_dxLocation]
      , pt.[FK_dxProduct]  [FK_dxProduct]
      , pt.Lot             [Lot]  
      , 0.0  as [InStock] 
      , 0.0  as [OnPurchaseOrder] 
      , Round(sum( Coalesce(pt.Quantity -pt.ShippedQuantity, 0.0 )),4)  as [OnClientOrder] 
      , 0.0  as [OnWorkOrder] 
               
    FROM [dbo].[dxClientOrderDetail] pt
    left join dxClientOrder co on ( pt.FK_dxClientOrder = co.PK_dxClientOrder)
    Where co.TransactionDate <= @TransactionDate 
      and pt.Closed = 0
      and not FK_dxProduct is null
    Group by  
         pt.[FK_dxWarehouse]
       , pt.[FK_dxLocation]
       , pt.[FK_dxProduct]  
       , pt.Lot            
    Having Round(sum( Coalesce(pt.Quantity -pt.ShippedQuantity, 0.0 )),4)  <> 0.0

    Union all

    SELECT 
        null               [FK_dxWarehouse]
      , null               [FK_dxLocation]
      , pt.[FK_dxProduct]  [FK_dxProduct]
      , pt.Lot             [Lot]  
      , 0.0  as [InStock] 
      , Round(sum( Coalesce(pt.Quantity -pt.ReceivedQuantity, 0.0 )),4)  as [OnPurchaseOrder] 
      , 0.0  as [OnClientOrder] 
      , 0.0  as [OnWorkOrder] 
               
    FROM [dbo].[dxPurchaseOrderDetail] pt
    left join dxPurchaseOrder co on ( pt.FK_dxPurchaseOrder = co.PK_dxPurchaseOrder)
    Where co.TransactionDate <= @TransactionDate 
      and pt.Closed = 0
      and not FK_dxProduct is null
    Group by  
         pt.[FK_dxProduct]  
       , pt.Lot            
    Having Round(sum( Coalesce(pt.Quantity -pt.ReceivedQuantity, 0.0 )),4)  <> 0.0

    Union all

    SELECT 
        null               [FK_dxWarehouse]
      , null               [FK_dxLocation]
      , pt.[FK_dxProduct]  [FK_dxProduct]
      , pt.Lot             [Lot]  
      , 0.0  as [InStock] 
      , 0.0  as [OnPurchaseOrder] 
      , 0.0  as [OnClientOrder] 
      , Round(sum( Coalesce(pt.QuantityToProduce -pt.ProducedQuantity, 0.0 )),4)  as  [OnWorkOrder] 
               
    FROM [dbo].[dxWorkOrder] pt
    Where pt.WorkorderDate <= @TransactionDate
      and WorkOrderStatus < 4
      and not FK_dxProduct is null
    Group by  
         pt.[FK_dxProduct]  
       , pt.Lot            
    Having Round(sum( Coalesce(pt.QuantityToProduce -pt.ProducedQuantity, 0.0 )),4)  <> 0.0
     
    order by 3,4
 end
GO
