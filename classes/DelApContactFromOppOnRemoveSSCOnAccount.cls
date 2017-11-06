public with sharing class DelApContactFromOppOnRemoveSSCOnAccount {
	public DelApContactFromOppOnRemoveSSCOnAccount() {
		
	}


	public void deleteApConfromOppOnUnlinkSSCFromAcc(List<Account> accountList, Map<Id,Account>oldAccountMap,Set<Id>accountIds){

		List<OpportunityContacts__c> opportunityApContactToDelete= getApOpportunityContactToDelete(getSSCAccountVsApOppContacts(accountIds),accountList,oldAccountMap);

		if(opportunityApContactToDelete != null && opportunityApContactToDelete.size() > 0){
			delete 	opportunityApContactToDelete;
		}
	}


	public List<OpportunityContacts__c> getApOpportunityContactToDelete(Map<Id,List<OpportunityContacts__c>>sscAccountIdVsOpContactMap,List<Account> accountList,Map<Id,Account>oldAccountMap){
		List<OpportunityContacts__c> opportunityApContactToDelete = new List<OpportunityContacts__c>();
		for(Account acc : accountList){
			If(sscAccountIdVsOpContactMap != null && sscAccountIdVsOpContactMap.size() > 0){
				if(sscAccountIdVsOpContactMap.containsKey(oldAccountMap.get(acc.Id).Shared_Service_Center__c)){
					for(OpportunityContacts__c apOppContact : sscAccountIdVsOpContactMap.get(oldAccountMap.get(acc.Id).Shared_Service_Center__c)){
						opportunityApContactToDelete.add(apOppContact);
					}						
				}
			}
		}
		

		return opportunityApContactToDelete;
	}

	public Map<Id,List<OpportunityContacts__c>> getSSCAccountVsApOppContacts  (Set<Id>accountIds){
			AccountBillingAddressUpdateHelperClass helper = new AccountBillingAddressUpdateHelperClass();
			Id sscRecordTypeId = helper.fetchSSCRecordTypeId();
			Map<String,OpportunityDeletetStagesNotAllowed__c> OpportunityDeletetStagesNotAllowedMap = OpportunityDeletetStagesNotAllowed__c.getAll();
		List<OpportunityContacts__c> oppCOntactList = [SELECT Id, Name, Opportunity__c,Opportunity__r.AccountId, AccountId__c,Contact__r.AccountId,Opportunity__r.Account.Shared_Service_Center__c, Account__c, Contact__c, Role__c,
														Contact__r.Account.RecordTypeId FROM OpportunityContacts__c where Role__c = 'Accounts Payable' AND  Contact__r.Account.RecordTypeId= :sscRecordTypeId AND Opportunity__r.StageName NOT IN :OpportunityDeletetStagesNotAllowedMap.Keyset() 
														AND Opportunity__r.AccountId IN :accountIds];
		Map<Id,List<OpportunityContacts__c>> sscAccountIdVsOpContactMap = new Map<Id,List<OpportunityContacts__c>>();

		If(oppCOntactList != null && oppCOntactList.size() > 0 ){
			for(OpportunityContacts__c oppContact : oppCOntactList){
					If(sscAccountIdVsOpContactMap.containsKey(oppContact.Contact__r.AccountId)){
						sscAccountIdVsOpContactMap.get(oppContact.Contact__r.AccountId).add(oppContact);
					}else{
						sscAccountIdVsOpContactMap.put(oppContact.Contact__r.AccountId, new List<OpportunityContacts__c>{oppContact});
					}
			}	
		}

		return sscAccountIdVsOpContactMap;	
	}
	

 
}