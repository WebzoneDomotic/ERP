SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxAddressShipping] as
Select
	sh.PK_dxAddress as PK_dxAddress_as,
	sh.ID ID_as,
	sh.Address Address_as,
	sh.CompanyName CompanyName_as,
	sh.FirstName FirstName_as,
	sh.LastName LastName_as,
	sh.Address1 Address1_as,
	sh.Address2 Address2_as,
	sh.Suite Suite_as,
	sh.FK_dxCity FK_dxCity_as,
        ci.ID CityID_as,
        ci.Name CityName_as,
	sh.FK_dxState FK_dxState_as,
        st.ID   StateID_as,
        st.Name StateName_as,
	sh.FK_dxCountry FK_dxCountry_as,
        co.ID CountryID_as,
        co.Name CountryName_as,
	sh.ZipCode ZipCode_as,
	sh.Phone Phone_as,
	sh.Fax Fax_as,
	sh.Cellular Cellular_as,
	sh.EMail EMail_as,
	sh.WebSite WebSite_as,
	sh.Distance Distance_as,
	sh.FK_dxTax FK_dxTax_as,
	sh.FK_dxSetup FK_dxSetup_as,
	sh.FK_dxClient FK_dxClient_as,
	sh.FK_dxVendor FK_dxVendor_as,
	sh.FK_dxEmployee FK_dxEmployee_as,
	sh.DefaultShipping DefaultShipping_as,
	sh.DefaultInvoicing DefaultInvoicing_as,
	sh.DefaultPayment DefaultPayment_as,
	sh.Home Home_as,
	sh.Work Work_as
from dxAddress sh
left outer join dxCity    ci on ( ci.PK_dxCity = sh.FK_dxCity ) 
left outer join dxState   st on ( st.PK_dxState = sh.FK_dxState )  
left outer join dxCountry co on ( co.PK_dxCountry = sh.FK_dxCountry )
GO
