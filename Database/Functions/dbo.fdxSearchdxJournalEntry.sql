SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-09
-- Description:	Quick Search
-- --------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fdxSearchdxJournalEntry] (@Expression varchar(50))
RETURNS TABLE
AS
    RETURN (
    Select  PK_dxJournalEntry as PK from dxJournalEntry
     Where  cast(ID as varchar)    like '%'+@Expression+'%'
        or  convert(varchar, TransactionDate, 126) like '%'+@Expression+'%'
        or  Convert ( varchar(1000), Description ) like '%'+@Expression+'%'
     Union
    Select  FK_dxJournalEntry as PK from dxJournalEntryDetail
     Where  Convert ( varchar(1000), Description ) like '%'+@Expression+'%'
           )
GO
