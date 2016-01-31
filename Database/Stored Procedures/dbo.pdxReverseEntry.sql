SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxReverseEntry]  
  @KindOfDocument  int,
  @PrimaryKeyValue int
AS
  
  Declare @Entry int
  Set @Entry = Coalesce((Select Max(FK_dxEntry) from dxAccountTransaction where KindOfDocument = @KindOfDocument and PrimaryKeyValue = @PrimaryKeyValue), -1) 
  if @Entry <> -1   
  begin
     insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT , CT ,FK_dxCurrency, EndOfYearTransaction,KindOfDocument,PrimaryKeyValue )
     select FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, CT , DT ,FK_dxCurrency, EndOfYearTransaction,KindOfDocument,PrimaryKeyValue from  dxAccountTransaction where FK_dxEntry = @Entry and Reversed = 0
     update dxAccountTransaction set reversed = 1 where FK_dxEntry = @Entry
  end
GO
