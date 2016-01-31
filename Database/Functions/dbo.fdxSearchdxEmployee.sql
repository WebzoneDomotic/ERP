SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxEmployee] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (Select PK_dxEmployee as PK from dxEmployee
    Where
          ID           like '%'+@Expression+'%'
          or FirstName like '%'+@Expression+'%'
          or LastName  like '%'+@Expression+'%'
          or convert(varchar, birthday, 126) like '%'+@Expression+'%'
          or PK_dxEmployee in (Select FK_dxEmployee from dxAddress where PK_dxAddress in (Select * from [dbo].[fdxSearchdxAddress](@Expression ))
          )
         )
GO
