SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxFactorTable] as
  WITH dxConversionTable (FK_dxScaleUnit__In,Factor,FK_dxScaleUnit__Out, STEPS, Way)
  AS
  (SELECT DISTINCT
  FK_dxScaleUnit__In , convert(float,1.0), FK_dxScaleUnit__In, 0,
  '('+Convert(Varchar(max),FK_dxScaleUnit__In)+')'
  FROM dxInvertedConversionFactor c
  WHERE FK_dxScaleUnit__IN > 0
  UNION ALL
  SELECT
  i.FK_dxScaleUnit__In,o.Factor* i.Factor,o.FK_dxScaleUnit__OUT,i.STEPS + 1 ,
  i.WAY + '(' + Convert(Varchar(max),o.FK_dxScaleUnit__Out)+')'
  FROM dxInvertedConversionFactor AS o
  INNER JOIN dxConversionTable AS i ON i.FK_dxScaleUnit__Out = o.FK_dxScaleUnit__IN
  WHERE i.WAY not LIKE '%(' + Convert(Varchar(max),o.FK_dxScaleUnit__Out) + ')%')
Select * from dxConversionTable
GO
