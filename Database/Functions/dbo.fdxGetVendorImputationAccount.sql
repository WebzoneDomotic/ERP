SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-03
-- Description:	Retour le compte d'imputation fournisseur la matrice de sélection
-- --------------------------------------------------------------------------------------------

Create function [dbo].[fdxGetVendorImputationAccount] ( @KindOfDocument int , @PK_Document int )
returns int
as
begin
 -- @KindOfDocument 1 = PurchaseOrderDetail
 -- @KindOfDocument 2 = PayableOrderDetail
 Declare @FK_dxAccount int

 Set @FK_dxAccount = dbo.fcxGetVendorImputationAccount ( @KindOfDocument , @PK_Document )
 -- ---------------------------------------------------------------------------------------
 -- For the Purchase Order
 if @FK_dxAccount is null
   If @KindOfDocument = 1
   begin
     -- Check account imputation with out passing by the inventory
     set @FK_dxAccount =
      (Select Top 1 ae.FK_dxAccount__Expense
      from dxAccountExpense ae
      left join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = @PK_Document )
      left join dxPurchaseOrder       po on ( po.PK_dxPurchaseOrder       = pd.FK_dxPurchaseOrder )
      left join dxProduct             pr on ( pr.PK_dxProduct = pd.FK_dxProduct )
      left join dxVendor              ve on ( ve.PK_dxVendor = po.FK_dxVendor )
      where (ae.FK_dxCurrency        = po.FK_dxCurrency)
        and (ae.FK_dxVendorCategory  = ve.FK_dxVendorCategory or ae.FK_dxVendorCategory is null)
        and (ae.FK_dxVendor          = po.FK_dxVendor or ae.FK_dxVendor is null)
        and (ae.FK_dxCostLevel       = ve.FK_dxCostLevel or ae.FK_dxCostLevel is null)
        and (ae.FK_dxProductCategory = pr.FK_dxProductCategory or ae.FK_dxProductCategory is null)
        and (ae.FK_dxProduct         = pd.FK_dxProduct or ae.FK_dxProduct is null)
      order by ae.FK_dxCurrency        desc
              ,ae.FK_dxVendorCategory  desc
              ,ae.FK_dxVendor          desc
              ,ae.FK_dxCostLevel       desc
              ,ae.FK_dxProductCategory desc
              ,ae.FK_dxProduct         desc
       ) -- Select Expense

      -- Check account imputation for inventory
      if @FK_dxAccount is null
      set @FK_dxAccount =
         ( Select
            case when pr.InventoryItem = 1 then
            ( select wa.FK_dxAccount__Material From dxWarehouse wa
             where wa.PK_dxWarehouse = Coalesce(pr.FK_dxWarehouse__Reception, pr.FK_dxWarehouse) )
            else Null end
           From dxPurchaseOrderDetail pd
           left join dxPurchaseOrder  po on ( po.PK_dxPurchaseOrder       = pd.FK_dxPurchaseOrder )
           left join dxProduct        pr on ( pr.PK_dxProduct = pd.FK_dxProduct )
           where ( pd.PK_dxPurchaseOrderDetail = @PK_Document ) )
    end -- Purchase Order
    -- ---------------------------------------------------------------------------------------
    -- For the Payable invoice
    else If @KindOfDocument = 2
    begin
     -- Check account imputation with out passing by the inventory
     set @FK_dxAccount =
      (Select Top 1 ae.FK_dxAccount__Expense
      from dxAccountExpense ae
      left join dxPayableInvoiceDetail pd on ( pd.PK_dxPayableInvoiceDetail = @PK_Document )
      left join dxPayableInvoice       po on ( po.PK_dxPayableInvoice       = pd.FK_dxPayableInvoice )
      left join dxProduct              pr on ( pr.PK_dxProduct = pd.FK_dxProduct )
      left join dxVendor               ve on ( ve.PK_dxVendor = po.FK_dxVendor )
      where (ae.FK_dxCurrency        = po.FK_dxCurrency)
        and (ae.FK_dxVendorCategory  = ve.FK_dxVendorCategory or ae.FK_dxVendorCategory is null)
        and (ae.FK_dxVendor          = po.FK_dxVendor or ae.FK_dxVendor is null)
        and (ae.FK_dxCostLevel       = ve.FK_dxCostLevel or ae.FK_dxCostLevel is null)
        and (ae.FK_dxProductCategory = pr.FK_dxProductCategory or ae.FK_dxProductCategory is null)
        and (ae.FK_dxProduct         = pd.FK_dxProduct or ae.FK_dxProduct is null)
      order by ae.FK_dxCurrency        desc
              ,ae.FK_dxVendorCategory  desc
              ,ae.FK_dxVendor          desc
              ,ae.FK_dxCostLevel       desc
              ,ae.FK_dxProductCategory desc
              ,ae.FK_dxProduct         desc
       ) -- Select Expense

      -- Check account imputation for inventory
      if @FK_dxAccount is null
      set @FK_dxAccount =
         ( Select
            case when pr.InventoryItem = 1 then
            ( select wa.FK_dxAccount__Material From dxWarehouse wa
             where wa.PK_dxWarehouse = Coalesce(pr.FK_dxWarehouse__Reception, pr.FK_dxWarehouse) )
            else Null end
           From dxPayableInvoiceDetail pd
           left join dxPayableInvoice  po on ( po.PK_dxPayableInvoice       = pd.FK_dxPayableInvoice )
           left join dxProduct        pr on ( pr.PK_dxProduct = pd.FK_dxProduct )
           where ( pd.PK_dxPayableInvoiceDetail = @PK_Document )
             and not pd.FK_dxReceptionDetail is null )
    end -- Payable Invoice

  Return @FK_dxAccount
End
GO
