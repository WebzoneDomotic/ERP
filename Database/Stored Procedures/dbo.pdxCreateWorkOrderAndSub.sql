SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 15 avril 2012
-- Description:	Création d'un OF et de ses Sub
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxCreateWorkOrderAndSub] @FK_dxProduct_ int, @FK_dxProductionLine_  int, @Quantity_ float, @WorkOrderDate_ Datetime, @CombineSUB int =0 ,@PK_dxWorkOrder_ int OUTPUT, @Lot_ Varchar(50) OUTPUT
as
Begin

  Execute dbo.pdxCreateWorkOrder @FK_dxProduct_, @FK_dxProductionLine_, @Quantity_ , @WorkOrderDate_ ,@PK_dxWorkOrder = @PK_dxWorkOrder_ output , @Lot = @Lot_ Output

   -- Create all the sub combine or not
   if  @CombineSUB = 0
     Insert Into dxWorkOrder (
       FK_dxWorkOrder__Master
      ,FK_dxProduct
      ,FK_dxProductionLine
      ,WorkOrderStatus
      ,QuantityToProduce
      ,AskedQuantity
      ,WorkOrderDate
      ,Lot
     )
     Select
         @PK_dxWorkOrder_
        ,ad.FK_dxProduct
        ,@FK_dxProductionLine_
        ,0
        ,Round(@Quantity_ * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,0)
        ,Round(@Quantity_ * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,0)
        ,Dateadd(dd,-1.0*pr.LeadTimeInDays,@WorkOrderDate_)
        ,@Lot_
     from dxAssemblyDetail ad
        left outer join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
        left outer join dxProduct  pr on (pr.PK_dxProduct  = ad.FK_dxProduct )
        where aa.FK_dxProduct = @FK_dxProduct_
          and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , @WorkOrderDate_ )
          and pr.ManufacturedItem = 1
          and ad.NetQuantity > 0.0

  else
     Insert Into dxWorkOrder (
       FK_dxWorkOrder__Master
      ,FK_dxProduct
      ,FK_dxProductionLine
      ,WorkOrderStatus
      ,QuantityToProduce
      ,AskedQuantity
      ,WorkOrderDate
      ,Lot
     )
     Select
         @PK_dxWorkOrder_
        ,ad.FK_dxProduct
        ,@FK_dxProductionLine_
        ,0
        ,0.000001
        ,Round(@Quantity_ * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,0)
        ,Dateadd(dd,-1.0*pr.LeadTimeInDays,@WorkOrderDate_)
        ,@Lot_
     from dxAssemblyDetail ad
        left outer join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
        left outer join dxProduct  pr on (pr.PK_dxProduct  = ad.FK_dxProduct )
        where aa.FK_dxProduct = @FK_dxProduct_
          and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , @WorkOrderDate_ )
          and pr.ManufacturedItem = 1
          and ad.NetQuantity > 0.0
          and Not Exists ( Select 1 from dxWorkOrder where WorkOrderDate = Dateadd(dd,-1.0*pr.LeadTimeInDays,@WorkOrderDate_)
                                                       and FK_dxProduct = ad.FK_dxProduct
                                                       and WorkOrderStatus = 0 )

  -- Ajust sub assembly quantity to combine with all other WO
  If  @CombineSUB = 1
    Update wo
      set wo.QuantityToProduce =  Round(wo.QuantityToProduce + Round(@Quantity_ * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,0),0)
    From dxAssemblyDetail ad
      left join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
      left join dxProduct  pr on (pr.PK_dxProduct  = ad.FK_dxProduct )
      left join dxWorkOrder wo on (wo.FK_dxProduct    = ad.FK_dxProduct and
                                   wo.WorkOrderDate   = Dateadd(dd,-1.0*pr.LeadTimeInDays,@WorkOrderDate_) and
                                   wo.WorkOrderStatus = 0)
      where aa.FK_dxProduct = @FK_dxProduct_
        and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , @WorkOrderDate_ )
        and pr.ManufacturedItem = 1
        and ad.NetQuantity > 0.0
        and Exists ( Select 1 from dxWorkOrder where WorkOrderDate = Dateadd(dd,-1.0*pr.LeadTimeInDays,@WorkOrderDate_)
                                                     and FK_dxProduct = ad.FK_dxProduct
                                                     and WorkOrderStatus = 0 )

End
GO
