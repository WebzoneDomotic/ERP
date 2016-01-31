SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxEntryAccountAccountTransaction] as
       Select
            FK_dxEntry,
            Max(KindOfDocument)  as Document,
            Max(PrimaryKeyValue) as No,
            Max(TransactionDate) as TransactionDate,
            sum(CT) as CT ,
            sum(DT) as DT ,
            sum(Amount) as Amount
     from dxAccountTransaction
group by FK_dxEntry
GO
