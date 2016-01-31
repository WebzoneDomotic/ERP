SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-03-19
-- Description:	Reseed all table
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxReseedAllTable]
as
begin
    Declare @ProcessTableName varchar(100)
    Declare pk_Table CURSOR FAST_FORWARD for
    SELECT COLUMNS.TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS COLUMNS, INFORMATION_SCHEMA.TABLES TABLES
    WHERE COLUMNS.COLUMN_NAME LIKE 'PK[_]%' AND COLUMNS.TABLE_NAME=TABLES.TABLE_NAME AND
         TABLES.TABLE_TYPE='BASE TABLE' and not COLUMNS.TABLE_NAME in ('dxAccountExpense','dxAccountingYear','dxGarbage','dxBatchPrintingCheque','dxPeriod') ;

    BEGIN TRANSACTION
       OPEN pk_Table
       -- First record 
       FETCH NEXT FROM pk_Table INTO @ProcessTableName
       WHILE @@FETCH_STATUS = 0
       BEGIN
          exec dbo.pdxReseedTable @TableName = @ProcessTableName, @Value = -1
          FETCH NEXT FROM pk_Table INTO @ProcessTableName
       END
       CLOSE pk_Table 
       DEALLOCATE pk_Table
    COMMIT
 end
GO
