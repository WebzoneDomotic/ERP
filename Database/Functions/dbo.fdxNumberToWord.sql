SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-01-21
-- Description:	Number to word .
-- --------------------------------------------------------------------------------------------

create function [dbo].[fdxNumberToWord] (@n bigint, @FK_dxLanguage int = 1 )
--Returns the number as words.
returns VARCHAR(255)
as
BEGIN
  return Case when @FK_dxLanguage = 1 then [dbo].[fdxNumberToWordFR]( @n ) else [dbo].[fdxNumberToWordEN]( @n ) end
END
GO
