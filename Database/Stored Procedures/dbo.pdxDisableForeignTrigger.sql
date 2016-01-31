SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 26 Août 2012
-- Description:	Désactiver tous les triggers qui ne sont pas stock - Trigger étrangé au système
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxDisableForeignTrigger]
AS
Begin
  Declare @trigger_name  varchar (100) ;
  Declare @table_name    varchar (100) ;
  Declare @SQL varchar(8000) ; 
  Declare pk_cursor CURSOR FAST_FORWARD for 
     select ob.name, po.name
       from dbo.sysobjects ob
  Left join dbo.sysobjects po on ( po.id = ob.parent_obj ) 
      where not ob.name like '%.tr%' 
        and OBJECTPROPERTY(ob.id, 'IsTrigger') = 1
 
  BEGIN TRANSACTION
  OPEN pk_cursor
  -- First record 
  FETCH NEXT FROM pk_cursor INTO @trigger_name ,@table_name
  WHILE @@FETCH_STATUS = 0
  BEGIN
      Select @SQL = 'DISABLE TRIGGER [DBO].[' + @trigger_name + '] ON [dbo].[' + @table_name + ']' ;
      EXEC(@SQL);
      -- next record
      FETCH NEXT FROM pk_cursor INTO @trigger_name, @table_name
  END
  CLOSE pk_cursor 
  DEALLOCATE pk_cursor
  COMMIT
end
GO
