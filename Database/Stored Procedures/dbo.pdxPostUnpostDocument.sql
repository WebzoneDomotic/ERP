SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-06-25
-- Description: Post Document
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxPostUnpostDocument] @Document varchar(100), @PrimaryKeyValue int ,@Posted int
as
Begin
   Declare @SQL varchar(1000)

   if ( @Document = 'dxCashReceiptInvoice')  or ( @Document = 'dxCashReceiptImputation')
     Set @SQL =  'Update ' + @Document +' set Posted = '+ CONVERT(varchar,@Posted)+' where FK_dxCashReceipt = '+ Convert(varchar,@PrimaryKeyValue)
   else
   if ( @Document = 'dxPaymentInvoice')  or ( @Document = 'dxPaymentImputation')
     Set @SQL =  'Update ' + @Document +' set Posted = '+ CONVERT(varchar,@Posted)+' where FK_dxPayment = '+ Convert(varchar,@PrimaryKeyValue)
   else
     Set @SQL =  'Update ' + @Document +' set Posted = '+ CONVERT(varchar,@Posted)+' where PK_'+@Document+' = '+ Convert(varchar,@PrimaryKeyValue)
   -- Execute SQL Commande
   Exec( @SQL )
end
GO
