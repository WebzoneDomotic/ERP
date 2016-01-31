SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-12-10
-- Description:	Custom Post Invoice 
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pcxPostInvoice] @FK_dxInvoice INT, @TransactionDate DATETIME, @KOD INT, @Entry INT, @Journal INT
as
BEGIN
   -- Replace this with your SQL
   Update dxSetup set Description = '' where PK_dxSetup = -99

END
GO
