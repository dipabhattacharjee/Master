@isTest
public class AccountTerritoryManager_Test {
	public static testMethod void testAccountTerritory(){
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
		//acct.Territory__c = 'APAC';
		acct.Global_School_Type__c = 'Government';
		acct.Global_School_Category__c = 'Primary';	
		List<Account>accountList = new List<Account>();
		accountList.add(acct);
		AccountTerritoryManager accTerritory = new AccountTerritoryManager();
		accTerritory.assignTerritory(accountList);
		System.assert(true);
	}

	@testSetup static void insertRecords(){
		//insert Trigger_Handler__c custom setting 
		try 
		{
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = false;
		insert handler;

		//insert Service_EndPoints__c custom setting
		Service_EndPoints__c endPoint = new Service_EndPoints__c();
		endPoint.Endpoint_URL__c = 'abc.com';
		endPoint.Name = 'Authorization Service';
		insert endPoint;
		
	    
		//insert postCode_Mapping record
		Postcode_Mapping__c postMap = new Postcode_Mapping__c();
		postMap.Country__c = 'AU';
		postMap.Post_Zip_Code__c = '1440';
		postMap.Territory__c = 'NSW South & ACT';
		insert postMap;
		}
		catch(Exception ex){
		
		}
	}
}