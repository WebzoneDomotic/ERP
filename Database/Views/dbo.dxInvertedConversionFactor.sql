SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxInvertedConversionFactor] as
Select
    FK_dxScaleUnit__In,
    Factor,
    FK_dxScaleUnit__Out
From dxConversionFactor
Union All
Select
    FK_dxScaleUnit__Out,
    1.0 / Factor,
    FK_dxScaleUnit__In
From dxConversionFactor
GO
