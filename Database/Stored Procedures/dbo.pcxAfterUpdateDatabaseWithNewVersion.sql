SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-17
-- Description:	Update Database with this custom procedure after installing a new version of this application
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pcxAfterUpdateDatabaseWithNewVersion] 
--Update Database with this custom procedure after installing a new version of this application
as
BEGIN
   -- Replace this with your SQL
   Update dxSetup set Description = '' where PK_dxSetup = -99
END
GO
