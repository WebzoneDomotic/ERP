SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-12-10
-- Description:	Retour Les champs lookup list des les clés étrangères
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGetFKLookupField] ( @TableName  varchar(100)  )
--Returns Display Value.
returns varchar(500)
as
BEGIN
  Declare @R varchar(500)
  set @R = ''
  Return @R  
END
GO
