SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxCreatePhaseLocation] 
  @FK_dxWorkOrder   int , 
  @PhaseNumber      int,
  @PK_dxLocation    int out,
  @PriorPhaseNumber int out  

AS
  --Insert the phase location only if does not exists
  INSERT INTO dxLocation ( ID, FK_dxWorkOrder, PhaseNumber )
   select  top 1 Convert(varchar(20), @FK_dxWorkOrder)+'-'+ Convert(varchar(10), @PhaseNumber)
         , @FK_dxWorkOrder , @PhaseNumber 
     from dxLocation 
    where ( not exists ( Select 1 from dxLocation where FK_dxWorkOrder = @FK_dxWorkOrder and PhaseNumber = @PhaseNumber ) )

  set @PK_dxLocation    = ( select PK_dxLocation from dxLocation where FK_dxWorkOrder = @FK_dxWorkOrder and PhaseNumber = @PhaseNumber )
  -- Get Prior Phase Number to this phase according to the routing
  set @PriorPhaseNumber = 
      Coalesce( (Select  Top 1 ph.PhaseNumber
      From dxWorkOrder wo 
      join dxAssembly  aa on (aa.FK_dxProduct = wo.FK_dxProduct) and  (aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly( wo.FK_dxProduct, wo.WorkorderDate)) 
      join dxRouting   rt on (aa.FK_dxRouting = rt.PK_dxRouting)
      join dxPhase     ph on (rt.PK_dxRouting = ph.FK_dxRouting)
      where wo.PK_dxWorkOrder = @FK_dxWorkOrder and ph.PhaseNumber < @PhaseNumber order by PhaseNumber desc )
      , -1 )
GO
