SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 8 septembre 2012
-- Description:	Recalcul des transactions d'inventaire pour un produit sur un localisation et un lot donné
-- --------------------------------------------------------------------------------------------

Create Procedure [dbo].[pdxRecalculateInventory]
     @FK_dxProductTransaction int = 0
   , @TransactionDate Datetime = '2000-01-01'
   , @FK_dxWarehouse int = -1
   , @FK_dxLocation int = -1 
   , @FK_dxProduct int
   , @Lot varchar(50) = '0'
   , @Path varchar(8000) = ''
as
Begin

  Set NOCOUNT ON

  -- Get Batch information if PK is provided
  if @FK_dxProductTransaction > 0
    Select @TransactionDate = TransactionDate
         , @FK_dxWarehouse = FK_dxWarehouse
         , @FK_dxLocation = FK_dxLocation
         , @FK_dxProduct = FK_dxProduct
         , @Lot = Lot
    From dxProductTransaction where PK_dxProductTransaction = @FK_dxProductTransaction

  -- Create working Table
  Declare @PT TABLE (
   	  [RecNo] [int] IDENTITY(1,1) NOT NULL,
	  [PK_dxProductTransaction] [int] NOT NULL,
	  [TransactionType] [int] NOT NULL,
	  [FK_dxWarehouse] [int] NOT NULL,
	  [FK_dxProduct] [int] NOT NULL,
	  [TransactionDate] [datetime] NOT NULL,
	  [Lot] [varchar](50) NOT NULL,
	  [FK_dxLocation] [int] NOT NULL,

	  [Description] [varchar](255) NULL,
	  [Quantity] [float] NOT NULL,

	  [AmountPerUnit] [float] NOT NULL,
	  [AmountPerUnit_] [float] NOT NULL,
	  UnitMaterialStdCost  [float] NOT NULL,
      UnitLaborStdCost  [float] NOT NULL,
      UnitOverheadFixedStdCost  [float] NOT NULL,
      UnitOverheadVariableStdCost [float] NOT NULL,

	  [Amount] [float] NOT NULL,
	  [Amount_] [float] NOT NULL,
	  [InStockQuantity] [float] NOT NULL,
	  [InStockQuantiy_] [float] NOT NULL,
	  [AverageAmountPerUnit] [float] NOT NULL,
	  [AverageAmountPerUnit_] [float] NOT NULL,
	  [TotalAmount]  [float] NOT NULL,
      [TotalAmount_] [float] NOT NULL,

      [KindOfDocument] [int] NOT NULL,
	  [Status] [int] NOT NULL,
	  [LinkedProductTransaction] [int] NOT NULL,
	  [UpstreamLink] [int] NOT NULL,

	  [MaterialCost] [float] NOT NULL,
	  [MaterialCost_] [float] NOT NULL,
	  [LaborCost] [float] NOT NULL,
	  [LaborCost_] [float] NOT NULL,
	  [OverheadFixedCost] [float] NOT NULL,
	  [OverheadFixedCost_] [float] NOT NULL,
	  [OverheadVariableCost] [float] NOT NULL,
	  [OverheadVariableCost_] [float] NOT NULL,

	  [MaterialCostVariance] [float] NOT NULL,
	  [LaborCostVariance] [float] NOT NULL,
	  [OverheadFixedCostVariance] [float] NOT NULL,
	  [OverheadVariableCostVariance] [float] NOT NULL,

	  [MaterialCostNetVariance] [float] NOT NULL,
	  [LaborCostNetVariance] [float] NOT NULL,
	  [OverheadFixedCostNetVariance] [float] NOT NULL,
	  [OverheadVariableCostNetVariance] [float] NOT NULL,

	  [MaterialStandardCost] [float] NOT NULL,
	  [MaterialStandardCost_][float] NOT NULL,
	  [LaborStandardCost] [float] NOT NULL,
	  [LaborStandardCost_] [float] NOT NULL,
	  [OverheadFixedStandardCost] [float] NOT NULL,
	  [OverheadFixedStandardCost_] [float] NOT NULL,
	  [OverheadVariableStandardCost] [float] NOT NULL,
	  [OverheadVariableStandardCost_] [float] NOT NULL,

	  [PhaseNumber] [int] NOT NULL,
	  [PriorPhase] [bit] NOT NULL,
	  [FK_dxLocation__PriorPhase] [int] NULL,

	  [Ratio] [float] NOT NULL,

	  [PhaseMaterialStandardCost] [float] NOT NULL,
	  [PhaseMaterialStandardCost_] [float] NOT NULL,
	  [PhaseLaborStandardCost] [float] NOT NULL,
	  [PhaseLaborStandardCost_] [float] NOT NULL,
	  [PhaseOverheadFixedStandardCost] [float] NOT NULL,
	  [PhaseOverheadFixedStandardCost_] [float] NOT NULL,
	  [PhaseOverheadVariableStandardCost] [float] NOT NULL,
	  [PhaseOverheadVariableStandardCost_] [float] NOT NULL,

	  [PhaseMaterialStandardCostVariance]  [float] NOT NULL,
	  [PhaseMaterialStandardCostVariance_] [float] NOT NULL,
	  [PhaseLaborStandardCostVariance]  [float] NOT NULL,
	  [PhaseLaborStandardCostVariance_] [float] NOT NULL,
	  [PhaseOverheadFixedStandardCostVariance]  [float] NOT NULL,
	  [PhaseOverheadFixedStandardCostVariance_] [float] NOT NULL,
	  [PhaseOverheadVariableStandardCostVariance]  [float] NOT NULL,
	  [PhaseOverheadVariableStandardCostVariance_] [float] NOT NULL
    Unique (RecNo)
  )

  -- -------------------------------------------------------------------------------------
  -- Récuperation du coût standard
  Declare @StandardCost TABLE (
      FK_dxProduct int
    , PhaseNumber int
    , TransactionDate Datetime
    , UnitMaterialStdCost float
    , UnitLaborStdCost float
    , UnitOverheadFixedStdCost float
    , UnitOverheadVariableStdCost float
    Unique ( FK_dxProduct,PhaseNumber,TransactionDate) )
  Insert into  @StandardCost
  Select Distinct
       pt.[FK_dxProduct]
	  ,pt.[PhaseNumber]
	  ,pt.[TransactionDate]
	  ,0.0,0.0,0.0,0.0
  From dxProductTransaction pt
  WHERE
        pt.FK_dxWarehouse = @FK_dxWarehouse
    and pt.FK_dxLocation  = @FK_dxLocation
    and pt.FK_dxProduct   = @FK_dxProduct
    and pt.Lot            = @Lot
  -- Recupére le cummul du coût standard par phase et par type ( mat, mod, fgf, fgv )
  Update pt
      Set UnitMaterialStdCost         = dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,0,pt.PhaseNumber,pt.TransactionDate)
        , UnitLaborStdCost            = dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,1,pt.PhaseNumber,pt.TransactionDate)
        , UnitOverheadFixedStdCost    = dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,2,pt.PhaseNumber,pt.TransactionDate)
        , UnitOverheadVariableStdCost = dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,3,pt.PhaseNumber,pt.TransactionDate)
  From  @StandardCost  pt
  -- ----------------------------------------------------------------------------------------------

  Insert into @PT
  Select
	   pt.[PK_dxProductTransaction]
	  ,pt.[TransactionType]
	  ,pt.[FK_dxWarehouse]
	  ,pt.[FK_dxProduct]
	  ,pt.[TransactionDate]
	  ,pt.[Lot]
	  ,pt.[FK_dxLocation]
	  ,pt.[Description]
	  ,pt.[Quantity]
	  ,pt.[AmountPerUnit]
	  ,0.0
	  ,st.UnitMaterialStdCost         --dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,0,pt.PhaseNumber,pt.TransactionDate) as UnitMaterialStdCost
      ,st.UnitLaborStdCost            --dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,1,pt.PhaseNumber,pt.TransactionDate) as UnitLaborStdCost
      ,st.UnitOverheadFixedStdCost    --dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,2,pt.PhaseNumber,pt.TransactionDate) as UnitOverheadFixedStdCost
      ,st.UnitOverheadVariableStdCost --dbo.fdxGetStandardCostByStatus( pt.FK_dxProduct,3,pt.PhaseNumber,pt.TransactionDate) as UnitOverheadVariableStdCost
	  ,pt.[Amount]
	  ,0.0
	  ,pt.[InStockQuantiy]
	  ,0.0
	  ,pt.[AverageAmountPerUnit]
	  ,0.0
	  ,pt.[TotalAmount]
      ,0.0
      ,pt.[KindOfDocument]
	  ,pt.[Status]
	  ,pt.[LinkedProductTransaction]
	  ,Case when not pl.PK_dxProductTransaction is null then 1 else 0 end -- UpstreamLink
	  ,pt.[MaterialCost]
	  ,0.0
	  ,pt.[LaborCost]
	  ,0.0
	  ,pt.[OverheadFixedCost]
	  ,0.0
	  ,pt.[OverheadVariableCost]
	  ,0.0
	  ,pt.[MaterialCostVariance]
	  ,pt.[LaborCostVariance]
	  ,pt.[OverheadFixedCostVariance]
	  ,pt.[OverheadVariableCostVariance]
	  ,pt.[MaterialCostNetVariance]
	  ,pt.[LaborCostNetVariance]
	  ,pt.[OverheadFixedCostNetVariance]
	  ,pt.[OverheadVariableCostNetVariance]
	  ,pt.[MaterialStandardCost]
	  ,0.0
	  ,pt.[LaborStandardCost]
	  ,0.0
	  ,pt.[OverheadFixedStandardCost]
	  ,0.0
	  ,pt.[OverheadVariableStandardCost]
	  ,0.0
	  ,pt.[PhaseNumber]
	  ,pt.[PriorPhase]
	  ,pt.[FK_dxLocation__PriorPhase]
      ,0.0
	  ,pt.[PhaseMaterialStandardCost]
	  ,0.0
	  ,pt.[PhaseLaborStandardCost]
	  ,0.0
	  ,pt.[PhaseOverheadFixedStandardCost]
	  ,0.0
	  ,pt.[PhaseOverheadVariableStandardCost]
	  ,0.0
	  ,pt.[PhaseMaterialStandardCostVariance]
	  ,0.0
	  ,pt.[PhaseLaborStandardCostVariance]
	  ,0.0
	  ,pt.[PhaseOverheadFixedStandardCostVariance]
	  ,0.0
	  ,pt.[PhaseOverheadVariableStandardCostVariance]
	  ,0.0
  From dxProductTransaction pt
  -- Cette jointure nous permet de savoir si cette transaction est liée en amont (UpstreamLink )
  Left join dxProductTransaction pl on ( pl.LinkedProductTransaction = pt.PK_dxProductTransaction )
  Left join dbo.dxProduct   pr ON pt.FK_dxProduct   = pr.PK_dxProduct
  Left join dbo.dxWarehouse wo ON wo.PK_dxWarehouse = pt.FK_dxWarehouse
  Left join dbo.dxLocation  lo ON lo.PK_dxLocation  = pt.FK_dxLocation
  Left join @StandardCost   st on ( st.FK_dxProduct = pt.FK_dxProduct and st.PhaseNumber = pt.PhaseNumber and st.TransactionDate = pt.TransactionDate)
  WHERE
        pt.FK_dxWarehouse = @FK_dxWarehouse
    and pt.FK_dxLocation  = @FK_dxLocation
    and pt.FK_dxProduct   = @FK_dxProduct
    and pt.Lot            = @Lot
  -- Ici la séquence est très importante
  -- pour une phase la dernière transaction doit être celle qui transfert le tout à la phase suivante
  ORDER BY
    pt.FK_dxWarehouse asc
   ,pt.FK_dxLocation asc
   ,pt.FK_dxProduct asc
   ,pt.Lot asc
   ,pt.TransactionDate asc
   ,pt.PhaseNumber asc
   ,case when pt.PhaseNumber > 0 then pt.LinkedProductTransaction else 0 end asc
   ,pt.PK_dxProductTransaction asc


  Declare @Tolerance float = 0.0000000001 , @TransactionRecNo int = 0 , @RecNo int = 1
  Declare @EOF int, @Status int, @Ratio float = 0.0
        , @TransactionType int
        , @RecordDate Datetime
        , @KindOfDocument int
        , @LinkedTransaction int = -1
        , @PhaseNumber int
        , @PriorPhase int = -1
        , @UpstreamLink int = 0
        , @Quantity float = 0.0
        , @AmountPerUnit float = 0.0
        , @Amount float = 0.0

  Declare @NewTotalQuantity float = 0.0
        , @NewAverageUnitAmount float = 0.0
        , @NewAmount float = 0.0
        , @NewTotalAmount float =0.0
        , @NewTotalMaterialStdCost float = 0.0
        , @NewTotalLaborStdCost float = 0.0 
        
        , @TotalMATCost float = 0.0
        , @TotalMODCost float = 0.0  
        , @TotalFGFCost float = 0.0
        , @TotalFGVCost float = 0.0  
         
  Declare @MaterialStdCost float =0.0
        , @LaborStdCost float =0.0
        , @OverheadFixedStdCost float =0.0
        , @OverheadVariableStdCost float =0.0
  Declare @UnitMaterialStdCost float = 0.0
        , @UnitLaborStdCost float = 0.0
        , @UnitOverheadFixedStdCost float = 0.0
        , @UnitOverheadVariableStdCost float = 0.0
  Declare @PhaseMaterialStdCost float = 0.0
        , @PhaseLaborStdCost float = 0.0
        , @PhaseOverheadFixedStdCost float = 0.0
        , @PhaseOverheadVariableStdCost float = 0.0
  Declare @PhaseMaterialStdCostVariance float = 0.0
        , @PhaseLaborStdCostVariance float = 0.0
        , @PhaseOverheadFixedStdCostVariance float = 0.0
        , @PhaseOverheadVariableStdCostVariance float = 0.0
  -- ----------------------------------------------------------------------------------------------
  -- Récuperation de l'index de la transaction ou il faut commencer les calculs
  set @TransactionRecNo = Coalesce(( Select RecNo from @PT where PK_dxProductTransaction = @FK_dxProductTransaction ), 0)
  Set @EOF = ( Select max(RecNo) from @PT )
  -- et début du traitement
  -- ----------------------------------------------------------------------------------------------
  While @RecNo <= @EOF
  begin
     -- ----------------------------------------------------------------------------------------------
     -- Lecture de l'enregistrement - Données de base qui serviront à faire le calcul du coût réel et std
     -- ----------------------------------------------------------------------------------------------
     Select @Status = [Status]
          , @Quantity = Quantity
          , @TransactionType = TransactionType
          , @KindOfDocument = KindOfDocument
          , @PhaseNumber = PhaseNumber
          , @AmountPerUnit = AmountPerUnit
          , @PriorPhase = PriorPhase
          , @Amount = Amount
          
          , @UnitMaterialStdCost = UnitMaterialStdCost
          , @UnitLaborStdCost    = UnitLaborStdCost
         
          -- On initialise le cumul avec la valeur déjà passée si premier enregistrement .... !!!!!!
          , @TotalMATCost = Case when @RecNo =1 then MaterialCost         else @TotalMATCost end
          , @TotalMODCost = Case when @RecNo =1 then LaborCost            else @TotalMODCost end
          , @TotalFGFCost = Case when @RecNo =1 then OverheadFixedCost    else @TotalFGFCost end
          , @TotalFGVCost = Case when @RecNo =1 then OverheadVariableCost else @TotalFGVCost end
          , @UpstreamLink = UpstreamLink
          
          , @PhaseMaterialStdCostVariance = PhaseMaterialStandardCostVariance
          , @PhaseLaborStdCostVariance    = PhaseLaborStandardCostVariance
         
          , @PhaseMaterialStdCost         = Case when @RecNo =1 and kindofDocument <> 17 then 0.0  
                                                 when kindofDocument = 17 and Quantity > 0 then PhaseMaterialStandardCostVariance   
                                            else @PhaseMaterialStdCost end
      
          , @PhaseLaborStdCost           = Case when @RecNo =1 and kindofDocument <> 17 then 0.0  
                                                 when kindofDocument = 17 and Quantity > 0 then PhaseLaborStandardCostVariance   
                                            else @PhaseLaborStdCost end
          
          -- Si la valeur à été passé par une transaction en amont alors on utilise cette valeur pour ne pas la réinitialiser 
          -- à sa valeur par défault
          , @MaterialStdCost         = Case When UpstreamLink = 1 then MaterialStandardCost         else Round(Quantity * UnitMaterialStdCost, 2 ) end
          , @LaborStdCost            = Case when Status = 1       then LaborStandardCost            else Round(Quantity * UnitLaborStdCost, 2 ) end
          , @OverheadFixedStdCost    = Case When UpstreamLink = 1 then OverheadFixedStandardCost    else Round(Quantity * UnitOverheadFixedStdCost,2 ) end
          , @OverheadVariableStdCost = Case when UpstreamLink = 1 then OverheadVariableStandardCost else Round(Quantity * UnitOverheadVariableStdCost,2 ) end
          
     from @PT where RecNo = @RecNo
     
     set @NewTotalMaterialStdCost = Round(@NewTotalMaterialStdCost + @MaterialStdCost,2)
     set @NewTotalLaborStdCost    = Round(@NewTotalLaborStdCost    + @LaborStdCost, 2 )

     -- -------------------------------------------------------------------------------------------------
     -- Calcul du coût Réel selon
     -- 0 - Quantity Ajustment
     -- 1 - Average cost Ajustment
     -- 2 - Add an Amount to total Amount
     -- 3 - Quantity & Cost Adjustment
     -- -------------------------------------------------------------------------------------------------
     if @TransactionType = 0 -- 0 - Quantity Ajustment
     begin
        set @NewTotalQuantity = Round(@Quantity  + @NewTotalQuantity,6)
        set @NewAmount        = Round(@Quantity  * @NewAverageUnitAmount,2 )
        set @NewTotalAmount   = Round(@NewAmount + @NewTotalAmount,2);
        -- Case spécial pour la consommation lorsqu'on arrive avec zéro qté
        -- Ajustement des coût arriver à zéro $
        if ( @NewTotalQuantity < @Tolerance)  
        begin
            -- Réel
           if abs(@NewTotalAmount) < 10.0
           begin
             set @NewAmount = Round(@NewAmount - @NewTotalAmount,2)
             set @NewTotalAmount = 0.0
           end
           -- Material Standard
           if abs(@NewTotalMaterialStdCost) < 10.0
           begin
             set @MaterialStdCost = Round(@MaterialStdCost - @NewTotalMaterialStdCost,2)
             set @NewTotalMaterialStdCost = 0.0
           end
           -- Labor Standard
           if abs(@NewTotalLaborStdCost) < 10.0
           begin
             set @LaborStdCost = Round(@LaborStdCost - @NewTotalLaborStdCost,2)
             set @NewTotalLaborStdCost = 0.0
           end
        end ;
        set @Amount        = Round(@NewAmount,2)
        set @AmountPerUnit = Round(@NewAverageUnitAmount,4)
        if  @NewTotalQuantity > @Tolerance  set @NewAverageUnitAmount = Round(@NewTotalAmount / @NewTotalQuantity ,4)
     end else
     if @TransactionType = 1 -- 1 - Average cost Ajustment
     begin
         set @NewTotalQuantity     = Round(@Quantity + @NewTotalQuantity,6)
         set @NewAverageUnitAmount = Round(@AmountPerUnit,6)
         set @NewAmount            = Round(@NewTotalQuantity * @NewAverageUnitAmount , 2);
         set @AmountPerUnit        = Round(@NewAverageUnitAmount,6)
         set @Amount               = Round(@NewAmount - @NewTotalAmount,2)
         set @NewTotalAmount = @NewAmount
     end else
     if @TransactionType = 2 -- 2 - Add an Amount to total Amount
     begin
        set @NewTotalQuantity = Round(@Quantity+@NewTotalQuantity,6)
        set @NewTotalAmount   = Round(@Amount+@NewTotalAmount,2)
        Set @AmountPerUnit    = 0.0
        if  @NewTotalQuantity > @Tolerance  set @NewAverageUnitAmount = Round(@NewTotalAmount / @NewTotalQuantity ,4)
     end else
     if @TransactionType = 3 -- 3 - Quantity & Cost Adjustment
     begin
        set @NewTotalQuantity = Round(@Quantity+@NewTotalQuantity,6)
        set @NewTotalAmount   = Round(@Amount+@NewTotalAmount,2)
        set @NewAverageUnitAmount = @AmountPerUnit
        if @NewTotalQuantity  >  @Tolerance
           set @NewAverageUnitAmount = Round(@NewTotalAmount / @NewTotalQuantity, 4)
     end
     -- -------------------------------------------------------------------------------------------------
     -- Fin du calcul du coût réel
     -- -------------------------------------------------------------------------------------------------

     If @NewTotalQuantity < 0.0 
     begin
        RAISERROR('Inventaire négatif non permis / Negative inventory not allowed ', 16, 1)
        ROLLBACK TRANSACTION
     end
     
     if @PhaseNumber > 0 and @KindofDocument = 15 and @Quantity > 0 and @UpstreamLink = 0 and @RecNo = 1
     begin
       set @PhaseMaterialStdCost = 0.0
     --  set @PhaseLaborStdCost = 0.0
     end 
    
     -- Calculate the Phase Cumulative Amount on Consumption Transaction Only
     if (@KindOfDocument in (16,18))  -- if transaction is material consumption or labor
     begin 
       -- Calculate the cumulative amount at real cost for each category of a phase
       set @TotalMATCost = @TotalMATCost + case when @Status = 0 then @Amount else 0 end  
       set @TotalMODCost = @TotalMODCost + case when @Status = 1 then @Amount else 0 end  
       set @TotalFGFCost = @TotalFGFCost + case when @Status = 2 then @Amount else 0 end 
       set @TotalFGVCost = @TotalFGVCost + case when @Status = 3 then @Amount else 0 end 
       -- -------------------------------------------------------------------------------------------------
       -- Calcul du cummulatif du coût standard de la phase
       -- et calcul de la variance d'une phase, la variance est égale au coût std de la transaction
       -- qui on été consommé dans les inventaires
       --  Valeur cumulative de la phase
       set @PhaseMaterialStdCost         = @PhaseMaterialStdCost         +  @MaterialStdCost
       set @PhaseLaborStdCost            = @PhaseLaborStdCost            +  @LaborStdCost
       set @PhaseOverheadFixedStdCost    = @PhaseOverheadFixedStdCost    +  @OverheadFixedStdCost
       set @PhaseOverheadVariableStdCost = @PhaseOverheadVariableStdCost +  @OverheadVariableStdCost
       
       set @PhaseMaterialStdCostVariance         = @MaterialStdCost
       set @PhaseLaborStdCostVariance            = @LaborStdCost
       set @PhaseOverheadFixedStdCostVariance    = @OverheadFixedStdCost
       set @PhaseOverheadVariableStdCostVariance = @OverheadVariableStdCost
     end
      
     if @PhaseNumber < 0 and @KindOfDocument <> 17
     begin 
       set @PhaseMaterialStdCostVariance         = 0.0
       set @PhaseLaborStdCostVariance            = 0.0
       set @PhaseOverheadFixedStdCostVariance    = 0.0
       set @PhaseOverheadVariableStdCostVariance = 0.0

       set @PhaseMaterialStdCost         = 0.0
       set @PhaseLaborStdCost            = 0.0
       set @PhaseOverheadFixedStdCost    = 0.0
       set @PhaseOverheadVariableStdCost = 0.0
     end    
    
     if (@KindOfDocument =15) and @Quantity > 0 
     begin
       set @PhaseMaterialStdCost         = @PhaseMaterialStdCost         +  @PhaseMaterialStdCostVariance
       set @PhaseLaborStdCost            = @PhaseLaborStdCost            +  @PhaseLaborStdCostVariance
       set @PhaseOverheadFixedStdCost    = @PhaseOverheadFixedStdCost    +  @PhaseOverheadFixedStdCostVariance
       set @PhaseOverheadVariableStdCost = @PhaseOverheadVariableStdCost +  @PhaseOverheadVariableStdCostVariance
     end   
   
     -- Inversion de la valeur si consommation - passage à la phase suivante ou en produit fin1
     -- Ajustement selon le ratio passé
     -- Calcul de la proportion
     if (@Quantity < 0.0) and ( @PhaseNumber > 0 )
     begin
       set @Ratio  = (@Quantity / (@NewTotalQuantity-@Quantity ))
       --Variation du a la consommation avec ajustement du cumulatif
       set @PhaseMaterialStdCostVariance = Round( @Ratio * @PhaseMaterialStdCost ,2)
       set @PhaseMaterialStdCost         = @PhaseMaterialStdCost + @PhaseMaterialStdCostVariance
       
       set @PhaseLaborStdCostVariance = Round( @Ratio * @PhaseLaborStdCost ,2)
       set @PhaseLaborStdCost         = @PhaseLaborStdCost + @PhaseLaborStdCostVariance
      
       set @PhaseOverheadFixedStdCost    = Round( @Ratio * @PhaseOverheadFixedStdCost ,2)
       set @PhaseOverheadVariableStdCost = Round( @Ratio * @PhaseOverheadVariableStdCost ,2)

       set @TotalMATCost =  Round(@Ratio * @TotalMATCost,2)
       set @TotalMODCost =  Round(@Ratio * @TotalMODCost,2)
       set @TotalFGFCost =  Round(@Ratio * @TotalFGFCost,2)
       set @TotalFGVCost =  Round(@Ratio * @TotalFGVCost,2)
     end 
     
     -- ----------------------------------------------------------------------------------------------
     -- Update current record  - Mise à jour de l'enregistement courant
     -- ----------------------------------------------------------------------------------------------
     Update @PT
        set
            AmountPerUnit_                = Round(@AmountPerUnit,6)
          , Amount_                       = Round(@Amount,2)
          , InStockQuantiy_               = Round(@NewTotalQuantity,6)
          , TotalAmount_                  = Round(@NewTotalAmount,2)
          , AverageAmountPerUnit_         = @NewAverageUnitAmount

          , MaterialCost_                 = @TotalMATCost
          , LaborCost_                    = @TotalMODCost
          , OverheadFixedCost_            = @TotalFGFCost
          , OverheadVariableCost_         = @TotalFGVCost

          , MaterialStandardCost_         = @MaterialStdCost
          , LaborStandardCost_            = @LaborStdCost
          , OverheadFixedStandardCost_    = @OverheadFixedStdCost
          , OverheadVariableStandardCost_ = @OverheadVariableStdCost
           
          , PhaseMaterialStandardCost_         =  @PhaseMaterialStdCost
          , PhaseLaborStandardCost_            =  @PhaseLaborStdCost
          , PhaseOverheadFixedStandardCost_    =  @PhaseOverheadFixedStdCost
          , PhaseOverheadVariableStandardCost_ =  @PhaseOverheadVariableStdCost
          
          , PhaseMaterialStandardCostVariance_         = @PhaseMaterialStdCostVariance 
          , PhaseLaborStandardCostVariance_            = @PhaseLaborStdCostVariance
          , PhaseOverheadFixedStandardCostVariance_    = @PhaseOverheadFixedStdCostVariance
          , PhaseOverheadVariableStandardCostVariance_ = @PhaseOverheadVariableStdCostVariance
          
     where RecNo = @RecNo
     -- ----------------------------------------------------------------------------------------------
     -- On passe au prochain enregistrement
     -- ----------------------------------------------------------------------------------------------
     set @RecNo = @RecNo + 1
  end

  --Select * from @PT
  -- ----------------------------------------------------------------------------------------------
  -- Update Transaction with calculated value, Update only from specified Transaction and Date
  -- ----------------------------------------------------------------------------------------------
  Update pt1
     set pt1.Amount               = pt2.Amount_
       , pt1.AmountPerUnit        = pt2.AmountPerUnit_
       , pt1.InStockQuantiy       = pt2.InStockQuantiy_
       , pt1.AverageAmountPerUnit = pt2.AverageAmountPerUnit_
       , pt1.TotalAmount          = pt2.TotalAmount_
       
       , pt1.MaterialCost         = pt2.MaterialCost_
       , pt1.LaborCost            = pt2.LaborCost_
       , pt1.OverheadFixedCost    = pt2.OverheadFixedCost_
       , pt1.OverheadVariableCost = pt2.OverheadVariableCost_

       , pt1.MaterialStandardCost         = pt2.MaterialStandardCost_
       , pt1.LaborStandardCost            = pt2.LaborStandardCost_
       , pt1.OverheadFixedStandardCost    = pt2.OverheadFixedStandardCost_
       , pt1.OverheadVariableStandardCost = pt2.OverheadVariableStandardCost_

       , pt1.PhaseMaterialStandardCost         =  pt2.PhaseMaterialStandardCost_
       , pt1.PhaseLaborStandardCost            =  pt2.PhaseLaborStandardCost_
       , pt1.PhaseOverheadFixedStandardCost    =  pt2.PhaseOverheadFixedStandardCost_
       , pt1.PhaseOverheadVariableStandardCost =  pt2.PhaseOverheadVariableStandardCost_
      
       , pt1.PhaseMaterialStandardCostVariance         = pt2.PhaseMaterialStandardCostVariance_
       , pt1.PhaseLaborStandardCostVariance            = pt2.PhaseLaborStandardCostVariance_
       , pt1.PhaseOverheadFixedStandardCostVariance    = pt2.PhaseOverheadFixedStandardCostVariance_
       , pt1.PhaseOverheadVariableStandardCostVariance = pt2.PhaseOverheadVariableStandardCostVariance_
       
  From dxProductTransaction pt1
  Left join @PT pt2 on ( pt1.PK_dxProductTransaction = pt2.PK_dxProductTransaction)
   where pt1.FK_dxWarehouse = @FK_dxWarehouse
     and pt1.FK_dxLocation  = @FK_dxLocation
     and pt1.FK_dxProduct   = @FK_dxProduct
     and pt1.Lot            = @Lot
     -- Check if record change
     and (abs( pt2.Amount               - pt2.Amount_               ) > @Tolerance
      or  abs( pt2.AmountPerUnit        - pt2.AmountPerUnit_        ) > @Tolerance
      or  abs( pt2.MaterialCost         - pt2.MaterialCost_         ) > @Tolerance
      or  abs( pt2.LaborCost            - pt2.LaborCost_            ) > @Tolerance
      or  abs( pt2.MaterialStandardCost - pt2.MaterialStandardCost_ ) > @Tolerance
      or  abs( pt2.LaborStandardCost    - pt2.LaborStandardCost_    ) > @Tolerance
      or  abs( pt2.InStockQuantity      - pt2.InStockQuantiy_       ) > @Tolerance
      or  abs( pt2.AverageAmountPerUnit - pt2.AverageAmountPerUnit_ ) > @Tolerance
      or  abs( pt2.TotalAmount          - pt2.TotalAmount_          ) > @Tolerance
      
      or abs( pt2.PhaseMaterialStandardCost         - pt2.PhaseMaterialStandardCost_         )> @Tolerance
      or abs( pt2.PhaseLaborStandardCost            - pt2.PhaseLaborStandardCost_            )> @Tolerance
      
      or abs( pt2.PhaseMaterialStandardCostVariance - pt2.PhaseMaterialStandardCostVariance_ )> @Tolerance
      or abs( pt2.PhaseLaborStandardCostVariance    - pt2.PhaseLaborStandardCostVariance_    )> @Tolerance
      )
     and pt1.TransactionDate >= @TransactionDate
     and pt2.RecNo >= @TransactionRecNo
   -- ----------------------------------------------------------------------------------------------
   -- Update Linked transaction only if the transaction changed
   -- ----------------------------------------------------------------------------------------------
   Update pt1
     set pt1.Amount               = -1.0 * pt2.Amount_
       , pt1.AmountPerUnit        = pt2.AmountPerUnit_

       , pt1.MaterialCost                 = -1.0 * pt2.MaterialCost_
       , pt1.LaborCost                    = -1.0 * pt2.LaborCost_
       , pt1.OverheadFixedCost            = -1.0 * pt2.OverheadFixedCost_
       , pt1.OverheadVariableCost         = -1.0 * pt2.OverheadVariableCost_
       
       , pt1.MaterialStandardCost         = -1.0 * pt2.MaterialStandardCost_
       , pt1.LaborStandardCost            = -1.0 * pt2.LaborStandardCost_
       , pt1.OverheadFixedStandardCost    = -1.0 * pt2.OverheadFixedStandardCost_
       , pt1.OverheadVariableStandardCost = -1.0 * pt2.OverheadVariableStandardCost_
       
       , pt1.PhaseMaterialStandardCost         = -1.0 * pt2.PhaseMaterialStandardCost_ 
       , pt1.PhaseLaborStandardCost            = -1.0 * pt2.PhaseLaborStandardCost_
       , pt1.PhaseOverheadFixedStandardCost    = -1.0 * pt2.PhaseOverheadFixedStandardCost_
       , pt1.PhaseOverheadVariableStandardCost = -1.0 * pt2.PhaseOverheadVariableStandardCost_
       
       , pt1.PhaseMaterialStandardCostVariance         = -1.0 * pt2.PhaseMaterialStandardCostVariance_  
       , pt1.PhaseLaborStandardCostVariance            = -1.0 * pt2.PhaseLaborStandardCostVariance_
       , pt1.PhaseOverheadFixedStandardCostVariance    = -1.0 * pt2.PhaseOverheadFixedStandardCostVariance_
       , pt1.PhaseOverheadVariableStandardCostVariance = -1.0 * pt2.PhaseOverheadVariableStandardCostVariance_
    
  From dxProductTransaction pt1
  inner join @PT pt2 on ( pt1.PK_dxProductTransaction = pt2.LinkedProductTransaction)
  where
      -- Check if record change
       ( abs( pt2.Amount                - pt2.Amount_               ) > @Tolerance
      or abs( pt2.AmountPerUnit         - pt2.AmountPerUnit_        ) > @Tolerance
      or abs( pt2.MaterialCost          - pt2.MaterialCost_         ) > @Tolerance
      or abs( pt2.LaborCost             - pt2.LaborCost_            ) > @Tolerance
      or abs( pt2.MaterialStandardCost  - pt2.MaterialStandardCost_ ) > @Tolerance
      or abs( pt2.LaborStandardCost     - pt2.LaborStandardCost_    ) > @Tolerance
      or abs( pt2.InStockQuantity       - pt2.InStockQuantiy_       ) > @Tolerance
      or abs( pt2.AverageAmountPerUnit  - pt2.AverageAmountPerUnit_ ) > @Tolerance
      or abs( pt2.TotalAmount           - pt2.TotalAmount_          ) > @Tolerance
      
      or abs( pt2.PhaseMaterialStandardCost         - pt2.PhaseMaterialStandardCost_         )> @Tolerance
      or abs( pt2.PhaseLaborStandardCost            - pt2.PhaseLaborStandardCost_            )> @Tolerance
      
      or abs( pt2.PhaseLaborStandardCostVariance    - pt2.PhaseLaborStandardCostVariance_    )> @Tolerance
      or abs( pt2.PhaseMaterialStandardCostVariance - pt2.PhaseMaterialStandardCostVariance_ )> @Tolerance
       )
      and pt2.TransactionDate >= @TransactionDate
      and pt2.RecNo >= @TransactionRecNo
      and not pt2.KindOfDocument in ( 25,26 ) -- Do not update inventory correction
  -- ----------------------------------------------------------------------------------------------
  -- Recalculate Linked Transaction
  -- Recursive part of that procedure cascade to each linked transaction
  -- ----------------------------------------------------------------------------------------------
  Set @RecNo = 1
  While @RecNo <= @EOF
  begin
     -- Get Linked Transaction PK
     Select @LinkedTransaction = LinkedProductTransaction
          , @RecordDate = TransactionDate
     from @PT where RecNo = @RecNo
     -- Avoid infinit recursion
     -- if CHARINDEX(convert(varchar,@LinkedTransaction), @Path) = 0 
       if (@RecNo >= @TransactionRecNo) and (@RecordDate >= @TransactionDate) and ( @LinkedTransaction > 0 )
       begin
          set @Path = @Path +' '+convert(varchar,@LinkedTransaction)
          Exec dbo.pdxRecalculateInventory @LinkedTransaction, '2000-01-01', -1,-1,-1,'0', @Path
       end
     set @RecNo = @RecNo + 1
  end
end
GO
