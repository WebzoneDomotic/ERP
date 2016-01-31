SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-09-19
-- Description:	Insert Accounting Transaction linked with the inventory
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxProductTransactionAdjustment]
AS
BEGIN
  SET NOCOUNT ON

  Declare @FK_dxCurrency__System int
        , @FK_dxAccount__LaborAbsorbed int
        , @FK_dxAccount__OverheadFixedAbsorbed int
        , @FK_dxAccount__OverheadVariableAbsorbed int
  Select
      @FK_dxCurrency__System = FK_dxCurrency__System
     ,@FK_dxAccount__LaborAbsorbed = FK_dxAccount__LaborAbsorbed
     ,@FK_dxAccount__OverheadFixedAbsorbed = FK_dxAccount__OverheadFixedAbsorbed
     ,@FK_dxAccount__OverheadVariableAbsorbed = FK_dxAccount__OverheadVariableAbsorbed
  from dxAccountConfiguration

  Declare @KOD int -- Kind Of Document
  Set @KOD = 9

  BEGIN
      ------------------------------------------------------------------------------------
      EXECUTE [dbo].[pdxPrepareInventoryAccountingEntry] @KindOfDocument = @KOD
      ------------------------------------------------------------------------------------
      -- Material Standard Cost of the transaction
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,wa.FK_dxAccount__Material
           ,left('MAT-STD '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( ei.MaterialStandardCost )
           ,dbo.fdxCT( ei.MaterialStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs(ei.MaterialStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
        and ei.DoNotGenerateGLEntry = 0
      -- Material Variance
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,pc.FK_dxAccount__MaterialCostVariance
           ,left('MAT-VAR '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( ei.Amount -ei.MaterialStandardCost )
           ,dbo.fdxCT( ei.Amount -ei.MaterialStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxProductCategory  pc on ( pc.PK_dxProductCategory  = pr.FK_dxProductCategory  )
      Where abs( ei.Amount -ei.MaterialStandardCost) > 0.0000001
      and ei.KindOfDocument = @KOD
      and ei.DoNotGenerateGLEntry = 0
      ------------------------------------------------------------------------------------
      -- Labor Standard Cost of the transaction
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,wa.FK_dxAccount__Labor
           ,left('LAB-STD '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( ei.LaborStandardCost )
           ,dbo.fdxCT( ei.LaborStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs(ei.LaborStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
        and ei.DoNotGenerateGLEntry = 0
      -- Labor Abosorbtion at Standard Cost of the transaction
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,@FK_dxAccount__LaborAbsorbed
           ,left('LAB-ABS '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.LaborStandardCost )
           ,dbo.fdxDT( ei.LaborStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxProductCategory  pc on ( pc.PK_dxProductCategory  = pr.FK_dxProductCategory  )
      Where abs( ei.LaborStandardCost ) > 0.0000001
      and ei.KindOfDocument = @KOD
      and ei.DoNotGenerateGLEntry = 0
      ------------------------------------------------------------------------------------
      -- Overhead Fixed Standard Cost of the transaction
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,wa.FK_dxAccount__OverheadFixed
           ,left('OHF-STD '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( ei.OverheadFixedStandardCost )
           ,dbo.fdxCT( ei.OverheadFixedStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs(ei.OverheadFixedStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
        and ei.DoNotGenerateGLEntry = 0
      -- Overhead Fixed Standard Cost Absorbtion
      insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,@FK_dxAccount__OverheadFixedAbsorbed
           ,left('OHF-ABS '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.OverheadFixedStandardCost )
           ,dbo.fdxDT( ei.OverheadFixedStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs( OverheadFixedStandardCost ) > 0.0000001
      and ei.KindOfDocument = @KOD
      and ei.DoNotGenerateGLEntry = 0
      ------------------------------------------------------------------------------------
      -- Overhead Variable Standard Cost of the transaction
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,wa.FK_dxAccount__OverheadFixed
           ,left('OHV-STD '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( ei.OverheadVariableStandardCost )
           ,dbo.fdxCT( ei.OverheadVariableStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs(ei.OverheadVariableStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
        and ei.DoNotGenerateGLEntry = 0
      -- Overhead Variable Standard Cost Absorbtion
      insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,@FK_dxAccount__OverheadVariableAbsorbed
           ,left('OHV-ABS '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.OverheadVariableStandardCost )
           ,dbo.fdxDT( ei.OverheadVariableStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs( OverheadVariableStandardCost ) > 0.0000001
      and ei.KindOfDocument = @KOD
      and ei.DoNotGenerateGLEntry = 0
      ------------------------------------------------------------------------------------
      -- Adjustment Account - Real cost amount of the transaction
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry, ei.TransactionDate, 76,pe.PK_dxPeriod
           ,dt.FK_dxAccount__InventoryAdjustment
           ,left('INV-ADJ '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.Amount )
           ,dbo.fdxDT( ei.Amount )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxInventoryAdjustment     ad on (ad.PK_dxInventoryAdjustment = ei.PrimaryKeyValue )
      left outer join dxInventoryAdjustmentType dt on (dt.PK_dxInventoryAdjustmentType = ad.FK_dxInventoryAdjustmentType )
      Where abs(ei.Amount ) > 0.0000001
        and ei.KindOfDocument = @KOD
        and ei.DoNotGenerateGLEntry = 0
      ------------------------------------------------------------------------------------
      -- Delete newly modified Transactions Reference
      delete from dxProductTransactionToUpdate where KindOfDocument = @KOD
  END
END
GO
