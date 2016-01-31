SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-16
-- Description:	Récupération d'une entrée au GL pour un document
-- --------------------------------------------------------------------------------------------
Create  procedure [dbo].[pdxGetGLEntry] ( @KindOfDocument int, @PrimaryKeyValue int )
as
BEGIN

  -- Accounting Document
  If @KindOfDocument in (0,1,2,3,4,5,6,7,8,10)
  Select
        Convert(bit,0) as ReversedTransaction
       ,dbo.fcxGetGLReference ( at.[PK_dxAccountTransaction],at.[PrimaryKeyValue],at.[KindOfDocument] ) Reference
       ,at.[PK_dxAccountTransaction]
       ,at.[FK_dxEntry]
       ,at.[FK_dxJournal]
       ,at.[FK_dxAccount]
       ,at.[FK_dxPeriod]
       ,( Select Coalesce(Convert(varchar(50),AccountingPeriod),ID) From dxPeriod WITH(NOLOCK) where PK_dxPeriod = FK_dxPeriod) [Period]
       ,at.[TransactionDate]
       ,( Select ID +', '+ dxAccount.Description From dxAccount WITH(NOLOCK) where PK_dxAccount = FK_dxAccount) [Account]
       ,at.[DT]
       ,at.[CT]
       ,at.[Amount]
       ,at.[FK_dxCurrency]
       ,at.[Description]
       ,at.[EndOfPeriodInventory]
       ,at.[EndOfPeriodTransaction]
       ,at.[EndOfYearTransaction]
       ,at.[KindOfDocument]
       ,at.[PrimaryKeyValue]

   from dxAccountTransaction at WITH(NOLOCK)
   where ((at.KindOfDocument = @KindOfDocument) and (at.PrimaryKeyValue = @PrimaryKeyValue))
     -- Cas pour les encaissements - on récupère le détail
     or  ((at.KindOfDocument = case when @KindOfDocument = 2 then 8  end) and (at.PrimaryKeyValue = @PrimaryKeyValue))
     -- Cas pour les paiements - on récupère le détail
     or  ((at.KindOfDocument = case when @KindOfDocument = 4 then 10 end) and (at.PrimaryKeyValue = @PrimaryKeyValue))

   Else If @KindOfDocument in (9,12,13,14,20)

   -- Simple Inventory Document
   Select
        Convert(bit,0) as ReversedTransaction
       ,dbo.fcxGetGLReference ( at.[PK_dxAccountTransaction],at.[PrimaryKeyValue],at.[KindOfDocument] ) Reference
       ,at.[PK_dxAccountTransaction]
       ,at.[FK_dxEntry]
       ,at.[FK_dxJournal]
       ,at.[FK_dxAccount]
       ,at.[FK_dxPeriod]
       ,( Select Coalesce(Convert(varchar(50),AccountingPeriod),ID) From dxPeriod WITH(NOLOCK) where PK_dxPeriod = FK_dxPeriod) [Period]
       ,at.[TransactionDate]
       ,( Select ID +', '+ dxAccount.Description From dxAccount WITH(NOLOCK) where PK_dxAccount = FK_dxAccount) [Account]
       ,at.[DT]
       ,at.[CT]
       ,at.[Amount]
       ,at.[FK_dxCurrency]
       ,at.[Description]
       ,at.[EndOfPeriodInventory]
       ,at.[EndOfPeriodTransaction]
       ,at.[EndOfYearTransaction]
       ,at.[KindOfDocument]
       ,at.[PrimaryKeyValue]

   from dxProductTransaction pt WITH(NOLOCK)
   left join dxAccountTransaction at WITH(NOLOCK) on ( at.PrimaryKeyValue = pt.PK_dxProductTransaction )
   where pt.KindOfDocument  = @KindOfDocument
     and pt.PrimaryKeyValue = @PrimaryKeyValue
     and not at.FK_dxAccount is null

  Else If @KindOfDocument in (11)

   -- Simple Inventory Document
   --Select
   --     Convert(bit,0) as ReversedTransaction
   --    ,dbo.fcxGetGLReference ( at.[PK_dxAccountTransaction],at.[PrimaryKeyValue],at.[KindOfDocument] ) Reference
   --    ,at.[PK_dxAccountTransaction]
   --    ,at.[FK_dxEntry]
   --    ,at.[FK_dxJournal]
   --    ,at.[FK_dxAccount]
   --    ,at.[FK_dxPeriod]
   --    ,( Select Coalesce(Convert(varchar(50),AccountingPeriod),ID) From dxPeriod WITH(NOLOCK) where PK_dxPeriod = FK_dxPeriod) [Period]
   --    ,at.[TransactionDate]
   --    ,( Select ID +', '+ dxAccount.Description From dxAccount WITH(NOLOCK) where PK_dxAccount = FK_dxAccount) [Account]
   --    ,at.[DT]
   --    ,at.[CT]
   --    ,at.[Amount]
   --    ,at.[FK_dxCurrency]
   --    ,at.[Description]
   --    ,at.[EndOfPeriodInventory]
   --    ,at.[EndOfPeriodTransaction]
   --    ,at.[EndOfYearTransaction]
   --    ,at.[KindOfDocument]
   --    ,at.[PrimaryKeyValue]

   --from dxProductTransaction pt WITH(NOLOCK)
   --left join dxAccountTransaction at WITH(NOLOCK) on ( at.PrimaryKeyValue = pt.PK_dxProductTransaction )
   --where pt.KindOfDocument  = @KindOfDocument
   --  and pt.PrimaryKeyValue = @PrimaryKeyValue
   --  and not PK_dxAccountTransaction is null

   --Union all

   Select
        Convert(bit,0) as ReversedTransaction
       ,dbo.fcxGetGLReference ( at.[PK_dxAccountTransaction],at.[PrimaryKeyValue],at.[KindOfDocument] ) Reference
       ,at.[PK_dxAccountTransaction]
       ,at.[FK_dxEntry]
       ,at.[FK_dxJournal]
       ,at.[FK_dxAccount]
       ,at.[FK_dxPeriod]
       ,( Select Coalesce(Convert(varchar(50),AccountingPeriod),ID) From dxPeriod WITH(NOLOCK) where PK_dxPeriod = FK_dxPeriod) [Period]
       ,at.[TransactionDate]
       ,( Select ID +', '+ dxAccount.Description From dxAccount  WITH(NOLOCK) where PK_dxAccount = FK_dxAccount) [Account]
       ,at.[DT]
       ,at.[CT]
       ,at.[Amount]
       ,at.[FK_dxCurrency]
       ,at.[Description]
       ,at.[EndOfPeriodInventory]
       ,at.[EndOfPeriodTransaction]
       ,at.[EndOfYearTransaction]
       ,at.[KindOfDocument]
       ,at.[PrimaryKeyValue]

   from dxAccountTransaction at WITH(NOLOCK)
   where at.KindOfDocument  = @KindOfDocument
     and at.FK_dxEntry in ( Select PK_dxEntry from dxEntry en where at.KindOfDocument  = 11 and en.PrimaryKeyValue =@PrimaryKeyValue)
     and not at.FK_dxAccount is null
     --and at.PrimaryKeyValue in ( Select PK_dxReceptionDetail from dxReceptionDetail WITH(NOLOCK) where FK_dxReception = @PrimaryKeyValue)

END
GO
