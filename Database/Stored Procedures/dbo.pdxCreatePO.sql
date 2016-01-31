SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-10-13
-- Description:	Création d'un bon de commande Fournisseur 
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxCreatePO]
          @FK_dxVendor int = null
        , @FK_dxProduct int = null
        , @PODate Datetime
        , @Quantity Float = 0.0
        , @CreateNewPO int = 1

as
BEGIN
  Declare @PK_dxPurchaseOrder int
        , @UnitCost float = 0.0
        , @DocumentDate DateTime


  -- Try to find Blanket Order

  -- Give an error message if blanket do not match the proposed quantity

  -- If Ok then Create PO or the Release on the blanket
  Begin

     -- Get the PK
     Set @PK_dxPurchaseOrder =
           Coalesce(( Select Max(po.PK_dxPurchaseOrder)
                    from dxPurchaseOrderDetail pd
                    left join dxPurchaseOrder po on (po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder)
                   where po.FK_dxVendor = @FK_dxVendor
                     and pd.ExpectedReceptionDate = @PODate
                     and po.Posted = 0
                     and po.Closed = 0 ),-1)

     if @CreateNewPO = 1 or (@PK_dxPurchaseOrder = -1)
     begin
        Set @DocumentDate = dbo.fdxGetDateNoTime( Getdate() )
        Exec dbo.pdxCreatePurchaseOrder @FK_dxVendor= @FK_dxVendor ,@Date =@DocumentDate , @CreateNewPO = @CreateNewPO
        Set @PK_dxPurchaseOrder = ( Select IDENT_CURRENT('dxPurchaseOrder') );
     end

     -- Get UnitCost
     Set @UnitCost = [dbo].[fdxGetVendorUnitCost] (@FK_dxVendor,@FK_dxProduct,@PODate,@Quantity)
     -- Insert item
     Insert into dxPurchaseOrderDetail ( FK_dxPurchaseOrder, ExpectedReceptionDate, FK_dxProduct,
                                         [Description], Quantity , UnitAmount,
                                         FK_dxScaleUnit__Quantity, FK_dxScaleUnit__UnitAmount, FK_dxScaleUnit )
     Select   Top 1
              @PK_dxPurchaseOrder
            , @PODate
            , @FK_dxProduct
            , pr.Description
            , coalesce( @Quantity / ft.Factor , 0 )
            , @UnitCost
            , Case when  ft.FK_dxScaleUnit__In is null then pr.FK_dxScaleUnit else ft.FK_dxScaleUnit__In end
            , Coalesce(pr.FK_dxScaleUnit__UnitAmount,pr.FK_dxScaleUnit)
            , pr.FK_dxScaleUnit
      From dxProduct pr
      left join dbo.dxFactorTable ft on ( coalesce( pr.FK_dxScaleUnit__Vendor, pr.FK_dxScaleUnit) = ft.FK_dxScaleUnit__In
                                          and pr.FK_dxScaleUnit = ft.FK_dxScaleUnit__Out )
     where PK_dxProduct = @FK_dxProduct
     Order by ft.STEPS asc -- Give us the conversion factor with the less steps
     -- Calculate PO
     Exec dbo.pdxCalculatePurchaseOrder @PK_dxPurchaseOrder = @PK_dxPurchaseOrder

  End

END
GO
