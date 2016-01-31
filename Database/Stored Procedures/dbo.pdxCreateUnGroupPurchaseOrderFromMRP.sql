SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-25
-- Description:	Création des Bons de commande Fournisseur non groupés à partir du MRP
-- --------------------------------------------------------------------------------------------
create procedure [dbo].[pdxCreateUnGroupPurchaseOrderFromMRP]
as
BEGIN
  Declare @FK_dxVendor int
        , @FK_dxProduct int
        , @PeriodDate Datetime
        , @PlannedOrderReleases Float
        , @UnitCost Float
        , @PK_dxPurchaseOrder int

  -- Set Cursor
  Declare cr_CreatePOMRP CURSOR FAST_FORWARD for
   SELECT FK_dxVendor
        , FK_dxProduct
        , PeriodDate
        , case
              when ProposedQuantity > 0.00000001 then ProposedQuantity
              else PlannedOrderReleases
          end
        from dxMRP mr
        left outer join dxProduct pr on (pr.PK_dxProduct = mr.FK_dxProduct )
        where not mr.FK_dxVendor is null
          and mr.PlannedOrderReleases > 0.00000001
          and mr.Selected = 1
          and mr.FK_dxPurchaseOrder is null
          and mr.FK_dxWorkOrder is Null
          and pr.PurchasedItem = 1 ;

  -- Open cursor
  Open cr_CreatePOMRP
  Fetch NEXT FROM cr_CreatePOMRP INTO
          @FK_dxVendor
        , @FK_dxProduct
        , @PeriodDate
        , @PlannedOrderReleases ;
  -- Calculate all the Purchase Order Details
  While @@FETCH_STATUS = 0
  Begin
     exec dbo.pdxCreatePurchaseOrder @FK_dxVendor= @FK_dxVendor ,@Date =@PeriodDate, @CreateNewPO =1
     -- Get the PK
     set @PK_dxPurchaseOrder = ( Select IDENT_CURRENT('dxPurchaseOrder') );
     -- Get UnitCost
     Set @UnitCost = [dbo].[fdxGetVendorUnitCost] (@FK_dxVendor,@FK_dxProduct,@PeriodDate,@PlannedOrderReleases)
     -- Insert item
     insert into dxPurchaseOrderDetail ( FK_dxPurchaseOrder, ExpectedReceptionDate, FK_dxProduct, [Description], Quantity , UnitAmount, FK_dxScaleUnit__Quantity, FK_dxScaleUnit__UnitAmount, FK_dxScaleUnit )
     Select   Top 1
              @PK_dxPurchaseOrder
            , dbo.fdxGetPrevNextWorkDay(DateAdd(dd,pr.LeadTimeInDays, @PeriodDate)-1,1)
            , @FK_dxProduct
            , pr.Description
            , coalesce( @PlannedOrderReleases / ft.Factor , 0 )
            , @UnitCost
            , Case when  ft.FK_dxScaleUnit__In is null then pr.FK_dxScaleUnit else ft.FK_dxScaleUnit__In end
            , Coalesce(pr.FK_dxScaleUnit__UnitAmount,pr.FK_dxScaleUnit)
            , pr.FK_dxScaleUnit
      From dxProduct pr
      left join dbo.dxFactorTable ft on ( coalesce( pr.FK_dxScaleUnit__Vendor, pr.FK_dxScaleUnit) = ft.FK_dxScaleUnit__In
                                          and pr.FK_dxScaleUnit = ft.FK_dxScaleUnit__Out )
     where PK_dxProduct = @FK_dxProduct
     order by ft.STEPS asc
     -- Calculate PO
     exec dbo.pdxCalculatePurchaseOrder @PK_dxPurchaseOrder = @PK_dxPurchaseOrder
     update dxMRP set FK_dxPurchaseOrder = @PK_dxPurchaseOrder
      where FK_dxVendor =@FK_dxVendor
        and FK_dxProduct=@FK_dxProduct
        and PeriodDate  =@PeriodDate
        and PlannedOrderReleases = @PlannedOrderReleases

     FETCH NEXT FROM cr_CreatePOMRP INTO
          @FK_dxVendor
        , @FK_dxProduct
        , @PeriodDate
        , @PlannedOrderReleases ;
  End
  Close cr_CreatePOMRP
  Deallocate cr_CreatePOMRP ;

  Update dxMRP set FK_dxPurchaseOrder = ( Select Min(FK_dxPurchaseOrder) from dxPurchaseOrderDetail pd
                                     left outer join dxPurchaseOrder po on (po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
                                     left outer join dxProduct pr on (pr.PK_dxProduct = pd.FK_dxProduct )
                                     where pd.FK_dxProduct      = dxMRP.FK_dxProduct
                                       and ((pd.Quantity  = dxMRP.PlannedOrderReleases) or (pd.Quantity = dxMRP.ProposedQuantity))
                                       and po.TransactionDate   = dxMRP.PeriodDate
                                       and pr.PurchasedItem  = 1)
  where FK_dxPurchaseOrder is null
    and Selected = 1

END
GO
