SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Valider si les entrés au GL balancent par devise
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxValidateEntryByCurrency]
as
Begin
  Declare @Entry Table ( FK_dxEntry int, FK_dxPeriod int, DT Float, CT Float )

  Insert into  @Entry
  Select Top 1
      tr.FK_dxEntry
   , tr.FK_dxPeriod
   , Round(sum(tr.DT),2) as DT
   , Round(sum(tr.CT),2) as CT
  from dbo.dxAccountTransaction tr
  where tr.FK_dxEntry in ( Select ap.FK_dxEntry from dbo.dxAccountPeriodToUpdate ap)
  group by tr.FK_dxEntry,tr.FK_dxPeriod, tr.FK_dxCurrency
  having abs(Round(sum(tr.DT),2) - Round(sum(tr.CT),2)) > 0.0001

  if (Select Count(0) from @Entry) > 0
  begin
     RAISERROR('L''écriture ne balance pas / GL Entry do not balance.', 16, 1)
     RETURN
  end
end
GO
