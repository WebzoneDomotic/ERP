SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-01-12
-- Description:	Création du picking list pour une déclaration relative à une phase
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxDeclarationPickingList] @FK_dxDeclaration int
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
	set @Date     = ( select TransactionDate from dxDeclaration where PK_dxDeclaration =  @FK_dxDeclaration )

	Declare @BOM Table (
	   RowNo int IDENTITY(1,1)
	 , Level int
	 , FK_dxAssembly int
	 , FK_dxAssemblyDetail int
	 , PhaseNumber int
	 , FK_dxProduct__Master int
	 , FK_dxProduct int
	 , TotalNetQuantity int
	 , Kit bit
	 , ParentPhaseKit int 
	 -- -------------------------
	 , ProductCode varchar(50)
	 , Description varchar(250)
	 , ScaleUnit varchar(50)
	 , NetQuantity float
	 , PctOfWasteQuantity float
	 , TotalQuantity float
	 , NumberOfItems int
   , UnitStandardCost float
	 , UnitMaterialCost float
	 , UnitLaborCost Float
	 , UnitOverheadFixedCost Float
	 , UnitOverheadVariableCost Float
	 , StandardCost float
	) 
	insert into @BOM 
	exec pdxBOM @FK_dxProduct = @FK_dxProduct, @Date =@Date, @Quantity=@Quantity

	Update @BOM set Level = Level -1

	-- Delete unposted consumption   
	delete from dxDeclarationConsumption where FK_dxDeclaration = @FK_dxDeclaration and Posted = 0
	set @RowNo = 1
	set @EOF = (Select Max(RowNo) from @BOM )

	While @RowNo <= @EOF --Loop on the BOM table
	begin
	   -- Check if we have to pick this item
	   -- We do not pick the item define as a kit
	   -- Pick all the children part of a kit
	   set @PickItem = ( Select COUNT(*) from @BOM 
						  where RowNo = @RowNo 
							and PhaseNumber = @Phase
							and (Level <> 0)
              and (     (Level = 1 )
							      or  (ParentPhaseKit > 0)
							    )
						)         
	   if @PickItem > 0 
	   begin
		 -- Get item to pick
		 set @FK_dxProductToPick = ( Select FK_dxProduct from @BOM where RowNo = @RowNo ) 
		 -- Get total quantity needed for the production Get Quantity On First Level
		 set @QuantityForProduction = ( Select Sum(TotalQuantity) from @BOM where FK_dxProduct =@FK_dxProductToPick and Level = 1)
		 -- Get All Quantities on this Declaration Posted and not Posted
		 set @QuantityOnThisDeclaration = Coalesce(( select SUM(Quantity) from dxDeclarationConsumption pc
																where pc.FK_dxDeclaration = @FK_dxDeclaration                                                             
																  and pc.FK_dxProduct = @FK_dxProductToPick ),0.0)
		 set @QuantityToInsert = Round(@QuantityForProduction - @QuantityOnThisDeclaration, 6)
		 while @QuantityToInsert > 0.0000001
		 begin
			-- Set Default Quantity
			set @FK_dxWarehouse = Coalesce( @FK_dxWarehouse,4) -- WIP inventory by Default
			set @FK_dxLocation  = Coalesce( @FK_dxLocation, (Select Max(PK_dxLocation) From dxLocation where FK_dxWorkOrder = @FK_dxWorkOrder and PhaseNumber is null), 1 )
			set @LotNumber      = ''
			set @QuantityStock  = 0.0
			-- Get Available quantity for this product in the inventory
			Select 
				Top 1
				  @FK_dxWarehouse = pt.FK_dxWarehouse
			  , @FK_dxLocation  = pt.FK_dxLocation
			  , @LotNumber      = pt.Lot
			  , @QuantityStock  = SUM(pt.Quantity) -
					Coalesce(( select SUM(Quantity) from dxDeclarationConsumption
								where FK_dxProduct = @FK_dxProductToPick
                  and FK_dxDeclaration = @FK_dxDeclaration
								  and lot = pt.lot and Posted = 0 ),0.0)
			from dxProductTransaction pt
			left outer join dxProductProductionDate pd on ( pd.FK_dxProduct = pt.FK_dxProduct and pd.Lot = pt.Lot)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse = pt.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation  = pt.FK_dxLocation )
			where pt.FK_dxProduct = @FK_dxProductToPick
        and lo.FK_dxClientOrder is null
        and (   (lo.ReservedArea = 0 and @ManageByDropZone =0 )
             or (    (lo.FK_dxWorkOrder = @FK_dxWorkOrder and lo.ReservedArea = 1 and lo.PhaseNumber is null)
                  or (lo.CommonWIPLocation = 1)
                )
            )
        and wa.Quarantine = 0
			Group by pt.FK_dxWarehouse, pt.FK_dxLocation, pt.FK_dxProduct, pt.Lot, pd.ProductionDate, lo.PickingOrder
			Having SUM(pt.Quantity) -
				   -- Substract the unposted quantity from all declaration to represent the stock availability
				   Coalesce(( select SUM(Quantity) from dxDeclarationConsumption
							   where FK_dxProduct = @FK_dxProductToPick
                   and FK_dxDeclaration = @FK_dxDeclaration
   								 and lot = pt.lot and Posted = 0 ),0.0) > 0.0000001
			-- FIFO we do a sort by production date ascending
			Order by pd.ProductionDate asc, lo.PickingOrder desc

			if @QuantityStock > 0.0000001 if @QuantityToInsert > @QuantityStock  set @QuantityToInsert = @QuantityStock
			-- Insert into declaration
			insert into dxDeclarationConsumption (FK_dxDeclaration,FK_dxWarehouse,FK_dxLocation,FK_dxProduct, Lot, Quantity)
			select @FK_dxDeclaration ,@FK_dxWarehouse ,@FK_dxLocation,@FK_dxProductToPick , @LotNumber,@QuantityToInsert
			-- Get All Quantities on this Declaration Posted and not Posted
			set @QuantityOnThisDeclaration = Coalesce(( select SUM(Quantity) from dxDeclarationConsumption pc
															  where pc.FK_dxDeclaration = @FK_dxDeclaration
																and pc.FK_dxProduct     = @FK_dxProductToPick),0.0)
			set @QuantityToInsert = Round (@QuantityForProduction - @QuantityOnThisDeclaration , 6)
		 end -- while @QuantityToInsert > 0
	   end -- if @PickItem > 0
	   -- go to the next record
	   set @RowNo = @RowNo +1

	end

	select * from @BOM

end
GO
