SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-12
-- Description:	Create Phase and Resource linked to a Work Order
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxCreateWorkOrderPhase] @FK_dxWorkOrder int = -1
as
Begin
   Declare @FK_WO int

   if @FK_dxWorkOrder > 0 --we try to create all WO
     Set @FK_WO = 999999999999
   else
     Set @FK_WO = @FK_dxWorkOrder

   --Delete from dbo.dxSchedulerEvent
   --Delete from dxWorkOrderResource
   --Delete from dxWorkOrderPhase --where IsWorkOrder = 1

   -- ---------------------------------------------------------
   -- Create Work Order Phase
   Insert into dxWorkOrderPhase
       (  FK_dxWorkOrder
         ,FK_dxRouting
         ,FK_dxPhase
         ,PhaseNumber
         ,Description
         ,StartDate
         ,FinishDate
         ,Duration
       )

    Select
       wo.PK_dxWorkOrder
      ,rt.PK_dxRouting
      ,ph.PK_dxPhase
      ,ph.PhaseNumber
      ,Convert(varchar(10),ph.PhaseNumber) +' - '+ph.Name
      ,DateAdd( hh,  6.0, wo.WorkOrderDate)
      ,DateAdd( hh, 12.0, wo.WorkOrderDate)
      ,Coalesce(( select Max(dbo.fdxFracToHour(BatchOperationTime) / BatchSize )  from dxPhaseDetail where FK_dxPhase = ph.PK_dxPhase ),0.0)* wo.QuantityToProduce as ExecutionTime

    From dxWorkOrder wo
    left outer join dxAssembly  aa on (aa.FK_dxProduct = wo.FK_dxProduct) and  (aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly( wo.FK_dxProduct, wo.WorkorderDate))
    left outer join dxRouting    rt on (aa.FK_dxRouting = rt.PK_dxRouting)
    left outer join dxPhase     ph on (rt.PK_dxRouting = ph.FK_dxRouting)
    where ((PK_dxWorkOrder = @FK_dxWorkOrder) or (PK_dxWorkOrder > @FK_WO ))
      and not rt.PK_dxRouting is null
      and wo.WorkOrderStatus < 4
      and not Exists ( select 1 from dxWorkOrderPhase
                        where FK_dxWorkOrder = wo.PK_dxWorkOrder
                          and FK_dxPhase = ph.PK_dxPhase )

    order by wo.PK_dxWorkOrder,ph.PhaseNumber

    -- ---------------------------------------------------------
    -- Create Work Order acting as Main Phase
    Insert into dxWorkOrderPhase
       (  FK_dxWorkOrder
         ,FK_dxRouting
         ,FK_dxPhase
         ,PhaseNumber
         ,Description
         ,StartDate
         ,FinishDate
         ,Duration
         ,IsWorkOrder
       )
    Select
       wo.PK_dxWorkOrder
      ,Min(rt.PK_dxRouting)
      ,Min(ph.PK_dxPhase)
      ,Min(ph.PhaseNumber)
      ,Convert(Varchar, wo.PK_dxWorkOrder)
      ,DateAdd( hh,  6.0, wo.WorkOrderDate)
      ,DateAdd( hh, 12.0, wo.WorkOrderDate)
      ,Coalesce(( select Max(dbo.fdxFracToHour(BatchOperationTime) / BatchSize )  from dxPhaseDetail ),0.0)* wo.QuantityToProduce as ExecutionTime
      ,1

    From dxWorkOrder wo
    left outer join dxAssembly  aa on (aa.FK_dxProduct = wo.FK_dxProduct) and  (aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly( wo.FK_dxProduct, wo.WorkorderDate))
    left outer join dxRouting    rt on (aa.FK_dxRouting = rt.PK_dxRouting)
    left outer join dxPhase     ph on (rt.PK_dxRouting = ph.FK_dxRouting)
    where ((PK_dxWorkOrder = @FK_dxWorkOrder) or (PK_dxWorkOrder > @FK_WO ))
      and not rt.PK_dxRouting is null
      and wo.WorkOrderStatus < 4
      and not Exists ( select 1 from dxWorkOrderPhase
                        where FK_dxWorkOrder = wo.PK_dxWorkOrder
                          and IsWorkOrder = 1 )
    Group by wo.PK_dxWorkOrder,wo.WorkOrderDate,wo.QuantityToProduce
    order by wo.PK_dxWorkOrder

    Update wp
      set wp.FK_dxWorkOrderPhase__WorkOrder = ( select PK_dxWorkOrderPhase from dxWorkOrderPhase ww where ww.FK_dxWorkOrder = wp.FK_dxWorkOrder and IsWorkOrder = 1)
    from dxWorkOrderPhase wp
    where ((wp.FK_dxWorkOrder = @FK_dxWorkOrder) or (wp.FK_dxWorkOrder > @FK_WO ))
      and wp.IsWorkOrder = 0

    Update dxWorkOrderPhase set Duration = Case when Duration <=0 then 0.0 else Duration end
    -- ---------------------------------------------------------
    -- Insert Work Order Resource Link to Each Phase
    Insert into dxWorkOrderResource
       (  FK_dxWorkOrderPhase
         ,FK_dxPhaseDetail
         ,FK_dxResource
         ,Hours
       )

     Select
       PK_dxWorkOrderPhase
      ,pd.PK_dxPhaseDetail
      ,pd.FK_dxResource
      ,dbo.fdxFracToHour(pd.BatchOperationTime) / pd.BatchSize * wo.QuantityToProduce

    From dxWorkOrderPhase wp
    left join dxPhaseDetail pd on (wp.FK_dxPhase = pd.FK_dxPhase )
    left join dxWorkOrder   wo on (wo.PK_dxWorkOrder = wp.FK_dxWorkOrder )
    where not Exists ( Select 1 from dxWorkOrderResource where FK_dxWorkOrderPhase = wp.PK_dxWorkOrderPhase 
                                 and FK_dxPhaseDetail = pd.PK_dxPhaseDetail )
      and ((wo.PK_dxWorkOrder = @FK_dxWorkOrder) or (wo.PK_dxWorkOrder > @FK_WO ))
      and not pd.FK_dxResource is null

end
GO
