@isTest
public class OpportunityTax_Test { 
    
    @testSetup static void initialSetUp(){
    
        List<sObject> regionTax = Test.loadData(RegionTaxSetting__c.sObjectType, 'RegionTaxCSV');
		List<sObject> EMETax = Test.loadData(EMETaxSetting__c.sObjectType,'EMETaxCSV');
		List<sObject> canadaProvinceTax = Test.loadData(CanadaProvinceTaxSetting__c.sObjectType, 'CanadaProvinceTaxRates');

        ISOMapping__c isoMap = CreateFakeIsoMap();
        insert isoMap;

        String mathletics = 'Mathletics';
        insert new LicencedProduct__c(ProductFamily__c = mathletics, Name = mathletics);
        
        String spellodrome = 'Spellodrome';
        insert new LicencedProduct__c(ProductFamily__c = spellodrome, Name = spellodrome);

        /*insert new RegionTaxSetting__c( Name                    = 'APAC',
                                        RegionName__c           = 'APAC',
                                        SiteCountry__c          = 'OTHER',
                                        TaxCode__c              = 'EXPS-AU',
                                        TaxCodeInternalId__c    = '10',
                                        TaxRate__c              = 0);*/
        
                
        
		//insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = true;
		insert handler;
		
  }
    
    //Scenario 0
    @isTest private static void ConvertLead_ToOpportunityCreatedByAPAC_TaxRateAPAC()
    {
     	      
        Lead lead = createFakeLead();        
        insert lead;      
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        System.assert(lcr.getAccountId() != null);
        System.assert(lcr.getOpportunityId() != null);
        System.assert(lcr.getContactId() != null);        
        
    }
    
    //Scenario 1 - Created with APAC User and Creates an Opportunity
    @isTest private static void OpportunityCreatedByAPACUser_TaxRateAPAC()
    {
        
        Map<String,ID> profiles = new Map<String,ID>();
      	List<Profile> ps = [select id, name from Profile where name = 
         					'Standard User' or name = 'System Administrator' or name = 'Sales User'];

        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        User testSalesUser   = new User(alias = 'standt', 
      	email			='standarduser@testorg.com', 
      	emailencodingkey='UTF-8', 
      	lastname		='Testing', languagelocalekey='en_US', 
      	localesidkey	='en_US', 
      	profileid 		= profiles.get('Sales User'), 
      	timezonesidkey	='America/Los_Angeles', 
      	username		='testSalesUser@testorg.com',
        Region__c = 'APAC');

      	insert testSalesUser;
        
        ACTNSCRM__Currency__c australianCurrency = CreateFakeCurrency('AUD');
		insert australianCurrency;
        System.runas(testSalesUser){
		
        //List<RegionTaxSetting__c> regionTaxSett = RegionTaxSetting__c.getAll().values();
        
        //Map<String, EMETaxSetting__c> nameVsEMEsett = EMETaxSetting__c.getAll();
        Account account = createFakeAccount();
        account.ACTNSCRM__Currency__c = australianCurrency.id;
        insert account;
     	
        Opportunity opportunity = createFakeOpportunity();
       	AssociateOpportunityToAccount(account, opportunity);
  		opportunity.ACTNSCRM__NS_Currency__c = australianCurrency.Id;            
        insert opportunity;

        List<Opportunity> Opplist = [select Id,Name from Opportunity where Id = : opportunity.Id];
            
        //System.debug('opportunity.TaxRate__c' + opportunity.TaxRate__c);        
        //System.assertEquals(opportunity.TaxRate__c, nameVsEMEsett.get('Not UK or EU').TaxRate__c);
        //System.assertEquals(opportunity.TaxCodeInternalID__c, nameVsEMEsett.get('Not UK or EU').TaxCodeInternalID__c);
        //System.assert(opportunity.TaxCode__c != null);
        
        System.assertEquals(1, Opplist.size());        
    
        }
     }   
    
    
    
    //Scenario 2 - Created with Canada User and Creates an Opportunity
    @isTest private static void OpportunityCreatedByCanadaUser_TaxRateCanada()
    {
        
       /* insert new CanadaProvinceTaxSetting__c( Name                    = 'Alberta',                                                
                                                TaxCode__c              = 'CA-S-AB',
                                                TaxCodeInternalId__c    = '286',
                                                TaxRate__c              = 5);*/

        
        Map<String,ID> profiles = new Map<String,ID>();
      	List<Profile> ps = [select id, name from Profile where name = 
         					'Standard User' or name = 'System Administrator' or name = 'Sales User'];

        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        User testSalesUser   = new User(alias = 'standt', 
      	email			='standarduser@testorg.com', 
      	emailencodingkey='UTF-8', 
      	lastname		='Testing', languagelocalekey='en_US', 
      	localesidkey	='en_US',
      	profileid 		= profiles.get('Sales User'), 
      	timezonesidkey	='America/Los_Angeles', 
      	username		='testSalesUser@Canada.com',
        Region__c = 'Canada');

      	insert testSalesUser;
        
        ACTNSCRM__Currency__c CanadaCurrency = CreateFakeCurrency('CAD');
		insert CanadaCurrency;
        
        System.runas(testSalesUser){
		
        //List<RegionTaxSetting__c> regionTaxSett = RegionTaxSetting__c.getAll().values();
        
        //Map<String, EMETaxSetting__c> nameVsEMEsett = EMETaxSetting__c.getAll();
        Account account = createFakeAccountCanada();
        account.ACTNSCRM__Currency__c = CanadaCurrency.id;
        insert account;
     	
        System.debug('account ACTNSCRM__Currency__c' + account.ACTNSCRM__Currency__c);
        System.debug('account ACTNSCRM__Currency__c' + account);
        
        Opportunity opportunity = createFakeOpportunity();
       	AssociateOpportunityToAccount(account, opportunity);
  		opportunity.ACTNSCRM__NS_Currency__c = CanadaCurrency.Id;            
        insert opportunity;

        List<Opportunity> Opplist = [select Id,Name from Opportunity where Id = : opportunity.Id];
        
        System.assertEquals(1, Opplist.size());        
    
        }
     }
    
