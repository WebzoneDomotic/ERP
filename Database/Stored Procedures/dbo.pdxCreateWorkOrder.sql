SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 15 avril 2012
-- Description:	Création d'un OF 
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxCreateWorkOrder] @FK_dxProduct int, @FK_dxProductionLine int, @Quantity float, @WorkOrderDate Datetime, @PK_dxWorkOrder int OUTPUT, @Lot Varchar(50) OUTPUT
as
Begin

  if @Lot = '0' Set @Lot = [dbo].[fdxGenerateLotNumber] ( 0, 'DXWORKORDER', 0)

  -- Insert Master WorkOrder
  Insert Into dxWorkOrder (
    FK_dxProduct,
    FK_dxProductionLine,
    WorkOrderStatus,
    QuantityToProduce,
    AskedQuantity,
    WorkOrderDate,
    Lot
  )
  Select 
     @FK_dxProduct
    ,@FK_dxProductionLine
    ,0
    ,@Quantity
    ,@Quantity
    ,@WorkOrderDate
    ,@Lot

   Set @PK_dxWorkOrder = ( Select IDENT_CURRENT('dxWorkOrder') );
end
GO
