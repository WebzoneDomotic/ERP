SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxCreatePeriod]  @Year  int, @StartingMonth int = 1
AS
  Declare @Y int ,@Period int , @CurrentPeriod int
  set @Y = Coalesce(( Select PK_dxAccountingYear from dxAccountingYear where PK_dxAccountingYear = @Year ),-1)
  if @Y = -1
  begin
     INSERT INTO [dbo].[dxAccountingYear]
           ([PK_dxAccountingYear]
           ,[ID]
           ,[Description])
     VALUES( @Year , @Year, ' Année ' +Convert(varchar(10), @Year) );
  end

  set @CurrentPeriod  =  1 ;
  While @CurrentPeriod  <= 12
  begin
    set @Period = Coalesce(( Select PK_dxPeriod from dxPeriod where PK_dxPeriod = @Year * 100 + @CurrentPeriod ),-1)
    if @Period = -1
    begin
      insert into dxPeriod ( PK_dxPeriod, ID,PeriodNumber, FK_dxAccountingYear, StartDate, EndDate )
                  values   ( @Year * 100 + @CurrentPeriod,  cast( @Year * 100 + @CurrentPeriod as varchar) , @CurrentPeriod , @Year,
                  DateAdd( Month, @CurrentPeriod+(@startingMonth -2),DateADD( year, @Year-1900 , 0)),  DateADD( Month , @CurrentPeriod+(@startingMonth -1), DateADD( year, @Year-1900 , 0) )-1  );
    end;
    set @CurrentPeriod  = @CurrentPeriod  + 1 ;
  end;
GO
