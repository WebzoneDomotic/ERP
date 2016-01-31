SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-09-20
-- Description:	Update projected Stock
-- --------------------------------------------------------------------------------------------
CREATE procedure [dbo].[pdxUpdateProjectedStock]
as
Begin

  Set NoCount On

  Declare @CurrentDate Datetime
        , @EndOfMonthDate Datetime
        , @BeginningOfNextMonthDate DateTime
        , @BeginningOfNextNextMonthDate DateTime
  Declare @newseed int ;

  Set @CurrentDate                  = dbo.fdxGetDateNoTime ( GetDate())
  Set @EndOfMonthDate               = dbo.fdxGetEndOfMonthDate ( @CurrentDate )
  Set @BeginningOfNextMonthDate     = Dateadd( dd, 1, @EndOfMonthDate)
  Set @BeginningOfNextNextMonthDate = Dateadd( mm, 1, @BeginningOfNextMonthDate)

  Execute  [dbo].[pcxUpdateProjectedStock]

  if not Exists ( Select 1 from dxProjectedStock )
  begin

    set @newseed = ( select coalesce(max(PK_dxProjectedStock),0) from dxProjectedStock ) ;
    DBCC CHECKIDENT ( 'dxProjectedStock' , RESEED, @newseed  );

    Insert INTO [dbo].[dxProjectedStock]
             ([Document]
             ,[FK_dxProduct]
             ,[PeriodDate]
             ,[GrossRequirements]
             ,[Forecast]
             ,[CumulativeGrossRequirements]
             ,[ScheduledReceipts]
             ,[PlannedExpedition]
             ,[Stock]
             ,[ProjectedStock]
             ,[Level])


     -- Scheduled Receipt PO
     select
          'OA '+convert(varchar(10),po.ID)
         ,pr.PK_dxProduct
         ,pd.ExpectedReceptionDate
         ,0.0                             as GrossRequirement
         ,0.0
         ,0.0
         ,pd.Quantity-pd.ReceivedQuantity as ScheduledReceipt
         ,0.0 PlannedShipment
         , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
         ,0.0
         ,0
      from dxPurchaseOrderDetail pd WITH(NOLOCK)
      left join dxPurchaseOrder  po WITH(NOLOCK) on po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder
      left join dxProduct        pr WITH(NOLOCK) on (pr.PK_dxProduct  = pd.FK_dxProduct )
      where po.Posted = 1
        and po.BlanketOrder = 0
        and pd.Closed = 0
        and (pd.Quantity-pd.ReceivedQuantity) > 0
        and not pd.FK_dxProduct is null

     Union all

     -- Scheduled Receipt WO
     select
           'OF '+convert(varchar(10),wo.ID)
         , pr.PK_dxProduct
         , wo.WorkOrderDate
         , 0.0                             as GrossRequirement
         , 0.0
         , 0.0
         , wo.QuantityToProduce-wo.ProducedQuantity as ScheduledReceipt
         , 0.0 PlannedShipment
         , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
         , 0.0
         , 0
      from dxWorkOrder     wo WITH(NOLOCK)
      left join dxProduct  pr WITH(NOLOCK) on (pr.PK_dxProduct  = wo.FK_dxProduct )
      where (wo.QuantityToProduce-wo.ProducedQuantity) > 0
        and wo.WorkOrderStatus between 0 and 3

     Union all

     -- Gross Requirement From WO
     Select
          'OF '+convert(varchar(10),wo.ID) as Document
         ,pr.PK_dxProduct
         ,wo.WorkOrderDate
         ,Round((QuantityToProduce-ProducedQuantity) * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,4)  as GrossRequirement
         , 0.0
         , 0.0
         , 0.0 ScheduledReceipt
         , 0.0 PlannedShipment
         , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
         , 0.0
         , 0
      from dxWorkOrder           wo WITH(NOLOCK)
      left join dxAssembly       aa WITH(NOLOCK) on ( aa.FK_dxProduct = wo.FK_dxProduct )
      left join dxAssemblyDetail ad WITH(NOLOCK) on (aa.PK_dxAssembly = ad.FK_dxAssembly)
      left join dxProduct  pr WITH(NOLOCK) on (pr.PK_dxProduct  = ad.FK_dxProduct )
      where aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  wo.FK_dxProduct , wo.WorkOrderDate )
        and ad.NetQuantity > 0.0
        and wo.WorkOrderStatus between 0 and 3
        and (wo.QuantityToProduce - wo.ProducedQuantity) > 0

     Union all

     -- Planned Shipment
     Select
          'BC '+convert(varchar(10),co.ID)
         ,pr.PK_dxProduct
         ,co.ExpectedDeliveryDate
         ,0.0 as GrossRequirement
         ,0.0
         ,0.0
         ,0.0 as ScheduledReceipt
        , cd.ProductQuantity - cd.ShippedQuantity PlannedShipment
        , Coalesce(Round(( Select sum( Quantity ) from dxProductTransaction where FK_dxProduct = pr.PK_dxProduct and TransactionDate <= GetDate() ),4),0) Stock
        , 0.0
        , 0
       from dxClientOrderDetail cd WITH(NOLOCK)
       left join dxClientOrder  co WITH(NOLOCK) on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
       left join dxProduct      pr WITH(NOLOCK) on (pr.PK_dxProduct  = cd.FK_dxProduct )
       where  co.Posted = 1
         and  cd.closed = 0
         and (cd.ProductQuantity - cd.ShippedQuantity) > 0.0
         and not cd.FK_dxProduct is null

   
     --Execute [dbo].[pdxCreateForecastByMonth]
     Execute [dbo].[pdxCreateForecastByWeek]

     -- Delete item with no forecast
     Delete from dxProjectedStock where Forecast <= 0.000000001 and Level = 1
     
     -- 2nd Pass for Assembly
     -- Gross Requirement From Forecast Sub Level 2 to 5
     Execute [dbo].[pdxCreateSubLevelRequirements] 2
     Execute [dbo].[pdxCreateSubLevelRequirements] 3
     Execute [dbo].[pdxCreateSubLevelRequirements] 4
     Execute [dbo].[pdxCreateSubLevelRequirements] 5
          
     Execute [dbo].[pdxGroupForecast]  
     
     Update  dxProjectedStock set ForeCast = Round(Forecast,4)
    
     -- Initialize Row Index
     Declare @RecNo Table ( RecNo int, PK int )
     Insert into @RecNo
     Select ROW_NUMBER() OVER(ORDER BY s.FK_dxProduct asc, s.PeriodDate asc, s.PK_dxProjectedStock asc )
            , PK_dxProjectedStock
       from dxProjectedStock s

     Update ps
         set ps.RecNo = pr.RecNo
     From dxProjectedStock ps
     inner join @RecNo pr on (pr.PK  = ps.PK_dxProjectedStock )
     
     
     
     -- Update Cumulative GrossRequirements and Forecast
     Update ps set
        CumulativeGrossRequirements = Round(
                                   Coalesce(( Select sum(GrossRequirements) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate
                                           ),0.0) , 4)
       ,CumulativeForecast          = Round(
                                   Coalesce(( Select sum(Forecast) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate
                                           ),0.0) , 4)
     from  dxProjectedStock ps
     

     -- Update Projected Stock
     Update ps set
       ProjectedStock = Round( Stock
                    - Coalesce(( Select sum(GrossRequirements) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    -- ne pas considérer les reception programmée antérieur à la date courante pour les OA seulement - Nous permet d'investiguer
                    + Coalesce(( Select sum(ScheduledReceipts) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate between Case when left(Document,2) = 'OF' then Dateadd(dd,-300,GETDATE()) else GETDATE() end and ps.PeriodDate ),0.0)
                    - Coalesce(( Select sum(PlannedExpedition) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    , 4)
       
      ,ProjectedStockNoForecast = Round( Stock
                    - Coalesce(( Select sum(GrossRequirements) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    -- ne pas considérer les reception programmée antérieur à la date courante pour les OA seulement - Nous permet d'investiguer
                    + Coalesce(( Select sum(ScheduledReceipts) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate between Case when left(Document,2) = 'OF' then Dateadd(dd,-300,GETDATE()) else GETDATE() end and ps.PeriodDate ),0.0)
                    - Coalesce(( Select sum(PlannedExpedition) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    , 4)     
      ,ProjectedStockWithAllPO = Round( Stock
                    - Coalesce(( Select sum(GrossRequirements) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    + Coalesce(( Select sum(ScheduledReceipts) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    - Coalesce(( Select sum(PlannedExpedition) from dxProjectedStock p where p.RecNo <= ps.RecNo and p.FK_dxProduct = ps.FK_dxProduct and p.PeriodDate <= ps.PeriodDate ),0.0)
                    , 4)     
     from  dxProjectedStock ps
     
     -- Correction sur l'évolution des stock selon le quota des prévision vs le réel
     Update ps set ProjectedStock = Round( ProjectedStock - (CumulativeForecast- CumulativeGrossRequirements), 4)
                 , ProjectedStockWithAllPO = Round( ProjectedStockWithAllPO - (CumulativeForecast- CumulativeGrossRequirements), 4)
     from  dxProjectedStock ps
     where (CumulativeForecast- CumulativeGrossRequirements) > 0.0

     -- Créer les propositions d'achat ou de fabrication
     Delete dbo.dxProjectedStock where abs(ProposedQuantity) > 0.0;

     WITH cte AS
     ( SELECT  RecNo, FK_dxProduct , PeriodDate ,  ProjectedStock , ROW_NUMBER() OVER(PARTITION BY FK_dxProduct ORDER BY PeriodDate asc) AS RowNumber
       FROM    dxProjectedStock   Where ProjectedStock - dbo.fdxGetProductSafetyStock(FK_dxProduct,PeriodDate ) < 0.0 )

     Insert into dbo.dxProjectedStock (RecNo, Document, FK_dxProduct , PeriodDate ,  ProposedQuantity )
     SELECT
       RecNo
     , 'Qté proposée/Proposed Quantity'
     , FK_dxProduct
     , case when Dateadd( dd, -1 * pr.LeadTimeInDays, PeriodDate) < dbo.fdxGetDateNotime (GetDate()) then dbo.fdxGetDateNotime (GetDate()) else  Dateadd( dd, -1 * pr.LeadTimeInDays, PeriodDate) end
     , [dbo].[fdxNetQtyWithLotSizing] (FK_dxProduct ,abs(ProjectedStock))
     FROM cte
     Left join dxProduct pr on ( pr.PK_dxProduct = FK_dxProduct )
     WHERE RowNumber = 1
     Order by 1

  end
end
GO
