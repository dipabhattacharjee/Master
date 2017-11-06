@isTest
public class AssetControllerExtension_Test 
{    

    @testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;
    }

    @isTest
    static void testGetSyncMsg()
    {    

        String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(14));

        asset.Name = 'Test';
        asset.CurrencyIsoCode = 'AUD';
        asset.AccountId = account.Id;        

        insert asset;

        Id assetId = asset.Id;        
                
        AssetSyncStatusData.InsertAssetSyncStatus(assetId, 'Success', AssetSyncMsgTypeEnum.Success);        

        ApexPages.StandardController stdAsset = new ApexPages.StandardController(asset);
        AssetControllerExtension objAssetControllerExtension  = new AssetControllerExtension(stdAsset);

        System.assertEquals('Success', objAssetControllerExtension.SyncMessage);
        System.assertEquals('Success', objAssetControllerExtension.MessageType);

    }

    @isTest
    static void testGetSyncMsg_IfMsgDoesNotExistButC3IdPresent_SuccessMsgShouldReturn()
    {    

        String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();        
        insert account; 

        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(14));

        asset.Name = 'Test';
        asset.CurrencyIsoCode = 'AUD';
        asset.AccountId = account.Id;        
        asset.C3_Id__c = 1;

        insert asset;                    

        ApexPages.StandardController stdAsset = new ApexPages.StandardController(asset);
        AssetControllerExtension objAssetControllerExtension  = new AssetControllerExtension(stdAsset);

        System.assertEquals('Licence synchronised successfully', objAssetControllerExtension.SyncMessage);
        System.assertEquals('Success', objAssetControllerExtension.MessageType);

    }

    @isTest
    static void testGetSyncMsg_IfMsgDoesNotExistAndC3IdNotPresent_ErrorMsgShouldReturn()
    {    

        String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();        
        insert account; 

        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(14));

        asset.Name = 'Test';
        asset.CurrencyIsoCode = 'AUD';
        asset.AccountId = account.Id;        

        insert asset;                    

        ApexPages.StandardController stdAsset = new ApexPages.StandardController(asset);
        AssetControllerExtension objAssetControllerExtension  = new AssetControllerExtension(stdAsset);

        System.assertEquals('Licence is not synchronised', objAssetControllerExtension.SyncMessage);
        System.assertEquals('Error', objAssetControllerExtension.MessageType);

    }                 
}