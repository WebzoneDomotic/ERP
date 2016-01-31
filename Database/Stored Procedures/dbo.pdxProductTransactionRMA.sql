SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-05
-- Description:	Insert Accounting Transaction linked with the inventory
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxProductTransactionRMA]
AS
BEGIN
  SET NOCOUNT ON

  Declare @FK_dxCurrency__System int
  Select
      @FK_dxCurrency__System = FK_dxCurrency__System
  from dxAccountConfiguration

  Declare @KOD int -- Kind Of Document
  Set @KOD = 20

  BEGIN
      ------------------------------------------------------------------------------------
      EXECUTE [dbo].[pdxPrepareInventoryAccountingEntry] @KindOfDocument = @KOD
      ------------------------------------------------------------------------------------

      -- ----------------------------------------------------------------------------------
      -- Material Standard Cost - Inventory
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
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
      left outer join dxProductCategory pc on ( pc.PK_dxProductCategory = pr.FK_dxProductCategory )
      Where abs(ei.MaterialStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
      -- Material Standard Cost - Cost Of Sales
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,pc.FK_dxAccount__CostOfSalesMaterial
           ,left('MAT-COS '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.MaterialStandardCost )
           ,dbo.fdxDT( ei.MaterialStandardCost )
           ,@FK_dxCurrency__System,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxProductCategory pc on ( pc.PK_dxProductCategory = pr.FK_dxProductCategory )
      Where abs(ei.MaterialStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
      -- ----------------------------------------------------------------------------------
      -- Labor Standard Cost - Inventory
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
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
      left outer join dxProductCategory pc on ( pc.PK_dxProductCategory = pr.FK_dxProductCategory )
      Where abs(ei.LaborStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
      -- Labor Standard Cost - Cost Of Sales
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,pc.FK_dxAccount__CostOfSalesLabor
           ,left('LAB-COS '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
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
      left outer join dxProductCategory pc on ( pc.PK_dxProductCategory = pr.FK_dxProductCategory )
      Where abs(ei.LaborStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD

      -- ----------------------------------------------------------------------------------
      -- Overhead Fixed Standard Cost - Inventory

      -- ----------------------------------------------------------------------------------
      -- Overhead Variable Standard Cost - Inventory

      -- -------------------------------------------------------------------------------------------------------------------
      -- Material Standard Cost - Transitory Account
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,KEY_dxRMADetail )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,cu.FK_dxAccount__ReceivableAccrual
           ,left('ACC-ACR '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( pd.Amount * sd.ReturnedQuantity / pd.Quantity )
           ,dbo.fdxDT( pd.Amount * sd.ReturnedQuantity / pd.Quantity )
           ,po.FK_dxCurrency,0,ei.KindOfDocument,ei.PK_dxProductTransaction, ei.FK_dxRMADetail
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxRMADetail         sd on ( sd.PK_dxRMADetail    = ei.FK_dxRMADetail )
      left outer join dxClientOrderDetail pd on ( pd.PK_dxClientOrderDetail = sd.FK_dxClientOrderDetail )
      left outer join dxClientOrder       po on ( po.PK_dxClientOrder = pd.FK_dxClientOrder )
      left outer join dxCurrency          cu on ( cu.PK_dxCurrency = po.FK_dxCurrency )
      Where abs(pd.Amount * sd.ReturnedQuantity / pd.Quantity ) > 0.0000001
        and ei.KindOfDocument = @KOD

      -- Material Standard Cost - Sales Account
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry
           ,ei.TransactionDate, 76, pe.PK_dxPeriod
           -- ---------------------------
           -- Get Account Revenue - Sales
           ,[dbo].[fdxGetAccountRevenue] (
                po.FK_dxCurrency
              , null      --FK_dxTax int
              , null      --FK_dxProjectCategory
              , pd.FK_dxProject
              , cl.FK_dxClientCategory
              , po.FK_dxClient
              , cl.FK_dxPriceLevel
              , pr.FK_dxProductCategory
              , ei.FK_dxProduct )
           -- ---------------------------
           ,left('ACC-SAI '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxDT( pd.Amount * sd.ReturnedQuantity / pd.Quantity )
           ,dbo.fdxCT( pd.Amount * sd.ReturnedQuantity / pd.Quantity )
           ,po.FK_dxCurrency,0,ei.KindOfDocument,ei.PK_dxProductTransaction
      From dbo.dxProductTransactionToUpdate pu
      left outer join dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction)
      left outer join dxEntry     en on ( en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue )
      left outer join dxPeriod    pe on ( ei.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxWarehouse wa on ( wa.PK_dxWarehouse  = ei.FK_dxWarehouse)
      left outer join dxLocation  lo on ( lo.PK_dxLocation   = ei.FK_dxLocation)
      left outer join dxProduct   pr on ( pr.PK_dxProduct    = ei.FK_dxProduct  )
      left outer join dxCurrency  cu on ( cu.PK_dxCurrency   = @FK_dxCurrency__System )
      left outer join dxRMADetail         sd on ( sd.PK_dxRMADetail         = ei.FK_dxRMADetail )
      left outer join dxClientOrderDetail pd on ( pd.PK_dxClientOrderDetail = sd.FK_dxClientOrderDetail )
      left outer join dxClientOrder       po on ( po.PK_dxClientOrder       = pd.FK_dxClientOrder )
      left outer join dxClient            cl on ( cl.PK_dxClient            = po.FK_dxClient )
      Where abs(pd.Amount * sd.ReturnedQuantity / pd.Quantity) > 0.0000001
        and ei.KindOfDocument = @KOD

      ------------------------------------------------------------------------------------
      -- Delete newly modified Transactions Reference
      delete from dxProductTransactionToUpdate where KindOfDocument = @KOD
  END
END
GO
