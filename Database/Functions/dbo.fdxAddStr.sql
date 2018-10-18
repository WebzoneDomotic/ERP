SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ---------------------------------------- Create All Function ---------------------------------------------


-- --------------------------------------------------------------------------------------------
-- Add a string to and other with separator - 2018-03-27
--
create function [dbo].[fdxAddStr] ( @s1 varchar(max) , @d varchar(10), @s2 varchar(max) )
returns varchar(max)
as
begin
  if @s1 = null set @s1 = ''
  if @s2 = null set @s2 = ''
  if @s1 = '' set @s1 = @s2 else if @s2 <> '' set @s1 = @s1 +@d +' ' + @s2 ;
  Return @s1
end
GO
