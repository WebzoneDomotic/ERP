SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-06-19
-- Description:	Retourne le compte d imputation pour le fournisseur en fonction du document
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGetVendorImputationAccount] ( @KindOfDocument int , @PK_Document int )
--Returns Reference Value.
returns int
as
BEGIN
  Declare @FK_dxAccount int
  set @FK_dxAccount =  Null
  Return @FK_dxAccount
END
GO
