SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[fdxRemoveTag] ( @Expression varchar(8000) )
returns varchar(8000)
as
begin
  declare @ix1 int;
  declare @ix2 int;
  declare @r varchar(8000) 
  set @ix1 = CHARINDEX('>',@Expression)
  set @ix2 = CHARINDEX('<',@Expression, @ix1 )
  set @r = SUBSTRING ( @Expression ,@ix1+1, @ix2-@ix1-1)
  Return @r 
end
GO
