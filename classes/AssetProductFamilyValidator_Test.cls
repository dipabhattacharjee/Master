@isTest
private class AssetProductFamilyValidator_Test
{
	@isTest
	static void CallingGetLicenceProducts_WithHavingMathleticsInSettings_ItShouldReturn_Only_AndMathletics()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');

		AssetProductFamilyValidator validator = new AssetProductFamilyValidator();

		List<String> productFamilyList = validator.GetLicenceProducts();

		System.assert(productFamilyList.size() == 1);

		String productFamily= productFamilyList[0];

		System.assert(productFamily.equals('Mathletics'));
				
	}

	@isTest
	static void CallingGetLicenceProducts_HavingTwoItemsInProductFamily_ItShouldReturnTwo()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');

		upsert new LicencedProduct__c(
  		 Name = 'Spellodrome',
    	 ProductFamily__c = 'Spellodrome');

		AssetProductFamilyValidator validator = new AssetProductFamilyValidator();

		List<String> productFamilyList = validator.GetLicenceProducts();

		System.assert(productFamilyList.size() == 2);
				
	}

	@isTest
	static void CallingGetLicenceProducts_WithoutAnyProductFamilyInSettings_ItShouldEmptyList()
	{		
		AssetProductFamilyValidator validator = new AssetProductFamilyValidator();

		List<String> productFamilyList = validator.GetLicenceProducts();

		System.assert(productFamilyList.size() == 0);
				
	}

	@isTest
	static void CallingGetLicenceProducts_HavingMathleticsAsProductFamily_MathleticsIsValid()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');		

		AssetProductFamilyValidator validator = new AssetProductFamilyValidator();
		
		System.assert(validator.Validate('Mathletics'));
				
	}

	@isTest
	static void CallingGetLicenceProducts_ValidatorIsNotCaseSensative()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');		

		AssetProductFamilyValidator validator = new AssetProductFamilyValidator();
		
		System.assert(validator.Validate('Mathletics'));
		System.assert(validator.Validate('mathletics'));
		System.assert(validator.Validate('mathleTics'));
	}

	@isTest
	static void CallingGetLicenceProducts_ValidateAnyProduct_ItShouldThrowsValidationException()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');		

		try
		{
			AssetProductFamilyValidator validator = new AssetProductFamilyValidator();
			validator.Validate('AnyProduct');
		}
		catch(ValidationException ex)
		{				
			System.assert(ex.getMessage().contains('not a valid product'));		
		}
	}


		@isTest
	static void CallingGetLicenceProducts_PassingNullProduct_ItShouldThrowsValidationException()
	{
		upsert new LicencedProduct__c(
  		 Name = 'Mathletics',
    	 ProductFamily__c = 'Mathletics');		

		try
		{
			AssetProductFamilyValidator validator = new AssetProductFamilyValidator();
			validator.Validate(null);
		}
		catch(ValidationException ex)
		{			
			System.assert(ex.getMessage().contains('ProductFamily cannot be null or empty'));		
		}
	}
}