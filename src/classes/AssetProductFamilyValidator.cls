public with sharing class AssetProductFamilyValidator {
	

	public boolean Validate(String productFamily)
	{
		if(productFamily == null)
		{
			throw new ValidationException('ProductFamily cannot be null or empty');
		}

		for(String product : GetLicenceProducts())
		{
			if(product.equalsIgnoreCase(productFamily))
			{
				return true;
			}
		}
		
		throw new ValidationException(productFamily + ' is not a valid product');
	}

	@TestVisible
	private  List<String> GetLicenceProducts()
	{
		List<String> productFamilies = new 	List<String>();
		List<LicencedProduct__c> licenceProducts = LicencedProduct__c.getall().values();

		if(licenceProducts == null || licenceProducts.isEmpty())
		{
			System.debug(Logginglevel.ERROR, 'LicencedProduct__c does not exist!');
			
		}

		for(LicencedProduct__c  licenceProduct : licenceProducts)  
		{
			productFamilies.add(licenceProduct.ProductFamily__c);
		}

		return productFamilies;

	}
}