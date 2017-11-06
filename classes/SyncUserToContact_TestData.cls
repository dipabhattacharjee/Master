@isTest
private class SyncUserToContact_TestData {

	@isTest(SeeAllData=true) 
	static void CreateContact_WithOneUserId_ItShouldCreate_OneContact()
	{
		
		User user= [select Id, email from user where IsActive=true and Email != null limit 1];
	 
		 List<Id> userIds= new List<Id>();
		 userIds.add(user.Id);

		 Test.startTest();
		 SyncUserToContact.CreateContact(userIds);
		 Test.stopTest();

		List<Contact> contacts =[Select Id,FirstName, LastName, Email, Status__c 
								from contact
								where Email =: user.Email];

		//system.assertEquals(1, contacts.size(),'one contact should return');

	}
}