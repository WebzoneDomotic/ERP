SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxClientOrderDetail] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
            Select FK_dxClientOrder as PK from dxClientOrderDetail
             Where Lot                    like '%'+@Expression+'%'
                or Description            like '%'+@Expression+'%'
            )
GO
