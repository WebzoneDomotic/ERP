SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-22
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxWorkOrder] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxWorkOrder as PK from dxWorkOrder
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  Lot                    like '%'+@Expression+'%'
        or  LotNumberList          like '%'+@Expression+'%'
        or  Convert (varchar, WorkOrderDate, 126)   like '%'+@Expression+'%'
        or  Convert ( varchar(1000), Instructions ) like '%'+@Expression+'%'
     Union
    Select  PK_dxWorkOrder as PK from dxWorkOrder
     Where  FK_dxProduct in (Select PK from [dbo].[fdxSearchdxProduct](@Expression ))
          )
GO
