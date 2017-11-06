public with sharing class SyncUserToContact {
	

 @InvocableMethod     
 public static void CreateContact(List<Id> UserIds)     
 {
 	if(UserIds==null || UserIds.isEmpty())
 		return;
 	List<User> users = [select 
 							Id,
 							Email,
 							Region__c,
 							FirstName,
 							LastName,
 							IsActive 
 						from
 							user
 						where 
 							Id in :UserIds ];
 	


   Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Internal 3PL').getRecordTypeId();

   List<Account> internal3PLAccounts = [Select
   											 Id,
   											 Territory__C
   										from
   											 Account
   										 where
   										 	recordTypeId = :accountRecordTypeId ];


   for(User user : users)
   {
   		for(Account account : internal3PLAccounts)
   		{
   			if(user.region__c == null)
   			continue;
   			//user region matches the account territory 
   			//ex: User in APAC and 3pl account for APAC
   			if(user.Region__c.equals(account.Territory__c))
   			{
   				//Check if the user already exist as a contact in the account
   				List<Contact> contacts = [Select Id, Status__c from Contact 
   										 where 
							   				AccountId = :account.Id
							   			 And 
							   				Email = :user.Email
							   			 And 
							   			 	Status__c = 'Current']; 
				if(contacts.isEmpty())
				{
					//Contact needs to be created
					Insert_NewContact(user.email, user.Firstname, user.LastName, account.Id);
				}
				else
				{
					//if user is inactive the make contact inactive
					if(!user.IsActive)
					{
						Inactivate_Contact(contacts[0].Id);
					}

				}

   			}

   		}

   }


 }

 @future
 public static void Insert_NewContact(String email, string firstName, String lastName, Id accountId)
 {
 	Contact newContact 	= new Contact();
	newContact.AccountId= accountId;
	newContact.FirstName= firstName;
	newContact.LastName = lastName;
	newContact.Email	= email;
	newContact.Status__c='Current';
	insert newContact;
 }

 @future
 public static void  Inactivate_Contact(Id contactId)
 {
 	List<Contact> contacts = [Select Id, Status__c from Contact 
   										 where 						   				
							   				Id = :contactId]; 
	if(!contacts.isEmpty())						   				
	{
		Contact oldContact= contacts[0];
		oldContact.Status__c = 'Inactive';
		update oldContact;						   				
    }
 }

}