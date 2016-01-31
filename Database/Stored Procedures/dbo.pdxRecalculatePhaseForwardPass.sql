SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-14
-- Description:	Recalculate Phase Date Linked to a Work Order
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxRecalculatePhaseForwardPass] @FK_dxWorkOrder int, @StartCalculateAtPhase int = -1
as
Begin
   Set NOCOUNT ON
   Declare @Phase Table ( 
       [RecNo]       [int] IDENTITY(1,1) NOT NULL 
      ,[FK_dxPhase] int
      ,[StartDate]  Datetime
      ,[FinishDate] Datetime 
      ,[LateFinishDate] Datetime 
      ,[PhaseNumber] int
      ,[Duration]   Float
      ,[Locked]   bit
      )
   Declare @FK_dxPhase int
         , @RecNo int, @EOF int   
         , @StartDate Datetime
         , @FinishDate Datetime
         , @LateFinishDate Datetime
         , @PhaseNumber int
         , @PriorPhase int
         , @Duration Float
         , @DateNotOk integer = 1
         , @Recalc integer = 0
         , @Locked bit

      
    Delete from @Phase
    Insert into @Phase    
    SELECT 
       [FK_dxPhase]
      ,[StartDate]
      ,[FinishDate]
      ,[LateFinishDate]
      ,[PhaseNumber]
      ,[Duration]
      ,[Locked]
    FROM [dbo].[dxWorkOrderPhase]
    where FK_dxWorkOrder = @FK_dxWorkOrder 
      and (PhaseNumber >= @StartCalculateAtPhase) 
      and IsWorkOrder = 0
    order by [PhaseNumber] asc
     
    Set @RecNo  = 1
    Set @EOF    = ( Select Max([RecNo]) from @Phase )
 
    While @RecNo <= @EOF
    begin
       Select @FK_dxPhase = FK_dxPhase 
             , @StartDate = case When @RecNo > 1 then @FinishDate else StartDate end
             , @FinishDate = FinishDate
             , @LateFinishDate = Coalesce( LateFinishDate , FinishDate )
             , @Duration = Duration
             , @PhaseNumber = PhaseNumber
             , @Locked = Locked
         From @Phase where RecNo = @RecNo
    
       if @Locked = 0 
       begin 
         Set @StartDate  = dbo.fdxGetPrevNextWorkDay (@StartDate-1, 1 )
         Set @FinishDate = dbo.fdxGetFinishDate ( @StartDate, @Duration)
         Set @FinishDate = dbo.fdxGetPrevNextWorkDay (@FinishDate-1, 1 ) 
      
         Update dxWorkOrderPhase
            set StartDate = @StartDate
              , FinishDate = @FinishDate 
          where FK_dxWorkOrder = @FK_dxWorkOrder 
            and  FK_dxPhase = @FK_dxPhase    
            and  IsWorkOrder = 0
       end   

       -- Next Phase  
       set @RecNo = @RecNo+ 1
    end
   
    -- Update Phase Event Representing a  Work Order, grouping event (IsWorkOrder = True)
    Update dxWorkOrderPhase
       set StartDate  = ( select Min(StartDate) from dxWorkOrderPhase where FK_dxWorkOrder = @FK_dxWorkOrder and IsWorkOrder = 0)
         , FinishDate = ( select Max(FinishDate) from dxWorkOrderPhase where FK_dxWorkOrder = @FK_dxWorkOrder and IsWorkOrder = 0)
     where FK_dxWorkOrder = @FK_dxWorkOrder 
       and  IsWorkOrder = 1
   
end
GO
