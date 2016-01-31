SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[pdxWhereUsed]   @FK_dxProduct int
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
     w.FK_dxAssembly
    ,w.FK_dxAssemblyDetail
    ,w.FK_dxProduct__Master
    ,w.FK_dxProduct
    ,po.Active
    ,po.ID ProductCode
    ,po.Description
    ,a.ID  AssemblyVersion
    ,a.Version
    ,a.EffectiveDate
    ,d.NetQuantity 
     from dxWhereUsed w
     left outer join dxAssembly a on (a.PK_dxAssembly = w.FK_dxAssembly )
     left outer join dxAssemblyDetail d on (d.PK_dxAssemblyDetail = w.FK_dxAssemblyDetail )
     left outer join dxProduct po on (po.PK_dxProduct = w.FK_dxProduct)
   order by 1,2,3 
end
GO
