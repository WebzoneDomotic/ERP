SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-03-02
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxDeclaration] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxDeclaration as PK from dxDeclaration
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  FK_dxWorkOrder in (Select * from [dbo].[fdxSearchdxWorkOrder](@Expression ))
           )
GO
