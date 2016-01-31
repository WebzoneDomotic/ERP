SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-03-19
-- Description:	Reseed table
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxReSeedTable] @TableName varchar(100) , @Value int
as
begin
    Declare @newseed int 
    Declare @SQL varchar(500)
    Create  Table #Table ( PK int )
    Delete from #Table
    if @Value >= 0 
      set @SQL = ' insert into #Table  select ' + Convert(varchar(50), @value) 
    else
      set @SQL = ' insert into #Table  select coalesce(max(PK_'+@TableName+')+1,1) from ' + @TableName
    Execute(  @SQL )
    -- Get the max value of primary key
    set @newseed = ( Select PK from #Table )
    -- Reseed primary key
    set @SQL = 'DBCC CHECKIDENT ( '''+ @TableName +''' , RESEED,  ' + Convert(varchar(50),@newseed) +' ) '
    Execute(  @SQL )
    -- next record
    Drop Table #Table      
end
GO
