SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		François Baillargé
-- Create date: 9 avril 2012
-- Description:	Copy a purchase order
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxCopyPurchaseOrder] 
	@PK_dxPurchaseOrder_ToCopy int = 0, @FK_dxEmployee int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Set the auto increment to the highest value
	Declare @newseed int;
	--SET @newseed = ( select coalesce(max(PK_dxPurchaseOrder),30000) from dxPurchaseOrder ) ;
	--DBCC CHECKIDENT ( 'dxPurchaseOrder' , RESEED, @newseed  );
  
	INSERT INTO [dbo].[dxPurchaseOrder]
           ([FK_dxVendor]
           ,[TransactionDate]
           ,[Description]
           ,[FK_dxAddress__Billing]
           ,[BillingAddress]
           ,[FK_dxAddress__Shipping]
           ,[ShippingAddress]
           ,[FK_dxPaymentType]
           ,[FK_dxProject]
           ,[FK_dxTax]
           ,[FK_dxNote]
           ,[Note]
           ,[FK_dxCurrency]
           ,[FK_dxFOB]
           ,[FOB]
           ,[FK_dxShipVia]
           ,[ShipVia]
           ,[BlanketOrder]
           ,[FK_dxEmployee__Purchasing]
           ,[Closed]
           ,[HavingReception]
           ,[Amount]
           ,[DiscountAmount]
           ,[TotalAmountBeforeTax]
           ,[Tax1Amount]
           ,[Tax2Amount]
           ,[Tax3Amount]
           ,[TotalAmount]
           ,[TaxAmount]
           ,[BalanceAmount]
           ,[FK_dxEmployee__ApprovedBy]
           ,[FK_dxEmployee__DoneBy]
           ,[FK_dxEmployee__RequestBy]
           ,[Posted]
           ,[FK_dxPurchaseOrder__BlanketOrder]
           ,[ExpirationDate]
           ,[ReleaseNumber]
           ,[FK_dxShippingServiceType])
	SELECT 
      [FK_dxVendor]
      ,[TransactionDate]
      ,[Description]
      ,[FK_dxAddress__Billing]
      ,[BillingAddress]
      ,[FK_dxAddress__Shipping]
      ,[ShippingAddress]
      ,[FK_dxPaymentType]
      ,[FK_dxProject]
      ,[FK_dxTax]
      ,[FK_dxNote]
      ,[Note]
      ,[FK_dxCurrency]
      ,[FK_dxFOB]
      ,[FOB]
      ,[FK_dxShipVia]
      ,[ShipVia]
      ,[BlanketOrder]
      ,CASE WHEN @FK_dxEmployee > 0 THEN @FK_dxEmployee ELSE NULL END -- [FK_dxEmployee__Purchasing]
      ,0 -- [Closed]
      ,0 -- [HavingReception]
      ,[Amount]
      ,[DiscountAmount]
      ,[TotalAmountBeforeTax]
      ,[Tax1Amount]
      ,[Tax2Amount]
      ,[Tax3Amount]
      ,[TotalAmount]
      ,[TaxAmount]
      ,[BalanceAmount]
      ,null -- [FK_dxEmployee__ApprovedBy]
      ,CASE WHEN @FK_dxEmployee > 0 THEN @FK_dxEmployee ELSE NULL END -- [FK_dxEmployee__DoneBy]
      ,null -- [FK_dxEmployee__RequestBy]
      ,0    -- [Posted]
      ,null -- [FK_dxPurchaseOrder__BlanketOrder]
      ,null -- [ExpirationDate]
      ,0    -- [ReleaseNumber]
      ,[FK_dxShippingServiceType]
	FROM [dbo].[dxPurchaseOrder]
	WHERE PK_dxPurchaseOrder = @PK_dxPurchaseOrder_ToCopy

	DECLARE @PK_dxPurchaseOrder int;
	SET @PK_dxPurchaseOrder = (SELECT IDENT_CURRENT('dxPurchaseOrder')); 

	INSERT INTO [dbo].[dxPurchaseOrderDetail]
           ([FK_dxPurchaseOrder]
           ,[Closed]
           ,[ExpectedReceptionDate]
           ,[FK_dxProduct]
           ,[Lot]
           ,[Description]
           ,[Quantity]
           ,[ReceivedQuantity]
           ,[FK_dxScaleUnit__Quantity]
           ,[UnitAmount]
           ,[FK_dxScaleUnit__UnitAmount]
           ,[ProductQuantity]
           ,[FK_dxScaleUnit]
           ,[Amount]
           ,[Discount]
           ,[DiscountAmount]
           ,[TotalAmountBeforeTax]
           ,[Tax1Amount]
           ,[Tax2Amount]
           ,[Tax3Amount]
           ,[TaxAmount]
           ,[TotalAmount]
           ,[FK_dxAccount__Expense]
           ,[ApplyTax1]
           ,[ApplyTax2]
           ,[ApplyTax3]
           ,[Tax1Rate]
           ,[Tax2Rate]
           ,[Tax3Rate]
           ,[FK_dxProject]
           ,[Rank]
           ,[DefaultReleaseQuantity]
           ,[AlertQuantity]
           ,[FK_dxShippingServiceType]
           ,[UnitAmountVariance]
           ,[VendorCode])
	SELECT
      @PK_dxPurchaseOrder
      ,0 -- [Closed]
      ,[ExpectedReceptionDate]
      ,[FK_dxProduct]
      ,[Lot]
      ,[Description]
      ,[Quantity]
      ,0.0 -- [ReceivedQuantity]
      ,[FK_dxScaleUnit__Quantity]
      ,[UnitAmount]
      ,[FK_dxScaleUnit__UnitAmount]
      ,[ProductQuantity]
      ,[FK_dxScaleUnit]
      ,[Amount]
      ,[Discount]
      ,[DiscountAmount]
      ,[TotalAmountBeforeTax]
      ,[Tax1Amount]
      ,[Tax2Amount]
      ,[Tax3Amount]
      ,[TaxAmount]
      ,[TotalAmount]
      ,[FK_dxAccount__Expense]
      ,[ApplyTax1]
      ,[ApplyTax2]
      ,[ApplyTax3]
      ,[Tax1Rate]
      ,[Tax2Rate]
      ,[Tax3Rate]
      ,[FK_dxProject]
      ,[Rank]
      ,[DefaultReleaseQuantity]
      ,[AlertQuantity]
      ,[FK_dxShippingServiceType]
      ,[UnitAmountVariance]
      ,[VendorCode]
	FROM [dbo].[dxPurchaseOrderDetail]
	WHERE FK_dxPurchaseOrder = @PK_dxPurchaseOrder_ToCopy
    
    SELECT @PK_dxPurchaseOrder as PK_dxPurchaseOrder
	SET NOCOUNT OFF
END
GO
