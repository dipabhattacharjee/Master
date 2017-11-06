@isTest
public class OppBigDealAlertOnChatter_Test {
	/*public static testMethod void testOppBigDeal(){
		List<Opportunity> oppList = [select id,name,StageName,School_Site_Country__c,CurrencyIsoCode,Amount from Opportunity where name= 'testOpp'];
		//opp.StageName = 'Negotiated';
		//update opp;
		Map<Id,Opportunity>oppMap = new Map<Id,Opportunity>();
		oppMap.put(oppList[0].Id,oppList[0]);
		OppBigDealAlertOnChatter oppBig = new OppBigDealAlertOnChatter();
		oppBig.postBigDealAlert(oppList,oppMap);
	}
	 @testSetup static void insertRecords(){
		//insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = true;
		insert handler;		
		
		//insert opportunity record 
		Opportunity opp = new Opportunity();
		opp.name = 'testOpp';
		opp.closeDate = Date.valueOf('2016-06-06');
		//opp.AccountId = acct.Id;
		opp.Type = 'Renewal';
		opp.Probability = 50;
		opp.StageName = 'Intrest';
		opp.Type = 'Renewal';
		opp.StageName = 'Sold - Invoiced';
		//opp.School_Site_Country__c = 'United States';
		opp.Amount = 20000;
		opp.CurrencyIsoCode = 'USD';
		opp.Won_Lost_Reason__c = 'AssessmentsUndo';
		//opp.Won_Lost_Reason__c = ''
		insert opp;
	 } */
}