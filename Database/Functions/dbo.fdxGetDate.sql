SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetDate] () 
--Returns Integer part of current date.
returns datetime
as
BEGIN
  RETURN  Convert( Datetime , Floor(Convert(Float, GetDate())) )
END
GO
