SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Author:		François Baillargé
-- Create date: 27 janvier 2013
-- Description:	Gets data for Process report
CREATE PROCEDURE [dbo].[pdxReportProcess]
 @FK_dxLanguage INT = 1
AS
BEGIN
  SET NOCOUNT ON ;
	WITH ProcessDetail (PK_dxProcessDetail, FK_dxProcess, FK_dxProcessDetailType, Name, ImageIndex, FK_dxProcessDetail__Parent, Caption, Description, ItemNumber) as
	(
		SELECT p.PK_dxProcessDetail,
			   p.FK_dxProcess,
			   p.FK_dxProcessDetailType,
			   p.Name as DetailName,
			   p.ImageIndex,
			   p.FK_dxProcessDetail__Parent,
			   Case
				   when @FK_dxLanguage = 1 then  p.FrenchCaption
				   when @FK_dxLanguage = 2 then  case when Coalesce(p.EnglishCaption,'') = '' then p.FrenchCaption else p.EnglishCaption end
				   when @FK_dxLanguage = 3 then  case when Coalesce(p.SpanishCaption,'') = '' then p.FrenchCaption else p.SpanishCaption end
			   end As Caption,
			   Case
				   when @FK_dxLanguage = 1 then  p.FrenchDescription
				   when @FK_dxLanguage = 2 then  case when p.EnglishDescription is null then p.FrenchDescription else p.EnglishDescription end
				   when @FK_dxLanguage = 3 then  case when p.SpanishDescription is null then p.FrenchDescription else p.SpanishDescription end
			   end As Description,
			   CAST(ROW_NUMBER() OVER(PARTITION BY FK_dxProcessDetail__Parent ORDER BY ProcessDetailOrder,
				 Case
				   when @FK_dxLanguage = 1 then  p.FrenchCaption
				   when @FK_dxLanguage = 2 then  case when Coalesce(p.EnglishCaption,'') = '' then p.FrenchCaption else p.EnglishCaption end
				   when @FK_dxLanguage = 3 then  case when Coalesce(p.SpanishCaption,'') = '' then p.FrenchCaption else p.SpanishCaption end
				 end) AS varchar(max)) as ItemNumber
			FROM dxProcessDetail p
			WHERE p.FK_dxProcess IN (SELECT PK_Value FROM #dxPrimaryKeySelection) AND p.FK_dxProcessDetail__Parent is null
		UNION ALL
		SELECT c.PK_dxProcessDetail,
			   c.FK_dxProcess,
			   c.FK_dxProcessDetailType,
			   c.Name as DetailName,
			   c.ImageIndex,
			   c.FK_dxProcessDetail__Parent,
			   Case
				   when @FK_dxLanguage = 1 then  c.FrenchCaption
				   when @FK_dxLanguage = 2 then  case when Coalesce(c.EnglishCaption,'') = '' then c.FrenchCaption else c.EnglishCaption end
				   when @FK_dxLanguage = 3 then  case when Coalesce(c.SpanishCaption,'') = '' then c.FrenchCaption else c.SpanishCaption end
			   end As Caption,
			   Case
				   when @FK_dxLanguage = 1 then  c.FrenchDescription
				   when @FK_dxLanguage = 2 then  case when c.EnglishDescription is null then c.FrenchDescription else c.EnglishDescription end
				   when @FK_dxLanguage = 3 then  case when c.SpanishDescription is null then c.FrenchDescription else c.SpanishDescription end
			   end As Description,
			   CONVERT(varchar(max), r.ItemNumber + '.' + CAST(ROW_NUMBER() OVER(PARTITION BY c.FK_dxProcessDetail__Parent ORDER BY c.ProcessDetailOrder,
				 Case
				   when @FK_dxLanguage = 1 then  c.FrenchCaption
				   when @FK_dxLanguage = 2 then  case when Coalesce(c.EnglishCaption,'') = '' then c.FrenchCaption else c.EnglishCaption end
				   when @FK_dxLanguage = 3 then  case when Coalesce(c.SpanishCaption,'') = '' then c.FrenchCaption else c.SpanishCaption end
				 end) AS varchar(max))) as ItemNumber
			FROM dxProcessDetail AS c
			INNER JOIN ProcessDetail AS r ON c.FK_dxProcessDetail__Parent = r.PK_dxProcessDetail
			WHERE c.FK_dxProcess IN (SELECT PK_Value FROM #dxPrimaryKeySelection)
	)
	SELECT p.*,
	       pd.Caption as DetailCaption,
	       pd.Description as DetailDescription,
	       pd.PK_dxProcessDetail,
		   pd.FK_dxProcess,
		   pd.FK_dxProcessDetailType,
		   pd.Name as DetailName,
		   pd.ImageIndex,
		   pd.FK_dxProcessDetail__Parent,
		   pd.ItemNumber,
		   s.Logo
	FROM dxSetup s, ProcessDetail pd
	FULL OUTER JOIN
	(SELECT PK_dxProcess
      ,ProcessName
      ,FlowChartInfo
      ,FlowChartImage
      , Case
       when @FK_dxLanguage = 1 then  FrenchCaption
	   when @FK_dxLanguage = 2 then  case when Coalesce(EnglishCaption,'') = '' then FrenchCaption else EnglishCaption end
	   when @FK_dxLanguage = 3 then  case when Coalesce(SpanishCaption,'') = '' then FrenchCaption else SpanishCaption end
        end As ProcessCaption
      , Case
	   when @FK_dxLanguage = 1 then  FrenchDescription
	   when @FK_dxLanguage = 2 then  case when EnglishDescription is null then FrenchDescription else EnglishDescription end
	   when @FK_dxLanguage = 3 then  case when SpanishDescription is null then FrenchDescription else SpanishDescription end
        end As ProcessDescription
      , dbo.fdxGetFKDisplayValue(FK_dxUser__Author, 'dxUser') AS 'Author'
      ,IsSystem
      ,FK_dxReportCategory
     FROM dxProcess
     WHERE PK_dxProcess IN (SELECT PK_Value FROM #dxPrimaryKeySelection)) p on p.PK_dxProcess = pd.FK_dxProcess
     WHERE pd.FK_dxProcess IN (SELECT PK_Value FROM #dxPrimaryKeySelection)
	ORDER BY pd.ItemNumber
END
GO
