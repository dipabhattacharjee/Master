public with sharing class OpportunityData {
	public List<OpportunityLineItem> GetOpportunityLineItems(Id opportunityId)
	{
		   System.debug('OpportunityId printing: ' + opportunityId);
		   List<OpportunityLineItem> oppLineItemList = [select 
			   												Id, name, Product2.Family , Product2Id, Family__c	, Quantity,
			   												Provision_Full_License__c , SubscriptionStartDate__c, SubscriptionEndDate__c , 
	                                                        Provision_Trial_License__c, Trial_Start_Date__c                                                        
                                                        from 
                                                        	OpportunityLineItem 
                                                        where
                                                        	OpportunityId = :opportunityId];  

          	return oppLineItemList;
	}
}