    //Scenario 3 - Created with EME User and Creates an Opportunity
    @isTest private static void OpportunityCreatedByEME_TaxRateEME()
    {
        Map<String,ID> profiles = new Map<String,ID>();
      	List<Profile> ps = [select id, name from Profile where name = 
         					'Standard User' or name = 'System Administrator' or name = 'Sales User'];

        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        User testSalesUser   = new User(alias = 'standt', 
      	email			='standarduser@testorg.com', 
      	emailencodingkey='UTF-8', 
      	lastname		='Testing', languagelocalekey='en_US', 
      	localesidkey	='en_US',
      	profileid 		= profiles.get('Sales User'), 
      	timezonesidkey	='America/Los_Angeles', 
      	username		='testSalesUser@EME.com',
        Region__c = 'EME');

      	insert testSalesUser;
        
        ACTNSCRM__Currency__c EuroCurrency = CreateFakeCurrency('EUR');
		insert EuroCurrency;
        
        System.runas(testSalesUser){		
       
        Account account = createFakeAccountEMERegion();
        account.ACTNSCRM__Currency__c = EuroCurrency.id;
        account.ShippingCountry = 'United Kingdom';
        account.Local_Authority__c = 'Cornwall';    
        insert account;
     	
        System.debug('account ACTNSCRM__Currency__c' + account.ACTNSCRM__Currency__c);
        System.debug('account ACTNSCRM__Currency__c' + account);
        
        Opportunity opportunity = createFakeOpportunity();
       	AssociateOpportunityToAccount(account, opportunity);
  		opportunity.ACTNSCRM__NS_Currency__c = EuroCurrency.Id;        
        insert opportunity;

        List<Opportunity> Opplist = [select Id,Name from Opportunity where Id = : opportunity.Id];
        
        System.assertEquals(1, Opplist.size());     
    
        }
     }
    
   
    
    private static Lead createFakeLead()
	{
	    // Create the Lead object
	    Lead testLead = new Lead(
			FirstName    = 'Demo 100800',
			LastName 	 = 'Demo 100800 UnitTest',
			Status	     = 'Qualified',
			company      = 'Lacosta',
			street       = '1211 E I-40 Service Rd',
			city		 = 'NS',
            state		 = 'New South Wales',
            country		 = 'Australia',
            PostalCode = '2000'  
  	    ); 
        return testLead;
    
    }    
    
    private static ACTNSCRM__Currency__c CreateFakeCurrency(String currencyCode)
    {
        ACTNSCRM__Currency__c newCurr = new ACTNSCRM__Currency__c();
        newCurr.ACTNSCRM__ISO_Code__c = currencyCode;
        newCurr.ACTNSCRM__NS_Internal_ID__c = '13';
        newCurr.ACTNSCRM__NetSuite_Internal_ID__c = '13';        
        return newCurr;
    }
    
    private static Account createFakeAccount()
    {
        Account acct = new Account();
		acct.Name = 'testacct1';
		acct.ShippingPostalCode = '2000';
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
        return acct;
        
    }    
    private static Account createFakeAccountCanada()
    {
        Account acct = new Account();
		acct.Name = 'testacct1';
        acct.Tax_Exempt__c = true;
		acct.ShippingPostalCode = '201';
		acct.ShippingState = 'Alberta';
		acct.ShippingCity = 'test';
		acct.ShippingStreet =' test';   
		acct.ShippingCountryCode = 'CA';
		acct.ShippingCountry = 'Canada';
		acct.billingCountryCode = 'CA';
		acct.BillingState = 'Alberta';  
		acct.Territory__c = 'Canada';
		acct.Global_School_Type__c = 'Government';
		acct.Global_School_Category__c = 'Primary';
        return acct;        
    }
    
    private static Account createFakeAccountEMERegion()
    {
        Account acct = new Account();
        acct.Name = 'testacct1';
        acct.ShippingPostalCode = 'TR11 5HQ';
        acct.ShippingState = '';
        acct.ShippingCity = 'Falmouth';
        acct.ShippingStreet =' test';   
        acct.ShippingCountryCode = 'GB';
        acct.ShippingCountry = 'United Kingdom';        
        acct.billingCountryCode = 'GB';
        acct.BillingState = '';
        acct.Local_Authority__c = 'Cornwall';  
        acct.Territory__c = 'EME';
        acct.Global_School_Type__c = 'Government';
        acct.Global_School_Category__c = 'Primary';        
        return acct;        
    }

    
    
    private static Opportunity createFakeOpportunity()
    {
        Opportunity opp = new Opportunity();
		opp.name = 'testOpp';
		opp.closeDate = System.today();		
		opp.Type = 'New Business';
		opp.StageName = 'Interest';      
        
        return opp;
    }
    private static void AssociateOpportunityToAccount(Account account, Opportunity opportunity)
    {
        opportunity.AccountId = account.Id;
    }

    private static ISOMapping__c CreateFakeIsoMap()
    {
        ISOMapping__c isoMap    = new ISOMapping__c();
        isoMap.Geo_Code__c      = 'AUS';
        isoMap.ISO2__c          = 'AU';
        isoMap.ISO3__c          = 'AUS';
        return isoMap;
    }
}