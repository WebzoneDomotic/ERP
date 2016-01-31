SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Valider si les entrés au GL balancent
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxValidateEntry] @ClosingPeriod int = 0
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
  group by tr.FK_dxEntry,tr.FK_dxPeriod
  having abs(Round(sum(tr.DT),2) - Round(sum(tr.CT),2)) > 0.0001
  -- Check if entry balance
  if (Select Count(0) from @Entry) > 0
  begin
     RAISERROR('L''écriture ne balance pas pour le document / Document GL Entry do not balance.', 16, 1)
     RETURN
  end else
  -- check if period balance
  if abs(( Select sum(Amount) from dxAccountTransaction where FK_dxPeriod in ( Select FK_dxPeriod from dbo.dxAccountPeriodToUpdate))) >= 0.0001
  begin
     RAISERROR('Les écritures ne balancent pas par période / GL Entries do not balance by period.', 16, 1)
     RETURN
  end else
  -- Check if period is closed
  if @ClosingPeriod = 0
    if ( Select Max(Convert(int,AccountingIsClosed)) from dxAccountTransaction at left join dxPeriod pe on (pe.PK_dxPeriod = at.FK_dxPeriod)
          where FK_dxPeriod in ( Select FK_dxPeriod from dbo.dxAccountPeriodToUpdate)) = 1
    begin
       RAISERROR('La période est fermée / Period is closed.', 16, 1)
       RETURN
    end
end
GO
