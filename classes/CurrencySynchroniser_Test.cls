@isTest
public class CurrencySynchroniser_Test {
    
           
    @testSetup static void insertRecords(){
    
        //insert Trigger_Handler__c custom setting 
       /* Trigger_Handler__c handler = new Trigger_Handler__c();
        handler.Name = 'Block Trigger';
        handler.Block_Trigger_Execution__c = true;
        insert handler;*/
        FakeObjectFactory.testclasssetup();
        
       // List<sObject> regionTax = Test.loadData(RegionTaxSetting__c.sObjectType, 'RegionTaxCSV');
        //List<sObject> EMETax = Test.loadData(EMETaxSetting__c.sObjectType, 'EMETaxCSV');
        //List<sObject> canadaProvinceTax = Test.loadData(CanadaProvinceTaxSetting__c.sObjectType, 'CanadaProvinceTaxRates');

        
        
        
  }


    
    @isTest private static void OpportunityWithNewCurrency_OnOpportunitySave_NewCurrencyShouldBeAvaiableAccountCuurency()
    {
        ACTNSCRM__Currency__c australiaCurrency = CreateFakeCurrency('AUD');
        insert australiaCurrency;
        
        Account account = createFakeAccount();
        account.ACTNSCRM__Currency__c = australiaCurrency.id;        
        insert account;
        
        List<Account> accList = [Select Id,ACTNSCRM__Currency__c from Account where Id = : account.Id ];
        
        System.debug('account.accList' + accList[0]);
        
        ACTNSCRM__Currency__c canadaCurrency = CreateFakeCurrency('NZD');
        insert canadaCurrency;
        
        Opportunity opportunity = createFakeOpportunity();
        AssociateOpportunityToAccount(account, opportunity);        
       // opportunity.ACTNSCRM__NS_Currency__c = canadaCurrency.Id;            
        insert opportunity;
        
        Opportunity oppToUpdateCurrency = [Select ID,ACTNSCRM__NS_Currency__c from Opportunity where Id = :opportunity.Id];
        oppToUpdateCurrency.ACTNSCRM__NS_Currency__c = canadaCurrency.Id;  
        update  oppToUpdateCurrency;

        List<Opportunity> oppList = [Select Id,ACTNSCRM__Currency__c,ACTNSCRM__NS_Currency__c from Opportunity where Id = : opportunity.Id ];
        
        System.debug('Opp.oppList' + oppList[0]);

        List<ACTNSCRM__Account_Currency__c> accCurrencies = [Select ACTNSCRM__Currency__c ,CurrencyIsoCode
                                                                 from ACTNSCRM__Account_Currency__c
                                                                 where
                                                                 ACTNSCRM__Account__c = : account.Id];      
        
        System.assert(accCurrencies.size() == 2);
        
    }
    
    private static void AssociateOpportunityToAccount(Account account, Opportunity opportunity)
    {
        opportunity.AccountId = account.Id;
    }
    
    @isTest private static void OpportunityWithExistingCurrency_OnOpportunitySave_AccountCuurencyShouldStayTheSame()
    {
         ACTNSCRM__Currency__c australianCurrency = CreateFakeCurrency('AUD');
        insert australianCurrency;
        
        Account account = createFakeAccount();
        account.ACTNSCRM__Currency__c = australianCurrency.id;
        insert account;       
      
        
        Opportunity opportunity = createFakeOpportunity();
        AssociateOpportunityToAccount(account, opportunity);
        opportunity.ACTNSCRM__NS_Currency__c = australianCurrency.Id;            
        insert opportunity;
        
        List<ACTNSCRM__Account_Currency__c> accCurrencies = [Select ACTNSCRM__Currency__c ,CurrencyIsoCode
                                                                 from ACTNSCRM__Account_Currency__c
                                                                 where
                                                                 ACTNSCRM__Account__c = : account.Id];      
        
        System.assert(accCurrencies.size() == 1);
        
    }
    
    private static Account createFakeAccount()
    {
        ACTNSCRM__Actian_Subsidiary__c subsidiary = new ACTNSCRM__Actian_Subsidiary__c();
        subsidiary.CurrencyIsoCode = 'AUD';
        subsidiary.ACTNSCRM__NS_Internal_ID__c = '1';
        subsidiary.ACTNSCRM__NetSuite_Internal_ID__c = '1';
        insert subsidiary;
        
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
        acct.ACTNSCRM__Subsidiary_Lookup__c = subsidiary.Id;  
        //acct.ACTNSCRM__Currency__c = newCurr.Id;
        return acct;
        
    }
    private static Opportunity createFakeOpportunity()
    {
        Opportunity opp = new Opportunity();
        opp.name = 'testOpp';
        opp.closeDate = System.today();
        
        opp.Type = 'New Business';
        opp.Probability = 50;
        opp.StageName = 'Interest';      
        
        return opp;
    }
    
    private static ACTNSCRM__Currency__c CreateFakeCurrency(String currencyCode)
    {
        ACTNSCRM__Currency__c newCurr = new ACTNSCRM__Currency__c();
        newCurr.ACTNSCRM__ISO_Code__c = currencyCode;
        newCurr.ACTNSCRM__NS_Internal_ID__c = '13';
        newCurr.ACTNSCRM__NetSuite_Internal_ID__c = '13';
        
        return newCurr;
    }
}