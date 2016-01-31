SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-05-19
-- Description:	Retourne une reference concernant la transaction au GL
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetGLReference] ( @FK_dxAccountTransaction int, @PrimaryKeyValue int, @KindOfDocument int )
--Returns Reference Value.
returns varchar(500)
as
BEGIN
  Declare @R varchar(500)

  set @R = [dbo].[fcxGetGLReference] ( @FK_dxAccountTransaction , @PrimaryKeyValue , @KindOfDocument  )

  if @R = ''
  begin
    set @R =   case @KindOfDocument
        WHEN 0   THEN 'Écriture de fin d''année - '+ Convert(varchar(50), @PrimaryKeyValue )
        WHEN 1   THEN 'Écriture de journal - '     + Convert(varchar(50), @PrimaryKeyValue )
        WHEN 2   THEN 'Encaissement - '            + ( select Convert(varchar(50),ID) + ', Client:'+ dbo.fdxGetFKDisplayValue(FK_dxClient,'dxClient') from dxCashReceipt WITH(NOLOCK) where PK_dxCashReceipt =  @PrimaryKeyValue )
        WHEN 3   THEN 'Facture - '                 + ( select Convert(varchar(50),ID) + ', Client:'+ dbo.fdxGetFKDisplayValue(FK_dxClient,'dxClient') from dxInvoice WITH(NOLOCK) where PK_dxInvoice =  @PrimaryKeyValue )
        WHEN 4   THEN 'Paiement - '                + ( select Convert(varchar(50),ID) + ', Fournisseur:'+ dbo.fdxGetFKDisplayValue(FK_dxVendor,'dxVendor') from dxPayment WITH(NOLOCK) where PK_dxPayment =  @PrimaryKeyValue )
        WHEN 5   THEN 'Facture à payer - '         + ( select Convert(varchar(50),ID) + ', Fournisseur:'+ dbo.fdxGetFKDisplayValue(FK_dxVendor,'dxVendor') from dxPayableInvoice WITH(NOLOCK) where PK_dxPayableInvoice =  @PrimaryKeyValue )
        WHEN 6   THEN 'Conciliation - '            + Convert(varchar(50), @PrimaryKeyValue )
        WHEN 7   THEN 'Dépôt - '                   + Convert(varchar(50), @PrimaryKeyValue )
        WHEN 8   THEN 'Encaissement - ' + ( select Convert(varchar(50),ID) + ', Imputation client:'+ dbo.fdxGetFKDisplayValue(FK_dxClient,'dxClient') from dxCashReceipt WITH(NOLOCK) where PK_dxCashReceipt =  @PrimaryKeyValue )

        WHEN 9   THEN 'Ajustement d''inventaire - '+ ( select Convert(varchar(50), PrimaryKeyValue ) + ', '+ Coalesce(ad.Description,'')
                                                         From dxProductTransaction pt WITH(NOLOCK) left join dxInventoryAdjustment ad WITH(NOLOCK) on (ad.PK_dxInventoryAdjustment = pt.PrimaryKeyValue)
                                                        where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 10  THEN 'Paiement - '     + ( select Convert(varchar(50),ID) + ', Imputation fournisseur:'+ dbo.fdxGetFKDisplayValue(FK_dxVendor,'dxVendor') from dxPayment WITH(NOLOCK) where PK_dxPayment =  @PrimaryKeyValue )
        WHEN 11  THEN 'Réception - '  + ( select Convert(varchar(50), PK_dxReception ) + ', '+ dbo.fdxGetFKDisplayValue(re.FK_dxVendor,'dxVendor')
                                           From dxAccountTransaction pt WITH(NOLOCK)
                                           left join dxReceptionDetail rd WITH(NOLOCK) on (rd.PK_dxReceptionDetail = pt.PrimaryKeyValue)
                                           left join dxReception       re WITH(NOLOCK) on (re.PK_dxReception = rd.FK_dxReception )
                                          where PK_dxAccountTransaction = @FK_dxAccountTransaction
                                            and KindOfDocument = 11)
        WHEN 12  THEN 'Livraison - ' + ( select Convert(varchar(50), PrimaryKeyValue ) + ', '+ dbo.fdxGetFKDisplayValue(FK_dxClient,'dxClient')
                                           From dxProductTransaction pt WITH(NOLOCK) left join dxShipping sh WITH(NOLOCK) on (sh.PK_dxShipping = pt.PrimaryKeyValue)
                                          where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 13  THEN 'Cycle Counting - ' +Convert(varchar(50), @PrimaryKeyValue )
        WHEN 14  THEN 'Transfert d''inventaire - ' + ( select Convert(varchar(50), PrimaryKeyValue ) + ', '+ Coalesce(it.Note,'')
                                                         From dxProductTransaction pt WITH(NOLOCK) left join dxInventoryTransfer it WITH(NOLOCK) on (it.PK_dxInventoryTransfer = pt.PrimaryKeyValue)
                                                        where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 15  THEN 'Déclaration - ' + ( select Convert(varchar(50), de.PhaseNumber )+', OF:'+Convert(varchar(50), wo.ID )
                                                    From dxProductTransaction pt WITH(NOLOCK)
                                                    left join dxDeclaration            de WITH(NOLOCK) on (de.PK_dxDeclaration = pt.PrimaryKeyValue)
                                                    left join dxWorkOrder              wo WITH(NOLOCK) on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
                                                   where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 16  THEN 'Déclaration - ' + ( select Convert(varchar(50), de.PhaseNumber )+', OF:'+Convert(varchar(50), wo.ID )
                                                    From dxProductTransaction pt WITH(NOLOCK)
                                                    left join dxDeclarationConsumption dc WITH(NOLOCK) on (dc.PK_dxDeclarationConsumption = pt.PrimaryKeyValue)
                                                    left join dxDeclaration            de WITH(NOLOCK) on (de.PK_dxDeclaration = dc.FK_dxDeclaration)
                                                    left join dxWorkOrder              wo WITH(NOLOCK) on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
                                                   where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 17  THEN 'Déclaration - '+ ( select 'Finale' + ', OF:'+Convert(varchar(50), wo.ID )
                                                    From dxProductTransaction            pt WITH(NOLOCK)
                                                    left join dxWorkOrderFinishedProduct dc WITH(NOLOCK) on (dc.PK_dxWorkOrderFinishedProduct = pt.PrimaryKeyValue)
                                                    left join dxWorkOrder                wo WITH(NOLOCK) on (wo.PK_dxWorkOrder = dc.FK_dxWorkOrder)
                                                   where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 18  THEN 'Déclaration - ' + ( select Convert(varchar(50), pt.PhaseNumber )+', OF:'+Convert(varchar(50), wo.ID )
                                                    From dxProductTransaction pt WITH(NOLOCK)
                                                    left join dxDeclarationLabor dc WITH(NOLOCK) on (dc.PK_dxDeclarationLabor = pt.PrimaryKeyValue)
                                                    left join dxDeclaration      de WITH(NOLOCK) on (de.PK_dxDeclaration = dc.FK_dxDeclaration)
                                                    left join dxWorkOrder        wo WITH(NOLOCK) on (wo.PK_dxWorkOrder = de.FK_dxWorkOrder)
                                                    where PK_dxProductTransaction = @PrimaryKeyValue)

        WHEN 19  THEN 'Réservation commande client - ' + ( select Convert(varchar(50), PrimaryKeyValue ) + ', '+ dbo.fdxGetFKDisplayValue(FK_dxClient,'dxClient')
                                     From dxProductTransaction pt WITH(NOLOCK) left join dxClientOrder co WITH(NOLOCK) on (co.PK_dxClientOrder = pt.PrimaryKeyValue)
                                    where PK_dxProductTransaction = @PrimaryKeyValue)
        WHEN 20  THEN 'RMA - ' + ( select Convert(varchar(50), PrimaryKeyValue ) + ', '+ dbo.fdxGetFKDisplayValue(FK_dxClient,'dxClient')
                                     From dxProductTransaction pt WITH(NOLOCK) left join dxRMA sh WITH(NOLOCK) on (sh.PK_dxRMA = pt.PrimaryKeyValue)
                                    where PK_dxProductTransaction = @PrimaryKeyValue)

        WHEN 25  THEN 'Correction inventaire '

     else
       'Non défini - ' +Convert(varchar(50), @PrimaryKeyValue )
     end

     -- Cas spécial pour une réception hors inventaire, il n y a pas de transaction au GL donc on recherche
     -- directement dans les transactions comptable ou le Primary key value est égale au PK_dxReceptionDetail
     if @R is null and  @KindOfDocument = 11

     set @R = 'Réception - '  + ( select Convert(varchar(50), PrimaryKeyValue ) + ', '+ dbo.fdxGetFKDisplayValue(FK_dxVendor,'dxVendor')
                                           From dxProductTransaction pt WITH(NOLOCK)
                                           left join dxReception re WITH(NOLOCK) on (re.PK_dxReception = pt.PrimaryKeyValue)
                                          where PK_dxProductTransaction = @PrimaryKeyValue)

  end

  Return @R
END
GO
