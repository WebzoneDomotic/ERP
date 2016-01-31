SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-14
-- Description:	Recalculate All Work Order Phase Date Linked to a Work Order
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxRecalculateAllWorkOrderDate] 
as
Begin
   Declare @PK_dxWorkOrder int
         , @RecNo int, @EOF int   
      
   Declare @WOList Table ( 
       [RecNo]       [int] IDENTITY(1,1) NOT NULL 
      ,[FK_dxWorkOrder] int )
     
   Insert into @WOList    
   SELECT 
       [PK_dxWorkOrder]
   FROM [dbo].[dxWorkOrder]
  where WorkOrderStatus < 4 
    
  -- Recalculate All Work Order Phase Date
  Set @RecNo = 1
  Set @EOF = ( Select Max([RecNo]) from @WOList )
  While @RecNo <= @EOF
  begin
      Select @PK_dxWorkOrder = [FK_dxWorkOrder] 
       From @WOList where RecNo = @RecNo
    Exec dbo.pdxRecalculatePhaseForwardPass  @FK_dxWorkOrder = @PK_dxWorkOrder
    Exec dbo.pdxRecalculatePhaseBackwardPass @FK_dxWorkOrder = @PK_dxWorkOrder
    set @RecNo = @RecNo+ 1
  end
  
end
GO
