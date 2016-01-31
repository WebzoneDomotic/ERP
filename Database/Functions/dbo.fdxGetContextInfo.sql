SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetContextInfo] (@QueryInfo varchar(128))
returns varchar(128)
as
begin
declare 
	@startpos int,
	@endpos int,
	@length int,
	@contextinfo varchar(128),
	@result varchar(128);

	select @contextinfo = CAST(CONTEXT_INFO AS varchar(128))FROM master.dbo.SYSPROCESSES WHERE SPID=@@SPID
    
	select @result = ''
	select @length = LEN(@QueryInfo)
	select @endpos = @length+1
	select @startpos = PATINDEX('%' + @QueryInfo + '%', @contextinfo)
	if @startpos > 0
	begin
		select @result = SUBSTRING(@contextinfo, @startpos + @length + 1, @endpos)
	end

	return @result
end
GO
