SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxAssemblyCircRef] ( @PK_dxProduct int, @Date Datetime )
returns int
-- This function check if we have a circular reference on an assembly for the origin product
as
begin
  Declare  @IsCircular int, @FK_P int, @PK_Ass int ;
  set  @IsCircular = 0;
  -- we are not allowed to pass 32 level in a recursive function
  begin
    -- Get Assembly related to a specific date ( version )
    Set @PK_Ass = (Select Top 1 PK_dxAssembly from dxAssembly
                    where FK_dxProduct = @PK_dxProduct
                      and EffectiveDate <= @Date order by EffectiveDate Desc ) ;
    Declare pk_cursor CURSOR FAST_FORWARD for SELECT FK_dxProduct from dxAssemblyDetail where FK_dxAssembly = @PK_Ass;
    Open pk_cursor Fetch NEXT FROM pk_cursor INTO @FK_P
    -- Scan all the children and get the Standard cost
    While @@FETCH_STATUS = 0
    Begin
       set @IsCircular = dbo.fdxAssemblyCircRef( @FK_P , @Date )
       FETCH NEXT FROM pk_cursor INTO @FK_P
    End
    Close pk_cursor Deallocate pk_cursor
 end
 Return @IsCircular
end
GO
