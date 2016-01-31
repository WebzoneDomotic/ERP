CREATE TABLE [dbo].[dxMRPLevel]
(
[Level] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[Grouped] [bit] NOT NULL CONSTRAINT [DF_dxMRPLevel_Grouped] DEFAULT ((0))
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxMRPLevel_FK_dxProduct] ON [dbo].[dxMRPLevel] ([FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMRPLevel] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxMRPLevel] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
