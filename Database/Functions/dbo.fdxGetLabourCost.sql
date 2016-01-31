SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetLabourCost] ( @PK_dxProduct int ,@Date Datetime, @DeclareQuantity Float, @FirstDeclaration int )
returns float
-- Return de PHASE labour cost for a Product at a specific date
AS
BEGIN
    --If first declaration @FirstDeclaration = 1
    --If not a first declaration @FirstDeclaration = 0
    Declare @LabourCost Float,
            @FK_dxResource Float,
            @Rate Float, 
            @InternalSetupTime Float ,
            @ExternalSetupTime Float, 
            @BatchOperationTime Float, 
            @BatchSize Float ,
            @FixeCostPerBatch Float
    
    Declare @Loop Table
         (  
            RecNo int IDENTITY(1,1)
           ,FK_dxResource int
           ,Rate float
           ,InternalSetupTime float
           ,ExternalSetupTime float
           ,BatchOperationTime float
           ,BatchSize float
           ,FixeCostPerBatch float
         )
    Declare @RecNo int, @EOF int
    Set @RecNo = 1
    Insert into @Loop
    Select pd.FK_dxResource, 
           dbo.fdxGetResourceRate(pd.FK_dxResource, @Date), 
           dbo.fdxFracToHour(InternalSetupTime), 
           dbo.fdxFracToHour(ExternalSetupTime), 
           dbo.fdxFracToHour(BatchOperationTime), BatchSize , FixeCostPerBatch
    From dxPhaseDetail pd
    join dxPhase   ph on (pd.FK_dxPhase = ph.PK_dxPhase ) 
    join dxRouting rt on (ph.FK_dxRouting = rt.PK_dxRouting)
    where rt.PK_dxRouting = ( Select top 1 FK_dxRouting from dxAssembly aa 
                               where FK_dxProduct = @PK_dxProduct 
                                 and EffectiveDate <= @Date order by EffectiveDate Desc , Version Desc) ;
    Set @EOF  = ( Select Count(*) from @Loop) 
    -- Calculate phase Labor cost
    set @LabourCost = 0.0 ;
    While @RecNo <= @EOF
    Begin
      -- Get loop value
      Select 
            @FK_dxResource =FK_dxResource 
           ,@Rate = Rate 
           ,@InternalSetupTime =  InternalSetupTime 
           ,@ExternalSetupTime =  ExternalSetupTime 
           ,@BatchOperationTime = BatchOperationTime 
           ,@BatchSize= BatchSize 
           ,@FixeCostPerBatch =FixeCostPerBatch 
      from @Loop where RecNo = @RecNo
      
      if @FirstDeclaration = 0 
      begin
        set @InternalSetupTime = 0.0
        set @ExternalSetupTime = 0.0
      end
      
      set @LabourCost = @LabourCost +
      + ( @InternalSetupTime  * @Rate ) 
      + ( @ExternalSetupTime  * @Rate )
      + ( @BatchOperationTime * @Rate / @BatchSize * @DeclareQuantity )
      + ( @FixeCostPerBatch / @BatchSize * @DeclareQuantity)
      
      set @RecNo = @RecNo + 1  
    end; -- While @RecNo <= @EOF
    RETURN Coalesce(@LabourCost,0.0)
END
GO
