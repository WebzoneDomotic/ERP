SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 15 avril 2012
-- Description:	Création des OF  
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxCreateWorkOrderFromMRP] @WithSub int
as
begin
  -- Declaration des variable 
  Declare @MRP Table ( RowNo int IDENTITY(1,1), PK_dxMRP int , FK_dxProduct int , Quantity float, WorkOrderDate Datetime )
  Declare @RowNo int
  Declare @RowMax int
  Declare @PK_dxMRP int
  Declare @FK_WorkOrder int 
  Declare @ALot varchar(50)
  Declare @FKProduct int
  Declare @QTY float
  Declare @ADate Datetime
 
  -- Enregistrement à traiter
  Insert into @MRP
  Select
    PK_dxMRP
   ,FK_dxProduct
   ,case 
      when ProposedQuantity > 0.00000001 then ProposedQuantity
      else PlannedOrderReleases 
    end
   ,PeriodDate 
  From dxMRP mr
  left join dxProduct pr on pr.PK_dxProduct = mr.FK_dxProduct
  where Selected = 1 
    and pr.ManufacturedItem =1
    and mr.PlannedOrderReleases > 0 
    and mr.FK_dxWorkOrder is Null 
    and mr.FK_dxPurchaseOrder is Null
   
  -- Création des OF sur les item sélectionnés 
  Set @RowNo = 1
  Set @RowMax = ( Select max( RowNo ) from @MRP )
  While @RowNo <= @RowMax
  begin
    Select 
        @PK_dxMRP  = PK_dxMRP 
       ,@FKProduct = FK_dxProduct 
       ,@ADate     = WorkOrderDate
       ,@QTY       = Quantity
    from @MRP where RowNo =@RowNo 
    if @WithSub = 1
      Execute dbo.pdxCreateWorkOrderAndSub @FKProduct, Null,  @QTY, @ADate, @PK_dxWorkOrder_ = @FK_WorkOrder output , @Lot_ = @ALot output
    else  
      Execute dbo.pdxCreateWorkOrder       @FKProduct, Null, @QTY, @ADate, @PK_dxWorkOrder  = @FK_WorkOrder output , @Lot  = @ALot output
    Update dxMRP set FK_dxWorkOrder = @FK_WorkOrder where PK_dxMRP =  @PK_dxMRP 
    Set @RowNo = @RowNo +1
  end  
end
GO
