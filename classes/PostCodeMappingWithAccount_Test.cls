@isTest
public class PostCodeMappingWithAccount_Test {
	 public static testMethod void testPostCodeMap(){
		Postcode_Mapping__c postMap = [select Id,Post_Zip_Code__c,Country__c,Territory__c from Postcode_Mapping__c Where Post_Zip_Code__c = 'Test'];
		postMap.Territory__c = 'testTerritory2';
		update postMap;
	 }

	 @testSetup static void insertRecords(){
		//insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = false;
		insert handler;		

		    Postcode_Mapping__c postMap = new Postcode_Mapping__c();
			postMap.Post_Zip_Code__c = 'test';
			postMap.Country__c = 'AUS';
			postMap.Territory__c = 'testTerritory';
			insert postMap;

	 }
}