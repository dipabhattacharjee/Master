@isTest
public class ContactsWithReferenceControllerOpty_test {
    public static testMethod void testContactWithReference(){
        PageReference pageRef = Page.contactsWithReference;
        Test.setCurrentPageReference(pageRef);        
		Opportunity testopty = [Select Id,Name from Opportunity where School_Site_City__c = 'test'];		
        ApexPages.StandardController sc = new ApexPages.standardController(testopty);
        ContactsWithReferenceControllerOpty conWithRefe = new ContactsWithReferenceControllerOpty(sc);
        conWithRefe.contactsWithReferences();

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

        //insert Opportunity record 
        Opportunity testopty = new Opportunity();       
        testopty.Interest_IntoScience__c = true;
		testopty.AccountId = acct.Id;
        testopty.Name = 'TestOpty';
        testopty.CloseDate = System.today() + 2;
        testopty.StageName = 'Interest';
        testopty.Type = 'New Business';        
        insert testopty;
    } 
}