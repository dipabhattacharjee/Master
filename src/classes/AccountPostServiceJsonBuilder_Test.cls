@isTest(SeeAllData=true)
public class AccountPostServiceJsonBuilder_Test {
   public static testMethod void testAccountServiceJsonBuild(){
    //insert contact record
        Account acct = new Account();
        acct.Name = 'testacct1';
        acct.ShippingPostalCode = 'test';
        acct.ShippingState = 'New South Wales';
        acct.ShippingCity = 'test';
        acct.ShippingStreet =' test';   
        acct.ShippingCountryCode = 'AU';
        acct.ShippingCountry = 'Australia';
        acct.billingCountryCode = 'AU';
        acct.BillingState = 'New South Wales';  
        acct.Territory__c = 'APAC';
        acct.Global_School_Type__c = 'Government';
        acct.Global_School_Category__c = 'Primary';
        
        //ISOMapping__c
        ISOMapping__c isoTest = new ISOMapping__c();
        isoTest.Geo_Code__c = 'test';
        isoTest.ISO3__c = 'AUS';
        Map<String,ISOMapping__c>isOMap  = new Map<String,ISOMapping__c>();
        isOMap.put('AU',isoTest);

        //Account team member Map
        Map<String,AccountTeamMember> teamMemberMap = new Map<String,AccountTeamMember>();
        AccountTeamMember accTeamMemb = new AccountTeamMember();
        accTeamMemb.accountId = acct.Id;
        accTeamMemb.TeamMemberRole = 'IM';
        
        accTeamMemb.UserId =  UserInfo.getUserId();
        teamMemberMap.put('IM',accTeamMemb);
        AccountPostServiceJsonBuilder jsonBuilder = new AccountPostServiceJsonBuilder();
        jsonBuilder.populateFieldsForService(acct,isOMap,teamMemberMap);
   }
}