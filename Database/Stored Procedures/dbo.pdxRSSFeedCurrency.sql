SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-05-10
-- Description:	Récupération du taux de change à partir d'un lien RSS
--              On doit avoir l'application CURL installé sur le server
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxRSSFeedCurrency] ( @FK_dxCurrency int ) 
AS
Begin
  SET nocount ON
  DECLARE @command     NVARCHAR(255) --the command string used for spExecuteSQL
  DECLARE @FileName    Varchar(255)
  DECLARE @ExecCmd     Varchar(255)
  Declare @RSSFeed     Varchar(255)
  Declare @RateDate    Datetime
  Declare @NoonRate    float
  Declare @ClosingRate float
  Declare @exitcode    int
  Declare @R           varchar(15)
  
  CREATE TABLE #tempXML(PK INT NOT NULL IDENTITY(1,1), XMLValue VARCHAR(255))

  WAITFOR DELAY '00:00:20';
  -----------------------Get Noon Rate ---------------------------------------------------
  Set @RSSFeed  = ( Select RSSNoonRate from dxCurrency where PK_dxCurrency = @FK_dxCurrency )
  Set @FileName = 'C:\CURL\Currency.XML'
  Set @ExecCmd  = 'Type ' + @FileName
  set @command  = 'C:\CURL\curl "'+ @RSSFeed +'" -o ' + @FileName
 
  --And execute it
  EXECUTE @exitcode= xp_cmdshell @command
  INSERT INTO #tempXML EXEC master.dbo.xp_cmdshell @ExecCmd
    
  Set @RateDate = Convert(Datetime,(SELECT Distinct substring( dbo.fdxRemoveTag(XMLValue),1,10) from #tempXML where XMLValue like '%dc:date%'))
  Set @NoonRate = Round(1.0 / Convert(Float,(SELECT Distinct Replace(dbo.fdxRemoveTag(XMLValue),',','.') from #tempXML where XMLValue like '%cb:Value%')),6)

  Delete from  #tempXML

  WAITFOR DELAY '00:00:20';
  -----------------------Get Closing Rate ---------------------------------------------------
  Set @RSSFeed  = ( Select RSSClosingRate from dxCurrency where PK_dxCurrency = @FK_dxCurrency )
  Set @FileName = 'C:\CURL\Currency.XML'
  Set @ExecCmd  = 'Type ' + @FileName
  set @command  = 'C:\CURL\curl "'+ @RSSFeed +'" -o ' + @FileName

  --And execute it
  EXECUTE @exitcode= xp_cmdshell @command
  INSERT INTO #tempXML EXEC master.dbo.xp_cmdshell @ExecCmd

  Set @RateDate    = Convert(Datetime,(SELECT Distinct substring( dbo.fdxRemoveTag(XMLValue),1,10) from #tempXML where XMLValue like '%dc:date%'))
  Set @ClosingRate = Round(1.0 / Convert(Float,(SELECT Distinct Replace(dbo.fdxRemoveTag(XMLValue),',','.') from #tempXML where XMLValue like '%cb:Value%')),6)
  
  DROP TABLE #tempXML

  ----------------------------Update Currency Detail Table ----------------------------------
  Insert into dxCurrencyDailyRate (  FK_dxCurrency, RateDate )
      select PK_dxCurrency, @RateDate from dxCurrency where PK_dxCurrency = @FK_dxCurrency
         and  ( not exists ( select 1 from dxCurrencyDailyRate where FK_dxCurrency = @FK_dxCurrency and RateDate = @RateDate )) ;
  Update dxCurrencyDailyRate set NoonRate = @NoonRate , ClosingRate = Coalesce(@ClosingRate,@NoonRate)
  where FK_dxCurrency = @FK_dxCurrency and RateDate = @RateDate;


  ----------------------------Update Period Rate --------------------------------------------
  Update dxCurrencyDetail set AverageRate =
  coalesce(( select Round(Avg(ClosingRate),6) from dxCurrencyDailyRate cr, dxPeriod pe
   where cr.FK_dxCurrency = dxCurrencyDetail.FK_dxCurrency
     and pe.PK_dxPeriod = dxCurrencyDetail.FK_dxPeriod
     and cr.RateDate between pe.StartDate and pe.EndDate ), 1.0)
  Where FK_dxPeriod = ( select Max(PK_dxPeriod) from dxPeriod where @RateDate between StartDate and EndDate ) 
    and FK_dxCurrency = @FK_dxCurrency;

  Update dxCurrencyDetail set ClosingRate =
  coalesce(( select top 1 ClosingRate from dxCurrencyDailyRate cr, dxPeriod pe
              where cr.FK_dxCurrency = dxCurrencyDetail.FK_dxCurrency
                and pe.PK_dxPeriod = dxCurrencyDetail.FK_dxPeriod
                and cr.RateDate between pe.StartDate and pe.EndDate
           order by cr.RateDate desc ), 1.0)
  Where FK_dxPeriod = ( select Max(PK_dxPeriod) from dxPeriod where @RateDate between StartDate and EndDate )
    and FK_dxCurrency = @FK_dxCurrency ;

end
GO
