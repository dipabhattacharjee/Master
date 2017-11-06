@isTest
public class ContactServices_Test { 

    public static testMethod void testContactService(){
        try 
        {           
            Set<Id> contactIds = new Set<Id>();
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            Contact con = [Select Id from Contact where LastName = 'testLast'];
            contactIds.add(con.Id);
            ContactServices conService = new ContactServices();
        
             System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
                        Test.startTest();       
                            conService.runServices(contactIds);
                        Test.stopTest();

                    }
        }
        catch (Exception  ex)
        {
            
        }
            
    }

    @testSetup static void insertRecords(){
       //insert Trigger_Handler__c custom setting 
        Trigger_Handler__c handler = new Trigger_Handler__c();
        handler.Name = 'Block Trigger';
        handler.Block_Trigger_Execution__c = true;
        insert handler;     

        ////insert Service_EndPoints__c custom setting
        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'abc.com';
        endPoint.Name = 'Contact Service';
        insert endPoint;
        //insert contact record 
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'testLast';
        con.Phone = '1111111111';
        insert con; 

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
        insert acct;
        
        //insert Account Team member

        AccountTeamMember accTeamMemb = new AccountTeamMember();
        accTeamMemb.accountId = acct.Id;
        accTeamMemb.TeamMemberRole = 'AM Manager';
        accTeamMemb.UserId =  UserInfo.getUserId();
        insert accTeamMemb;
    }
}