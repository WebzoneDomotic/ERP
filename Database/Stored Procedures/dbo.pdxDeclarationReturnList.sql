SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-11-28
-- Description:	Création d'un retour de materiel en inventaire
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxDeclarationReturnList] @FK_dxDeclaration int
as
begin

  --Declare  @FK_dxDeclaration int
  --set  @FK_dxDeclaration = 1

  Declare @FK_dxWorkOrder int
  Declare @ManageByDropZone bit
	Declare @FK_dxWarehouse int
	Declare @FK_dxLocation int
	Declare @LotNumber varchar(50)
	Declare @FK_dxProduct int
	Declare @Quantity float
	Declare @QuantityToInsert float
	Declare @Phase int
	Declare @Date Datetime
	Declare @FK_dxProductToPick int
	Declare @QuantityForProduction float
	Declare @QuantityStock float
	Declare @QuantityOnThisDeclaration float
	Declare @NbItem int
	Declare @RowNo int, @EOF int
	Declare @PickItem int -- 0 = False 1 = True
	Declare @C int

  set @ManageByDropZone = ( Select ManageWOWithReservedArea From dxSetup)
  set @FK_dxWorkOrder   = ( Select FK_dxWorkOrder from dxDeclaration where PK_dxDeclaration = @FK_dxDeclaration )
  set @FK_dxProduct     = ( Select FK_dxProduct from dxWorkOrder where PK_dxWorkOrder = @FK_dxWorkOrder )

	set @Quantity = ( select DeclaredQuantity + RejectedQuantity from dxDeclaration where PK_dxDeclaration =  @FK_dxDeclaration )
	set @Phase    = ( select PhaseNumber from dxDeclaration where PK_dxDeclaration =  @FK_dxDeclaration )
	set @Date     = ( Select WorkOrderDate from dxWorkOrder where PK_dxWorkOrder = @FK_dxWorkOrder )

  Delete from dxDeclarationDismantling
   where FK_dxDeclaration = @FK_dxDeclaration
     and not Exists ( Select 1 From dxWorkOrder where FK_dxDeclarationDismantling = PK_dxDeclarationDismantling )
     and Posted = 0

  Insert into  dxDeclarationDismantling ( FK_dxDeclaration, Rank, FK_dxWarehouse,FK_dxLocation,FK_dxProduct, Lot, Quantity )
  Select
      @FK_dxDeclaration
     ,Rank
     ,4
     ,Coalesce((Select PK_dxLocation from dxLocation where FK_dxWorkOrder = @FK_dxWorkOrder and PhaseNumber is Null and ReservedArea = 1),1)
     ,FK_dxProduct
     ,''
     , (@Quantity * NetQuantity) -
       Coalesce(( Select Sum(Quantity) from dxDeclarationDismantling
                   where FK_dxDeclaration = @FK_dxDeclaration
                     and FK_dxProduct = ad.FK_dxProduct ),0)
  From dxAssemblyDetail ad
  where FK_dxAssembly = dbo.fdxGetCurrentAssembly( @FK_dxProduct , @Date )
    and DismantlingPhaseNumber = @Phase
    and ((@Quantity * NetQuantity) -
         Coalesce(( Select Sum(Quantity) from dxDeclarationDismantling
                     where FK_dxDeclaration = @FK_dxDeclaration
                       and FK_dxProduct = ad.FK_dxProduct),0)) > 0.0000001
    order by ad.rank

end
GO
