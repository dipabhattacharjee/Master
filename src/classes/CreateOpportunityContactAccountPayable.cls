public with sharing class CreateOpportunityContactAccountPayable {
	
	public CreateOpportunityContactAccountPayable() {
		
	}

	public void InsertAccountPayableOpportunityContact(List<Opportunity> opportunities, Set<Id> oppIds){

		List<Opportunity> opportunityListWithFields = fetchOpportunityAccountFields(oppIds);
		List<Opportunity> opportunityAssociatedWithSSC = validateOpportunityHasSSC(opportunityListWithFields);	
		if (opportunityAssociatedWithSSC != null && opportunityAssociatedWithSSC.size() > 0 ){			
			createAccountsPayableRecords(opportunityAssociatedWithSSC,fetchSSCIdvsContacts());
		}
	}

	public void createAccountsPayableRecords(List<Opportunity> oppList, Map<Id,Contact> mapSSCIdvsContact){		
		
		try{
			List<OpportunityContacts__c> oppContacts = new List<OpportunityContacts__c>();
			for(Opportunity opp: oppList)
			{
				if (mapSSCIdvsContact.size() > 0 && mapSSCIdvsContact != null) {
					if( mapSSCIdvsContact.containsKey(opp.account.Shared_Service_Center__c))
					{
						OpportunityContacts__c oppCon 	= new OpportunityContacts__c();
						oppCon.Account__c 				= opp.AccountId;
						oppCon.Contact__c 				= mapSSCIdvsContact.get(opp.account.Shared_Service_Center__c).Id;
						oppCon.Opportunity__c    		= opp.Id; 
						oppCon.Role__c 					= 'Accounts Payable';
						oppContacts.add(oppCon);
					}
				}
			}

			If(oppContacts.size() > 0)
			{
				Insert oppContacts;
			}			
		}
		Catch(Exception ex)			
		{
			throw ex;
		}
	}



	public Map<Id,Contact> fetchSSCIdvsContacts(){
		Map<Id,Contact> mapSSCIdvsContact = new Map<Id,Contact>();
		Id sharedServiceCentreRecordTypeId = fetchSSCAccounts();
		//List<Account> accontsSSC = [Select Id,Name from Account where RecordTypeId = :sharedServiceCentreRecordTypeId];
		List<Contact> contacts = [Select Id,Name,AccountId 
									from Contact 
									where Account.RecordTypeId = :sharedServiceCentreRecordTypeId
									AND Status__c = 'Current'
									AND Job_Function__c = 'Accounts/Finance'									
								];
		for(Contact con :contacts)
		{ 
			if(!mapSSCIdvsContact.containsKey(con.AccountId)){
				mapSSCIdvsContact.put(con.AccountId, con);	
			}
			
		}
		
		return mapSSCIdvsContact;
	}


	//get Standard Opportunity record type Id 
    private Id fetchSSCAccounts(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType 
        					Where DeveloperName = 'Shared_Service_Center'  And sObjectType = 'Account'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }

	public List<Opportunity> validateOpportunityHasSSC(List<Opportunity> opplist){

		List<Opportunity> opportunitiesSSC = new List<Opportunity>();

		for(Opportunity opp : opplist)
		{
			if(opp.Account.Shared_Service_Center__c != null)
			{
				opportunitiesSSC.add(opp);
			}
		}

		If(opportunitiesSSC.size() > 0)
		{
			return opportunitiesSSC;
		}
		else
		return null;
	}

	public List<Opportunity> fetchOpportunityAccountFields(Set<Id> oppIds){

		List<Opportunity> oppList = [
										Select Id,Name,RecordTypeId,CurrencyIsoCode,AccountId,
                                            Account.Name,Owner.Name,StageName,Amount,
                                            account.OwnerId,Account.Shared_Service_Center__c
                                            From Opportunity 
                                            Where Id IN :oppIds 
                                    ];
        return oppList;

	}

}