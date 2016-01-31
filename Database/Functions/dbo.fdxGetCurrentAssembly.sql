SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetCurrentAssembly] ( @FK_dxProduct int, @EffectiveDate Datetime ) 
--Returns period according to delta difference from current period.
returns int
as
BEGIN
  DECLARE @PK_dxAssembly int
  Set @PK_dxAssembly=(Select top 1 PK_dxAssembly from dxAssembly where FK_dxProduct = @FK_dxProduct and EffectiveDate <=@EffectiveDate order by EffectiveDate Desc )
  RETURN  Coalesce(@PK_dxAssembly, -1)
END
GO
