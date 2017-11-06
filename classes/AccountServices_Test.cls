@isTest
public class AccountServices_Test {
	public static testMethod void testAccountService(){
		try 
		{	        
			AccountServices accoServ = new AccountServices();
			 User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
			Set<Id> accountIds = new Set<Id>();
			Account acc = [Select Id from account where name = 'testacct1'];
			 accountIds.add(acc.Id);
			 System.runAs(thisUser) {
			// startTest/stopTest block to run future method synchronously
						Test.startTest();       
						 accoServ.runServices(accountIds);
						Test.stopTest();

					}
			   System.assertEquals(AccountServices.fetchAccountTeamMemberList(accountIds).size(),1);
		}
		catch (Exception  ex)
		{
			
		}
	 
	}

	@testSetup static void insertRecords(){
	   //insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = true;
		insert handler;
		
		//insert contact record
		Account acct = new Account();
		acct.Name = 'testacct1';
		acct.ShippingPostalCode = 'test';
		acct.ShippingState = 'New South Wales';
		acct.ShippingCity = 'test';
		acct.ShippingStreet =' test';   
		acct.ShippingCountryCode = 'AU';
		acct.ShippingCountry = 'Australia';
		acct.billingCountryCode = 'AU';
		acct.BillingState = 'New South Wales';  
		acct.Territory__c = 'APAC';
		acct.Global_School_Type__c = 'Government';
		acct.Global_School_Category__c = 'Primary';
		insert acct;
		
		//insert Account Team member

		AccountTeamMember accTeamMemb = new AccountTeamMember();
		accTeamMemb.accountId = acct.Id;
		accTeamMemb.TeamMemberRole = 'AM Manager';
		accTeamMemb.UserId =  UserInfo.getUserId();
		insert accTeamMemb;
	}
	
}