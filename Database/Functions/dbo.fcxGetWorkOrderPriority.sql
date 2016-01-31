SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-06-07
-- Description:	Retour La priorité sur un OF
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fcxGetWorkOrderPriority] ( @FK_dxWorkOrder int )
--Returns the priority.
returns float
as
BEGIN
  Declare @Priority float
  set @Priority = 0.0
  Return @Priority 
END
GO
