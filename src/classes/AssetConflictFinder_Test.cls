@isTest
private class AssetConflictFinder_Test
{


    @isTest
    static void HavingNullAsset_CallingHasDateConflict_NotHaveAnyConflict()
    {
        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        Asset  asset = null;
        Boolean result;
        result = assetConflictFinder.HasDateConflict(asset, null , null);
        
        System.assertEquals( false , result); 

    }

    @isTest
    static void HavingAsset_PassingStartDateBetweenSubscriptionStartDateAndEndDate_HasConflict()
    {
        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        
        Asset  asset = new Asset();
        asset.InstallDate =  date.newInstance(2016,01,01);
        asset.UsageEndDate =  date.newInstance(2016,05,01);
        
        Boolean result = assetConflictFinder.HasDateConflict(asset,  date.newInstance(2016,02,01) ,  date.newInstance(2016,07,01));
        
        System.assertEquals( true , result); 

    }

    @isTest
    static void HavingAsset_PassingEndDateBetweenSubscriptionStartDateAndEndDate_HasCOnflicet()
    {
        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        
        Asset  asset = new Asset();
        asset.InstallDate =  date.newInstance(2016,01,01);
        asset.UsageEndDate =  date.newInstance(2016,05,01);
        
        Boolean result = assetConflictFinder.HasDateConflict(asset,  date.newInstance(2015,01,01) ,  date.newInstance(2016,04,01));
        
        System.assertEquals( true , result); 

    }

    @isTest
    static void HavingAsset_PassingStartDateAndEndDateNotBetweenSubscriptionStartDateAndEndDate_NotHavingAnyConflict()
    {
        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        
        Asset  asset = new Asset();
        asset.InstallDate =  date.newInstance(2016,01,01);
        asset.UsageEndDate =  date.newInstance(2016,05,01);
        
        Boolean result = assetConflictFinder.HasDateConflict(asset,  date.newInstance(2017,01,01) ,  date.newInstance(2017,04,01));
        
        System.assertEquals( false , result); 

    }

    @isTest
    static void HavingMathleticsAsset_And_StartDateBetween_SubscriptionPeriod_WithDifferentProduct_IsValid()
    {
        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        
        String productFamily = 'Mathletics';
        Id anotherProductId = TestUtility.getFakeId(Product2.SObjectType);
        Asset  asset = new Asset();
        asset.InstallDate =  date.newInstance(2016,01,01);
        asset.UsageEndDate =  date.newInstance(2016,02,01);
        asset.Product2Id = anotherProductId;
        List<Asset> assets=new  List<Asset>();
        assets.add(asset);

        boolean result= assetConflictFinder.Validate(assets , productFamily, date.newInstance(2016,01,15) ,  date.newInstance(2016,01,20));

        System.assertEquals(true, result);
        
        
    }

    @isTest
    static void HavingAsset_PassingStartDateAndEndDateTheSameAsSubscriptionStartDateAndEndDate_HasConflict()
    {
        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        
        Asset  asset = new Asset();
        asset.InstallDate =  date.newInstance(2016,01,01);
        asset.UsageEndDate =  date.newInstance(2016,02,01);
        
        Boolean result = assetConflictFinder.HasDateConflict(asset,  date.newInstance(2016,01,01) ,  date.newInstance(2016,02,01));
        
        System.assertEquals( true , result); 

    }

    @isTest
    static void HavingMathleticsAsset_And_StartDateBetween_SubscriptionPeriod_WithSameProduct_ThrowsConflictException()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

        Account account      = FakeObjectFactory.GetSchoolAccount();
        insert account;

        // Given
        AssetConflictFinder assetConflictFinder = new AssetConflictFinder();
        
        String productFamily    = 'Mathletics';
        List<Asset> assets      = new  List<Asset>();
        Date startDate          = System.today();
        Date endDate            = System.today().addDays(10);

        Product2 product        = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        Asset asset              = FakeObjectFactory.GetTrialAsset(product, startDate , endDate);      
        asset.AccountId          = account.Id;
        insert asset;

        assets =    [select
                        Id, InstallDate, Name, Product_Type__c, Status,
                        Type_of_License__c, recordTypeID, UsageEndDate , Opportunity__c,
                        ProductFamily__c
                    FROM 
                        Asset 
                    WHERE                                           
                       AccountId           = :account.Id];
        
        String message ='';

        try 
        {            
            assetConflictFinder.Validate(assets , productFamily, startDate , endDate);
        } 
        catch(TrialLicenceConflictException e) 
        {           
            message = e.getMessage();          
        }
    
        System.assert(message.contains('There is already a provisioned Trial licence for this product'));       
    }


}