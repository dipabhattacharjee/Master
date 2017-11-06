@isTest
private class UpdateLicenceStatus_Test
{
	@testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    }

	@isTest
	static void ifProvisionedAssetHas_EndDateBeforeToday_UpdateAssetToExpired()
	{
		 String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.Product2Id = product.Id;
        asset.AccountId = account.Id;
        asset.UsageEndDate = date.today().addDays(-1);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Asset> assetList = new List<Asset>();
        assetList.add(asset);
        UpdateLicenceStatus updateLicence = new UpdateLicenceStatus();
        updateLicence.execute(assetList);
       
	}
	@isTest
	static void ifExpiredAssetHas_EndDate90DaysBeforeToday_UpdateAssetToLost()
	{
		String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.Product2Id = product.Id;
        asset.AccountId = account.Id;
        asset.UsageEndDate = date.today().addDays(-91);
        asset.Status = 'Expired';
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;
        List<Asset> assetList = new List<Asset>();
        assetList.add(asset);
        UpdateLicenceStatus updateLicence = new UpdateLicenceStatus();
        updateLicence.execute(assetList);
        updateLicence.finish();
	}
}