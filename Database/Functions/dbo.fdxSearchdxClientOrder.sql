SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxClientOrder] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxClientOrder as PK from dxClientOrder
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  PONumber               like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
     union
    Select  PK_dxClientOrder as PK from dxClientOrder
     Where  FK_dxClient in  (Select PK from [dbo].[fdxSearchdxClient](@Expression ))
          )
GO
