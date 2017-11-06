@isTest
public class AssetYGLicenseRequestSender_Test {
    public static testMethod void testAssetPostPutService(){
                    
        try 
        {           
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            List<Asset> assetList = [Select Id,License_Type__c,AccountId,License_Cap__c,School_C3_Id__c,C3_Id__c,Product_Type__c,InstallDate,UsageEndDate from Asset];          
            AssetYGLicenseRequestGeneratorAndSender assetService = new AssetYGLicenseRequestGeneratorAndSender();
             Map<Id,List<Year_Group__c>> assetMap = new  Map<Id,List<Year_Group__c>>();
             Year_Group__c yearGroup = new Year_Group__c();
             yearGroup.Year_Group__c ='Year 1';
             yearGroup.Provision__c = true;
             yearGroup.Asset__c = assetList[0].Id;
             List<Year_Group__c>yearList = new List<Year_Group__c>();
             yearList.add(yearGroup);
             assetMap.put(assetList[0].Id,yearList);
            
             System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
                        Test.startTest(); 
                        assetService.httpRequestGenerater(assetList,'abcdef','testBody');
                            System.assertEquals(assetService.getRequestType(2456), 'PUT');      
                            assetService.licenseRequestGeneraterAndSender(assetList,new Map<Id,List<Year_Group__c>>());
                            
                        Test.stopTest();

                    }
        }
        catch (Exception  e)
        {

            throw e;
        }           
        
        
    }
    
    @testSetup static void insertRecords(){
        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'abc.com';
        endPoint.Name = 'School Licence Service';
        insert endPoint;

         //insert Trigger_Handler__c custom setting 
        Trigger_Handler__c handler = new Trigger_Handler__c();
        handler.Name = 'Block Trigger';
        handler.Block_Trigger_Execution__c = true;
        insert handler;     

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
        List<Product2> ProdIds  = [Select Id from Product2 where Name =: 'Zero Cost Mathletics']; 
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