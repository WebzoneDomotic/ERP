SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxPayableInvoice] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxPayableInvoice as PK from dxPayableInvoice
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
        or  Convert ( varchar(1000), Note ) like '%'+@Expression+'%'
        or  ListOfReception like '%'+@Expression+'%'
     Union
    Select  PK_dxPayableInvoice as PK from dxPayableInvoice
     Where  FK_dxVendor in  (Select PK from [dbo].[fdxSearchdxVendor](@Expression ))
          )
GO
