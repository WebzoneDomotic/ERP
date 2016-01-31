SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetDateNoTime] ( @ADate Datetime )
--Returns Integer part of current date.
returns datetime
as
BEGIN
  RETURN  Convert( Datetime , Floor(Convert(Float, @ADate )) )
END
GO
