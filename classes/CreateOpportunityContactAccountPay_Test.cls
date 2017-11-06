@isTest
private class CreateOpportunityContactAccountPay_Test {
	
	@testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    }

	@isTest static void createAccount_AssociateShareServiceCentre_CreateNewOpportunity_APContactIsAssociatedWithOpportunity() {		
		
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();
        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        insert account;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;
        
        List<OpportunityContacts__c> opportunityContacts =  [
				        										Select Id FROM OpportunityContacts__c 
				        										WHERE 
				        										Account__c 				= :account.Id
																AND	Contact__c 			= :contact.Id
																AND	Opportunity__c    	= :fullOpportunity.Id 
																AND	Role__c 			= 'Accounts Payable'
															];

		System.assertEquals(1, opportunityContacts.size());											
	}
	
	@isTest static void createAccount_CreateNewOpportunity_APContactIsNotAssociatedWithOpportunity() {		
		
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();
        //TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        insert account;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;
        
        List<OpportunityContacts__c> opportunityContacts =  [
				        										Select Id FROM OpportunityContacts__c 
				        										WHERE 
				        										Account__c 				= :account.Id
																AND	Contact__c 			= :contact.Id
																AND	Opportunity__c    	= :fullOpportunity.Id 
																AND	Role__c 			= 'Accounts Payable'
															];

		System.assertEquals(0, opportunityContacts.size());
        
	}
	
}