@isTest
public class AccountPostService_Test {
	public static testMethod void testAccountPostPutService(){
		
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
		
		//ISOMapping__c
		ISOMapping__c isoTest = new ISOMapping__c();
		isoTest.Geo_Code__c = 'test';
		isoTest.ISO3__c = 'AUS';
		Map<String,ISOMapping__c>isOMap  = new Map<String,ISOMapping__c>();
		isOMap.put('AU',isoTest);

		//Account team member Map
		Map<String,AccountTeamMember> teamMemberMap = new Map<String,AccountTeamMember>();
		AccountTeamMember accTeamMemb = new AccountTeamMember();
		accTeamMemb.accountId = acct.Id;
		accTeamMemb.TeamMemberRole = 'AM Manager';
		accTeamMemb.UserId =  UserInfo.getUserId();
		teamMemberMap.put('IM',accTeamMemb);
				
		try 
		{	        
			AccountPostService accountPost = new AccountPostService();
			//AccountPostService.generatePostRequest(acct,'abcsd','Post','testBody');
			//AccountPostService.generateAccountRecordToJson(acct,isOMap,teamMemberMap);
			accountPost.serviceCall(acct, 'abcsd','Post',isOMap,teamMemberMap);  

		}
		catch (Exception  ex)
		{
			
		}
		
	}
	@testSetup static void insertRecords(){
		Service_EndPoints__c endPoint = new Service_EndPoints__c();
		endPoint.Endpoint_URL__c = 'abc.com';
		endPoint.Name = 'Account Service';
		insert endPoint;
	}
}