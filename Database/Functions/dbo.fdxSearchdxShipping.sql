SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxShipping] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxShipping as PK from dxShipping
     Where  cast(ID as varchar)                like '%'+@Expression+'%'
        or  cast(FK_dxClientOrder as varchar)  like '%'+@Expression+'%'
        or  ListOfOrder                        like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
        or  Convert ( varchar(1000), Note ) like '%'+@Expression+'%'
     Union
    Select  PK_dxShipping as PK from dxShipping
     Where  FK_dxClient in  (Select PK from [dbo].[fdxSearchdxClient](@Expression ))
     Union
    Select  FK_dxShipping as PK from dxTrackingNumberShipping
     where  TrackingNumber like '%'+@Expression+'%'
          )
GO
