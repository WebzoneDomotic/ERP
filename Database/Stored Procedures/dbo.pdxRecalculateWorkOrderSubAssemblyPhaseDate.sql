SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-28
-- Description:	Recalculate Phase Date for All Sub Assembly Linked to a Work Order 
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxRecalculateWorkOrderSubAssemblyPhaseDate] @FK_dxWorkOrder__Master int
as
Begin
   Declare @PK_dxWorkOrder int
         , @RecNo int, @EOF int  
         , @StartDate Datetime
         , @FinishDate Datetime
     
   Declare @WOList Table ( 
       [RecNo]       [int] IDENTITY(1,1) NOT NULL 
      ,[FK_dxWorkOrder] int )
     
   Insert into @WOList    
   SELECT 
       [PK_dxWorkOrder]
   FROM [dbo].[dxWorkOrder]
  where WorkOrderStatus < 4 
    and FK_dxWorkOrder__Master = @FK_dxWorkOrder__Master
    
  -- Get Start Date and End Date from Marter Work Order
  Select @StartDate = StartDate , @FinishDate = FinishDate From dxWorkOrderPhase 
   where FK_dxWorkOrder =@FK_dxWorkOrder__Master 
     and FK_dxWorkOrderPhase__WorkOrder is null
     and IsWorkOrder = 1
     
  -- Update Start Date and Finish Date of Phases    
  Update wp
       set wp.FinishDate =  @StartDate  
  From dxWorkOrderPhase wp
  where FK_dxWorkOrder in ( select [FK_dxWorkOrder] from @WOList )
    and not FK_dxWorkOrderPhase__WorkOrder is null    
    and IsWorkOrder = 0
    and Locked = 0
    
  -- Recalculate All Work Order Phase Date
  Set @RecNo = 1
  Set @EOF = ( Select Max([RecNo]) from @WOList )
  While @RecNo <= @EOF
  begin
    -- Get Sub to Update
    Select @PK_dxWorkOrder = [FK_dxWorkOrder] From @WOList where RecNo = @RecNo
    --Exec dbo.pdxRecalculatePhaseForwardPass  @FK_dxWorkOrder = @PK_dxWorkOrder
    Exec dbo.pdxRecalculatePhaseBackwardPass @FK_dxWorkOrder = @PK_dxWorkOrder
    set @RecNo = @RecNo+ 1
  end
  
end
GO
