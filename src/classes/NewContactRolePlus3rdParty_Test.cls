@isTest
public class NewContactRolePlus3rdParty_Test {

    public static testMethod void testContactWithReference(){
        PageReference pageRef = Page.NewContactwithContactRole;
        Test.setCurrentPageReference(pageRef);        
        Contact testContact  = [Select Id,FirstName,LastName,AccountId from Contact where FirstName = 'test' and LastName = 'testLast'];		
        ApexPages.StandardController sc = new ApexPages.standardController(testContact);
        NewContactRolePlus3rdParty NewContacts = new NewContactRolePlus3rdParty(sc);
        NewContacts.queryContact(testContact.Id);
       
        //Test.setCurrentPageReference('NewContactwithContactRole.myPage'); 
	    System.currentPageReference().getParameters().put('con4_lkid', testContact.AccountId);

        NewContacts.queryContact(null);
        Contact_Roles__c conRole = new Contact_Roles__c();
        conRole.Contact__c = testContact.Id;
        conRole.Role__c = 'Accounts Payable';
        conRole.Role_Status__c = 'Current';
        conRole.IInfluencer__c = true;
        NewContacts.ConRol = conRole;
        NewContacts.saveContact();
        Contact_Roles__c conRole2 = new Contact_Roles__c();
         conRole.Role_Status__c = null;
        conRole.IInfluencer__c = false;
        NewContacts.ConRol = conRole;
         NewContacts.ConRol = conRole2;
        NewContacts.saveContact();

    }

    @testSetup static void insertRecords(){
        //insert Service_EndPoints__c custom setting
        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'abc.com';
        endPoint.Name = 'Authorization Service';
        insert endPoint;

       //insert Trigger_Handler__c custom setting 
        Trigger_Handler__c handler = new Trigger_Handler__c();
        handler.Name = 'Block Trigger';
        handler.Block_Trigger_Execution__c = true;
        insert handler;

        
        //insert Service_EndPoints__c custom setting
        Service_EndPoints__c endPoint1 = new Service_EndPoints__c();
        endPoint1.Endpoint_URL__c = 'abc.com';
        endPoint1.Name = 'Contact Service';
        insert endPoint1;

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

        //insert contact record 
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'testLast';
        con.Phone = '11111111';
        con.AccountId = acct.Id;
        con.Reference_IntoScience__c = true;
        con.Reference_End_Date__c = System.today();
        if (Test.isRunningTest())
        {
            insert con; 
        }    

        
    }
    
}