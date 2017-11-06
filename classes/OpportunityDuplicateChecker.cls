public with sharing class OpportunityDuplicateChecker {
	
	//check agains all inpogress('Sold','Sold-Invoice','Reverse-Sold','Sold-adjustment','Lost') opportunities
	//using opty name and type
	public boolean Exist(Opportunity newOpportunity, String productFamily, map<Id, List<Opportunity>> inProgressOpportunities)
	{
		List<Opportunity> opportunities = GetInprogressAccountOpportunities(newOpportunity.accountId, inProgressOpportunities);

		if(opportunities == null)
		 return false;
		
		system.debug('OpportunityDuplicateChecker.newOpportunity:'+ newOpportunity);


		if(newOpportunity.AccountId == null)
		{
			throw new ValidationException('Cannot compare opportunity without having AccountId');
		}

		system.debug('newOpportunity.AccountId:' + newOpportunity.accountId + ', newOpportunity.Name:' + newOpportunity.name + ', newOpportunity.type:'+newOpportunity.type);

		for(Opportunity opportunity : opportunities)
		{
			if(opportunity.Name.contains(productFamily))
			{
				system.debug('Duplicate Opportunity Found for Account: ' + newOpportunity.accountId + ', newOpportunity.Name:' + newOpportunity.name + ', newOpportunity.type:'+newOpportunity.type);				
				return true;
			}			
		}

		return false;
	}

	private List<Opportunity> GetInprogressAccountOpportunities(Id accountId, map<Id, List<Opportunity>> inProgressOpportunities)
	{
		if(inProgressOpportunities.containsKey(accountId))
		{
			return inProgressOpportunities.get(accountId);
		}

		return null;

	}

	

}