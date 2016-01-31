SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-03-20
-- Description:	Création du picking list pour une livraison
-- --------------------------------------------------------------------------------------------
CREATE Procedure [dbo].[pdxShippingPickingList] @FK_dxShipping int as
begin

  --Declare  @FK_dxDeclaration int
  --set  @FK_dxDeclaration = 1

	Declare @FK_dxWarehouse int
	Declare @FK_dxLocation int
	Declare @LotNumber varchar(50)
	Declare @FK_dxProduct int
	Declare @Quantity float
	Declare @QuantityToInsert float
	Declare @Phase int
	Declare @Date Datetime
	Declare @FK_dxClientOrder int
	Declare @FK_dxClientOrderDetail int
	Declare @FK_dxProductToPick int
	Declare @QuantityForShippement float
	Declare @QuantityStock float
	Declare @QuantityOnThisShippement float
	Declare @Description varchar(2000)
	Declare @NbItem int
	Declare @RowNo int, @EOF int
	Declare @PickItem int -- 0 = False 1 = True
	Declare @C int
	Declare @OneClientOrderPerShipping bit

	Declare @ItemToShip Table (
	   RowNo int IDENTITY(1,1)
	 , FK_dxClientOrder int
	 , FK_dxClientOrderDetail int
	 , FK_dxProduct int
	 , Quantity Float
	 , Description varchar(2000)
	 , FK_dxScaleUnit varchar(50)
	)
	-- Check if client want one client order per shipping
	Set @OneClientOrderPerShipping = ( Select cl.OneClientOrderPerShipping from dxShipping sh
	                                   left join dxClient cl on ( cl.PK_dxClient = sh.FK_dxClient )
	                                   where sh.PK_dxShipping = @FK_dxShipping)
	if  @OneClientOrderPerShipping = 1
	begin
      -- Single Client Order per shipping
	  insert into @ItemToShip
	  --Sélection du BC en rupture antérieurs à la date de livraison
      --ayant le même client avec la même adresse de livraison
	  Select FK_dxClientOrder, PK_dxClientOrderDetail, FK_dxProduct, (cd.Quantity - cd.ShippedQuantity) , cd.Description ,FK_dxScaleUnit
	  From dxClientOrderDetail cd
	  left outer join dxClientOrder co on (co.PK_dxClientOrder = cd.FK_dxClientOrder )
	  where co.FK_dxClient       = ( Select FK_dxClient      from dxShipping where PK_dxShipping = @FK_dxShipping )
        and co.PK_dxClientOrder  = ( Select FK_dxClientOrder from dxShipping where PK_dxShipping = @FK_dxShipping )
	    and co.TransactionDate  <= ( Select TransactionDate  from dxShipping where PK_dxShipping = @FK_dxShipping )
	    and co.Posted = 1
	    and (cd.Quantity - cd.ShippedQuantity) > 0.00000001
	    and cd.Closed = 0
	  Order by cd.FK_dxClientOrder desc, cd.Rank
    end else
    begin
   	  -- Multiple Client Order per shipping
	  insert into @ItemToShip
	  --Sélection de tous le BC en rupture antérieurs à la date de livraison
    --ayant le même client avec la même adresse de livraison
	  Select FK_dxClientOrder, PK_dxClientOrderDetail, FK_dxProduct, (cd.Quantity - cd.ShippedQuantity) , cd.Description ,FK_dxScaleUnit
	  From dxClientOrderDetail cd
	  left outer join dxClientOrder co on (co.PK_dxClientOrder = cd.FK_dxClientOrder )
	  where co.FK_dxClient            = ( Select FK_dxClient            from dxShipping where PK_dxShipping = @FK_dxShipping )
        and co.FK_dxAddress__Shipping = ( Select FK_dxAddress__Shipping from dxShipping where PK_dxShipping = @FK_dxShipping )
	    and co.TransactionDate       <= ( Select TransactionDate        from dxShipping where PK_dxShipping = @FK_dxShipping )
	    and co.Posted = 1
	    and (Quantity - ShippedQuantity) > 0.00000001
	    and cd.Closed = 0
	  Order by cd.FK_dxClientOrder desc, cd.Rank
	end

	-- Remove reserved items and insert it again
	Delete from dxShippingDetail
	where FK_dxShipping = @FK_dxShipping
	  and FK_dxLocation in ( Select cd.FK_dxLocation__Reserved From dxClientOrderDetail cd
	left outer join dxClientOrder co on (co.PK_dxClientOrder = cd.FK_dxClientOrder )
	where co.FK_dxClient            = ( Select FK_dxClient            from dxShipping where PK_dxShipping = @FK_dxShipping )
	  and co.TransactionDate       <= ( Select TransactionDate        from dxShipping where PK_dxShipping = @FK_dxShipping )
	  and co.Posted = 1
	  and (Quantity - ShippedQuantity) > 0.00000001
	  and cd.Closed = 0
	  and not cd.FK_dxLocation__Reserved is null )

	-- Set Shipping Date to current Date
    Update dxShipping set TransactionDate = dbo.fdxGetDateNoTime(GetDate()) where PK_dxShipping = @FK_dxShipping
	-- Get Reserved Item prior to insert balance of material to ship
	insert into dxShippingDetail ([Rank],FK_dxShipping, FK_dxClientOrder, FK_dxClientOrderDetail
	                             ,FK_dxWarehouse,FK_dxLocation,FK_dxProduct, Lot, Quantity, ProductQuantity, Description)
	select cd.Rank, @FK_dxShipping, cd.FK_dxClientOrder, cd.PK_dxClientOrderDetail
	      ,cd.FK_dxWarehouse ,cd.FK_dxLocation__Reserved,cd.FK_dxProduct , cd.Lot, (cd.Quantity - cd.ShippedQuantity),(cd.Quantity - cd.ShippedQuantity), cd.Description
	From dxClientOrderDetail cd
	left outer join dxClientOrder co on (co.PK_dxClientOrder = cd.FK_dxClientOrder )
	where co.FK_dxClient            = ( Select FK_dxClient            from dxShipping where PK_dxShipping = @FK_dxShipping )
	  and co.FK_dxAddress__Shipping = ( Select FK_dxAddress__Shipping from dxShipping where PK_dxShipping = @FK_dxShipping )
	  and co.TransactionDate       <= ( Select TransactionDate        from dxShipping where PK_dxShipping = @FK_dxShipping )
	  and co.Posted = 1
	  and (cd.Quantity - cd.ShippedQuantity) > 0.00000001
	  and cd.Closed = 0
	  and not cd.FK_dxLocation__Reserved is null
	Order by cd.FK_dxClientOrder desc, cd.Rank


	set @RowNo = 1
	set @EOF = (Select Max(RowNo) from @ItemToShip )

	While @RowNo <= @EOF --Loop on the BOM table
	begin
	   -- Check if we have to pick this item
	   set @PickItem = ( Select COUNT(*) from @ItemToShip
						  where RowNo = @RowNo 	)
	   if @PickItem > 0
	   begin
		 -- Get item to pick
		 set @FK_dxClientOrder       = ( Select FK_dxClientOrder       from @ItemToShip where RowNo = @RowNo )
		 set @FK_dxClientOrderDetail = ( Select FK_dxClientOrderDetail from @ItemToShip where RowNo = @RowNo )
		 set @FK_dxProductToPick     = ( Select FK_dxProduct           from @ItemToShip where RowNo = @RowNo )
		 set @Description            = ( Select Description            from @ItemToShip where RowNo = @RowNo )
		 -- Get total quantity needed for this shipping
		 set @QuantityForShippement = ( Select Coalesce(Sum(Quantity),0.0) from @ItemToShip
		                                 where FK_dxClientOrderDetail = @FK_dxClientOrderDetail
		                                   and (  (FK_dxProduct =@FK_dxProductToPick)
		                                        or(FK_dxProduct is null)) )
		 -- Get All Quantities on this shippement an other shippement
		 set @QuantityOnThisShippement = Coalesce(( select SUM(Quantity) from dxShippingDetail sd
                                                left outer join dxShipping sp on ( sp.PK_dxShipping = sd.FK_dxShipping )
													                  		where
                                                  --    sd.FK_dxShipping = @FK_dxShipping
																                  --and sd.FK_dxClientOrder = @FK_dxClientOrder
																                       sd.FK_dxClientOrderDetail = @FK_dxClientOrderDetail
                                                  and  sp.Posted = 0
																                  and (  (sd.FK_dxProduct = @FK_dxProductToPick)
																                       or(FK_dxProduct is null)) ),0.0)
		 set @QuantityToInsert = @QuantityForShippement - @QuantityOnThisShippement
		 Print @QuantityToInsert
		 Print @QuantityOnThisShippement
		 while @QuantityToInsert > 0.0000001
		 begin
			-- Set Default Quantity
			set @FK_dxWarehouse = Coalesce( @FK_dxWarehouse,1)
			set @FK_dxLocation  = Coalesce( @FK_dxLocation,1)
			set @LotNumber      = ''
			set @QuantityStock  = 0.0

			-- Get Available quantity for this product in the inventory
			Select
				Top 1
				@FK_dxWarehouse = pt.FK_dxWarehouse
			  , @FK_dxLocation  = pt.FK_dxLocation
			  , @LotNumber      = pt.Lot
			  , @QuantityStock  = Coalesce(SUM(pt.Quantity), 0.0) -
					Coalesce(( select SUM(Quantity) from dxShippingDetail sd
				               left outer join dxShipping sp on ( sp.PK_dxShipping = sd.FK_dxShipping )
				   			      where FK_dxProduct     = @FK_dxProductToPick
				   			        and lot = pt.lot
								        and sp.Posted = 0  ),0.0)
			from dxProductTransaction pt
			left outer join dxProductProductionDate pd  on ( pd.FK_dxProduct = pt.FK_dxProduct and pd.Lot = pt.Lot)
            left outer join dxWarehouse wa on ( wa.PK_dxWarehouse = pt.FK_dxWarehouse)
            left outer join dxLocation  lo on ( lo.PK_dxLocation  = pt.FK_dxLocation)
			where pt.FK_dxProduct = @FK_dxProductToPick
			  and lo.FK_dxClientOrder is null
			  and lo.FK_dxWorkOrder is null
        and lo.ReservedArea = 0
        and wa.Quarantine = 0
			Group by pt.FK_dxWarehouse, pt.FK_dxLocation, pt.FK_dxProduct, pt.Lot, pd.ProductionDate ,lo.PickingOrder
			Having Coalesce(SUM(pt.Quantity), 0.0) -
				   -- Substract the unposted quantity from all declaration to represent the stock availability
				   Coalesce(( select SUM(Quantity) from dxShippingDetail sd
				               left outer join dxShipping sp on ( sp.PK_dxShipping = sd.FK_dxShipping )
				   			       where FK_dxProduct  = @FK_dxProductToPick
				   			         and lot = pt.lot
								         and sp.Posted = 0 ),0.0) > 0.0000001
			-- FIFO we do a sort by production date ascending
			Order by pd.ProductionDate asc, lo.PickingOrder desc

	        if @QuantityStock is null set @QuantityStock = 0.0
			if @QuantityStock > 0.0000001 if @QuantityToInsert > @QuantityStock  set @QuantityToInsert = @QuantityStock

			-- Insert into Shipping detail
			select @RowNo, @FK_dxShipping, @FK_dxClientOrder, @FK_dxClientOrderDetail
			      ,@FK_dxWarehouse ,@FK_dxLocation,@FK_dxProductToPick , @LotNumber,@QuantityToInsert,@QuantityToInsert, @Description

			-- Get All Quantities on this Shipping
			insert into dxShippingDetail ([Rank],FK_dxShipping, FK_dxClientOrder, FK_dxClientOrderDetail
			                             ,FK_dxWarehouse,FK_dxLocation,FK_dxProduct, Lot, Quantity, ProductQuantity, Description)
			select @RowNo, @FK_dxShipping, @FK_dxClientOrder, @FK_dxClientOrderDetail
			      ,@FK_dxWarehouse ,@FK_dxLocation,@FK_dxProductToPick , @LotNumber,@QuantityToInsert,@QuantityToInsert, @Description

			-- Get All Quantities on this Shipping
			set @QuantityOnThisShippement = Coalesce(( select SUM(Quantity) from dxShippingDetail sd
															  where sd.FK_dxShipping = @FK_dxShipping
														      and sd.FK_dxClientOrder = @FK_dxClientOrder
																  and sd.FK_dxClientOrderDetail = @FK_dxClientOrderDetail
																  and (     (sd.FK_dxProduct = @FK_dxProductToPick)
																         or (sd.FK_dxProduct is null)
																     )

																),0.0)
			set @QuantityToInsert = Round(@QuantityForShippement - @QuantityOnThisShippement ,6)
		 end -- while @QuantityToInsert > 0
	   end -- if @PickItem > 0
	   -- go to the next record
	   set @RowNo = @RowNo +1
	end

  -- Update Rank to the same sequence as Client Order
  Update sd
    set Rank = Coalesce(cd.Rank,0)
  From dxShippingDetail sd
  left join dxClientOrderDetail cd on ( cd.PK_dxClientOrderDetail = sd.FK_dxClientOrderDetail )
  where FK_dxShipping = @FK_dxShipping

  Update dxShippingDetail set Lot = '0'
  where FK_dxShipping = @FK_dxShipping
    and Lot = ''
    and ( (0 = Coalesce(( Select InventoryItem from dxProduct where PK_dxProduct = dxShippingDetail.FK_dxProduct), 0))
           or (FK_dxProduct is null)
        )
  -- Erase item with no lot number
	--Delete from dxShippingDetail where FK_dxShipping = @FK_dxShipping  and Lot = '' ;

end
GO
