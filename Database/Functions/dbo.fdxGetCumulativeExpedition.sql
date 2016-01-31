SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetCumulativeExpedition] ( @FK_dxProduct int , @Date Datetime )
returns float
-- Get Cumulative Expedition align with the Forecast Type
AS
BEGIN  

  Return (Select 
            (case
               when pr.ForecastType = 0 then  -- Daily 
                  dbo.fdxGetPlannedExpedition ( pr.PK_dxProduct , @Date )
               
               when pr.ForecastType = 1 then  -- Weekly
               
                   Coalesce(( Select Coalesce(SUM(cd.ProductQuantity - cd.ShippedQuantity),0.0) from dxClientOrderDetail cd
                              left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
                              where  co.Posted = 1
                                and  cd.FK_dxProduct = pr.PK_dxProduct
                                and  cd.closed = 0 and (cd.ProductQuantity - cd.ShippedQuantity) > 0.0
                                -- First day of current week  = DATEADD(wk,DATEDIFF(wk,0,GETDATE()),0)
                                and  co.ExpectedDeliveryDate between  DATEADD(wk,DATEDIFF(wk,0,@Date),0) and @Date),0.0)
                                 
               when pr.ForecastType = 2 then -- Twice a month ( not available yet )
                  dbo.fdxGetPlannedExpedition ( pr.PK_dxProduct , @Date )
                  
               when pr.ForecastType = 3 then -- Monthtly
                   Coalesce(( Select Coalesce(SUM(cd.ProductQuantity - cd.ShippedQuantity),0.0) from dxClientOrderDetail cd
                              left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
                              where  co.Posted = 1
                                and  cd.FK_dxProduct = pr.PK_dxProduct
                                and  cd.closed = 0 and (cd.ProductQuantity - cd.ShippedQuantity) > 0.0
                                -- First day of current month  = SELECT DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0)
                                and  co.ExpectedDeliveryDate between DATEADD(mm,DATEDIFF(mm,0,@Date),0) and @Date),0.0)
              else 0.0 end )
          From dxProduct pr where PK_dxProduct = @FK_dxProduct)  
  
end
GO
