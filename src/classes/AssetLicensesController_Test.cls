@isTest
public class AssetLicensesController_Test { 
     public static testMethod void testAssetController() {
        PageReference pageRef = Page.AssetLicencesRenewal;
        Test.setCurrentPage(pageRef);
        AssetLicensesController controller = new AssetLicensesController();
        controller.isValidated = true;
        controller.isSelected = true;
        controller.territoryType = 'My';
        //opportunity 
        Opportunity opp = new Opportunity();
        opp.Start_Date__c = System.today();
        opp.End_Date__c = System.today();
        opp.CloseDate = System.today();
        

        controller.opp = opp;
        //Test search method
        controller.search();
        controller.validationsOnInput();
        //controller.assetWrapperList[0].isSelected = true;
        controller.createOpportunities();
        controller.getItems();

        
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
        
          //insert product 

        Product2 prod = new Product2();
        prod.name = 'Mathletics';
        prod.Family = 'Mathletics';
        insert prod;  
        
        //insert Asset Record 
        Asset singleAsset = new Asset();
        singleAsset.Name = 'testAsset';
        singleAsset.AccountId = acct.Id;
        singleAsset.Product2Id  = prod.Id;
        singleAsset.InstallDate = System.today();
        singleAsset.UsageEndDate = System.today().AddDays(30);
        singleAsset.License_Cap__c = 1;
        insert singleAsset;
        
    }
}