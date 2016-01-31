CREATE TABLE [dbo].[dxLinkedRecordDocument]
(
[PK_dxLinkedRecordDocument] [int] NOT NULL IDENTITY(1, 1),
[LinkedTableName] [varchar] (100) COLLATE French_CI_AS NOT NULL,
[PrimaryKeyValue] [int] NOT NULL,
[FileName] [varchar] (2000) COLLATE French_CI_AS NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Note] [text] COLLATE French_CI_AS NULL,
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxLinkedRecordDocument_DocumentStatus] DEFAULT ((0)),
[Closed] [bit] NOT NULL CONSTRAINT [DF_dxLinkedRecordDocument_Closed] DEFAULT ((0)),
[DocumentDate] [datetime] NULL,
[ReminderDate] [datetime] NULL,
[PrintDocument] [bit] NOT NULL CONSTRAINT [DF_dxLinkedRecordDocument_PrintDocument] DEFAULT ((0)),
[Rank] [float] NOT NULL CONSTRAINT [DF_dxLinkedRecordDocument_Rank] DEFAULT ((0)),
[FK_dxUser] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create  TRIGGER [dbo].[dxLinkedRecordDocument.trUpdateDocumentStatus] ON [dbo].[dxLinkedRecordDocument]
AFTER INSERT, UPDATE
AS
BEGIN

  Set NOCOUNT ON ;

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxProduct        pr on ( pr.PK_dxProduct = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxProduct'


  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxClientOrder    pr on ( pr.PK_dxClientOrder = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxClientOrder'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxPurchaseOrder  pr on ( pr.PK_dxPurchaseOrder = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxPurchaseOrder'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxInvoice        pr on ( pr.PK_dxInvoice = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxInvoice'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxPayableInvoice        pr on ( pr.PK_dxPayableInvoice = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxPayableInvoice'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxWorkOrder        pr on ( pr.PK_dxWorkOrder = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxWorkOrder'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxDeclaration        pr on ( pr.PK_dxDeclaration = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxDeclaration'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxClient        pr on ( pr.PK_dxClient = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxClient'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxVendor        pr on ( pr.PK_dxVendor = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxVendor'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxPayment        pr on ( pr.PK_dxPayment = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxPayment'

  Update pr
     Set pr.DocumentStatus = ( Select max(DocumentStatus) from dxLinkedRecordDocument lr
                               where ( LinkedTableName    = ei.LinkedTableName )
                                and  ( lr.PrimaryKeyValue = ei.PrimaryKeyValue ) )
  From inserted ei
  left join dxCashReceipt       pr on ( pr.PK_dxCashReceipt = ei.PrimaryKeyValue )
  where ei.LinkedTableName = 'dxCashReceipt'

END
GO
ALTER TABLE [dbo].[dxLinkedRecordDocument] ADD CONSTRAINT [PK_dxLinkedRecordDocument] PRIMARY KEY CLUSTERED  ([PK_dxLinkedRecordDocument]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxLinkedRecordDocument_FK_dxUser] ON [dbo].[dxLinkedRecordDocument] ([FK_dxUser]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxLinkedRecordDocumentLinkedTableName] ON [dbo].[dxLinkedRecordDocument] ([LinkedTableName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxLinkedRecordDocumentPrimaryKey] ON [dbo].[dxLinkedRecordDocument] ([PrimaryKeyValue]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxLinkedRecordDocument] ADD CONSTRAINT [dxConstraint_FK_dxUser_dxLinkedRecordDocument] FOREIGN KEY ([FK_dxUser]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
