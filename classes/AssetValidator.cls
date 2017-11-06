public  with sharing class AssetValidator {
	
	protected AssetConflictFinder conflictFinder;
	protected AssetProductFamilyValidator  productFamilyValidator;
	private   AssetData assetData;

	public AssetValidator() {

		 conflictFinder 		= new AssetConflictFinder();
		 productFamilyValidator = new AssetProductFamilyValidator();		
		 assetData 				= new AssetData();
	}

	public  boolean Validate(Id accountId, String productFamily, Date startDate, Date endDate)
	{
		List<Asset> existingAssets = assetData.GetAssets(accountId, productfamily);		
		conflictFinder.Validate(existingAssets,  productFamily,  startDate,  endDate);
		productFamilyValidator.Validate(productFamily);

		return true;
	}	

	public boolean ValidateForCreate(Asset asset)
	{
		if(asset == null)
		{			
			throw new ValidationException('Asset cannot be null');
		}
		//productFamilyValidator.Validate(asset.ProductFamily__c);

		if(asset.Id != null)
		{
			List<Asset> existingAssets = assetData.GetAssets(asset.AccountId, asset.ProductFamily__c);

			List<Asset> filteredAssets	= assetData.FilterAsset(existingAssets, asset.Id);

			conflictFinder.Validate(filteredAssets,  asset.ProductFamily__c,  asset.InstallDate,  asset.UsageEndDate);
		}
		else
		{
			this.validate(asset.AccountId ,asset.ProductFamily__c, asset.InstallDate, asset.UsageEndDate);
		}	

		//TODO move to a validator class		
		//if(asset.Status == 'New' && asset.C3_Id__c != null)
		if(asset.C3_Id__c != null || asset.C3_Id__c > 0)
		{
			//throw new ValidationException('Only Asset with 3PLearning licenceId and NEW status can be created');
			throw new ValidationException('Only Asset without 3PLearning licenceId can be created');
		}

		return true;
	}

	public boolean ValidateForUpdate(Asset asset)
	{
		if(asset == null)
		{			
			throw new ValidationException('Asset cannot be null');
		}
		productFamilyValidator.Validate(asset.ProductFamily__c);

		if((asset.Status != 'Lost' && asset.Status != 'Cancelled'))
		{
			List<Asset> existingAssets = assetData.GetAssets(asset.AccountId, asset.ProductFamily__c);

			List<Asset> filteredAssets	= assetData.FilterAsset(existingAssets, asset.Id);

			conflictFinder.Validate(filteredAssets,  asset.ProductFamily__c,  asset.InstallDate,  asset.UsageEndDate);
		}	

		//TODO move to a validator class
		if((asset.Status == 'Provisioned' || asset.Status == 'Cancelled' ||  asset.Status == 'Lost') && (asset.C3_Id__c == null || asset.C3_Id__c <= 0))
		{
			throw new ValidationException('Only Asset with licenceId Can be updated.');
		}

		return true;
	}

	public  boolean ValidateIgnoreOpportunity(Id accountId, String productFamily, Date startDate, Date endDate, Id opportunityId , String type_of_License, List<Asset> existingAssets)
	{
		List<Asset> filteredAssets	= new List<Asset>();	

		for(Asset asset : existingAssets)
		{
			if(asset.Type_of_License__c.equalsIgnoreCase(type_of_License)  &&
			   asset.Opportunity__c 		== opportunityId &&
			 asset.ProductFamily__c 		== productFamily)
			{
				continue;						
			}				

			filteredAssets.add(asset);
		}
		
		conflictFinder.Validate(filteredAssets,  productFamily,  startDate,  endDate);
		productFamilyValidator.Validate(productFamily);

		return true;
	}	

	public boolean HasProvisiedFullLicence(Id accountId, String productFamily, Date endDate, List<Asset> existingAssets)
	{
	
		for(Asset asset : existingAssets)
		{
			if(asset.Type_of_License__c 	== 'Full Licence' &&
			   asset.ProductFamily__c 		== productFamily  &&
			   asset.UsageEndDate 			== endDate)
				return true;
		}

		throw new ValidationException('Expiry Date['+endDate+'] is different from the  '+productFamily +' provisioned licence, please update to the end date ');
	}


}