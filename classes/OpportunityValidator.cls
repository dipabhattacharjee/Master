public  class OpportunityValidator {
	
	private OpportunityData opportunityData;
	private AssetValidator assetValidator;

	public OpportunityValidator() {

		assetValidator 	= new AssetValidator();
		opportunityData = new OpportunityData();
	}

	
	public  void Validate(Opportunity opportunity)
	{
		List<OpportunityLineItem> oppLineItemList = opportunityData.GetOpportunityLineItems(opportunity.Id);
        AssetData assetData = new AssetData();  
         List<Asset> existingAssets = assetData.GetProvisionedAssets(opportunity.AccountId); 

 		for(OpportunityLineItem lineItem : oppLineItemList)
        { 
          	//If Full Licence checkbox or trial licence checkbox has beeen selected
        	if(lineItem.Provision_Full_License__c  && opportunity.StageName == 'Sold' )	
        	{
        	    assetValidator.ValidateIgnoreOpportunity(opportunity.AccountId, lineItem.Family__c, lineItem.SubscriptionStartDate__c, lineItem.SubscriptionEndDate__c, opportunity.Id, 'Full Licence', existingAssets);					
        	}   

        	if( lineItem.Provision_Trial_License__c && opportunity.StageName == 'Trial')
        	{
        		assetValidator.ValidateIgnoreOpportunity(opportunity.AccountId, lineItem.Family__c, lineItem.Trial_Start_Date__c, lineItem.Trial_Start_Date__c.addDays(AssetFactory.TrialLicenceDurationInDays), opportunity.Id, 'Trial Licence', existingAssets);	        		     	
        	}

        }

	}	

	
	public void ValidateUpSell(Opportunity opportunity)
	{
		List<OpportunityLineItem> oppLineItemList = opportunityData.GetOpportunityLineItems(opportunity.Id);
        
        AssetData assetData = new AssetData();  
        List<Asset> existingAssets = assetData.GetProvisionedAssets(opportunity.AccountId); 


 		for(OpportunityLineItem lineItem : oppLineItemList)
        { 
          	//If Full Licence checkbox or trial licence checkbox has beeen selected
        	if(lineItem.Provision_Full_License__c  )	
        	{
        	   assetValidator.HasProvisiedFullLicence(opportunity.AccountId, lineItem.Family__c, lineItem.SubscriptionEndDate__c, existingAssets);
        	}   

        	
        }

	}	

	
}