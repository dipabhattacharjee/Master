@isTest
private class AssetValidator_Test
{
	@isTest
	static void HavingNewAccount_ValidatingNewLicence_IsValid()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');		

		AssetValidator assetValidator = new AssetValidator();

		Id fakeId=TestUtility.getFakeId(Account.SObjectType);

		Date startDate= date.newInstance(2017, 01, 01);
		Date endDate= date.newInstance(2018, 01, 01);

		boolean result = assetValidator.Validate(fakeId, 'Mathletics', startDate, endDate);

		System.assert(true, result);

	}

	@isTest
	static void HavingNewAccountAndOpportunity_ValidatingNewLicence_IsValid()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');		

		AssetValidator assetValidator = new AssetValidator();

		Id accountId=TestUtility.getFakeId(Account.SObjectType);
		Id opportunityId=TestUtility.getFakeId(Opportunity.SObjectType);

		Date startDate= date.newInstance(2017, 01, 01);
		Date endDate= date.newInstance(2018, 01, 01);

		//Id accountId, String productFamily, Date startDate, Date endDate, Id opportunityId , String type_of_License, List<Asset> existingAssets
		List<Asset> assets = new  List<Asset>();
		boolean result = assetValidator.ValidateIgnoreOpportunity(accountId, 'Mathletics', startDate, endDate, opportunityId, 'Full Licence', assets);


		System.assert(true, result);

	}

	@isTest
	static void HavingNewAccount_HasProvisionedMathleticsLicence_ThrowsValidationException()
	{
		
		AssetValidator assetValidator = new AssetValidator();

		Id accountId=TestUtility.getFakeId(Account.SObjectType);
		
		try
		{
			List<Asset> assets = new  List<Asset>();
			assetValidator.HasProvisiedFullLicence(accountId, 'Mathletics', Date.today(), assets);
		}
		catch(ValidationException ex)
		{
			System.assert(true, ex.getMessage().contains('This account does not have a provisioned full licence'));
		}		

	}

	@isTest
	static void CreatingNewAsset_PassingNullAsset_throwsValidationException()
	{
		
		AssetValidator assetValidator = new AssetValidator();

		try
		{
			assetValidator.ValidateForUpdate(null);
		}
		catch(ValidationException ex)
		{
			System.assert(true, ex.getMessage().contains('Asset cannot be null'));
		}		

	}

	@isTest
	static void UpdatingAsset_PassingNullAsset_throwsValidationException()
	{
		
		AssetValidator assetValidator = new AssetValidator();

		Id accountId=TestUtility.getFakeId(Account.SObjectType);
		
		try
		{
			assetValidator.ValidateForCreate(null);
		}
		catch(ValidationException ex)
		{
			System.assert(true, ex.getMessage().contains('Asset cannot be null'));
		}		

	}
}