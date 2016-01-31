CREATE TABLE [dbo].[dxAccountPeriodToUpdate]
(
[FK_dxAccount] [int] NOT NULL,
[FK_dxPeriod] [int] NOT NULL,
[FK_dxEntry] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountPeriodToUpdate_FK_dxAccount] ON [dbo].[dxAccountPeriodToUpdate] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountPeriodToUpdate_FK_dxEntry] ON [dbo].[dxAccountPeriodToUpdate] ([FK_dxEntry]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountPeriodToUpdate_FK_dxPeriod] ON [dbo].[dxAccountPeriodToUpdate] ([FK_dxPeriod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccountPeriodToUpdate] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxAccountPeriodToUpdate] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountPeriodToUpdate] ADD CONSTRAINT [dxConstraint_FK_dxEntry_dxAccountPeriodToUpdate] FOREIGN KEY ([FK_dxEntry]) REFERENCES [dbo].[dxEntry] ([PK_dxEntry])
GO
ALTER TABLE [dbo].[dxAccountPeriodToUpdate] ADD CONSTRAINT [dxConstraint_FK_dxPeriod_dxAccountPeriodToUpdate] FOREIGN KEY ([FK_dxPeriod]) REFERENCES [dbo].[dxPeriod] ([PK_dxPeriod])
GO
