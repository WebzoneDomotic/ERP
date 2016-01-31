SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-01-12
-- Description:	Rechercher la disponibilité du stock pour un O.F.
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxWOMaterialAvailability] @FK_dxWorkOrder int as
begin

	Declare @FK_dxWarehouse int
	Declare @FK_dxLocation int
	Declare @LotNumber varchar(50)
	Declare @FK_dxProduct int
	Declare @Quantity float
	Declare @Ratio  float
	Declare @Date Datetime
	
	set @FK_dxProduct =  ( Select FK_dxProduct from dxWorkOrder 
											  where PK_dxWorkOrder = @FK_dxWorkOrder )
	
	set @Quantity = ( select QuantityToProduce - ProducedQuantity from dxWorkOrder where PK_dxWorkOrder =  @FK_dxWorkOrder  )
	set @Date     = ( select WorkOrderDate from dxWorkOrder where PK_dxWorkOrder =  @FK_dxWorkOrder  )
    if @Quantity < 0.0 set @Quantity = 0.0 

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
	
	Declare @WOMaterialAvailability Table(
	    PR int
	  , ProductCode varchar(50)
	  , Level int
	  , NumberOfItems int
	  , Description varchar(250)
	  , TotalQuantity float
	  , AvailableQuantityInStock float
	  , AvailabilityRatio float
	  , QuantityAvailableForProduction Float
	  , ScaleUnit varchar(50)
	  )
	
	insert into @WOMaterialAvailability
	select 
	    FK_dxProduct 
	  , ProductCode 
	  , Level 
	  , NumberOfItems 
	  , Description 
	  , TotalQuantity 
	  , 0.0
	  , 0.0
	  , 0.0
	  , ScaleUnit 
	From @BOM  
	
	update @WOMaterialAvailability 
		  set AvailableQuantityInStock = Coalesce(Round(( select sum(pt.InStockQuantity) from dxProductWarehouse pt 
                                            left outer join dxWarehouse wa on ( wa.PK_dxWarehouse = pt.FK_dxWarehouse)
	                                   where pt.FK_dxProduct = PR 
                                             and wa.Quarantine = 0 ),8),0.0)
	 update @WOMaterialAvailability                             
	      set AvailabilityRatio =  Round(Case when abs(TotalQuantity) < 0.0000000001 then 0.0
	                              else AvailableQuantityInStock / TotalQuantity end ,3)       
	                                     
	set @Ratio = (Select Coalesce(Min(AvailabilityRatio),1.0) from  @WOMaterialAvailability  
	 where AvailabilityRatio < 1.0 
	   and AvailabilityRatio > 0.0
	   and NumberOfItems = 0)
	   
	Update @WOMaterialAvailability set  QuantityAvailableForProduction = TotalQuantity * @Ratio   

	-- Get Ratio of Level 1
	set @Ratio = (Select Coalesce(Min(AvailabilityRatio),1.0) from  @WOMaterialAvailability
	 where AvailabilityRatio < 1.0 and Level =1)
    if @Ratio < 1.0 Update @WOMaterialAvailability set  QuantityAvailableForProduction = TotalQuantity * @Ratio  where Level <=1
	-- Return dataset
	Select * from  @WOMaterialAvailability


end
GO
