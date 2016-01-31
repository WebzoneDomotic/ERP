SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxClient] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (Select PK_dxClient as PK from dxClient
    Where
             ID                     like '%'+@Expression+'%'
          or Name                   like '%'+@Expression+'%'
          or Reference              like '%'+@Expression+'%'
          or ClientReferenceNumber  like '%'+@Expression+'%'
          or PK_dxClient in (Select * from [dbo].[fdxSearchdxAddressClient](@Expression ))
          )
GO
