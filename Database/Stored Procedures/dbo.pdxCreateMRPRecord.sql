SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-10-30
-- Description:	Création de fiche MRP pour chaque produit (tous les niveaux) pour la période d'analyse
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxCreateMRPRecord] @NumberOfPeriod int, @MRPStartDate Datetime  as
begin
  Declare @P int , @LowerBound int , @OldWOBound int
  Declare @PeriodDate Datetime
  Declare @LeadTime Float
  Declare @MinPeriodDate Datetime
  --  -----------------------------------------------------------------
  -- Create MPR Record for each Product for the period interval
  -- Start calculation MRP at period 1
  set @LeadTime = Coalesce(( Select Max(LeadTimeInDays) from dxProduct where PK_dxProduct in ( Select FK_dxProduct from dxMRPLevel)),0)
  -- Add weekend days to lead time ...
  Set @P = dbo.fdxGetNewLeadtime (@MRPStartDate, @Leadtime )+1
  Set @LowerBound = ( Select max(LowerBoundMRPAnalysisInDays) From dxSetup )
  Set @OldWOBound = Coalesce(Abs(Datediff ( dd, ( Select min(WorkOrderDate) From dxWorkOrder
                                      where WorkOrderStatus < 4 and WorkOrderDate < @MRPStartDate ), @MRPStartDate)), 0)

  if @OldWOBound > @LowerBound
     set @OldWOBound = @LowerBound
  if @P < @OldWOBound
    set @P = @OldWOBound
  Set @P = -1 * @P


  While @P <= @NumberOfPeriod
  begin
     Set @PeriodDate = DATEADD(dd, @P-1,  @MRPStartDate)
     Insert into dxMRP ( FK_dxProduct, Period, PeriodDate, LeadTime, ForecastRequirements, FK_dxVendor )
     Select Distinct ml.FK_dxProduct, @P, @PeriodDate,  pr.LeadTimeInDays
                     -- Only get forecast quantity from starting period analysis ...
                     , Case
                         when (@P > 0) and ( datepart(dw,@PeriodDate) in (2,3,4,5,6)) then   -- Get the value  for work day only
                            dbo.fdxGetProductWorkDayForecastQuantity (ml.FK_dxProduct,@PeriodDate )
                         else 0.0
                       end
                     , pr.FK_dxVendor__Default
     from dxMRPLevel ml
     left outer join dxProduct pr on (pr.PK_dxProduct = ml.FK_dxProduct)
     where pr.ExcludeFromMRP = 0
     set @P = @P+1
  end;

  ---------------------- Period < 1 ---------------------------
  --Get Starting value For inventory and Anticipated Receptions (PO or WO )
  set @MinPeriodDate = ( select MIN(PeriodDate) from dxMRP )
  update dxMRP set
    ProjectedOnHand =Coalesce(( select SUM(Quantity) From dxProductTransaction pt
                       left outer join dxWarehouse wa on ( wa.PK_dxWarehouse = pt.FK_dxWarehouse )
                       where wa.Quarantine = 0
                         and pt.FK_dxProduct = dxMRP.FK_dxProduct
                         and pt.TransactionDate <= dxMRP.PeriodDate), 0.0 )

                     + Coalesce(( Select Coalesce(SUM(wo.QuantityToProduce-wo.ProducedQuantity),0.0) from dxWorkOrder wo
                         where wo.FK_dxProduct = dxMRP.FK_dxProduct
                           and wo.WorkOrderStatus < 4
                           and wo.ProducedQuantity < wo.QuantityToProduce
                           and DATEADD(dd, dxMRP.LeadTime, WorkOrderDate) <= dxMRP.PeriodDate),0.0)

                     +Coalesce(( Select Coalesce(SUM(cd.ProductQuantity - cd.ReceivedQuantity),0.0) from dxPurchaseOrderDetail cd
                        left outer join dxPurchaseOrder co on ( co.PK_dxPurchaseOrder = cd.FK_dxPurchaseOrder )
                        where co.Posted = 1
                          and co.BlanketOrder = 0
                          and cd.FK_dxProduct = dxMRP.FK_dxProduct
                          and cd.closed = 0 and (cd.ProductQuantity - cd.ReceivedQuantity) > 0.0
                          and DATEADD(dd, dxMRP.LeadTime,co.TransactionDate) <= dxMRP.PeriodDate),0.0)

  where dxMRP.Period < 1

  -- First Pass initialise
  update dxMRP set  PlannedExpedition     = dbo.fdxGetPlannedExpedition       ( FK_dxProduct, PeriodDate)
                   ,SafetyStock           = dbo.fdxGetProductSafetyStock      ( FK_dxProduct, PeriodDate)
                   ,CumulativeExpedition  = dbo.fdxGetCumulativeExpedition    ( FK_dxProduct, PeriodDate)
                   ,ProductForecast       = dbo.fdxGetProductForecastQuantity ( FK_dxProduct, PeriodDate )
  update dxMRP set CorrectedForecast      = Case when PlannedExpedition > ForecastRequirements then PlannedExpedition else  ForecastRequirements end
   Where Period > 0
  update dxMRP set CumulativeCorrectedForecast     = dbo.fdxGetCumulativeForecast      ( FK_dxProduct, PeriodDate)
   Where Period > 0
  -- Calculate again CorrectedForecast
  update dxMRP set
      CorrectedForecast  =
        Case
          when CumulativeCorrectedForecast > ProductForecast then
          Case
             when (CumulativeCorrectedForecast - ProductForecast) < CorrectedForecast then (CumulativeCorrectedForecast - ProductForecast)
             else  0.0
          end
        else
          CorrectedForecast
        end
 Where Period > 0


  -- ---------------------- For each Period ---------------------------
  -- Initialize ForecastRequirements, GrossRequirements and ScheduledReceipts
  update dxMRP set
                       -- Client Order
  GrossRequirements =  --Coalesce(( Select Coalesce(SUM(cd.ProductQuantity - cd.ShippedQuantity),0.0) from dxClientOrderDetail cd
                       -- left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
                       -- where  co.Posted = 1
                       --   and  cd.FK_dxProduct = dxMRP.FK_dxProduct
                       --   and  cd.closed = 0 and (cd.ProductQuantity - cd.ShippedQuantity) > 0.0
                       --   and  co.ExpectedDeliveryDate = dxMRP.PeriodDate),0.0)
                         PlannedExpedition +
                       -- All Product who need to be Ordered
                       --Work Order
                        Coalesce((Select Coalesce(SUM(((wo.QuantityToProduce - wo.ProducedQuantity) * ad.NetQuantity * ((100.0+PctOfWasteQuantity) / 100.0) + WasteQuantity) ) ,0.0) From dxWorkOrder wo
                        left outer join dxAssembly aa on (aa.FK_dxProduct = wo.FK_dxProduct )
                        left outer join dxAssemblyDetail ad on ( aa.PK_dxAssembly = ad.FK_dxAssembly )
                        where wo.WorkOrderDate = dxMRP.PeriodDate
                          and wo.ProducedQuantity < wo.QuantityToProduce
                          and wo.WorkOrderStatus < 4
                          and ad.FK_dxProduct  = dxMRP.FK_dxProduct
                          and ad.DismantlingPhaseNumber <=0
                          and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , dxMRP.PeriodDate )
                        ),0.0),

  Note              =  '',

                      -- Work order + Purchase order
  ScheduledReceipts = Coalesce(( Select Coalesce(SUM(wo.QuantityToProduce-wo.ProducedQuantity),0.0) from dxWorkOrder wo
                         where wo.FK_dxProduct = dxMRP.FK_dxProduct
                           and wo.WorkOrderStatus < 4
                           and wo.ProducedQuantity < wo.QuantityToProduce
                           and DATEADD(dd, dxMRP.LeadTime, WorkOrderDate) = dxMRP.PeriodDate),0.0)
                      -- Purchase Order
                     +Coalesce(( Select Coalesce(SUM(cd.ProductQuantity - cd.ReceivedQuantity),0.0) from dxPurchaseOrderDetail cd
                        left outer join dxPurchaseOrder co on ( co.PK_dxPurchaseOrder = cd.FK_dxPurchaseOrder )
                        where co.Posted = 1
                          and co.BlanketOrder = 0
                          and cd.FK_dxProduct = dxMRP.FK_dxProduct
                          and cd.closed = 0
                          and (cd.ProductQuantity - cd.ReceivedQuantity) > 0.0
                          and DATEADD(dd, dxMRP.LeadTime,co.TransactionDate) = dxMRP.PeriodDate),0.0)
                      -- Inventory available for each period
                      + Coalesce(( select SUM(Quantity) From dxProductTransaction pt
                        left outer join dxWarehouse wa on ( wa.PK_dxWarehouse = pt.FK_dxWarehouse )
                        left outer join dxLocation  lo on ( lo.PK_dxLocation = pt.FK_dxLocation )
                        where wa.Quarantine      = 0
                          and lo.ReservedArea    = 0
                          and pt.FK_dxProduct    = dxMRP.FK_dxProduct
                          and pt.TransactionDate = dxMRP.PeriodDate), 0.0 )

  -- -------------------------------------------------------------------------------
  -- Reset forecast quantity for period before Gross Requirements Period
  -- reason : we do not apply forecast if we have a real order
  --Update dxMRP set ForecastRequirements = 0 where PeriodDate <=
  --  ( Select MAX(PeriodDate) from dxMRP mr where mr.GrossRequirements > 0.0 and mr.FK_dxProduct = dxMRP.FK_dxProduct)

end;
GO
