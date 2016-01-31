SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-03-11
-- Description:	Retour La valeur à afficher pour les clés étrangere
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGetFKDisplayValue] ( @FK int , @TableName  varchar(100)  )
--Returns Display Value.
returns varchar(500)
as
BEGIN
  Declare @R varchar(500)
  set @R = ''
  Return @R  
END
GO
