@isTest
public class AssetSyncStatusData_Test 
{    

    @testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;
            
        System.debug('setup done');

    }
    @isTest
     static void testInsertAssetSyncStatus()
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

        List<AssetSyncStatus__c> assetSyncStatusList = [select Id, Asset__c, Message__c, MessageType__c  FROM AssetSyncStatus__c WHERE Asset__c  = :assetId];        
        
        System.assertEquals(1, assetSyncStatusList.size());
        System.assertEquals(String.valueof(AssetSyncMsgTypeEnum.Success.name()), assetSyncStatusList[0].MessageType__c);
     }
     
     public static testMethod void testInsertAssetSyncStatusException()
     {
        Id createdRecordId;
        string exceptionType;
        
        try
        {
            AssetSyncStatusData.InsertAssetSyncStatus('31231321', 'Success', AssetSyncMsgTypeEnum.Success);                                     
        }
        catch(Exception ex)
        {
            System.assertEquals(ex.getTypeName(), 'System.StringException');
            
        }        
     }     
}