@isTest
private class OpportunityDuplicateChecker_Test
{
	 @testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

            
        Service_EndPoints__c endPoint1 = new Service_EndPoints__c();
        endPoint1.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint1.Name = 'Contact Service';
        insert endPoint1;


        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint.Name = 'Account Service';
        insert endPoint;

        System.debug('setup done');

    }

    	
	@isTest
	static void AccountwithNewBusinessOpportunity_DuplicateChecker_ShouldReturnFalse()
	{
		  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		insert account;        

		Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();    
		insert opportunity;
		TestUtility.AssignOpportunityToAccount(opportunity, account);

		OpportunityDuplicateChecker opportunityDuplicateChecker = new OpportunityDuplicateChecker();

		List<opportunity> opportunitites= new List<opportunity>();
		opportunitites.add(opportunity);

		Map<Id, List<opportunity>> accountOpportunities= new Map<Id, List<opportunity>>();
		accountOpportunities.put(opportunity.AccountId, opportunitites );
		
		Boolean result = opportunityDuplicateChecker.Exist(opportunity, 'Mathletics', accountOpportunities);

		System.assertEquals(false    ,result,'Duplicate opty checker should return false');

       
	}

	@isTest
	static void AccountWithUpSellOpportunity_DuplicateChecker_ShouldReturnTrue()
	{
		  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		insert account;        

		Opportunity opportunity = FakeObjectFactory.GetUpSellOpportunity();
		opportunity.Name = 'Up Sell - Mathletics';
		insert opportunity;		
		TestUtility.AssignOpportunityToAccount(opportunity, account);

		OpportunityDuplicateChecker opportunityDuplicateChecker = new OpportunityDuplicateChecker();

		List<opportunity> opportunitites= new List<opportunity>();

		opportunitites.add(opportunity);

		Map<Id, List<opportunity>> accountOpportunities= new Map<Id, List<opportunity>>();
		accountOpportunities.put(opportunity.AccountId, opportunitites);
		
		Boolean result = opportunityDuplicateChecker.Exist(opportunity, 'Mathletics', accountOpportunities);

		System.assertEquals(true    ,result,'Up Sell Opportunity Found');

       
	}

/*
	@isTest
	static void OpportunityWithoutAnyAccount_Calling_DuplicateOpportunityChecker_ShouldThrowValidationException()
	{		  
		OpportunityDuplicateChecker opportunityDuplicateChecker = new OpportunityDuplicateChecker();

		Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();    
		
		String exceptionMessage='';

		try {
			
			opportunityDuplicateChecker.Exist(opportunity,'Mathletics');

		} catch(ValidationException e) {

			exceptionMessage = e.getMessage();
		}
		

		System.assert(exceptionMessage.contains('Cannot compare opportunity without having AccountId'));   
       
	}
*/
	
/*
	@isTest
	static void AccountWithOneUpsellOpportunity_DuplicateChecker_CreatingNewBusinessOpportunity_ShouldReturnFalse()
	{
		  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		insert account;        


		Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
		opportunity.type		='Up Sell';
		TestUtility.AssignOpportunityToAccount(opportunity, account);
		insert opportunity; 

		OpportunityDuplicateChecker opportunityDuplicateChecker = new OpportunityDuplicateChecker();

		Opportunity new_opportunity = FakeObjectFactory.GetStandardOpportunity();  
		new_opportunity.type 		='New Business'; 
		TestUtility.AssignOpportunityToAccount(new_opportunity, account);


		List<opportunity> opportunitites= new List<opportunity>();
		opportunitites.add(opportunity);

		Map<Id, List<opportunity>> accountOpportunities= new Map<Id, List<opportunity>>();
		accountOpportunities.put(opportunity.AccountId,opportunitites );



		Boolean result = opportunityDuplicateChecker.Exist(new_opportunity,'Mathletics', accountOpportunities );

		System.assertEquals(false ,result,'Duplicate opty checker should return false, as opty type is different');

       
	}*/

	/*@isTest
	static void AccountWithOneOpportunity_DuplicateChecker_UsingTheSameOpportunity_ShouldReturnTrue()
	{
		  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		insert account;        


		Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();   
		TestUtility.AssignOpportunityToAccount(opportunity, account);
		insert opportunity; 

		OpportunityDuplicateChecker opportunityDuplicateChecker = new OpportunityDuplicateChecker();

		Opportunity new_opportunity = FakeObjectFactory.GetStandardOpportunity();   
		TestUtility.AssignOpportunityToAccount(new_opportunity, account);


		Boolean result = opportunityDuplicateChecker.Exist(new_opportunity, 'Mathletics');

		System.assertEquals(true ,result,'Duplicate opty checker should return true');

       
	}*/
	
		
}