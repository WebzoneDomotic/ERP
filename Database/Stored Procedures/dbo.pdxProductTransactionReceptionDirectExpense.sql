SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-01
-- Description:	Insert Accounting Transaction linked with the inventory
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxProductTransactionReceptionDirectExpense] ( @FK_dxReception int )
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
  Declare @Entry int

  Set @KOD = 11

  -- Search for entry linked with this Document
  Select @Entry = PK_dxEntry from dxEntry where KindOfDocument = @KOD  and PrimaryKeyValue = @FK_dxReception
  -- If not found then create it
  if @Entry is Null Insert into dxEntry ( KindOfDocument,  PrimaryKeyValue ) values( @KOD  , @FK_dxReception )
  -- Search again
  Select @Entry = PK_dxEntry from dxEntry where KindOfDocument =@KOD  and PrimaryKeyValue = @FK_dxReception

  ------------------------------------------------------------------------------------
  -- Transitory Account according to original document
  insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, KEY_dxReceptionDetail )
  Select
        @Entry, re.TransactionDate, 76,pe.PK_dxPeriod
       ,cu.FK_dxAccount__PayableAccrual
       ,left('ACC-ACR '+rd.description,100)
       -- ,dbo.fdxDT( 0.0 )
       -- ,dbo.fdxCT( -1.0* pd.Amount * rd.Quantity /pd.ProductQuantity   )
       ,dbo.fdxCT( pd.Amount * rd.Quantity /pd.ProductQuantity  )
       ,dbo.fdxDT( pd.Amount * rd.Quantity /pd.ProductQuantity  )
       ,ac.FK_dxCurrency,0,@KOD, rd.PK_dxReceptionDetail, rd.PK_dxReceptionDetail
  From dbo.dxReceptionDetail rd
  left join dxReception           re on ( re.PK_dxReception = rd.FK_dxReception )
  left join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = rd.FK_dxPurchaseOrderDetail )
  left join dxPurchaseOrder       po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
  left join dxPeriod    pe on ( re.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxWarehouse wa on ( wa.PK_dxWarehouse  = rd.FK_dxWarehouse)
  left join dxLocation  lo on ( lo.PK_dxLocation   = rd.FK_dxLocation)
  left join dxProduct   pr on ( pr.PK_dxProduct    = rd.FK_dxProduct  )
  left outer join dxCurrency     cu on ( cu.PK_dxCurrency = po.FK_dxCurrency )
  left outer join dxAccount      ac on ( cu.FK_dxAccount__PayableAccrual = ac.PK_dxAccount )
  Where
        re.PK_dxReception = @FK_dxReception
    and (( rd.FK_dxProduct is null)  or (pr.InventoryItem = 0))
    and abs( pd.Amount ) > 0.0000001
    and abs(pd.ProductQuantity) > 0.0000001

  insert into dbo.dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, KEY_dxReceptionDetail )
  Select
        @Entry, re.TransactionDate, 76,pe.PK_dxPeriod
       ,pd.FK_dxAccount__Expense
       ,left('DIR-EXP '+rd.description,100)
       --,dbo.fdxDT( pd.Amount * rd.Quantity /pd.ProductQuantity   )
       --,dbo.fdxCT( 0.0 )
       ,dbo.fdxDT( pd.Amount * rd.Quantity /pd.ProductQuantity )
       ,dbo.fdxCT( pd.Amount * rd.Quantity /pd.ProductQuantity )
       ,ac.FK_dxCurrency,0,@KOD, rd.PK_dxReceptionDetail, null
  From dbo.dxReceptionDetail rd
  left join dxReception           re on ( re.PK_dxReception = rd.FK_dxReception )
  left join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = rd.FK_dxPurchaseOrderDetail )
  left join dxPurchaseOrder       po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
  left join dxPeriod    pe on ( re.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxWarehouse wa on ( wa.PK_dxWarehouse  = rd.FK_dxWarehouse)
  left join dxLocation  lo on ( lo.PK_dxLocation   = rd.FK_dxLocation)
  left join dxProduct   pr on ( pr.PK_dxProduct    = rd.FK_dxProduct  )
  left outer join dxCurrency     cu on ( cu.PK_dxCurrency = po.FK_dxCurrency )
  left outer join dxAccount      ac on ( cu.FK_dxAccount__PayableAccrual = ac.PK_dxAccount )
  Where
        re.PK_dxReception = @FK_dxReception
    and (( rd.FK_dxProduct is null)  or (pr.InventoryItem = 0))
    and abs( pd.Amount ) > 0.0000001
    and abs(pd.ProductQuantity) > 0.0000001

  -- Update GL
  Exec [dbo].[pdxValidateEntry]
  Exec [dbo].[pdxUpdateAccountPeriod]

END
GO
