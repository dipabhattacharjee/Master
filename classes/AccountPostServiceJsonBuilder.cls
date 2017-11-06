/*
 * @author: Vishnu Belkone
 * @TestClass: AccountPostServiceJsonBuilder_Test
 * @Description - This class returns fields for populate fields for account post/put service.
*/
public class AccountPostServiceJsonBuilder {
    public AccountFieldsForServiceWrapper populateFieldsForService( Account singleAccount,Map<String,ISOMapping__c> iso2VsIso3Map,Map<String,AccountTeamMember> teamMemberRoleVsAccountTeamMember){
        PppLearningServiceSettings serviceSettings = new PppLearningServiceSettings();
        AccountFieldsForServiceWrapper accountFieldWrapper = new AccountFieldsForServiceWrapper();       
        accountFieldWrapper.Id = singleAccount.C3_Id__c !=null ?Integer.valueOf(singleAccount.C3_Id__c) :null;
        accountFieldWrapper.SchoolId = null;
        accountFieldWrapper.Name = singleAccount.Name;
        accountFieldWrapper.Email = null;
        if (singleAccount.ShippingCountryCode != null)
        {
            accountFieldWrapper.GeoCode = checkNull(iso2VsIso3Map.get(singleAccount.ShippingCountryCode).Geo_Code__c);
            accountFieldWrapper.CountryCode = checkNull(iso2VsIso3Map.get(singleAccount.ShippingCountryCode).ISO3__c);
        }
        accountFieldWrapper.StateCode = singleAccount.ShippingStateCode;
        accountFieldWrapper.PostalAddress  = getPostalAddress(singleAccount,iso2VsIso3Map);
        accountFieldWrapper.MainAddress  = getMainAddress(singleAccount,iso2VsIso3Map); 
        accountFieldWrapper.IsExceludeFromMailout =null;
        accountFieldWrapper.IsExceludeFromFaxout = null;
        accountFieldWrapper.AccountManagerEmployeeId = singleAccount.owner.C3_Employee_Id__c != null ?Integer.valueOf(singleAccount.owner.C3_Employee_Id__c) :null;
        //system.debug('#THis is test'+Integer.valueOf(teamMemberRoleVsAccountTeamMember.get('Regional Manager').user.C3_Employee_Id__c));
        if (teamMemberRoleVsAccountTeamMember.containsKey('RM'))
        {
            accountFieldWrapper.RegionalManagerEmployeeId = Integer.valueOf(teamMemberRoleVsAccountTeamMember.get('RM').user.C3_Employee_Id__c);
        }else
        {          
            accountFieldWrapper.RegionalManagerEmployeeId = serviceSettings.FakeUserId;           
        }
                
        if (teamMemberRoleVsAccountTeamMember.containsKey('IM'))
        {
             accountFieldWrapper.InternalManagerEmployeeId = Integer.valueOf(teamMemberRoleVsAccountTeamMember.get('IM').user.C3_Employee_Id__c);
        }else{   

            accountFieldWrapper.InternalManagerEmployeeId = serviceSettings.FakeUserId;
            //singleAccount.owner.C3_Employee_Id__c != null ?Integer.valueOf(singleAccount.owner.C3_Employee_Id__c) :null
        }
        system.debug('#THis is test after'+accountFieldWrapper.RegionalManagerEmployeeId);
        //accountFieldWrapper.RegionalManagerEmployeeId = 1;
        //accountFieldWrapper.InternalManagerEmployeeId = 1;
        accountFieldWrapper.Description = singleAccount.Description;      
        accountFieldWrapper.IsActive = singleAccount.Inactive__c == false ?true :false;
        accountFieldWrapper.InactiveDateUtc = null;
        accountFieldWrapper.IsTest = false; 
        accountFieldWrapper.Website = singleAccount.Website;
        accountFieldWrapper.Phone = singleAccount.Phone;
        accountFieldWrapper.Fax = singleAccount.Fax;
        accountFieldWrapper.FocusLevelId = singleAccount.School_Classification__c;
        accountFieldWrapper.MarketSectorCode = 'U';
        accountFieldWrapper.SchoolLowYear = null;
        accountFieldWrapper.SchoolHighYear = null;
        accountFieldWrapper.Status = singleAccount.Status__c;
        accountFieldWrapper.GenderDescription = null;
        accountFieldWrapper.IsGsspSchool = false;
        accountFieldWrapper.DecileId = 1;
        accountFieldWrapper.SchoolRegisterationNumber = '';
        accountFieldWrapper.ReadingEggsCustomerId = singleAccount.Reading_Eggs_ID__c;
        accountFieldWrapper.ClientVat = singleAccount.VAT_Number__c ;//Added new for SMF-1440 - changed from '' to value
        //accountFieldWrapper.VATNumber = singleAccount.VAT_Number__c ;//Added new for SMF-1440
       // accountFieldWrapper.BusinessProfileId = 59;
        accountFieldWrapper.SchoolTypeId = Integer.valueOf(singleAccount.C3SchoolType__c);
        accountFieldWrapper.CurrentSchoolAcademicYear = 0;
        accountFieldWrapper.NameDisplaySettingModelEnum = 0;
        accountFieldWrapper.ExternalId = singleAccount.Id;
        accountFieldWrapper.NumberOfStudents = singleAccount.Total_Number_Students__c;
        accountFieldWrapper.School_Category = singleAccount.Global_School_Category__c;
        accountFieldWrapper.SchoolLowYear = singleAccount.School_Years_Start__c;
        accountFieldWrapper.SchoolHighYear = singleAccount.School_Years_End__c; 
        return accountFieldWrapper;
    }
    //This functiopn returns the Postal address which is billing address of Account for service.
    public AccountFieldsForServiceWrapper.cls_PostalAddress getPostalAddress(Account singleAccount,Map<String,ISOMapping__c> iso2VsIso3Map){
        AccountFieldsForServiceWrapper.cls_PostalAddress postAddress = new AccountFieldsForServiceWrapper.cls_PostalAddress();
       if (singleAccount.BillingCountryCode != null)
        {
            postAddress.RegionName = singleAccount.BillingState;
            if (singleAccount.BillingCountryCode != null)
            {
                postAddress.CountryCode = checkNull(iso2VsIso3Map.get(singleAccount.BillingCountryCode).ISO3__c);
            }
            postAddress.Province = singleAccount.BillingState;
            postAddress.StateCode =  singleAccount.BillingStateCode;
            postAddress.PostCode = singleAccount.BillingPostalCode;
            postAddress.Locality = '';
            //postAddress.UkCountryModelName = 0;
            postAddress.City = singleAccount.BillingCity;
            postAddress.Suburb = singleAccount.BillingCity;
            postAddress.Street1 = singleAccount.BillingStreet;        
            
        }
        return postAddress;
    }
    //This functiopn returns the Main address which is shipping address for service.
    public AccountFieldsForServiceWrapper.cls_MainAddress getMainAddress(Account singleAccount,Map<String,ISOMapping__c> iso2VsIso3Map){
        AccountFieldsForServiceWrapper.cls_MainAddress mainAddress = new AccountFieldsForServiceWrapper.cls_MainAddress();
        mainAddress.RegionName = singleAccount.ShippingState;
        if (singleAccount.ShippingCountryCode != null)
        {
            mainAddress.CountryCode = checkNull(iso2VsIso3Map.get(singleAccount.ShippingCountryCode).ISO3__c);  
        }
        mainAddress.Province = singleAccount.ShippingState;
        mainAddress.StateCode =  singleAccount.ShippingStateCode;
        mainAddress.PostCode = singleAccount.ShippingPostalCode;
        mainAddress.Locality = '';
        //mainAddress.UkCountryModelName = 0;
        mainAddress.City = singleAccount.ShippingCity;
        mainAddress.Suburb = singleAccount.ShippingCity;
        mainAddress.Street1 = singleAccount.ShippingStreet;        
        return mainAddress;
    }
    
    //This function returns converted country code from iso2 to Iso3.  
    private static String checkNull(String CountryCode){
       return CountryCode != null ? CountryCode :null;
    }
}