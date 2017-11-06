@isTest
private class EBSInboundEmailHandler_Test
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
	static void PassingNotExistingOpportunityId_CallingEBSEmailHandler_ItShouldReturnFalse()
	{
		
		EBSInboundEmailHandler eBSEmailHandler = new EBSInboundEmailHandler();

		Messaging.InboundEmail email = new Messaging.InboundEmail();

		email.subject = TestUtility.getFakeId(Opportunity.SObjectType);
		
		Messaging.InboundEmailResult result = eBSEmailHandler.handleInboundEmail(email, null);

		system.assertEquals(false, result.success);
		system.assert( result.message.contains('not found!'),'wrong message in the response');

	}

	@isTest
	static void PassingNullSubject_ToEBSEmailHandler_ItShouldReturnFalse()
	{
		
		EBSInboundEmailHandler eBSEmailHandler = new EBSInboundEmailHandler();

		Messaging.InboundEmail email = new Messaging.InboundEmail();

	
		Messaging.InboundEmailResult result = eBSEmailHandler.handleInboundEmail(email, null);

		system.assertEquals(false, result.success);
		system.assertEquals('Cannot process inbound email without a subject', result.message);

	}

	@isTest
	static void PassingExistedOpportunityId_ToEBSEmailHandler_ItShouldReturnTrue()
	{

		//Preparation
		//Creating Account with on opty
		Account account = FakeObjectFactory.GetSchoolAccount();
		insert account;

		Opportunity opty = FakeObjectFactory.GetStandardOpportunity();
		TestUtility.AssignOpportunityToAccount(opty, account);
		insert opty;
		
		EBSInboundEmailHandler eBSEmailHandler = new EBSInboundEmailHandler();

		Messaging.InboundEmail email = new Messaging.InboundEmail();
		

		email.subject = opty.Id;
		
		Messaging.InboundEmailResult result = eBSEmailHandler.handleInboundEmail(email, null);

		system.assertEquals(true, result.success);
	
		
	}
}