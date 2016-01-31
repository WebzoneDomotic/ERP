SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 27 novembre 2011
-- Description:	Création des dépôts directement à partir des encaissements
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxCreateDeposit] @PK_dxCashReceipt int
as
Begin
  Declare
         -- @PK_dxCashReceipt int
          @FK_dxBankAccount int
        , @FK_dxPaymentType int
        , @FK_dxCashReceipt int
        , @Reference varchar(100)
        , @TransactionDate Datetime
        , @FK_dxDeposit int

  Select
     @FK_dxBankAccount = FK_dxBankAccount
    ,@TransactionDate  = TransactionDate
    ,@FK_dxPaymentType = (Case when pt.DirectDeposit = 0 then Null else cr.FK_dxPaymentType end)
    ,@FK_dxCashReceipt = (Case when pt.GroupedDeposit = 0 and pt.DirectDeposit = 1 then cr.PK_dxCashReceipt else Null end)
    ,@Reference = pt.Description
    From dbo.dxCashReceipt cr
    left outer join dxPaymentType pt on (pt.PK_dxPaymentType = cr.FK_dxPaymentType )
    Where cr.PK_dxCashReceipt = @PK_dxCashReceipt
      and cr.Posted = 1


  Insert into dxDeposit (FK_dxBankAccount, TransactionDate, FK_dxPaymentType, FK_dxCashReceipt, Reference, Posted)
  Select
     @FK_dxBankAccount
    ,@TransactionDate
    ,@FK_dxPaymentType
    ,@FK_dxCashReceipt
    ,@Reference
    ,0
    where not exists ( Select PK_dxDeposit from dxDeposit de
                        where de.FK_dxBankAccount = @FK_dxBankAccount
                          and de.TransactionDate  = @TransactionDate
                          and Coalesce(de.FK_dxPaymentType,-1) = Coalesce(@FK_dxPaymentType,-1)
                          and Coalesce(de.FK_dxCashReceipt,-1) = Coalesce(@FK_dxCashReceipt,-1)
                          and de.Posted = 0 )

  -- Get the active Deposit for this bank
  Select @FK_dxDeposit = PK_dxDeposit from dxDeposit de
                        where de.FK_dxBankAccount = @FK_dxBankAccount
                          and de.TransactionDate  = @TransactionDate
                          and Coalesce(de.FK_dxPaymentType,-1) = Coalesce(@FK_dxPaymentType,-1)
                          and Coalesce(de.FK_dxCashReceipt,-1) = Coalesce(@FK_dxCashReceipt,-1)
                          and de.Posted = 0

  -- Delete detail for this deposit
  Delete from dxDepositDetail where FK_dxCashReceipt = @PK_dxCashReceipt and FK_dxDeposit = @FK_dxDeposit

  Insert into dxDepositDetail (FK_dxDeposit,FK_dxCashReceipt,Reference,TotalAmount)
  Select
     @FK_dxDeposit
    ,PK_dxCashReceipt
    ,cr.Reference
    ,cr.TotalAmount
    From dbo.dxCashReceipt cr
    left outer join dxPaymentType pt on (pt.PK_dxPaymentType = cr.FK_dxPaymentType )
    where PK_dxCashReceipt = @PK_dxCashReceipt

 end
GO
