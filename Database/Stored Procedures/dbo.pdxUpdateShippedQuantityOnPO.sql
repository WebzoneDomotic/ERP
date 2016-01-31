SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2013-01-28
-- Description:	Update Shipped Qty on CO
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxUpdateShippedQuantityOnPO] @FK_dxShipping int
as
Begin
    Update dxClientOrderDetail set ShippedQuantity = ( Select Coalesce(sum(rd.Quantity), 0.0 ) from dxShippingDetail rd
                                                           left outer join dxShipping re on ( re.PK_dxShipping = rd.FK_dxShipping )
                                                          where rd.FK_dxClientOrderDetail = dxClientOrderDetail.PK_dxClientOrderDetail and re.posted=1 )
    where FK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping ) ;

    Update dxClientOrder set HavingShippement = ( select Coalesce(Max(1),0) from dxClientOrderDetail pd
                                                    where ABS(ShippedQuantity) > 0.0  and pd.FK_dxClientOrder = dxClientOrder.PK_dxClientOrder )
    where PK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping ) ;

    Update dxClientOrderDetail set Closed = 1
    where ShippedQuantity >= Quantity
      and Quantity >= 0.0
      and FK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping ) ;

    Update dxClientOrderDetail set Closed = 1
    where ShippedQuantity <= Quantity
      and Quantity <  0.0
      and FK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping ) ;

    Update dxClientOrderDetail set Closed = 0
    where ShippedQuantity < Quantity
      and Quantity >= 0.0
      and FK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping ) ;

    Update dxClientOrderDetail set Closed = 0
    where ShippedQuantity > Quantity
      and Quantity < 0.0
      and FK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping ) ;

    update dxClientOrder set Closed = ( select Convert( bit, coalesce(min( Convert( int, pd.Closed) ),0)) from dxClientOrderDetail pd
                                           where  pd.FK_dxClientOrder = dxClientOrder.PK_dxClientOrder )
    where PK_dxClientOrder in ( select FK_dxClientOrder from dxShippingDetail where FK_dxShipping = @FK_dxShipping );
end
GO
