@isTest
private class OpportunityFactory_Test
{
	
	@isTest
	static void Calling_OpportunityFactory_CreateOpportuntityLineItem_OneOpportunityLineItemShouldBeCreated()
	{
		
		Id pricebookEntryId= TestUtility.getFakeId(PriceBookEntry.SObjectType);

		OpportunityLineItem opportunitylineItem = OpportunityFactory.Create(1, true, system.today(), system.today().addDays(30), 1, pricebookEntryId);

		System.assertNotEquals(null, opportunitylineItem);

	}



	@isTest
	static void Calling_OpportunityFactory_CloneOpportuntityLineItem_OneOpportunityLineItemShouldBeCreated()
	{
		
		Id pricebookEntryId= TestUtility.getFakeId(PriceBookEntry.SObjectType);

		OpportunityLineItem opportunityLineItem = OpportunityFactory.Create(1, true, system.today(), system.today().addDays(30), 1, pricebookEntryId);

		OpportunityLineItem clonedOpportunitylineItem = OpportunityFactory.CloneOpportunityLineItem(opportunityLineItem, system.today(),  1, true, 1) ;

		System.assertNotEquals(null, clonedOpportunitylineItem);

	}

	@isTest
	static void Calling_OpportunityFactory_CreateOpportuntity_OneOpportunityShouldBeCreated()
	{
		
		Product2 product = FakeObjectFactory.GetProduct('Mathletics');
        insert product;

        Id pricebookId = Test.getStandardPricebookId();  
      
		Id accountId= TestUtility.getFakeId(Account.SObjectType);

        Opportunity   opportunity  =  OpportunityFactory.Create('Up Sell', 'Standard Opportunity', pricebookId, product.Family, accountId, 'AUD') ; 		

		System.assertNotEquals(null, opportunity);

	}

	

	@isTest
	static void Calling_OpportunityFactory_CloneOpportuntity_OneOpportunityShouldBeCreated()
	{
		
		Product2 product = FakeObjectFactory.GetProduct('Mathletics');
        insert product;

        Id pricebookId = Test.getStandardPricebookId();  

        Id standardOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
      
		
		Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();

        Opportunity   clonedOpportunity  =  OpportunityFactory.CloneOpportunity(opportunity, pricebookId, product.Family, standardOpportunityRecordTypeId) ;
		
		System.assertNotEquals(null, clonedOpportunity);

	}
}