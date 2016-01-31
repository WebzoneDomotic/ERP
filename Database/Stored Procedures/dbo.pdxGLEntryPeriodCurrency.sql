SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxGLEntryPeriodCurrency]
AS

Declare   @Currency int
         ,@Period int
         ,@Account int

/*---------------- Insert currency detail for each period and currency -------------- */
Declare CP_CurPer CURSOR FAST_FORWARD FOR SELECT c.PK_dxCurrency, p.PK_dxPeriod FROM dxCurrency c, dxPeriod p ;
Open CP_CurPer ;
  FETCH NEXT FROM CP_CurPer into @Currency,@Period;
  WHILE @@FETCH_STATUS = 0
  BEGIN
      Insert into dxCurrencyDetail ( FK_dxCurrency, FK_dxPeriod  ) SELECT c.PK_dxCurrency, p.PK_dxPeriod  FROM dxCurrency c , dxPeriod p
      where  c.PK_dxCurrency = @Currency and p.PK_dxPeriod = @Period and
             ( not exists ( select 1 from dxCurrencyDetail where FK_dxCurrency =@Currency and FK_dxPeriod = @Period )) ;
      FETCH NEXT FROM CP_CurPer into @Currency,@Period;
  END;
Close CP_CurPer ;
Deallocate CP_CurPer ;


/*------------------------- Add new Account Period into GL Table ---------------------*/
Declare GL_ActPer CURSOR FAST_FORWARD FOR SELECT a.PK_dxAccount , p.PK_dxPeriod  FROM dxAccount a , dxPeriod p 
Open GL_ActPer ;
  FETCH NEXT FROM GL_ActPer into @Account,@Period;
  WHILE @@FETCH_STATUS = 0
  BEGIN
      Insert into dxGL ( FK_dxAccount,FK_dxPeriod ) SELECT aa.PK_dxAccount, pp.PK_dxPeriod FROM dxAccount aa , dxPeriod pp
      where  aa.PK_dxAccount = @Account and pp.PK_dxPeriod = @Period and
             ( not exists ( select 1 from dxGL where FK_dxAccount =@Account and FK_dxPeriod = @Period )) ;
      FETCH NEXT FROM GL_ActPer into @Account,@Period;
  END;
Close GL_ActPer ;
Deallocate GL_ActPer ;
GO
