SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxBOM]  @FK_dxProduct int, @Date Datetime, @Quantity Float
as
Begin
   With dxBOM ( Level, FK_dxAssembly, FK_dxAssemblyDetail, PhaseNumber, FK_dxProduct__Master , FK_dxProduct, TotalNetQuantity,Kit,ParentPhaseKit )
   as
     ( Select
            CONVERT(int,1)
           ,dbo.fdxGetCurrentAssembly( @FK_dxProduct , @Date )

           ,Null
           ,0
           ,Null
           ,@FK_dxProduct
           ,@Quantity
           ,Kit
           ,convert(int,0)
        from dxProduct where PK_dxProduct = @FK_dxProduct

       union all

       Select  B.Level + 1
          ,dbo.fdxGetCurrentAssembly( D.FK_dxProduct , @Date )
          ,D.PK_dxAssemblyDetail
          ,D.PhaseNumber
          ,B.FK_dxProduct
          ,D.FK_dxProduct
          ,D.NetQuantity * B.TotalNetQuantity
          ,pr.kit
          ,Convert(int,b.kit) * b.PhaseNumber
          from dxAssembly A
           inner join dxAssemblyDetail D on ( D.FK_dxAssembly = A.PK_dxAssembly )
           inner join dxBom as B on (B.FK_dxProduct = A.FK_dxProduct )
           inner join dxProduct pr on (pr.PK_dxProduct = D.FK_dxProduct )
          where A.PK_dxAssembly = dbo.fdxGetCurrentAssembly( B.FK_dxProduct , @Date )
            and A.FK_dxProduct = B.FK_dxProduct
     )
     Select bo.*
           ,pr.ID [ProductCode]
           ,pr.Description
           ,su.ID ScaleUnit
           ,Coalesce(aa.NetQuantity, @Quantity ) NetQuantity
           ,Coalesce(aa.PctOfWasteQuantity,0.0) PctOfWasteQuantity
           ,Coalesce(Convert(Float,bo.TotalNetQuantity * (1.0+(aa.PctOfWasteQuantity/100.0))),@Quantity) TotalQuantity
           ,dbo.fdxLeaf(bo.FK_dxProduct,@Date) NumberOfItems
           ,dbo.fdxGetStandardCost         (bo.FK_dxProduct, @Date)        UnitStandardCost
           ,dbo.fdxGetStandardCostByStatus (bo.FK_dxProduct, 0, -1, @Date ) UnitMaterialStandardCost
           ,dbo.fdxGetStandardCostByStatus (bo.FK_dxProduct, 1, -1, @Date ) UnitLaborStandardCost
           ,dbo.fdxGetStandardCostByStatus (bo.FK_dxProduct, 2, -1, @Date ) UnitOverheadFixedStandardCost
           ,dbo.fdxGetStandardCostByStatus (bo.FK_dxProduct, 3, -1, @Date ) UnitOverheadVariableStandardCost

           ,dbo.fdxGetStandardCost(bo.FK_dxProduct, @Date) *
            Coalesce(Convert(Float,bo.TotalNetQuantity * (1.0+(aa.PctOfWasteQuantity/100.0))),@Quantity) StandardCost
      from dxBom bo
     left outer join dxProduct pr on ( pr.PK_dxProduct = bo.FK_dxProduct )
     left outer join dxAssemblyDetail aa on ( aa.PK_dxAssemblyDetail = bo.FK_dxAssemblyDetail)
     left outer join dxScaleUnit su on ( su.PK_dxScaleUnit = pr.FK_dxScaleUnit )
End
GO
