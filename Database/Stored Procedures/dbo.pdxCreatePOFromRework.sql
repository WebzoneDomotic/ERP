SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-09-25
-- Description:	Création des Bons de commande Fournisseur pour achat WO
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxCreatePOFromRework] @FK_dxDeclarationDismantling int =1 
as
BEGIN
  Declare @FK_dxVendor int = null
        , @FK_dxProduct int
        , @PeriodDate Datetime
        , @Description varchar(250)
        , @PlannedOrderReleases Float = 0
        , @UnitCost Float
        , @PK_dxPurchaseOrder int
        
  SELECT  @FK_dxVendor          = Coalesce(pr.FK_dxVendor__Default, 1)
        , @FK_dxProduct         = mr.FK_dxProduct
        , @Description          = Coalesce(mr.Note,'') + ' '+pr.Description
        , @PeriodDate           = de.TransactionDate
        , @PlannedOrderReleases = mr.Quantity
        from dxDeclarationDismantling mr
        inner join dxDeclaration de on (de.PK_dxDeclaration = mr.FK_dxDeclaration)
        inner join dxProduct pr on (pr.PK_dxProduct = mr.FK_dxProduct )
        where 
         
              pr.PurchasedItem = 1 
          and mr.PK_dxDeclarationDismantling = @FK_dxDeclarationDismantling 
          and mr.PurchaseRequired = 1
  
  -- Create PO if not Exist
  If not Exists ( Select 1 from dxPurchaseOrder where FK_dxDeclarationDismantling = @FK_dxDeclarationDismantling) 
     and @PlannedOrderReleases > 0.0
  Begin
     exec dbo.pdxCreatePurchaseOrder @FK_dxVendor= @FK_dxVendor ,@Date =@PeriodDate , @CreateNewPO = 1
     -- Get the PK
     set @PK_dxPurchaseOrder = ( Select IDENT_CURRENT('dxPurchaseOrder') );
     -- set the link
     Update dxPurchaseOrder 
         set  FK_dxDeclarationDismantling = @FK_dxDeclarationDismantling
           , Description = @Description 
      where PK_dxPurchaseOrder = @PK_dxPurchaseOrder
     -- Get UnitCost
     Set @UnitCost = [dbo].[fdxGetVendorUnitCost] (@FK_dxVendor,@FK_dxProduct,@PeriodDate,@PlannedOrderReleases)
     -- Insert item
     insert into dxPurchaseOrderDetail ( FK_dxPurchaseOrder, ExpectedReceptionDate, FK_dxProduct, [Description], Quantity , UnitAmount, FK_dxScaleUnit__Quantity, FK_dxScaleUnit__UnitAmount, FK_dxScaleUnit )
     Select   Top 1
              @PK_dxPurchaseOrder
            , @PeriodDate
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
   end

END
GO
