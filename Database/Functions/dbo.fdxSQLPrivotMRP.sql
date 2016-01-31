SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxSQLPrivotMRP] ( @PK_dxLanguage int ,@Rank int, @QuantityType varchar(50) )
--Create SQL Statement to pivot Date field for the MRP Table  .
returns varchar(max)
as
BEGIN
  Declare @SQL varchar(max), @SQLPeriod varchar(500)
  Declare @StrDate Varchar(50)
  Declare @dw int, @P int, @SP int, @EP int ,@StrP Varchar(10)
  Declare @PeriodDate Datetime
  Declare @DayOfWeek varchar(20)
  Declare @QuantityTypeValue Varchar(100)

  if @PK_dxLanguage = 1
  begin
     if @Rank = 1 set @QuantityTypeValue = Char(39) +'Prévision de la demande' + Char(39)+' [Quantité pour]'
     if @Rank = 2 set @QuantityTypeValue = Char(39) +'Besoins bruts'           + Char(39)+' [Quantité pour]'
     if @Rank = 3 set @QuantityTypeValue = Char(39) +'Réceptions programmées'  + Char(39)+' [Quantité pour]'
     if @Rank = 4 set @QuantityTypeValue = Char(39) +'Stock projeté'           + Char(39)+' [Quantité pour]'
     if @Rank = 5 set @QuantityTypeValue = Char(39) +'Besoins nets'            + Char(39)+' [Quantité pour]'
     if @Rank = 6 set @QuantityTypeValue = Char(39) +'Réceptions planifiées'   + Char(39)+' [Quantité pour]'
     if @Rank = 7 set @QuantityTypeValue = Char(39) +'Lancements planifiés'    + Char(39)+' [Quantité pour]'
     set @SQL = 'Select Distinct pr.ID as [Produit] , pr.Description, pr.LeadTimeInDays [Délai(jrs)], '
                +Convert(varchar,@Rank)+' as [Rang],' +@QuantityTypeValue
  end else
  begin
     if @Rank = 1 set @QuantityTypeValue = Char(39) +'Forecast Requirements' + Char(39)+' [Quantity For]'
     if @Rank = 2 set @QuantityTypeValue = Char(39) +'Gross Requirements'    + Char(39)+' [Quantity For]'
     if @Rank = 3 set @QuantityTypeValue = Char(39) +'Scheduled Receipts'    + Char(39)+' [Quantity For]'
     if @Rank = 4 set @QuantityTypeValue = Char(39) +'Projected on Hand'     + Char(39)+' [Quantity For]'
     if @Rank = 5 set @QuantityTypeValue = Char(39) +'Net Requirements'      + Char(39)+' [Quantity For]'
     if @Rank = 6 set @QuantityTypeValue = Char(39) +'Planned Order Receipts'+ Char(39)+' [Quantity For]'
     if @Rank = 7 set @QuantityTypeValue = Char(39) +'Planned Order Releases'+ Char(39)+' [Quantity For]'
     set @SQL = 'Select Distinct pr.ID as [Product] , pr.Description, pr.LeadTimeInDays [Lead Time(Day)], '
                +Convert(varchar,@Rank)+' as [Rank],' +@QuantityTypeValue
  end

  set @SP = ( Select Min(Period) from dxMRP )
  set @EP = ( Select Max(Period) from dxMRP )
  set @P = @SP
  While @P <= @EP
  begin
     Set @StrP       = Convert(varchar(10),@P)
     Set @PeriodDate = dbo.fdxGetDateNoTime((Select Max(PeriodDate) from dxMRP where Period = @P))
     Set @dw = DatePart(dw, @PeriodDate)
     if @PK_dxLanguage = 1 
        Set @DayOfWeek = Case
                            When @dw = 1 then 'Dimanche' 
                            When @dw = 2 then 'Lundi' 
                            When @dw = 3 then 'Mardi' 
                            When @dw = 4 then 'Mercredi' 
                            When @dw = 5 then 'Jeudi' 
                            When @dw = 6 then 'Vendredi' 
                            When @dw = 7 then 'Samedi' 
                         end
     else 
        Set @DayOfWeek = Case
                            When @dw = 1 then 'Sunday' 
                            When @dw = 2 then 'Monday' 
                            When @dw = 3 then 'Tuesday' 
                            When @dw = 4 then 'Wednesday' 
                            When @dw = 5 then 'Thursday' 
                            When @dw = 6 then 'Friday' 
                            When @dw = 7 then 'Saturday' 
                         end
     
     Set @StrDate    = '[' + @StrP+' '+ Char(13)+
                           + @DayOfWeek +' '+ Char(13)+
                           + Convert(varchar,Datepart(yy,@PeriodDate))+'-'+
                           + Right('0'+Convert(varchar,Datepart(mm,@PeriodDate)),2)+'-'+
                           + Right('0'+Convert(varchar,Datepart(dd,@PeriodDate)),2)+']'

     set @SQLPeriod  = ',( Select round('+@QuantityType+',6) from dxMRP mr  where mr.FK_dxProduct
                           = mp.FK_dxProduct and Period ='+@StrP +') ' + @StrDate
     set @SQL = @SQL + @SQLPeriod
     set @P = @P+1
  end
  set @SQL = @SQL + ' From dxMRP mp '
  set @SQL = @SQL + ' Left outer join dxProduct pr on (pr.PK_dxProduct = mp.FK_dxProduct) '
  Return @SQL
END
GO
