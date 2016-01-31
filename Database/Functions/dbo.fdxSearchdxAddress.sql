SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxAddress] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (Select PK_dxAddress as PK from dxAddress
    Where
          cast(ID as varchar)           like '%'+@Expression+'%'
          or cast(FirstName as varchar) like '%'+@Expression+'%'
          or cast(LastName as varchar)  like '%'+@Expression+'%' 
          or cast(Address1 as varchar)  like '%'+@Expression+'%' 
          or cast(Address2 as varchar)  like '%'+@Expression+'%' 
          or cast(ZipCode as varchar)   like '%'+@Expression+'%'
          or cast(Phone as varchar)     like '%'+@Expression+'%'
          or cast(Fax as varchar)       like '%'+@Expression+'%' 
          or cast(Email as varchar)     like '%'+@Expression+'%' 
          or FK_dxCity    in ( Select PK_dxCity    from dxCity    where Name like '%'+@Expression+'%' )
          or FK_dxState   in ( Select PK_dxState   from dxState   where Name like '%'+@Expression+'%' )
          or FK_dxCountry in ( Select PK_dxCountry from dxCountry where Name like '%'+@Expression+'%' ) 
         )
GO
