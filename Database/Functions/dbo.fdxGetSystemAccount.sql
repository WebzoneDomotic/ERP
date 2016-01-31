SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-03-24
-- Description:	Get System Account
-- --------------------------------------------------------------------------------------------
Create  FUNCTION [dbo].[fdxGetSystemAccount] ()
RETURNS TABLE
AS
    -- Return all system account - used for filtering account list
    RETURN (
          Select FK_dxAccount__ForeignExchangeExpense as FK_dxAccount from dxAccountConfiguration WHERE FK_dxAccount__ForeignExchangeExpense IS NOT NULL
          union all
          Select FK_dxAccount__ProfitAndLoss as FK_dxAccount from dxAccountConfiguration WHERE FK_dxAccount__ProfitAndLoss IS NOT NULL
          Union all
          Select FK_dxAccount__LaborAbsorbed as FK_dxAccount from dxAccountConfiguration WHERE FK_dxAccount__LaborAbsorbed IS NOT NULL
          Union all
          Select FK_dxAccount__OverheadFixedAbsorbed as FK_dxAccount from dxAccountConfiguration WHERE FK_dxAccount__OverheadFixedAbsorbed IS NOT NULL
          Union all
          Select FK_dxAccount__OverheadVariableAbsorbed as FK_dxAccount from dxAccountConfiguration WHERE FK_dxAccount__OverheadVariableAbsorbed IS NOT NULL
          Union all
          Select FK_dxAccount__ProductionMaterialUsage as FK_dxAccount from dxAccountConfiguration WHERE FK_dxAccount__ProductionMaterialUsage IS NOT NULL

          --Union all
          --Select Distinct FK_dxAccount__AP_Tax1 as FK_dxAccount from dxTax
          --Union all
          --Select Distinct FK_dxAccount__AP_Tax2 as FK_dxAccount from dxTax
          --Union all
          --Select Distinct FK_dxAccount__AP_Tax3 as FK_dxAccount from dxTax
          --Union all
          --Select Distinct FK_dxAccount__AR_Tax1 as FK_dxAccount from dxTax
          --Union all
          --Select Distinct FK_dxAccount__AR_Tax2 as FK_dxAccount from dxTax
          --Union all
          --Select Distinct FK_dxAccount__AR_Tax3 as FK_dxAccount from dxTax

          Union all
          Select Distinct FK_dxAccount__Payable as FK_dxAccount from dxCurrency WHERE FK_dxAccount__Payable IS NOT NULL
          Union all
          Select Distinct FK_dxAccount__PayableAccrual as FK_dxAccount from dxCurrency WHERE FK_dxAccount__PayableAccrual IS NOT NULL
          Union all
          Select Distinct FK_dxAccount__Receivable as FK_dxAccount from dxCurrency WHERE FK_dxAccount__Receivable IS NOT NULL
          Union all
          Select Distinct FK_dxAccount__ReceivableAccrual as FK_dxAccount from dxCurrency WHERE FK_dxAccount__ReceivableAccrual IS NOT NULL

          --Union all
          --Select Distinct FK_dxAccount__Material as FK_dxAccount from dbo.dxWarehouse
          --Union all
          --Select Distinct FK_dxAccount__Labor as FK_dxAccount from dbo.dxWarehouse
          --Union all
          --Select Distinct FK_dxAccount__OverheadFixed as FK_dxAccount from dbo.dxWarehouse
          --Union all
          --Select Distinct FK_dxAccount__OverheadVariable as FK_dxAccount from dbo.dxWarehouse

          --Union all
          --Select Distinct FK_dxAccount__MaterialCostVariance as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__AdjustmentCostRollup as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__LaborCostVariance as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__OverheadFixedCostVariance as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__OverheadVariableCostVariance as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__CostOfSalesMaterial as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__CostOfSalesLabor as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__CostOfSalesOverheadFixed as FK_dxAccount from dbo.dxProductCategory
          --Union all
          --Select Distinct FK_dxAccount__CostOfSalesOverheadVariable as FK_dxAccount from dbo.dxProductCategory

          Union all
          Select Distinct FK_dxAccount__ForeignExchangeReference as FK_dxAccount from dxAccount where not FK_dxAccount__ForeignExchangeReference is null
          Union all
          Select Distinct FK_dxAccount__GL as FK_dxAccount from dbo.dxBankAccount WHERE FK_dxAccount__GL IS NOT NULL
           )
    --Select  FK_dxAccount from  [dbo].[fdxGetSystemAccount]()
GO
