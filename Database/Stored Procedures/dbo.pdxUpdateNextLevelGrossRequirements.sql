SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-10-30
-- Description:	Transfert de la demande de la demande de lancement planifier à la quantité brut requise
--              du sous-assemblage. Le besoin brut d’un article est fonction :
--              des lancements planifiés des articles parents
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxUpdateNextLevelGrossRequirements]
                            @FK_dxProduct__Parent int
                          , @Period int
                          , @GrossRequirements float as
Begin
   Declare @FK_dxProduct int , @NetQuantity Float, @Waste Float, @WasteQuantity Float

    Declare @Loop Table
         (
            RecNo int IDENTITY(1,1)
           ,FK_dxProduct int
           ,NetQuantity float
           ,Waste float
           ,WateQuantity float
         )

   Declare @RecNo int, @EOF int
   Set @RecNo = 1
   Insert into @Loop
   -- Select items where parent = @FK_dxProduct__Parent
   Select Distinct ad.FK_dxProduct, ad.NetQuantity, 1.0+(PctOfWasteQuantity / 100.0), WasteQuantity from dxAssemblyDetail ad
   left outer join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
   where aa.FK_dxProduct = @FK_dxProduct__Parent
   Set @EOF  = ( Select Count(*) from @Loop)

   While @RecNo <= @EOF
   Begin
     Select @FK_dxProduct =FK_dxProduct 
          , @NetQuantity=NetQuantity
          , @Waste=Waste
          , @WasteQuantity = WateQuantity
           from @Loop where RecNo = @RecNo

      Update dxMRP set GrossRequirements = 
                          GrossRequirements 
                        + ( @GrossRequirements * @NetQuantity *  @Waste ) 
                        + @WasteQuantity
      where FK_dxProduct = @FK_dxProduct
        and Period = @Period
      set @RecNo = @RecNo + 1
   END
   
end ;
GO
