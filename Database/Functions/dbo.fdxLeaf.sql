SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxLeaf] ( @PK_dxProduct int ,@Date Datetime )
returns int
-- Return the number of children attach to this product if = 0 we have a leaf
as
begin 
  Declare  @Res int, @PK_Ass int ;
  -- Get Assembly related to a specific date ( version )
  Set @PK_Ass = (Select Top 1 PK_dxAssembly from dxAssembly 
                  where FK_dxProduct = @PK_dxProduct
                    and EffectiveDate <= @Date order by EffectiveDate Desc ) ;
  -- Get Number of Children
  Set @Res = (Select Count(FK_dxAssembly) from dxAssemblyDetail where FK_dxAssembly = @PK_Ass);
  Return  @Res
end
GO
