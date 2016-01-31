SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-08-31
-- Description:	Insert Accounting Transaction linked with the inventory
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxProductTransactionCorrection]
AS
BEGIN
  Declare @FK_dxCurrency__System int
  Select
      @FK_dxCurrency__System = FK_dxCurrency__System
  from dxAccountConfiguration

  -- Pour la correction d'inventaire on enregistre la valeur du coût standard seulement (crédit)
  -- et la contre partie dans le compte d'imputation spécifié par l'usager ( débit)
  Declare @KOD int -- Kind Of Document
  Set @KOD = 25

  BEGIN
      ------------------------------------------------------------------------------------
       Insert into dxEntry ( KindOfDocument,  PrimaryKeyValue )
       select Distinct ei.KindOfDocument , ei.PrimaryKeyValue from dxProductTransactionToUpdate pu
        left outer join  dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction and pu.KindOfDocument = @KOD )
        where ( not exists ( select 1 from dxEntry en where en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue))
          and pu.KindOfDocument = @KOD
      ------------------------------------------------------------------------------------

      -- Credit Material Standard Cost
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
       
      -- Debit Imputation part  
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,ei.Fk_dxAccount__CorrectionMaterial
           ,left('MAT-STD '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
           ,dbo.fdxCT( ei.MaterialStandardCost )
           ,dbo.fdxDT( ei.MaterialStandardCost )
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
        
      ------------------------------------------------------------------------------------
      -- Credit Labor Standard Cost
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
      -- Debit imputation
      insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
      Select
            en.PK_dxEntry ,ei.TransactionDate, 76, pe.PK_dxPeriod
           ,ei.FK_dxAccount__CorrectionLabor
           ,left('LAB-STD '+wa.ID +', '+lo.ID +', '+pr.ID +', Lot:'+ei.Lot +', '+ei.description,100)
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
      Where abs(ei.LaborStandardCost) > 0.0000001
        and ei.KindOfDocument = @KOD
        
      ------------------------------------------------------------------------------------
      -- Delete newly modified Transactions Reference
      delete from dxProductTransactionToUpdate where KindOfDocument = @KOD
  END
END
GO
