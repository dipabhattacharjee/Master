@isTest
public class RenewLicencesForProduct_Test {
	 public static testMethod void testRenewLicence(){
		RenewLicencesForProduct renew = new RenewLicencesForProduct();
		
		Opportunity opp = [select id from Opportunity where name= 'testOpp'];
		renew.renewLicences(opp.Id);
	 }
	
	 @testSetup static void insertRecords(){
	   //insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = true;
		insert handler;		

        List<sObject> regionTax = Test.loadData(RegionTaxSetting__c.sObjectType, 'RegionTaxCSV');
		List<sObject> EMETax = Test.loadData(EMETaxSetting__c.sObjectType,'EMETaxCSV');
		List<sObject> canadaProvinceTax = Test.loadData(CanadaProvinceTaxSetting__c.sObjectType, 'CanadaProvinceTaxRates');
         
		////insert Service_EndPoints__c custom setting
		Service_EndPoints__c endPoint = new Service_EndPoints__c();
		endPoint.Endpoint_URL__c = 'abc.com';
		endPoint.Name = 'Contact Service';
		insert endPoint;
		
		

		//insert contact record
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
		insert acct;
		
		//insert product 

		Product2 prod = new Product2();
		prod.name = 'Mathletics';
		prod.Family = 'Test';
		insert prod;


		//insert Asset Record 
		List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Full_Licence'  And sObjectType = 'Asset'];
		Asset singleAsset = new Asset();
		singleAsset.Name = 'testAsset';
		singleAsset.AccountId = acct.Id;
		singleAsset.UsageEndDate = System.today().AddDays(30);
		singleAsset.InstallDate = System.today();
		singleAsset.License_Cap__c = 1;
		singleAsset.Status = 'Provisioned';
		singleAsset.recordTypeId =recTypeList[0].Id;
		singleAsset.Product2Id = prod.Id;
		insert singleAsset;

		//insert opportunity record 
		Opportunity opp = new Opportunity();
		opp.name = 'testOpp';
		opp.closeDate = System.today().AddDays(1);
		opp.AccountId = acct.Id;
		opp.Type = 'Renewal';
		opp.Probability = 50;
		opp.StageName = 'Intrest';
		opp.Type = 'Renewal';
		//opp.StageName = 'Sold - Invoiced';
		opp.Won_Lost_Reason__c = 'AssessmentsUndo';
		//opp.Won_Lost_Reason__c = ''
		insert opp;


		//insert priceBookEntryId
		/*Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);*/

		Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id  = pricebookId,
                                                            Product2Id   = prod.Id,
                                                            UnitPrice    = 1000,
                                                            IsActive     = true);

        insert standardPrice;
		//insert oppLineItem
		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.Id;
		//oppLineItem.Product2Id =prod.Id;
		oppLineItem.PriceBookEntryId = standardPrice.Id;
		oppLineItem.Quantity = 8;
		oppLineItem.TotalPrice = 40;
		//oppLineItem.Renew_Licence__c  = true;
        oppLineItem.SubscriptionStartDate__c = System.today();
        oppLineItem.SubscriptionEndDate__c=  System.today().addYears(1);
        oppLineItem.Provision_Full_License__c = true;
		insert oppLineItem;
		
	}
}