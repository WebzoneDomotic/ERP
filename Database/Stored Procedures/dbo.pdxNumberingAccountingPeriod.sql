SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxNumberingAccountingPeriod] ( @Year int )
as

  Declare  @AccountingYear int
         , @StartingPeriod int
         , @EndingPeriod int
         , @Period int, @NO int
         , @PriorYearEndingPeriod int
         , @PriorLastClosedPeriod int
         , @LastOpenPeriod  int

  Declare CR_NumYear cursor FAST_FORWARD for 
  Select PK_dxAccountingYear, Coalesce( EndingPeriod, PK_dxAccountingYear *100 + 12) 
    From dxAccountingYear 
    where PK_dxAccountingYear in ( select Distinct FK_dxAccountingYear from dxPeriod where FK_dxAccountingYear >= @Year )
    order by PK_dxAccountingYear desc

  -- Get current last closed period 
  set @PriorLastClosedPeriod = ( Select top 1 PK_dxPeriod from dxPeriod where AccountingIsClosed = 1 order by PK_dxPeriod desc )

  OPEN CR_NumYear
     FETCH NEXT FROM CR_NumYear INTO  @AccountingYear, @EndingPeriod 
     WHILE @@FETCH_STATUS = 0
     BEGIN
        -- Retrive Prior Ending Period
        set @PriorYearEndingPeriod = Coalesce((Select Coalesce( EndingPeriod, PK_dxAccountingYear *100 + 12) 
        From dxAccountingYear where PK_dxAccountingYear = @AccountingYear-1 and
                                     PK_dxAccountingYear in ( select Distinct FK_dxAccountingYear from dxPeriod ) ), -1)  

        -- Retive Starting Period
        if @PriorYearEndingPeriod = -1 
            set @StartingPeriod = ( select Min(PK_dxPeriod) from dxPeriod )
        else
           set @StartingPeriod = ( Select top 1 PK_dxPeriod from dxPeriod 
                                    where PK_dxPeriod > @PriorYearEndingPeriod order by PK_dxPeriod asc)
          
        -- Update Period with Accounting period value
        Set @Period = @EndingPeriod
        set @NO = ( select Count(*) From dxPeriod where PK_dxPeriod between @StartingPeriod and  @EndingPeriod )
        while (@Period >= @StartingPeriod) and (@No > 0) 
        begin
           -- Update Accounting Period Value and reopen Period in order to recalculate End of year Transactions
           update dxPeriod set AccountingPeriod = @AccountingYear * 100 + @No  where PK_dxPeriod = @Period 
           update dxPeriod set AccountingIsClosed = 0 where AccountingIsClosed = 1 and PK_dxPeriod >= @Period 
           set @Period = ( select top 1 PK_dxPeriod from dxPeriod where PK_dxPeriod < @Period order by PK_dxPeriod desc )
           set @No =@No - 1
        end
        -- Process next year  n, n-1, n-2 ....
        FETCH NEXT FROM CR_NumYear INTO @AccountingYear, @EndingPeriod 
     END
  CLOSE CR_NumYear 
  DEALLOCATE CR_NumYear
 
  update dxPeriod set ID  = Coalesce( AccountingPeriod, PK_dxPeriod )  
  -- Get current last closed period 
  set @LastOpenPeriod = ( Select top 1 PK_dxPeriod from dxPeriod where AccountingIsClosed = 0 order by PK_dxPeriod asc )

  -- Restore prior state for each period 
  -- Update Period - Close period until prior closed period  
  Set @Period = @LastOpenPeriod
  while (@Period <=  @PriorLastClosedPeriod  ) and (@No < 100) 
  begin
     -- Update Accounting Period  state
     update dxPeriod set AccountingIsClosed = 1 where PK_dxPeriod = @Period 
     set @Period = ( select top 1 PK_dxPeriod from dxPeriod where PK_dxPeriod > @Period order by PK_dxPeriod asc )
     set @No =@No + 1
  end
GO
