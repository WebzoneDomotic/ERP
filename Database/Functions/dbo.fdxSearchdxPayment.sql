SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-09
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fdxSearchdxPayment] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxPayment as PK from dxPayment
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  Reference              like '%'+@Expression+'%'
        or  ChequeNumber           like '%'+@Expression+'%'
        or  PaidTo                 like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
     Union
    Select  PK_dxPayment as PK from dxPayment
     Where  FK_dxVendor in  (Select PK from [dbo].[fdxSearchdxVendor](@Expression ))
          )
GO
