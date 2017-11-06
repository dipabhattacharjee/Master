@isTest
private class Update3rdPartyAddToUpdateAccBillAdd_Test {
	@testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    }


    @isTest static void createSchool_AssociateShareServiceCentre_RemoveSSCfromSchool() {		
			
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();                
        insert account;        
        List<Account>accountList = [Select Id,Name,Billing_3rd_Party_ID__c from ACcount where Id = :account.Id];
        System.debug('These are all Account after insert' + accountList);


        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        Test.startTest();
        update account;
        Test.stopTest();

        List<X3rd_Party_Address__c> thirdPartyAddress =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c,createddate
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id	
				        										Order by createddate desc 															
															];
		System.debug('These are all 3rd party address' + thirdPartyAddress);	
		System.assertEquals(2, thirdPartyAddress.size());			
      	
        List<Account>accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet,Shared_Service_Center__c from ACcount where Id = :account.Id];
        System.assertEquals(FakeObjectFactory.GetShareServiceCentreAccount().BillingStreet, accountList1[0].BillingStreet);	
      	TestUtility.AssignShareServiceCentreToAccount(new Account(), accountList1[0]);
      	update accountList1;
      	List<Account>accountList2ndUpdate = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];

      
       									
		System.assertEquals(2, thirdPartyAddress.size());											
		
		System.assertEquals(FakeObjectFactory.GetSchoolAccount().BillingStreet, accountList2ndUpdate[0].BillingStreet);											
											
	}

	@isTest static void createSchoolWithBillingAddress_AssociateShareServiceCentre_UpdateBillingAddress_BillingAddressShouldBeDiffFromSharedServceBillingAddress() {
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
       	insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();
        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        insert account;        
         List<Account>accountList = [Select Id,Name,Billing_3rd_Party_ID__c from ACcount where Id = :account.Id];
        System.debug('These are all Account after insert' + accountList);


        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        Test.startTest();
        update account;
        Test.stopTest();
        List<Account>accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];
      	accountList1[0].BillingStreet = FakeObjectFactory.GetSchoolAccount().BillingStreet;
      	//TestUtility.AssignShareServiceCentreToAccount(new Account(), accountList1[0]);
      	update accountList1;
      	List<Account>accountList2ndUpdate = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];
      	System.assertEquals(FakeObjectFactory.GetSchoolAccount().BillingStreet, accountList2ndUpdate[0].BillingStreet);			

	}
	
	@isTest static void createSchool_AssociateSSC_UnLinkSSC_LinkedAPContactIsDeleted() {
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
        

        List<Account>accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet,Shared_Service_Center__c from ACcount where Id = :account.Id];
        System.assertEquals(FakeObjectFactory.GetShareServiceCentreAccount().BillingStreet, accountList1[0].BillingStreet);	
      	TestUtility.AssignShareServiceCentreToAccount(new Account(), accountList1[0]);
      	 Test.startTest();
        update accountList1;
        Test.stopTest();
        List<OpportunityContacts__c> opportunityContacts =  [
				        										Select Id FROM OpportunityContacts__c 
				        										WHERE 
				        										Account__c 				= :account.Id
																AND	Contact__c 			= :contact.Id
																AND	Opportunity__c    	= :fullOpportunity.Id 
																AND	Role__c 			= 'Accounts Payable'
															];

		System.assertEquals(0, opportunityContacts.size());							      

       /* List<OpportunityContacts__c> opportunityContacts =  [
				        										Select Id FROM OpportunityContacts__c 
				        										WHERE 
				        										Account__c 				= :account.Id
																AND	Contact__c 			= :contact.Id
																AND	Opportunity__c    	= :fullOpportunity.Id 
																AND	Role__c 			= 'Accounts Payable'
															];

		System.assertEquals(0, opportunityContacts.size());	*/
	}

	@isTest static void createSchoolNotWithBillingAderess_AssociateSSC_UnLinkSSC_AccountBillingAddressShouldNull() {
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();           
        
        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        insert account;

         List<X3rd_Party_Address__c> thirdPartyAddress =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c,createddate
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id	
				        										Order by createddate desc 															
															];

        List<Account>accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet,Shared_Service_Center__c from ACcount where Id = :account.Id];
        System.assertEquals(FakeObjectFactory.GetShareServiceCentreAccount().BillingStreet, accountList1[0].BillingStreet);	
      	TestUtility.AssignShareServiceCentreToAccount(new Account(), accountList1[0]);
      	Test.startTest();
      	update accountList1;
      	Test.stopTest();
      	List<Account>accountList2ndUpdate = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];

      
       									
		System.assertEquals(2, thirdPartyAddress.size());											
		
		//System.assertEquals(null, accountList2ndUpdate[0].BillingStreet);		

   }
}