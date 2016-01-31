SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-01-11
-- Description:	Retour un no. de lot selon le document spécifié
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGenerateLotNumber] ( @PK int, @Document varchar(50) , @Option int) 
--Returns a Lot number related to a document.
returns varchar(100)
as
BEGIN
  Declare @R varchar(100)
  set @R = [dbo].[fcxGenerateLotNumber] ( @PK , @Document, @Option ) 
  
  if @R = '' 
  begin
    if Upper( @Document ) = 'DXWORKORDER' 
    begin
      set @R = Convert(varchar(4),DatePart( yy, GetDate()))
      set @R = @R + Right('0'+Convert(varchar(2),DatePart( mm, GetDate())),2)
      set @R = @R + Right('0'+Convert(varchar(2),DatePart( dd, GetDate())),2)
      set @R = @R + 'L'+Right('0'+Convert(varchar(2),DatePart( hh, GetDate())),2)
      set @R = @R + Right('0'+Convert(varchar(2),DatePart( mi, GetDate())),2)
      set @R = @R + Right('0'+Convert(varchar(2),DatePart( ss, GetDate())),2)
    end
  end
  Return @R
END
GO
