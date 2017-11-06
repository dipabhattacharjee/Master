@isTest(SeeAllData=true)
private class SchoolExcessLicensingProcessor_Test {
	
    /*@testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

            
        Service_EndPoints__c endPoint1 = new Service_EndPoints__c();
        endPoint1.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint1.Name = 'Contact Service';
        insert endPoint1;


        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint.Name = 'Account Service';
        insert endPoint;

        System.debug('setup done');

    }*/

    
	@isTest static void AccountwithRegisteredStudentsGreaterthanThreshold_ExcessLicenceOpportunityGetsCreated() {

		//User userInfo1 = new User();
		Excess_Licensing__c excessLicencerecord 					  	= FakeObjectFactory.GetExcessLicenceRecord('APAC', 5, 10,'Mathletics', true,'Interest',true,'Interest');
		insert excessLicencerecord;

		SchoolExcessLicensingProcessor schoolExcessLicensingProcessor 	= new SchoolExcessLicensingProcessor();
		
		UpsellOpportunitywithProducts_Bulk upsellOpportunitywithProducts_Bulk = new UpsellOpportunitywithProducts_Bulk();

		User userInfo1 													= [Select Id from User where Id =: UserInfo.getUserId()];

		Set<Id> accountIdSet 											= schoolExcessLicensingProcessor.GetActiveAccounts('APAC', 'Gov-Corr.');
		List<Asset> assets 												= schoolExcessLicensingProcessor.GetProvisionedLicenses(accountIdSet,'Mathletics', 5);
		List<Asset> mapIdAssetListLessthanThreshold 					= schoolExcessLicensingProcessor.GetAsset_withCAPUsed_LessThan_Threshold(assets, 10);
		List<Asset> mapIdAssetListMorethanThreshold 					= schoolExcessLicensingProcessor.GetAsset_withCAPUsed_MoreThan_Threshold(assets, 10);		

		List<OpportunityAsset> opportunityAssetListLessThanThreshold 	= upsellOpportunitywithProducts_Bulk.CreateUpsellOpportunity(assets,userInfo1.Id,excessLicencerecord.territory__c, excessLicencerecord.School_type__c);
		List<Opportunity> createdOpportunities 							= schoolExcessLicensingProcessor.InsertOpportunity(opportunityAssetListLessThanThreshold);

        schoolExcessLicensingProcessor.MoveOpportunityToStage(createdOpportunities, 'Interest');
		schoolExcessLicensingProcessor.CreateTaskForAccountManagers(createdOpportunities, 'Mathletics');

		 schoolExcessLicensingProcessor.SchoolExcessLicensingProcessor(excessLicencerecord);
	}
	
}