@isTest
public  class AssetData_Test {
    

     @testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

        String mathletics = 'Mathletics';
        insert new LicencedProduct__c(ProductFamily__c = mathletics, Name = mathletics);
        
        String spellodrome = 'Spellodrome';
        insert new LicencedProduct__c(ProductFamily__c = spellodrome, Name = spellodrome);

        insert new RegionTaxSetting__c( Name                    = 'APAC',
                                        RegionName__c           = 'APAC',
                                        SiteCountry__c          = 'OTHER',
                                        TaxCode__c              = 'EXPS-AU',
                                        TaxCodeInternalId__c    = '10',
                                        TaxRate__c              = 0); 

        Service_EndPoints__c endPoint1 = new Service_EndPoints__c();
        endPoint1.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint1.Name = 'Contact Service';
        insert endPoint1;


        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint.Name = 'Account Service';
        insert endPoint;

        System.debug('setup done');

    }
    
    @isTest
    static void ExtendTrialAsset_PassingNullAsset_ReturnFalse()
    {       
        AssetData assetData = new AssetData();
        
        boolean result= assetData.ExtendTrialAsset(null);

        System.assertEquals(false, result);     

    }

    @isTest
    static void UpdateNumberOfStudent_PassingNullAsset_ReturnFalse()
    {       
        AssetData assetData = new AssetData();
        
        Integer numberOfStudent = 1;
        boolean result= assetData.UpdateNumberOfStudent(null, numberOfStudent);

        System.assertEquals(false, result);     

    }


    @isTest
    static void UpdateAsset_PassingNullAsset_ReturnFalse()
    {       
        AssetData assetData = new AssetData();
        
        Integer quantity = 1;
        boolean result= assetData.UpdateAsset(null, null, null, quantity, 'Any reason');

        System.assertEquals(false, result);     

    }

    @isTest
    static void FindAssets_PassingNotExistingOpportunityId_ReturnNull()
    {       
        AssetData assetData = new AssetData();
        
        Id opportunityId=TestUtility.getFakeId(Opportunity.SObjectType);

        System.assertEquals(null,   assetData.FindAssets(opportunityId));       

    }

    @isTest
    static void FilterAsset_PassingNullAssetList_ReturnNull()
    {       
        AssetData assetData = new AssetData();
        
        System.assertEquals(null,   assetData.FilterAsset(null, 'Any Product', 'Any type'));        

    }

    @isTest
    static void GetAsset_PassingInvalidAssetId_ReturnNull()
    {       
        AssetData assetData = new AssetData();
        
        Id assetId = TestUtility.getFakeId(Asset.SObjectType);

        System.assertEquals(null,   assetData.GetAsset(assetId));       

    }

    @isTest
    static void GetAssets_PassingAccountWithoutAnyAsset_ReturnZeroAssets()
    {       
        AssetData assetData = new AssetData();
        
        Id accountId = TestUtility.getFakeId(Account.SObjectType);

        List<Asset> assets = assetData.GetAssets(accountId, 'Any Product');     

        System.assertEquals(0, assets.size());

    }

    @isTest
    static void HavingOneProvisionedAssetWith10Auantity_Add10MoreStudent_NumberOfStudentShouldBeIncreasedTo20()
    {           
        String productFamily = 'Mathletics';
        
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account;
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
       
        Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(20));
        asset.AccountId = account.Id;
        asset.License_Cap__c  = 10;
        insert asset;   


        AssetData assetData = new AssetData();

        Boolean result = assetData.UpdateNumberOfStudent(asset, 10);

          //Get all assets for the created account
        List<Asset> assets =         [select
                                           License_Cap__c
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];     


        System.assertEquals(true  , result);
        System.assertEquals(20  , assets[0].License_Cap__c);
            
    
    }

    @isTest
    static void HavingOneProvisionedAssetWhcihExpiresTomorrow_ThenExtendTrial_TrialShouldBeExtenedToNext14Days()
    {           
        String productFamily = 'Mathletics';
        
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account;
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
       
        Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(20));
        asset.AccountId = account.Id;
        asset.License_Cap__c  = 10;
        asset.UsageEndDate = date.today().addDays(1);
        insert asset;   


        AssetData assetData = new AssetData();

        Boolean result = assetData.ExtendTrialAsset(asset);

          //Get all assets for the created account
        List<Asset> assets =         [select
                                           UsageEndDate
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];     
                                            

        System.assertEquals(true  , result);
        System.assertEquals(date.today().addDays(14)  , assets[0].UsageEndDate);
            
    
    }


 @isTest
    static void HavingOneProvisionedAssetWhcihExpiresTomorrow_ThenUpdateTrial_TrialShouldBeExtenedToNext14Days()
    {           
        String productFamily = 'Mathletics';
        
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account;
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
       
        Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(20));
        asset.AccountId = account.Id;         
        insert asset;   

        AssetData assetData = new AssetData();

        Boolean result = assetData.UpdateAsset(asset, date.today(), date.today().addDays(10), 1, 'Pending Sale Confirmation');

        //Get all assets for the created account
        List<Asset> assets =         [select
                                           UsageEndDate,    InstallDate, 
                                           License_Cap__c,  Extension_Reason__c
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];     
                                            

        System.assertEquals(true                                , result);
        System.assertEquals( 1                                  , assets.size());
        System.assertEquals( date.today()                       , assets[0].InstallDate);
        System.assertEquals( date.today().addDays(10)           , assets[0].UsageEndDate);
        System.assertEquals( 1                                  , assets[0].License_Cap__c);
           
            
    
    }
}