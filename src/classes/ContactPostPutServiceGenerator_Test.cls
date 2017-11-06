@isTest
public class ContactPostPutServiceGenerator_Test {
	    public static testMethod void testAccountPostPutService(){
			Contact con = new Contact();
			con.FirstName = 'test';
			con.LastName = 'testLast';
			try 
		{	        
			ContactPostPutServiceGenerator contactPost = new ContactPostPutServiceGenerator();
			//AccountPostService.generatePostRequest(acct,'abcsd','Post','testBody');
			//AccountPostService.generateAccountRecordToJson(acct,isOMap,teamMemberMap);
			contactPost.serviceCall(con, 'abcsd','Post');  

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