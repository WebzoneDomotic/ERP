SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create  procedure [dbo].[pdxTraceability]   @FK_dxProduct int, @Lot varchar(50), @ADate Datetime, @FK_dxLanguage integer = 1
as
Begin

  With dxTraceability (
        Level


      , KEY_Parent
      , KEY_Child

      , ParentDocument
      , ChildDocument

      , ImageIndex
      , FK_dxReception
      , FK_dxInventoryAdjustment
      , FK_dxInventoryTransfert
      , FK_dxWorkOrder
      , FK_dxShipping
      , FK_dxShippingDetail

      , FK_dxVendor
      , FK_dxClient
      , TransactionDate

      , FK_dxProduct
      , FK_dxProduct__Master
      , Lot
      , Lot__Master
      , Quantity  )
  as
   (
     -- Réception
     Select
             CONVERT(int,1)

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500), 'RE'+Convert(varchar(50),FK_dxReception )) Child

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'Réception ' else 'Reception ' end+Convert(varchar(50),FK_dxReception )) Child

           , 12
           , FK_dxReception
           , Null
           , Null
           , Null
           , Null
           , Null

           , re.FK_dxVendor
           , Null
           , re.TransactionDate

           , FK_dxProduct
           , Null
           , Lot
           , Convert(varchar(50),'')
           , Quantity
           From dxReceptionDetail rd
           inner join dxReception re on ( re.PK_dxReception = rd.FK_dxReception )
           where FK_dxProduct = @FK_dxProduct
            and  Lot = @Lot
            and re.Posted = 1
            and re.TransactionDate >= @ADate

     Union All

     -- Ajustement
     Select
             CONVERT(int,1)

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500), 'ADJ'+Convert(varchar(50),FK_dxInventoryAdjustment )) Child

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'Ajustement ' else 'Adjustment ' end+Convert(varchar(50),FK_dxInventoryAdjustment )) Child

           , 118
           , Null
           , FK_dxInventoryAdjustment
           , Null
           , Null
           , Null
           , Null

           , Null
           , Null
           , re.TransactionDate

           , FK_dxProduct
           , Null
           , Lot
           , Convert(varchar(50),'')
           , Quantity
           From dxInventoryAdjustmentDetail rd
           inner join dxInventoryAdjustment re on ( re.PK_dxInventoryAdjustment = rd.FK_dxInventoryAdjustment )
           where FK_dxProduct = @FK_dxProduct
            and  Lot = @Lot
            and re.Posted = 1
            and re.TransactionDate >= @ADate

     Union All
     -- Produit Fini
     Select
             CONVERT(int,1)

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500), 'WO'+Convert(varchar(50),FK_dxWorkOrder )) Child

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'OF ' else 'WO ' end+Convert(varchar(50),FK_dxWorkOrder ) ) Child

           , 7
           , Null
           , Null
           , Null
           , FK_dxWorkOrder
           , Null
           , Null

           , Null
           , Null
           , rd.TransactionDate

           , FK_dxProduct
           , FK_dxProduct
           , '0'
           , rd.Lot
           , Quantity
           From dxWorkOrderFinishedProduct rd
           inner join dxWorkOrder wo on ( wo.PK_dxWorkOrder = rd.FK_dxWorkOrder )
           where FK_dxProduct = @FK_dxProduct
            and  rd.Lot = @Lot
            and rd.Posted = 1
            and rd.TransactionDate >= @ADate


     -- Transformation de lot -->
     Union All
     Select
             CONVERT(int,1)
           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500),'TR'+Convert(varchar(50),FK_dxInventoryTransfer )) Child

           , Convert(varchar(500),'')  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'Transfert ' else 'Transfer ' end+Convert(varchar(50),FK_dxInventoryTransfer )) Child

           , 119
           , Null
           , Null
           , FK_dxInventoryTransfer
           , Null
           , Null
           , Null

           , Null
           , Null
           , tr.TransactionDate

           , FK_dxProduct
           , Null
           , Lot
           , Convert(varchar(50),'')
           , Quantity
           From dxInventoryTransferDetail td
           inner join dxInventoryTransfer tr on ( tr.PK_dxInventoryTransfer = td.FK_dxInventoryTransfer )
           where FK_dxProduct = @FK_dxProduct
            and  Lot = @Lot
            and  Coalesce(NewLot,'') <> ''
            and  tr.posted = 1
            and  tr.TransactionDate >= @ADate


     -- Transformation de lot enfant
     Union All
     Select
             tr.Level + 1
           , tr.KEY_Child  Parent
           , Convert(varchar(500),'TR'+Convert(varchar(50),FK_dxInventoryTransfer )) Child

           , tr.ChildDocument  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'Transfert ' else 'Transfer ' end+Convert(varchar(50),FK_dxInventoryTransfer )) Child

           , 119
           , Null
           , Null
           , it.FK_dxInventoryTransfer
           , Null
           , Null
           , Null

           , Null
           , Null
           , tt.TransactionDate

           , it.FK_dxProduct
           , it.FK_dxProduct
           , it.NewLot
           , it.Lot
           , it.Quantity
           From dxInventoryTransferDetail it
           inner join dxInventoryTransfer tt on ( tt.PK_dxInventoryTransfer = it.FK_dxInventoryTransfer )
           inner join dxTraceability  tr on (tr.FK_dxProduct = it.FK_dxProduct and tr.lot = it.Lot)
           where Coalesce(NewLot,'') <> ''
             and tr.Level = 1
             and tt.posted = 1
             and tt.TransactionDate >= @ADate

     -- OF Enfant
     Union All
       select
             tr.Level + 1
           , tr.Key_Child  Parent
           , Convert(varchar(500),tr.Key_Child + '->WO'+Convert(varchar(50),de.FK_dxWorkOrder ) )

           , tr.ChildDocument  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'OF ' else 'WO ' end+Convert(varchar(50),de.FK_dxWorkOrder ) ) --+' - '+convert(Varchar(10), de.PhaseNumber)

           , 7
           , Null
           , Null
           , Null
           , de.FK_dxWorkOrder
           , Null
           , Null

           , Null
           , Null
           , wo.WorkOrderDate

           , co.FK_dxProduct
           , wo.FK_dxProduct
           , co.Lot
           , wo.Lot
           , co.Quantity
           From dxDeclarationConsumption co
           inner join dxDeclaration  de on (de.PK_dxDeclaration = co.FK_dxDeclaration )
           inner join dxWorkOrder    wo on (de.FK_dxWorkOrder   = wo.PK_dxWorkOrder)
           inner join dxTraceability  tr on (tr.FK_dxProduct     = co.FK_dxProduct and tr.lot = co.Lot)
           where (not tr.FK_dxReception is null  or not tr.FK_dxInventoryTransfert is null )
             and co.FK_dxProduct = tr.FK_dxProduct
             and co.posted = 1
             and tr.FK_dxShipping is null
             and de.TransactionDate >= @ADate
     -- OF Parent
     Union All
       select
             tr.Level + 1
           , tr.Key_Child  Parent
           , Convert(varchar(500),tr.Key_Child + '->WO'+Convert(varchar(50),de.FK_dxWorkOrder ))

           , tr.ChildDocument  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'OF ' else 'WO ' end+Convert(varchar(50),de.FK_dxWorkOrder ))

           , 7
           , Null
           , Null
           , Null
           , de.FK_dxWorkOrder
           , Null
           , Null

           , Null
           , Null
           , wo.WorkOrderDate

           , co.FK_dxProduct
           , wo.FK_dxProduct
           , co.Lot
           , wo.Lot
           , co.Quantity
           From dxDeclarationConsumption co
           inner join dxDeclaration  de on (de.PK_dxDeclaration = co.FK_dxDeclaration )
           inner join dxWorkOrder    wo on (de.FK_dxWorkOrder   = wo.PK_dxWorkOrder)
           inner join dxTraceability  tr on (tr.FK_dxProduct__Master = co.FK_dxProduct and tr.lot__Master = co.Lot)
           where co.FK_dxProduct = tr.FK_dxProduct__Master
            and  co.posted = 1
            and  tr.FK_dxShipping is null
            and  de.TransactionDate >= @ADate

     -- Livraison
     Union All
       select
             tr.Level + 1
           , tr.Key_Child  Parent
           , Convert(varchar(500),tr.Key_Child + '->SH'+Convert(varchar(50),sh.FK_dxShipping ))

           , tr.ChildDocument  Parent
           , Convert(varchar(500),case when @FK_dxLanguage =1 then 'Livraison ' else 'Shipping ' end+Convert(varchar(50),sh.FK_dxShipping ))

           , 17
           , Null
           , Null
           , Null
           , Null
           , sh.FK_dxShipping
           , sh.PK_dxShippingDetail

           , Null
           , ss.FK_dxClient
           , ss.TransactionDate

           , sh.FK_dxProduct
           , sh.FK_dxProduct
           , sh.Lot
           , sh.Lot
           , sh.Quantity
           From dxShippingDetail sh
           inner join dxShipping ss on ( ss.PK_dxShipping = sh.FK_dxShipping )
           inner join dxTraceability  tr on (tr.FK_dxProduct__Master = sh.FK_dxProduct and tr.lot__Master = sh.Lot)
           where abs(sh.Quantity) > 0.0000000001
             and tr.FK_dxShipping is null
             and ss.Posted = 1
             and ss.TransactionDate >= @ADate
    )

    Select ROW_NUMBER() OVER(ORDER BY TransactionDate ) AS RowNo,  * from dxTraceability
    order by 1,2,3,4,5,6
end
GO
