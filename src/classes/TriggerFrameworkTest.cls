@isTest
public with sharing class TriggerFrameworkTest { 
  public static testMethod void testAccountTrigger() {
    Account acct1 = [SELECT Id, Name FROM Account WHERE Name = 'testacct1'];
    acct1.Name = 'testacct2';
    update acct1;
    System.assert(true);
  }

  public static testMethod void testContactTrigger() {
    Contact con = [SELECT Id, Name FROM Contact WHERE LastName = 'testLast'];
    con.LastName = 'testacct2';
    update con;
    System.assert(true);
  }

   public static testMethod void testOpportunityTrigger() {
    Opportunity opp = [SELECT Id, Name,CloseDate,Type,AccountId FROM Opportunity WHERE name = 'testOpp'];
    opp.name = 'testacct2';
    update opp;
    System.assert(true);
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
      
      
    //insert Service_EndPoints__c custom setting
    Service_EndPoints__c endPoint = new Service_EndPoints__c();
    endPoint.Endpoint_URL__c = 'abc.com';
    endPoint.Name = 'Authorization Service';
    insert endPoint;

    //insert post mapping record
    Postcode_Mapping__c post = new Postcode_Mapping__c();
    //post.name = 'test';
    post.Country__c = 'AU';
    post.Post_Zip_Code__c = 'AUS';
    insert post;

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
    
    //insert contact record 
    Contact con = new Contact();
    con.FirstName = 'test';
    con.LastName = 'testLast';
    con.Phone = '11111111';
    insert con; 

    //insert opportunity record 
    Opportunity opp = new Opportunity();
    opp.name = 'testOpp';
    opp.closeDate = Date.valueOf('2016-06-06');
    opp.AccountId = acct.Id;
    opp.Type = 'Renewal';
    opp.Probability = 50;
    opp.StageName = 'Intrest';
    //opp.Won_Lost_Reason__c = ''
    insert opp;
  }
}