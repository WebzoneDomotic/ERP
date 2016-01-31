SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-03-11
-- Description:	Suppose que nous avons une référence si plus grand que 30 niveau
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxCircRefLevel] ( @PK_dxProduct int, @Date Datetime, @Level int )
returns int
-- This function check if we have a circular reference on an assembly for the origin product
as
begin
  Declare  @IsCircular int, @FK_P int, @PK_Ass int ;
  set  @IsCircular =  @Level;
  -- we are not allowed to pass 30 level in a recursive function
  begin
    -- Get Assembly related to a specific date ( version )
    Set @PK_Ass = (Select Top 1 PK_dxAssembly from dxAssembly
                    where FK_dxProduct = @PK_dxProduct
                      and EffectiveDate <= @Date order by EffectiveDate Desc ) ;
    Declare pk_cursor CURSOR FAST_FORWARD for SELECT FK_dxProduct from dxAssemblyDetail where FK_dxAssembly = @PK_Ass;
    Open pk_cursor Fetch NEXT FROM pk_cursor INTO @FK_P
    -- Scan all the children and get the Standard cost

    if @Level <= 30
    begin
       Set @Level = @Level + 1
       While @@FETCH_STATUS = 0
       Begin
         set @Level = dbo.[fdxCircRefLevel]( @FK_P , @Date, @Level )
         FETCH NEXT FROM pk_cursor INTO @FK_P
       End

    end
    Close pk_cursor Deallocate pk_cursor
  end
  Return @Level
end
GO
