SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxEntryAccountTransaction] as
       Select
            FK_dxEntry,
            FK_dxAccount,
            Max(KindOfDocument)  as Document,
            Max(PrimaryKeyValue) as No,
            Max(TransactionDate) as TransactionDate,
            sum(CT) as CT ,
            sum(DT) as DT ,
            sum(Amount) as Amount
     from dxAccountTransaction
group by FK_dxEntry , FK_dxAccount
GO
