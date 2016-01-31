SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-10-30
-- Description:	Lancement du calcul de la Planification Besoin Matière (PBM - MRP)
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxMRP] @MRPStartDate Datetime, @NumberOfPeriod int as
begin

  Set NOCOUNT ON

  Declare @MRPEndDate Datetime
  Declare @Level int, @MaxLevel int , @Count int
  Set @MRPEndDate = DateAdd(dd, @NumberOfPeriod , @MRPStartDate)
  -- Get Start time
  Update dxSetup set LastMRPStartDate = GetDate()

  if (Select top 1 UseCustomMPRProcedure from dxSetup ) = 1
     Exec dbo.pcxMRP  @MRPStartDate =@MRPStartDate , @NumberOfPeriod = NumberOfPeriod
  else
  begin

      -- Generate all MRP Level
      Delete from dxMRPLevel
      Delete from dxMRP

      -- Set first Level -------------------------------------------------
      insert into dxMRPLevel ( [Level], FK_dxProduct)
      -- All product on Client order
      Select Distinct 1, FK_dxProduct from dxClientOrderDetail cd
      left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
      left outer join dxProduct     pr on ( pr.PK_dxProduct = cd.FK_dxProduct )
      where Not FK_dxProduct is null
        and (((pr.DoNotProduce   = 0) and (pr.ManufacturedItem = 1))
         or  ((pr.DoNotPurchase  = 0) and (pr.PurchasedItem    = 1)))
        and (pr.InventoryItem = 1)
        and (pr.ExcludeFromMRP = 0)
        and (co.MakeToOrder = 0) -- Exclude MTO Client Orders
        and (co.Posted = 1)
        and (cd.Closed = 0)
        and (cd.ProductQuantity - cd.ShippedQuantity) > 0.00000001
        and cd.[FK_dxLocation__Reserved] is null
        and cd.ExpectedDeliveryDate between @MRPStartDate and @MRPEndDate
      union
      -- All Product having a Daily Forcast
      Select Distinct 1, pr.PK_dxProduct from dxProduct pr
      Where Active = 1
        and (((DoNotProduce   = 0) and (ManufacturedItem = 1))
         or  ((DoNotPurchase  = 0) and (PurchasedItem    = 1)))
        and InventoryItem  = 1
        and ExcludeFromMRP = 0
        and ((DailyForecast  > 0)
              or ((( Select COUNT(*) from dbo.dxProductForecastPerMonth where FK_dxProduct = pr.PK_dxProduct and Quantity > 0.0 ) > 0.0)
                     or
                  (( Select COUNT(*) from dbo.dxProductForecastPerWeek  where FK_dxProduct = pr.PK_dxProduct and Quantity > 0.0 ) > 0))
            )
      union
      -- All Product of the first level on Work order for the quantity that is not produced
      -- Do not Include Dismantling Material ie: Dismantling Phase > 0
      Select Distinct 1, ad.FK_dxProduct from dxAssemblyDetail ad
      left outer join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
      left outer join dxProduct  pr on (pr.PK_dxProduct  = ad.FK_dxProduct )
      where aa.FK_dxProduct in ( Select FK_dxProduct from dxWorkOrder
                                  where WorkOrderDate between @MRPStartDate and @MRPEndDate
                                    and ProducedQuantity < QuantityToProduce
                                    and WorkOrderStatus < 4 )  -- 4 = Closed
        and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , @MRPStartDate )
        and ad.DismantlingPhaseNumber <= 0
        and pr.ExcludeFromMRP = 0

      Set @Level = 1
      Set @Count = ( Select COUNT(*) from dxMRPLevel where [Level] = @Level)

      -- Get all other levels -------------------------------------------------
      While @Count > 0
      begin
         -- Insert item for that level
         Insert into dxMRPLevel ( [Level], FK_dxProduct)
         Select Distinct @Level+1, ad.FK_dxProduct from dxAssemblyDetail ad
         left outer join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
         where aa.FK_dxProduct in ( Select FK_dxProduct from  dxMRPLevel where Level = @Level )
           -- Exclude product part of a dismantling phase
           and ad.DismantlingPhaseNumber <= 0
           and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , @MRPStartDate )
         -- Get count value
         Set @Count = ( Select COUNT(*) from dxMRPLevel where [Level] = @Level+1)
         Set @Level = @Level + 1
      end;

      Insert into dxMRPLevel ( [Level], FK_dxProduct, Grouped )
      Select MAX(Level), FK_dxProduct, MAX(1) from dxMRPLevel group by FK_dxProduct
      Delete from dxMRPLevel where Grouped = 0

      Execute pdxCreateMRPRecord @NumberOfPeriod =@NumberOfPeriod, @MRPStartDate = @MRPStartDate
      Set @MaxLevel = ( Select Max([Level]) from dxMRPLevel )
      Set @Level = 1
      -- Iterate on each level and calculate the requirements -------------------
      While @Level <= @MaxLevel
      begin
         Execute dbo.pdxCalculateMRP @Level =@Level, @NumberOfPeriod = @NumberOfPeriod
         Set @Level = @Level + 1
      end;

      -- Set all requirement to 0.0 if negative
      Update dxMRP set NetRequirements = 0.0 where NetRequirements < 0.0000000001

   End
   -- Set the finish date
   Update dxSetup set LastMRPFinishDate = GetDate()
end;
GO
