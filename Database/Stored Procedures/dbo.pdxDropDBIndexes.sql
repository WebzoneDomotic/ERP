SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxDropDBIndexes]
AS
 Declare @Table_name  varchar (100) ;
 Declare @Index_name  varchar (100) ;
 Declare @SQL         varchar (500) ;

 ------------- Delete old constraint and replace with a unique index ----------------------------------------------------------
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxAddress]') AND name = N'IX_dxAddress')
 ALTER TABLE [dbo].[dxAddress] DROP CONSTRAINT [IX_dxAddress]
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxCurrencyDetail]') AND name = N'IX_dxCurrencyDetail')
 ALTER TABLE [dbo].[dxCurrencyDetail] DROP CONSTRAINT [IX_dxCurrencyDetail]
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxDepositDetail]') AND name = N'IX_dxDepositDetail')
 ALTER TABLE [dbo].[dxDepositDetail] DROP CONSTRAINT [IX_dxDepositDetail]
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxKanban]') AND name = N'IX_dxKanban')
 ALTER TABLE [dbo].[dxKanban] DROP CONSTRAINT [IX_dxKanban]
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxPayableInvoice]') AND name = N'IX_dxPayableInvoice')
 ALTER TABLE [dbo].[dxPayableInvoice] DROP CONSTRAINT [IX_dxPayableInvoice]
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxTaxDetail]') AND name = N'IX_dxTaxDetail')
 ALTER TABLE [dbo].[dxTaxDetail] DROP CONSTRAINT [IX_dxTaxDetail]
 IF  EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dxVendorProduct]') AND name = N'IX_dxVendorProduct')
 ALTER TABLE [dbo].[dxVendorProduct] DROP CONSTRAINT [IX_dxVendorProduct]

 Declare pk_cursor CURSOR FAST_FORWARD for 
 select Distinct
    t.name,ind.name
 --   , ind.index_id, ic.index_column_id, col.name,
 --   ind.*, ic.*, col.*
 from sys.indexes ind
 inner join  sys.index_columns ic on  ind.object_id = ic.object_id and ind.index_id = ic.index_id
 inner join  sys.columns col      on   ic.object_id = col.object_id and ic.column_id = col.column_id 
 inner join  sys.tables t         on  ind.object_id = t.object_id
 where ind.is_primary_key = 0 and ( ind.name like  'IxDB_%' or ind.name like 'IX_%')
 --    and ind.is_unique_constraint = 1

 BEGIN TRANSACTION
   OPEN pk_cursor
   -- First record 
   FETCH NEXT FROM pk_cursor INTO @Table_name, @Index_name
   WHILE @@FETCH_STATUS = 0
   BEGIN
      select @SQL = 'DROP INDEX ' + @Index_name + ' ON ' + @table_name  ;
      EXEC(@SQL);
      -- next record
      FETCH NEXT FROM pk_cursor INTO @Table_name, @Index_name
   END

 CLOSE pk_cursor 
 DEALLOCATE pk_cursor
 COMMIT
GO
