SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxDropAuditTrigger]
AS
 Declare @trigger_name  varchar (100) ;
 Declare @SQL varchar(8000) ; 
 Declare pk_cursor CURSOR FAST_FORWARD for 
    select name from dbo.sysobjects 
    where name like '%.trAudit%' 
    and OBJECTPROPERTY(id, 'IsTrigger') = 1
 
 BEGIN TRANSACTION
   OPEN pk_cursor
   -- First record 
   FETCH NEXT FROM pk_cursor INTO @trigger_name
   WHILE @@FETCH_STATUS = 0
   BEGIN
      Select @SQL = 'DROP TRIGGER [DBO].[' + @trigger_name + '] ' ;
      EXEC(@SQL);
      -- next record
      FETCH NEXT FROM pk_cursor INTO @trigger_name
   END

 CLOSE pk_cursor 
 DEALLOCATE pk_cursor
 COMMIT
GO
