SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-12-03
-- Description:	Copy an assembly
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxCopyAssembly] @PK_dxAssembly_ToCopy int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	INSERT INTO [dbo].[dxAssembly]
	   ([FK_dxProduct]
      ,[ID]
      ,[FK_dxRouting]
      ,[OptimalBatchSize]
      ,[Version]
      ,[EffectiveDate]
      ,[InactiveDate]
      ,[Instructions])
		
       SELECT 
       [FK_dxProduct]
      ,convert(varchar,GetDate()+1.0) 
      ,[FK_dxRouting]
      ,[OptimalBatchSize]
      ,[Version]
      ,dbo.fdxGetDateNoTime( GetDate()+1.0 )
      ,[InactiveDate]
      ,[Instructions]
  FROM [dbo].[dxAssembly] where PK_dxAssembly = @PK_dxAssembly_ToCopy

  DECLARE @PK_dxAssembly int;
  SET @PK_dxAssembly = (SELECT IDENT_CURRENT('dxAssembly')); 

	INSERT INTO dxAssemblyDetail
	  ([FK_dxAssembly]
      ,[Rank]
      ,[PhaseNumber]
      ,[FK_dxProduct]
      ,[NetQuantity]
      ,[WasteQuantity]
      ,[PctOfWasteQuantity]
      ,[Instructions]
      ,[DismantlingPhaseNumber]
      ,[ControledItem])
  	
	SELECT 
	   @PK_dxAssembly
      ,[Rank]
      ,[PhaseNumber]
      ,[FK_dxProduct]
      ,[NetQuantity]
      ,[WasteQuantity]
      ,[PctOfWasteQuantity]
      ,[Instructions]
      ,[DismantlingPhaseNumber]
      ,[ControledItem]
  FROM [dbo].[dxAssemblyDetail]
  WHERE FK_dxAssembly = @PK_dxAssembly_ToCopy

END
GO
