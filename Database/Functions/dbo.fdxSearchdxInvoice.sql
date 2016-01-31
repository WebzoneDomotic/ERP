SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxInvoice] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxInvoice as PK from dxInvoice
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  ListOfOrder            like '%'+@Expression+'%'
        or  ListOfShipping         like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
        or  Convert ( varchar(1000), Note ) like '%'+@Expression+'%'
     Union
    Select  PK_dxInvoice as PK from dxInvoice
     Where  FK_dxClient in  (Select PK from [dbo].[fdxSearchdxClient](@Expression ))
          )
GO
