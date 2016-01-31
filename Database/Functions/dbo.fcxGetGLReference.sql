SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-05-19
-- Description:	Retourne une reference concernant la transaction au GL
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGetGLReference] ( @FK_dxAccountTransaction int, @PrimaryKeyValue int, @KindOfDocument int )
--Returns Reference Value.
returns varchar(500)
as
BEGIN
  Declare @R varchar(500)
  set @R =   ''
  Return @R
END
GO
