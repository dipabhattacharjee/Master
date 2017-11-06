@isTest
private class PppLearningLicenceService_Test
{
	@isTest
	static void LicenceService_UpsertLicence_PassingInvalidAssetId()
	{		
		Id assetId= TestUtility.getFakeId(Asset.SObjectType);

		PppLearningLicenceService.UpsertLicenceAsync(assetId);
	}

	@isTest
	static void LicenceService_CreateLicence_PassingInvalidAssetId()
	{	
		Id assetId= TestUtility.getFakeId(Asset.SObjectType);

		PppLearningLicenceService.CreateLicenceAsync(assetId);

	}

	@isTest
	static void LicenceService_UpdateLicence_PassingInvalidAssetId()
	{
		Id assetId= TestUtility.getFakeId(Asset.SObjectType);

		PppLearningLicenceService.UpdateLicenceAsync(assetId);

	}

	@isTest 
	static void LicenceService_CallLicenceService()
	{
		HttpRequest request = new HttpRequest();

		PppLearningLicenceService licenceService = new PppLearningLicenceService();

		licenceService.CallLicenceService(request);

	}

	@isTest 
	static void LicenceService_SerializeAsset()
	{
		Asset asset = new Asset();

		String result = PppLearningLicenceService.SerializeRequestBody(asset);

		System.Assert(result!= null);

	}
}