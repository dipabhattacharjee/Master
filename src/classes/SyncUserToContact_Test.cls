@isTest
private class SyncUserToContact_Test
{
	 @testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

        Trigger_Handler__c triggerHandler = FakeObjectFactory.GetTriggerHandler();
        insert triggerHandler;

        String mathletics = 'Mathletics';
        insert new LicencedProduct__c(ProductFamily__c = mathletics, Name = mathletics);
        
        String spellodrome = 'Spellodrome';
        insert new LicencedProduct__c(ProductFamily__c = spellodrome, Name = spellodrome);

        insert new RegionTaxSetting__c( Name                    = 'APAC',
                                        RegionName__c           = 'APAC',
                                        SiteCountry__c          = 'OTHER',
                                        TaxCode__c              = 'EXPS-AU',
                                        TaxCodeInternalId__c    = '10',
                                        TaxRate__c              = 0); 

        Service_EndPoints__c endPoint1 = new Service_EndPoints__c();
        endPoint1.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint1.Name = 'Contact Service';
        insert endPoint1;


        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint.Name = 'Account Service';
        insert endPoint;

        System.debug('setup done');

    }

	@isTest
	static void Insert_NewContact_OneContactShouldbeCretaed()
	{
		Account account = FakeObjectFactory.Get3PAccount();
		insert account;

		 Test.startTest(); 
		SyncUserToContact.Insert_NewContact('a@a.com','name','lastname', account.Id);
		Test.stopTest();

		List<Contact> contacts =[Select Id,FirstName, LastName, Email from contact
								where accountId =: account.Id];

		system.assertEquals(1, contacts.size(),'one contact should return');
		system.assertEquals('name', contacts[0].FirstName,'Firstname not matched');
		system.assertEquals('lastname', contacts[0].Lastname,'Lastname not matched');
		system.assertEquals('a@a.com', contacts[0].Email,'Email address not matched');


	}

	@isTest
	static void Inactivate_Contact_StatusOfContactShouldBeInActivated()
	{
		Account account = FakeObjectFactory.Get3PAccount();
		insert account;

		 
		Contact contact =  FakeObjectFactory.GetContact();
		contact.AccountId= account.Id;
		insert contact;
		

		Test.startTest(); 
		SyncUserToContact.Inactivate_Contact(contact.Id);
		Test.stopTest();

		List<Contact> contacts =[Select Id,FirstName, LastName, Email, Status__c 
								from contact
								where Id =: contact.Id];

		system.assertEquals(1, contacts.size(),'one contact should return');
		system.assertEquals('Inactive', contacts[0].Status__c,'contact status not matched');
		

	}

	@isTest 
	static void CreateContact_WithoutAnyId_ItshouldntThoughAnyException()
	{
		SyncUserToContact.CreateContact(null);
	}

	
	
}