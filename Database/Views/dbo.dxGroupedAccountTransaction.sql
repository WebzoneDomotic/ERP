SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxGroupedAccountTransaction] as
       Select
            FK_dxEntry,
            FK_dxJournal,
            FK_dxPeriod,
            TransactionDate,
            FK_dxAccount,
            sum(CT) as CT ,
            sum(DT) as DT ,
            sum(Amount) as Amount,
            FK_dxCurrency,
            Max(Description) as Description,
            KindOfDocument,
            PrimaryKeyValue
     from dxAccountTransaction
 
group by FK_dxEntry,
             FK_dxJournal,
             FK_dxPeriod,
             TransactionDate,
             FK_dxAccount,
             FK_dxCurrency,
             KindOfDocument,
             PrimaryKeyValue
GO
