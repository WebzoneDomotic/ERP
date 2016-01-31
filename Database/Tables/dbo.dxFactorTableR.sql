CREATE TABLE [dbo].[dxFactorTableR]
(
[FK_dxScaleUnit__In] [int] NULL,
[Factor] [float] NULL,
[FK_dxScaleUnit__Out] [int] NULL,
[Steps] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFactorTableR_FK_dxScaleUnit__In] ON [dbo].[dxFactorTableR] ([FK_dxScaleUnit__In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFactorTableR_FK_dxScaleUnit__Out] ON [dbo].[dxFactorTableR] ([FK_dxScaleUnit__Out]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxFactorTableR] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__In_dxFactorTableR] FOREIGN KEY ([FK_dxScaleUnit__In]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxFactorTableR] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Out_dxFactorTableR] FOREIGN KEY ([FK_dxScaleUnit__Out]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
