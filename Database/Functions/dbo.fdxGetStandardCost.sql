SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetStandardCost] ( @PK_dxProduct int ,@Date Datetime )
returns float
as
begin
 Declare  @FK_P int, @PK_Ass int,@NetQuantity Float, @OptimalBatchSize Float, @PctOfWasteQuantity Float, @StandardCost float ;
 SET @OptimalBatchSize = 1.0 
 -- Get Assembly related to a specific date ( version )
 Set @PK_Ass = (Select Top 1 PK_dxAssembly from dxAssembly 
                 where FK_dxProduct = @PK_dxProduct
                   and EffectiveDate <= @Date order by EffectiveDate Desc, Version Desc ) ;

 Declare @Loop Table
         (  
            RecNo int IDENTITY(1,1)
           ,FK_dxProduct int
           ,NetQuantity float
           ,PctOfWasteQuantity float
        )
 Declare @RecNo int, @EOF int
 Set @RecNo = 1       
 Insert into @Loop       
 SELECT ad.FK_dxProduct
       , Coalesce(NetQuantity, 0.0) NetQuantity
       , Coalesce(PctOfWasteQuantity,0.0) PctOfWasteQuantity
 From dxAssemblyDetail ad 
      Left outer join dxAssembly ab on ( ab.PK_dxAssembly = ad.FK_dxAssembly )
 where ad.FK_dxAssembly = @PK_Ass;
 Set @EOF = ( Select Count(*) from @Loop)      
       
 Set @StandardCost = 0.0 ;
 -- Get batch size 
 SET @OptimalBatchSize = Coalesce(( select OptimalBatchSize from dxAssembly where PK_dxAssembly =  @PK_Ass ),1.0)
 
 -- Scan all the children and get the Standard cost
 While @RecNo <= @EOF
 Begin
     Select @FK_P =FK_dxProduct , @NetQuantity=NetQuantity, @PctOfWasteQuantity=PctOfWasteQuantity from @Loop where RecNo = @RecNo
     set @NetQuantity  = Coalesce ( @NetQuantity , 1.0)
     set @StandardCost = Round(@StandardCost +(( @PctOfWasteQuantity + 100.0)/ 100.0 * @NetQuantity *
                                                   (dbo.fdxGetStandardCost(@FK_P , @Date )
                                                 ) ) ,4 )
     set @RecNo = @RecNo + 1
 End
 if @StandardCost = 0 set @StandardCost = dbo.fdxGetProductCost( @PK_dxProduct, @Date )
 set @StandardCost = @StandardCost + (dbo.fdxGetLabourCost  (@PK_dxProduct , @Date ,@OptimalBatchSize,1)/@OptimalBatchSize)
 -- Return the total cost
 Return Coalesce( @StandardCost , 0.0 )
end
GO
