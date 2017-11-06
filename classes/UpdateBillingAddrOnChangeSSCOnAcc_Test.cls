@isTest
private class UpdateBillingAddrOnChangeSSCOnAcc_Test {
	
	@testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    }

	@isTest static void createSchool_AssociateShareServiceCentre_SSCAddressIsUpdatedOnSchoolBillingAddress() {		
		
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
        List<Account>accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];
        System.debug('These are all Account after update' + accountList1);
        List<X3rd_Party_Address__c> thirdPartyAddress =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c,createddate
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id
				        										AND Postal_Code__c = '2001'	
				        										Order by createddate desc 															
															];
		System.debug('These are all 3rd party address' + thirdPartyAddress);													
		//System.assertEquals(2, thirdPartyAddress.size());											
		System.assertEquals('c/o NSW Government Schools Accounts Payable - Finance Shared Service Centre GPO Box 4037', thirdPartyAddress[0].Street_Address__c);
		System.assertEquals('c/o NSW Government Schools Accounts Payable - Finance Shared Service Centre GPO Box 4037', accountList1[0].BillingStreet);											
	}

	@isTest static void createSchool_AssociateShareServiceCentreWhileCreating_SSCAddressIsUpdatedOnSchoolBillingAddress() {		
		
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();                
        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        insert account;        
     	System.debug('This is after insert' + account);
     	
     	
        List<Account> accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];
        System.debug('This is after update new' + accountList1);

        List<X3rd_Party_Address__c> thirdPartyAddress =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id	
				        										Order by createddate desc 															
															];											

		System.assertEquals(2, thirdPartyAddress.size());													
		System.assertEquals(FakeObjectFactory.GetShareServiceCentreAccount().BillingStreet, accountList1[0].BillingStreet);											
	}

	/*@isTest static void createSchoolWithBillingAddress_AssociateShareServiceCentre_UnLinkSSC_OldSchoolBillingAddressIsUpdatedFromThirdPartyAddresses() {

		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        Account account  = FakeObjectFactory.GetSchoolAccount();                
        insert account;        

        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
        update account;

        account.Shared_Service_Center__c = null;
		Test.startTest();
        update account;
        Test.stopTest();        
        List<Account> accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];

        List<X3rd_Party_Address__c> thirdPartyAddress =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id	
				        										Order by createddate desc 															
															];

		System.assertEquals(2, thirdPartyAddress.size());											
		System.assertEquals('School Street Address', accountList1[0].BillingStreet);
	}*/
	
	/*@isTest static void createSchoolWithOutBillingAddress_AssociateShareServiceCentre_UnLinkSSC_SchoolBillingAddressIsUpdatedToBlank() {
	}

	@isTest static void createSchool_AssociateSSC_UnLinkSSC_LinkedAPContactIsDeleted() {
	}*/

	@isTest static void createSchoolWithOutBillingAddress_AssociateShareServiceCentre_UpdateBillingAddressOnSchool_SchoolBillingAddressIsUpdatedToNewAddress() {
	

		//Create SSC
		Account sharedServiceCentre = FakeObjectFactory.GetShareServiceCentreAccount();
        insert sharedServiceCentre;

        //Associate SSC with a Contact
        Contact contact  = FakeObjectFactory.GetFinanceContact();        
        TestUtility.AssignAccountToContact(sharedServiceCentre, contact);        
        insert contact;

        //Create School
        Account account  = FakeObjectFactory.GetSchoolAccount();                
        insert account;        
        List<Account>accountList = [Select Id,Name,Billing_3rd_Party_ID__c from ACcount where Id = :account.Id];
        System.debug('These are all Account after insert' + accountList);

        //Assign SSC onto the School
        TestUtility.AssignShareServiceCentreToAccount(sharedServiceCentre, account);
		update account;        

		List<X3rd_Party_Address__c> thirdPartyAddress =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c,createddate
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id
				        										AND Postal_Code__c = '2001'	
				        										Order by createddate desc 															
															];
		System.debug('These are all 3rd party address' + thirdPartyAddress);													
		System.assertEquals(1, thirdPartyAddress.size());
		System.assertEquals('c/o NSW Government Schools Accounts Payable - Finance Shared Service Centre GPO Box 4037', thirdPartyAddress[0].Street_Address__c);
        account.BillingStreet = '124 Walker Street';
        
        Test.startTest();
        update account;
        Test.stopTest();

        List<Account> accountList1 = [Select Id,Name,Billing_3rd_Party_ID__c,BillingStreet from ACcount where Id = :account.Id];
        System.debug('These are all Account after update' + accountList1);
        
        List<X3rd_Party_Address__c> thirdPartyAddress2 =  [
				        										Select Id,Account__c,Street_Address__c,State_Province__c,City__c,Address_Type__c,Postal_Code__c,Country__c,createddate
				        										FROM X3rd_Party_Address__c 
				        										WHERE Account__c 				= :account.Id
				        										//AND Postal_Code__c = '2001'	
				        										Order by createddate desc 															
															];
		System.debug('These are all 3rd party address' + thirdPartyAddress2);													
		System.assertEquals(2, thirdPartyAddress2.size());
		//System.assertEquals('c/o NSW Government Schools Accounts Payable - Finance Shared Service Centre GPO Box 4037', thirdPartyAddress[0].Street_Address__c);
        											
		//System.assertEquals('124 Walker Street', thirdPartyAddress2[0].Street_Address__c);
		System.assertEquals('124 Walker Street', accountList1[0].BillingStreet);											

	}

	@isTest static void testFetchClusterIdFromAccountBillingAddressUpdateHelperClass(){

		AccountBillingAddressUpdateHelperClass helper = new AccountBillingAddressUpdateHelperClass();
		Id clusterId = helper.fetchClusterRecordTypeId();
		
	}

}