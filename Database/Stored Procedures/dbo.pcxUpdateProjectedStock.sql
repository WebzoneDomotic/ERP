SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-09-21
-- Description:	Projected Stock
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pcxUpdateProjectedStock] 
--Update Database with this custom procedure after installing a new version of this application
as
BEGIN
  
   -- Clear table 
   Delete from dxProjectedStock -- do not remove this line
   -- Add your SQL after

END
GO
