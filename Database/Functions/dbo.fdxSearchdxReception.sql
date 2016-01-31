SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxReception] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxReception as PK from dxReception
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  ListOfPO               like '%'+@Expression+'%'
        or  Description            like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
        or  Convert ( varchar(1000), Note ) like '%'+@Expression+'%'
     Union
    Select  FK_dxReception as PK from dxReceptionDetail
     Where  FK_dxProduct in (Select PK from [dbo].[fdxSearchdxProduct](@Expression ))
        or  Lot  like '%'+@Expression+'%'
        or  Description like '%'+@Expression+'%'
     Union
    Select  PK_dxReception as PK from dxReception
     Where  FK_dxVendor in  (Select PK from [dbo].[fdxSearchdxVendor](@Expression ))
          )
GO
