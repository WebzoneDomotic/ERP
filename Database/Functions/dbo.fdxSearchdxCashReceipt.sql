SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-09
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fdxSearchdxCashReceipt] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxCashReceipt as PK from dxCashReceipt
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  Reference              like '%'+@Expression+'%'
        or  Description            like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
     Union
    Select  PK_dxCashReceipt as PK from dxCashReceipt
     Where  FK_dxClient in  (Select PK from [dbo].[fdxSearchdxClient](@Expression ))
          )
GO
