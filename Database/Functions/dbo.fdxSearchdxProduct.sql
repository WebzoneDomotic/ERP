SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxProduct] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select PK_dxProduct as PK from dxProduct
    Where
             ID                     like '%'+@Expression+'%'
          or OtherID                like '%'+@Expression+'%'
          or Description            like '%'+@Expression+'%'
          or EnglishDescription     like '%'+@Expression+'%'
          or SpanishDescription     like '%'+@Expression+'%'
          or FK_dxProductCategory  in ( Select PK_dxProductCategory from dxProductCategory   where ID like '%'+@Expression+'%' or Description like '%'+@Expression+'%')
          or FK_dxScaleUnit        in ( Select PK_dxScaleUnit   from dxScaleUnit   where ID like '%'+@Expression+'%' or Symbol like '%'+@Expression+'%')
         )
GO
