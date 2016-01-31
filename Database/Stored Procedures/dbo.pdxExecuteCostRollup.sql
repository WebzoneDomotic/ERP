SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-26
-- Description:	Execute Cost Rollup
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxExecuteCostRollup]  @TransactionDate Datetime
AS
SET NOCOUNT ON
BEGIN TRY
    
   Declare @CurrentDate Datetime

   BEGIN TRANSACTION    -- Start the transaction

   Set @CurrentDate =dbo.fdxGetDateNoTime(GetDate())
   set @TransactionDate = Coalesce(@TransactionDate, @CurrentDate )
   -- Récupérer la date minimum des périodes ouverte
   Set @TransactionDate = ( Select top 1 DateAdd(dd,1,EndDate) from dxPeriod where AccountingIsClosed = 1 order by PK_dxPeriod desc )

   -- Genere CostRollup transaction
   
   While @TransactionDate <= @CurrentDate 
   begin
     Print @TransactionDate
     Exec [dbo].[pdxInventoryCostRollupCorrection] @TransactionDate
     Set @TransactionDate = DateAdd( dd, 1, @TransactionDate )
   end

   Exec [dbo].[pdxProductTransactionCostRollup]
   -- Validate Account Entry
   Exec [dbo].[pdxValidateEntry]
   Exec [dbo].[pdxUpdateAccountPeriod]
   -- If we reach here, success!
   COMMIT
END TRY
BEGIN CATCH
  -- Whoops, there was an error
  IF @@TRANCOUNT > 0 ROLLBACK
  -- Raise an error with the details of the exception
  DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
  SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
  RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
