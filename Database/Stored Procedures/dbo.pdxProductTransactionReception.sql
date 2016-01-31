SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-09-19
-- Description:	Insert Accounting Transaction linked with the inventory
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxProductTransactionReception]
AS
BEGIN
  SET NOCOUNT ON

  Declare @FK_dxCurrency__System int
         ,@FK_dxAccount__LaborAbsorbed int
         ,@FK_dxAccount__OverheadFixedAbsorbed int
         ,@FK_dxAccount__OverheadVariableAbsorbed int
  Select
      @FK_dxCurrency__System = FK_dxCurrency__System
     ,@FK_dxAccount__LaborAbsorbed = FK_dxAccount__LaborAbsorbed
     ,@FK_dxAccount__OverheadFixedAbsorbed = FK_dxAccount__OverheadFixedAbsorbed
     ,@FK_dxAccount__OverheadVariableAbsorbed = FK_dxAccount__OverheadVariableAbsorbed
  from dxAccountConfiguration

  Declare @KOD int -- Kind Of Document
  Set @KOD = 11

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
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs(ei.MaterialStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
      -- Price Purchase Variance
      insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,pc.FK_dxAccount__MaterialCostVariance
           ,left('MAT-VAR '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( ei.Amount-ei.MaterialStandardCost )
           ,dbo.fdxCT( ei.Amount-ei.MaterialStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxProductCategory  pc on ( pc.PK_dxProductCategory  = pr.FK_dxProductCategory  )
      Where abs( ei.Amount -ei.MaterialStandardCost) > 0.0000001
      and ei.KindOfDocument = @KOD

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
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs(ei.LaborStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
      -- Labor Absorbtion
      insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,@FK_dxAccount__LaborAbsorbed
           ,left('LAB-ABS '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.LaborStandardCost )
           ,dbo.fdxDT( ei.LaborStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      Where abs( LaborStandardCost ) > 0.0000001
      and ei.KindOfDocument = @KOD

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

       ------------------------------------------------------------------------------------
      -- Transitory Account according to original document
      -- Pour le compte transitoire avec les achats, la transaction se fait selon la devise du document.
      -- On en registre la difference dans le compte du taux de change en accord avec ce compte.
      -- Le montant est le montant converti au taux du jour
      insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, KEY_dxReceptionDetail )
      Select
            en.PK_dxEntry, ei.TransactionDate, 76,pe.PK_dxPeriod
           ,cu.FK_dxAccount__PayableAccrual
           ,left('ACC-ACR '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( round(ei.Amount / rd.CurrencyRate,2))
           ,dbo.fdxDT( round(ei.Amount / rd.CurrencyRate,2))
           ,ac.FK_dxCurrency,0,ei.KindOfDocument,ei.PK_dxProductTransaction, ei.FK_dxReceptionDetail
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxReceptionDetail     rd on ( rd.PK_dxReceptionDetail = ei.FK_dxReceptionDetail )
      left outer join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = rd.FK_dxPurchaseOrderDetail )
      left outer join dxPurchaseOrder       po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
      left outer join dxCurrency            cu on ( cu.PK_dxCurrency = po.FK_dxCurrency )
      left outer join dxAccount             ac on ( cu.FK_dxAccount__PayableAccrual = ac.PK_dxAccount )
      Where abs( round(ei.Amount / rd.CurrencyRate,2) ) > 0.0000001
        and ei.KindOfDocument = @KOD

      insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry, ei.TransactionDate, 76,pe.PK_dxPeriod
           ,( select FK_dxAccount__ForeignExchangeReference from dxAccount where PK_dxAccount = cu.FK_dxAccount__PayableAccrual)
           ,left('ACC-FRX '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.Amount - round(ei.Amount / rd.CurrencyRate,2))
           ,dbo.fdxDT( ei.Amount - round(ei.Amount / rd.CurrencyRate,2))
           ,ac.FK_dxCurrency,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxReceptionDetail     rd on ( rd.PK_dxReceptionDetail = ei.FK_dxReceptionDetail )
      left outer join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = rd.FK_dxPurchaseOrderDetail )
      left outer join dxPurchaseOrder       po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
      left outer join dxCurrency            cu on ( cu.PK_dxCurrency = po.FK_dxCurrency )
      left outer join dxAccount             ac on ( cu.FK_dxAccount__PayableAccrual = ac.PK_dxAccount )
      Where abs( ei.Amount - round(ei.Amount / rd.CurrencyRate,2) ) > 0.0000001
        and ei.KindOfDocument = @KOD

      -- Variation taux de change
      --insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      --Select
      --      en.PK_dxEntry, ei.TransactionDate, 76,pe.PK_dxPeriod
      --     ,( select FK_dxAccount__ForeignExchangeReference from dxAccount where PK_dxAccount = cu.FK_dxAccount__PayableAccrual)
      --     ,left('FRX-ACR '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
      --     ,dbo.fdxCT( ei.Amount - (ei.Amount-ei.MaterialStandardCost) )
      --     ,dbo.fdxDT( ei.Amount - (ei.Amount-ei.MaterialStandardCost) )
      --     ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      --From dbo.dxProductTransactionToUpdate pu
      --left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      --left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      --left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      --left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      --left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      --left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      --left outer join dxReceptionDetail     rd on ( rd.PK_dxReceptionDetail = ei.FK_dxReceptionDetail )
      --left outer join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = rd.FK_dxPurchaseOrderDetail )
      --left outer join dxPurchaseOrder       po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
      --left outer join dxCurrency            cu on ( cu.PK_dxCurrency = po.FK_dxCurrency )
      --Where abs( ei.Amount - (ei.Amount-ei.MaterialStandardCost) ) > 0.00001
      --  and ei.KindOfDocument = @KOD

      ------------------------------------------------------------------------------------
      -- Delete newly modified Transactions Reference
      delete from dxProductTransactionToUpdate where KindOfDocument = @KOD
  END
END
GO
