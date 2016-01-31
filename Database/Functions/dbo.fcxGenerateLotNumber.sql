SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-01-11
-- Description:	Retour un no. de lot selon le document spécifié - function custom client
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGenerateLotNumber] ( @PK int, @Document varchar(50) , @Option int) 
--Returns a Lot number related to a document.
returns varchar(100)
as
BEGIN
  Declare @R varchar(100)
  set @R = ''
  Return @R  
END
GO
