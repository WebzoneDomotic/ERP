SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetAddress] ( @PK int, @Option int, @SectionOnly int )
returns varchar(2000)
as
begin

  -- Options , starting to get information at
  -- 1 CompanyName
  -- 2 FirstName
  -- 3 Address1
  -- 4 Phone
  -- 5 Fax
  -- 6 Email  
  
  -- Section only
  -- 0 Inactive :  get all  
  -- 1 Active   :  get section information only

  Declare @r varchar(2000);
  Declare @Company      varchar(200) ;
  Declare @Address1     varchar(120) ;
  Declare @Address2     varchar(120) ;
  Declare @Suite        varchar(100) ;
  Declare @ZipCode      varchar(20)  ;
  Declare @FirstName    varchar(120) ;
  Declare @LastName     varchar(120) ;
  Declare @CityName     varchar(120) ;
  Declare @StateCode    varchar(50) ;
  Declare @CountryName  varchar(120) ;
  Declare @TelNumber    varchar(100) ;
  Declare @FaxNumber    varchar(100) ;
  Declare @EMail        varchar(100) ;
  
  Select @Company = Coalesce(CompanyName,''), @FirstName = Coalesce(FirstName,''), @LastName = Coalesce(LastName,''),
         @Address1 = Coalesce(Address1,''), @Suite = Coalesce(Suite,''), @ZipCode = Coalesce(ZipCode,''), 
         @CityName = Coalesce(ci.Name,''), @StateCode = Coalesce(st.ID,''), @CountryName = Coalesce(co.Name,''),
         @TelNumber = Coalesce(ad.Phone,''), @FaxNumber = Coalesce(ad.Fax,''), @EMail = Coalesce(ad.EMail,'')
    from dxAddress ad 
    left outer join dxCity    ci on (ci.PK_dxCity    = ad.FK_dxCity)
    left outer join dxState   st on (st.PK_dxState   = ad.FK_dxState)
    left outer join dxCountry co on (co.PK_dxCountry = ad.FK_dxCountry)
   where PK_dxAddress = @PK 
   
  set @R = '' 
  if @SectionOnly = 0
  begin
     if @option = 1 set @R = @R + @Company   
     if @option <= 2 set @R = @r + CHAR(13) + @FirstName + ' ' + @LastName
     if @option <= 3 set @R = @r + CHAR(13) + dbo.fdxAddStr(@address1,', ',@suite) 
     if @option <= 3 set @R = @r + CHAR(13) + dbo.fdxAddStr(@CityName,', ',@StateCode)   
     if @option <= 3 set @R = @r + CHAR(13) + dbo.fdxAddStr(@CountryName,'   ',@Zipcode)       
     if @option <= 4 set @R = @r + CHAR(13) + 'Tél.:'+@TelNumber        
     if @option <= 5 set @R = @r + CHAR(13) + 'Fax :'+@FaxNumber 
     if @option <= 6 set @R = @r + CHAR(13) + 'Courriel :'+@Email          
  end else
  begin
     if @option = 1 set @R = @R + @Company   
     if @option = 2 set @R = @r + @FirstName + ' ' + @LastName
     if @option = 3 set @R = @r + dbo.fdxAddStr(@address1,', ',@suite) 
     if @option = 3 set @R = @r + CHAR(13)+ dbo.fdxAddStr(@CityName,', ',@StateCode)   
     if @option = 3 set @R = @r + CHAR(13)+ dbo.fdxAddStr(@CountryName,'   ',@Zipcode)       
     if @option = 4 set @R = @r + 'Tél.:'+@TelNumber        
     if @option = 5 set @R = @r + 'Fax :'+@FaxNumber 
     if @option = 6 set @R = @r + 'Courriel :'+@Email          
   end

  Return @r
end
GO
