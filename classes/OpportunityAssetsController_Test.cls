@isTest
public class OpportunityAssetsController_Test {
    public static testMethod void testOppAssetController()
    {
        PageReference pageRef = Page.OpportunityAssets;
        Test.setCurrentPageReference(pageRef);
        Opportunity opp = [select Id,name from Opportunity where name = 'testOpp'];
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityAssetsController conWithRefe = new OpportunityAssetsController(sc);
        //conWithRefe.contactsWithReferences(); 
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
        //insert opportunity record 
        Opportunity opp = new Opportunity();
        opp.name = 'testOpp';
        opp.closeDate = Date.valueOf('2016-06-06');
        opp.AccountId = acct.Id;
        opp.Type = 'Renewal';
        opp.Probability = 50;
        opp.StageName = 'Intrest';
        //opp.Won_Lost_Reason__c = ''
        insert opp;
        
          //insert product 

        Product2 prod = new Product2();
        prod.name = 'Mathletics';
        prod.Family = 'Mathletics';
        insert prod;
        
        //insert Asset Record         
        Asset singleAsset = new Asset();
        singleAsset.Name = 'testAsset';
        singleAsset.Product2Id  = prod.Id;
        singleAsset.AccountId = acct.Id;
        singleAsset.UsageEndDate = System.today().addDays(30);
        singleAsset.InstallDate = System.today();
        singleAsset.License_Cap__c = 1;
        insert singleAsset;
        
    }
        
}