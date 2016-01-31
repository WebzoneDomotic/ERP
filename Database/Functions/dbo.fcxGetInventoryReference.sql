SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-12-03
-- Description:	Retourne une référence concernant la transaction sur un inventaire
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGetInventoryReference] ( @FK_dxProductTransaction int, @PrimaryKeyValue int, @KindOfDocument int )
--Returns Inventory Reference Value.
returns varchar(100)
as
BEGIN
  Declare @R varchar(100)
  set @R = ''
  Return @R  
END
GO
