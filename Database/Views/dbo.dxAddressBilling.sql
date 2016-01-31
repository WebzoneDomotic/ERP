SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxAddressBilling] as
Select
	ab.PK_dxAddress as PK_dxAddress_ab,
	ab.ID ID_ab,
	ab.Address Address_ab,
	ab.CompanyName CompanyName_ab,
	ab.FirstName FirstName_ab,
	ab.LastName LastName_ab,
	ab.Address1 Address1_ab,
	ab.Address2 Address2_ab,
	ab.Suite Suite_ab,
	ab.FK_dxCity FK_dxCity_ab,
        ci.ID CityID_ab,
        ci.Name CityName_ab,
	ab.FK_dxState FK_dxState_ab,
        st.ID   StateID_ab,
        st.Name StateName_ab,
	ab.FK_dxCountry FK_dxCountry_ab,
        co.ID CountryID_ab,
        co.Name CountryName_ab,
	ab.ZipCode ZipCode_ab,
	ab.Phone Phone_ab,
	ab.Fax Fax_ab,
	ab.Cellular Cellular_ab,
	ab.EMail EMail_ab,
	ab.WebSite WebSite_ab,
	ab.Distance Distance_ab,
	ab.FK_dxTax FK_dxTax_ab,
	ab.FK_dxSetup FK_dxSetup_ab,
	ab.FK_dxClient FK_dxClient_ab,
	ab.FK_dxVendor FK_dxVendor_ab,
	ab.FK_dxEmployee FK_dxEmployee_ab,
	ab.DefaultShipping DefaultShipping_ab,
	ab.DefaultInvoicing DefaultInvoicing_ab,
	ab.DefaultPayment DefaultPayment_ab,
	ab.Home Home_ab,
	ab.Work Work_ab
from dxAddress ab
left outer join dxCity    ci on ( ci.PK_dxCity = ab.FK_dxCity ) 
left outer join dxState   st on ( st.PK_dxState = ab.FK_dxState )  
left outer join dxCountry co on ( co.PK_dxCountry = ab.FK_dxCountry )
GO
