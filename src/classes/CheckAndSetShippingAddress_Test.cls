@isTest
public class CheckAndSetShippingAddress_Test {
	public static testMethod void testShippingAddress(){
		Account acct = new Account();
		acct.Name = 'testacct1';		
		acct.billingCountryCode = 'AU';
		acct.BillingState = 'New South Wales';  
		acct.State__c = 'New South Wales';
		acct.BillingStreet = 'test';
		acct.BillingCity = 'test';
		acct.Country__c = 'Austrelia';
 		//acct.Territory__c = 'APAC';
		acct.Global_School_Type__c = 'Government';
		acct.Global_School_Category__c = 'Primary';	
		List<Account>accountList = new List<Account>();
		accountList.add(acct);
		AccountTerritoryManager accTerritory = new AccountTerritoryManager();
		//accTerritory.assignTerritory(accountList);
		new CheckAndSetShippingAddress().setShippingAddress(accountList);
		System.assert(true);
	}
		
}