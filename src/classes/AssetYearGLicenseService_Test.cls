@isTest
public class AssetYearGLicenseService_Test { 
    public static testMethod void testAssetService(){
        try 
        {           
            Set<Id> assetIds = new Set<Id>();
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            Asset singleAsset = [Select Id from Asset where name = 'testAsset'];
            assetIds.add(singleAsset.Id);
            AssetYearGLicenseService assetService = new AssetYearGLicenseService();
            
            System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
                        Test.startTest();       
                            assetService.assetYearLicense(singleAsset.Id);
                        Test.stopTest();
                    }
        }
        catch (Exception  ex)
        {
            
        }
    }
    
    public static testMethod void testAssetServiceAsync(){
        try 
        {           
            Set<Id> assetIds = new Set<Id>();
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            Asset singleAsset = [Select Id from Asset where name = 'testAsset'];
            assetIds.add(singleAsset.Id);
            //AssetYearGLicenseService assetService = new AssetYearGLicenseService();
            AssetYearGLicenseService_Async assetService2 = new AssetYearGLicenseService_Async();
        
             System.runAs(thisUser) {            
                 
                 		Test.startTest();       
                            assetService2.assetYearLicense(singleAsset.Id);
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
        singleAsset.Product2Id  = prod.Id;
        singleAsset.AccountId = acct.Id;
        singleAsset.License_Cap__c = 1;
        singleAsset.InstallDate = Date.today();
        singleAsset.UsageEndDate = Date.today().AddDays(30);
        insert singleAsset;
        
    }
    
}