SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[pdxWhereUsedMRP]   @FK_dxProduct int
as
begin
   With dxWhereUsed ( 
    Level
   ,FK_dxAssembly
   ,FK_dxAssemblyDetail
   ,FK_dxProduct__Master
   ,FK_dxProduct
   )
   as
   ( 
   Select 1
   ,a.PK_dxAssembly
   ,d.PK_dxAssemblyDetail
   ,@FK_dxProduct
   ,a.FK_dxProduct
   from dxAssembly A
   inner join dxAssemblyDetail D on ( D.FK_dxAssembly = A.PK_dxAssembly ) 
   inner join dxProduct pr on ( pr.PK_dxProduct = a.FK_dxProduct)
   where d.FK_dxProduct = @FK_dxProduct
   Union all 
   Select B.Level + 1
   ,a.PK_dxAssembly
   ,d.PK_dxAssemblyDetail
   ,b.FK_dxProduct
   ,a.FK_dxProduct
   from dxAssembly A
   inner join dxAssemblyDetail D on ( D.FK_dxAssembly = A.PK_dxAssembly ) 
   inner join dxProduct pr on ( pr.PK_dxProduct = a.FK_dxProduct)
   inner join dxWhereUsed as B on (B.FK_dxProduct = d.FK_dxProduct )
   where d.FK_dxProduct = B.FK_dxProduct
   
   )
   Select 
     Distinct
     w.FK_dxProduct
    ,m.LeadTime
    ,m.PlannedOrderReleases
    ,m.PeriodDate
     from dxWhereUsed w
     left outer join dxMRP m on (m.FK_dxProduct = w.FK_dxProduct )
     where w.FK_dxProduct <> @FK_dxProduct
      and  m.PlannedOrderReleases > 0.000000001
    
  
end
GO
