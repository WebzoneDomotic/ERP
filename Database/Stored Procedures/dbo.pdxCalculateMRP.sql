SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-10-30
-- Description:	Calculate MRP for a level on each product
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxCalculateMRP] @Level int, @NumberOfPeriod int  as
begin
  Declare @P int,@MINP int, @FK_dxProduct int,@RelasePeriod int, @SafetyStock Float, @PeriodDate Datetime
  Declare @LeadTime float, @PlannedOrderReleases float

  Declare @Loop Table
         (
            RecNo int IDENTITY(1,1)
           ,FK_dxProduct int
           ,SafetyStock float
        )

  Declare @RecNo int, @EOF int
  Set @RecNo = 1
  Insert into @Loop
  SELECT FK_dxProduct, Coalesce(pr.SafetyStock,0.0) from dxMRPLevel mr
                              left outer join dxProduct pr on (PK_dxProduct = mr.FK_dxProduct )
                             where mr.Level = @Level
  Set @EOF  = ( Select Count(*) from @Loop)
  set @MINP = ( Select MIN(Period) from dxMRP )

  While @RecNo <= @EOF
  Begin
     Select @FK_dxProduct =FK_dxProduct , @SafetyStock=SafetyStock from @Loop where RecNo = @RecNo

     -- For level = 1 start calculating from period 1 but for the other level we have to look in the past
     -- for calculation
     Set @P = case when @Level = 1 then 1 else @MINP + 1 end

     While @P <= @NumberOfPeriod
     begin

         -- -------------NetRequirement----------------------------------
         Update dxMRP set dxMRP.NetRequirements =
                  (case when GrossRequirements < CorrectedForecast then CorrectedForecast else GrossRequirements end)
                - Coalesce(( select ProjectedOnHand from dxMRP where FK_dxProduct = @FK_dxProduct and Period = @P-1),0.0)
                - dxMRP.ScheduledReceipts
          where dxMRP.Period = @P and FK_dxProduct = @FK_dxProduct

         -- -------------PlannedOrderReceipts----------------------------------
         Update dxMRP set PlannedOrderReceipts =  Case when NetRequirements +  SafetyStock > 0.0 then
                                                    dbo.fdxNetQtyWithLotSizing (@FK_dxProduct, NetRequirements + SafetyStock)
                                                  else 0.0 end
          where dxMRP.Period = @P and FK_dxProduct = @FK_dxProduct

         -- -------------ProjectedOnHand----------------------------------
         Update dxMRP set
                  ProjectedOnHand =
                  Coalesce(( select ProjectedOnHand from dxMRP where FK_dxProduct = @FK_dxProduct and Period = @P-1),0.0)
                 +ScheduledReceipts + PlannedOrderReceipts
                 -(case when GrossRequirements < CorrectedForecast then CorrectedForecast else GrossRequirements end)
         where Period = @P and FK_dxProduct = @FK_dxProduct

         -- Calculate Release Period according to Lead time----------------------------------
         -- Sunday is the first Day of week
         -- Get Period Date
         set @PeriodDate = ( Select PeriodDate from dxMRP where Period = @P and FK_dxProduct =  @FK_dxProduct)

         SET DATEFIRST 7
         Set @LeadTime = ( select dbo.fdxGetNewLeadtime (@PeriodDate, Coalesce(LeadTimeInDays,0.0))
                             From dxProduct
                            where PK_dxProduct = @FK_dxProduct)
         Set @RelasePeriod = @P - @LeadTime
         Set @PlannedOrderReleases =  ( Select PlannedOrderReceipts from dxMRP mr
                                          where mr.Period = @P
                                            and mr.FK_dxProduct =  @FK_dxProduct )

         -- Update Planned release quantity ( bug fixe )
         Update dxMRP set PlannedOrderReleases = PlannedOrderReleases + @PlannedOrderReleases ,
            Note = Coalesce(Note,'') + Coalesce(( Select Note from dxMRP mr
                                          where mr.Period = @P
                                            and mr.FK_dxProduct =  @FK_dxProduct ),'')
            where Period = @RelasePeriod and FK_dxProduct = @FK_dxProduct

         -- Update planned orderRelases Quantity on next level ( set GrossRequirements )
         Execute pdxUpdateNextLevelGrossRequirements
                            @FK_dxProduct__Parent = @FK_dxProduct
                          , @Period               = @RelasePeriod
                          , @GrossRequirements    = @PlannedOrderReleases

         -- Goto net period and calculate next period
	     set @P = @P+1
     end
     set @RecNo = @RecNo + 1
  END

end
GO
