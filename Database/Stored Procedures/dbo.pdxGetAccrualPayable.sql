SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 23 juillet 2012
-- Description:	Liste des comptes à payer transitoire
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxGetAccrualPayable] @ADate Datetime
as
begin
  Set @ADate = Coalesce( @ADate, GetDate())

  -- Get all journal entry grouped by currency
  Select
       at.FK_dxCurrency
     , CONVERT(bit, 1) GLAdjustment
     , Null            FK_dxVendor
     , Null            FK_dxReception
     , Null            FK_dxReceptionDetail
     , Null            PayableInvoiceNumber
     , Null            FK_dxPayableInvoiceDetail
     , Max(at.TransactionDate) TransactionDate
     , Null            FK_dxProduct
     , Max(Coalesce(at.Description,'')) Description
     , Max(0.0) ReceivedQuantity
     , Max(0.0) BilledQuantity
     , -1.0 * Round(Sum(Round(at.Amount,2)),2) Amount
     , Convert( Datetime, Null) as CorrectionDate
     , Convert( int     , Null) as FK_dxAccount__Imputation
     , Convert( varchar(2000) , Null) as Note
     , Max(at.PK_dxAccountTransaction) FK_dxAccountTransaction
     , 0 TypeOfTransaction  -- Journal Entry

  From dxAccountTransaction at
  left join dxCurrency cr on ( cr.PK_dxCurrency = at.FK_dxCurrency)

  where at.FK_dxAccount = cr.FK_dxAccount__PayableAccrual
    and at.TransactionDate <= @ADate
    and at.KindOfDocument in ( 1, 22) -- we include correction transactions
  Group by
        at.FK_dxCurrency
  Having abs(Sum(Round(at.Amount,2))) > 0.000001

  Union all

  -- All transaction attach to a reception
  Select
       at.FK_dxCurrency
     , CONVERT(bit, 0) GLAdjustment
     , Max(Coalesce(re.FK_dxVendor,pa.FK_dxVendor,Null)) FK_dxVendor
     , (Select FK_dxReception from dxReceptionDetail where PK_dxReceptionDetail =Coalesce( at.KEY_dxReceptionDetail, pd.FK_dxReceptionDetail))
     , Coalesce( at.KEY_dxReceptionDetail, pd.FK_dxReceptionDetail) FK_dxReceptionDetail
     , Max(pa.ID)  PayableInvoiceNumber
     , max(at.FK_dxPayableInvoiceDetail) FK_dxPayableInvoiceDetail
     , Max(at.TransactionDate) TransactionDate
     , Max(Coalesce(rd.FK_dxProduct, pd.FK_dxProduct,Null)) FK_dxProduct
     , Max(Coalesce(rd.Description, pd.Description,at.Description)) Description
     , Max(Coalesce( rd.Quantity, 0.0)) ReceivedQuantity
     , Max(Coalesce( pd.Quantity, 0.0)) BilledQuantity
     , -1.0 * Round(Sum(Round(at.Amount,2)),2) Amount
     , Convert( Datetime, Null) as CorrectionDate
     , Convert( int     , Null) as FK_dxAccount__Imputation
     , Convert( varchar(2000) , Null) as Note
     , Max(at.PK_dxAccountTransaction) FK_dxAccountTransaction
     , 1 TypeOfTransaction  -- Reception with payable invoice

  From dxAccountTransaction at
  left join dxCurrency             cr on ( cr.PK_dxCurrency = at.FK_dxCurrency)
  left join dxReceptionDetail      rd on ( at.KEY_dxReceptionDetail     = rd.PK_dxReceptionDetail )
  left join dxPayableInvoiceDetail pd on ( at.FK_dxPayableInvoiceDetail = pd.PK_dxPayableInvoiceDetail )
  left join dxReception            re on ( re.PK_dxReception = rd.FK_dxReception )
  left join dxPayableInvoice       pa on ( pa.PK_dxPayableInvoice = pd.FK_dxPayableInvoice )

  where at.FK_dxAccount = cr.FK_dxAccount__PayableAccrual
    and at.TransactionDate <= @ADate
    and at.KindOfDocument in (5,11,23)  -- we include correction transactions
    and not Coalesce( at.KEY_dxReceptionDetail, pd.FK_dxReceptionDetail) is null
  Group by
        at.FK_dxCurrency
      , Coalesce( at.KEY_dxReceptionDetail, pd.FK_dxReceptionDetail)
  Having abs(Sum(Round(at.Amount,2))) > 0.000001

  Union all

-- All transaction not attach to a reception - payable invoice only
  Select
       at.FK_dxCurrency
     , CONVERT(bit, 0) GLAdjustment
     , Max(Coalesce(pa.FK_dxVendor,Null)) FK_dxVendor
     , Null   FK_dxReception
     , Null   FK_dxReceptionDetail
     , pa.ID  PayableInvoiceNumber
     , at.FK_dxPayableInvoiceDetail
     , Max(at.TransactionDate) TransactionDate
     , Max(Coalesce( pd.FK_dxProduct,Null)) FK_dxProduct
     , Max(Coalesce( pd.Description,at.Description)) Description
     , Max( 0.0 ) ReceivedQuantity
     , Max(Coalesce( pd.Quantity, 0.0)) BilledQuantity
     , -1.0 * Round(Sum(Round(at.Amount,2)),2) Amount
     , Convert( Datetime, Null) as CorrectionDate
     , Convert( int     , Null) as FK_dxAccount__Imputation
     , Convert( varchar(2000) , Null) as Note
     , Max(at.PK_dxAccountTransaction) FK_dxAccountTransaction
     , 2 TypeOfTransaction  -- Payable invoice with no reception

  From dxAccountTransaction at
  left join dxCurrency             cr on ( cr.PK_dxCurrency = at.FK_dxCurrency)
  left join dxPayableInvoiceDetail pd on ( at.FK_dxPayableInvoiceDetail = pd.PK_dxPayableInvoiceDetail )
  left join dxPayableInvoice       pa on ( pa.PK_dxPayableInvoice = pd.FK_dxPayableInvoice )

  where at.FK_dxAccount = cr.FK_dxAccount__PayableAccrual
    and at.TransactionDate <= @ADate
    and at.KindOfDocument in (5,23)  -- we include correction transactions
    and at.KEY_dxReceptionDetail is null
    and pd.FK_dxReceptionDetail is null
  Group by
        at.FK_dxCurrency
      , pa.ID
      , at.FK_dxPayableInvoiceDetail
      , Coalesce( at.KEY_dxReceptionDetail, pd.FK_dxReceptionDetail)
  Having abs(Sum(Round(at.Amount,2))) > 0.000001

  Order by 1,6 asc
end
GO
