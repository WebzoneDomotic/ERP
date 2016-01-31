SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-10-30
-- Description:	Transpose la la MRP avec les dates des périodes en abcisse
-- --------------------------------------------------------------------------------------------
create Procedure [dbo].[pdxPivotMRP] @PK_dxLanguage int
as
Declare @SQL varchar(max)
Set @SQL = ''
-- --------------------------------------------------------------------------------
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,1,'ForecastRequirements') 
Set @SQL = @SQL + ' Union all '
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,2,'GrossRequirements')
Set @SQL = @SQL + ' Union all '
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,3,'ScheduledReceipts')
Set @SQL = @SQL + ' Union all '
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,4,'ProjectedOnHand')
Set @SQL = @SQL + ' Union all '
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,5,'NetRequirements')
Set @SQL = @SQL + ' Union all '
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,6,'PlannedOrderReceipts')
Set @SQL = @SQL + ' Union all '
set @SQL = @SQL + [dbo].[fdxSQLPrivotMRP] (@PK_dxLanguage,7,'PlannedOrderReleases') 
Set @SQL = @SQL + ' Order by 1,2 '

exec(@SQL)
GO
