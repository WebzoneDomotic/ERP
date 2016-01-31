SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-24
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxSearchdxVendor] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (Select PK_dxVendor as PK from dxVendor
    Where
             ID                     like '%'+@Expression+'%'
          or Name                   like '%'+@Expression+'%'
          or Reference              like '%'+@Expression+'%'
          or VendorReferenceNumber  like '%'+@Expression+'%'
          or PK_dxVendor in (Select * from [dbo].[fdxSearchdxAddressVendor](@Expression ))
           )
GO
