SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxCostLevel] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxCostLevel as PK from dxCostLevel
     Where  cast(ID as varchar) like '%'+@Expression+'%'
        or  Description         like '%'+@Expression+'%'
          )
GO
