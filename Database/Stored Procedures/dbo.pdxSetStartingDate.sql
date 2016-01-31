SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxSetStartingDate]  
  @PK_dxBankReconciliation int = -1

AS
 Declare @StartingDate Datetime;
 Set @StartingDate = Coalesce((  Select top 1 EndDate + 1.0 from dxBankReconciliation where Posted = 1 and FK_dxBankAccount in
                     ( select FK_dxBankAccount From dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation )
                       order by EndDate desc),  ( select top 1 StartDate From dxPeriod where AccountingIsClosed = 0 order by StartDate asc)) ;
 BEGIN TRANSACTION
    if @StartingDate > 0.0 Update dxBankReconciliation set StartDate = @StartingDate where PK_dxBankReconciliation = @PK_dxBankReconciliation ;
 COMMIT
GO
