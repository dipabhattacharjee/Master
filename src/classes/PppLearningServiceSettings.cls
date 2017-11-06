public with sharing class PppLearningServiceSettings {
	
	/*
	Default timeout for calling Pppleaning services
	*/
	public Integer Timeout{ get {return 60 * 1000;}}

	public Integer FakeUserId{ get {

		 Account__c account_C = Account__c.getInstance('C3 User Id');
            
            if(account_C != null)
                return Integer.valueOf(account_C.Id__c);
            else
              System.debug('Account__c.getInstance(C3 User Id) does not exist');

            return 0;
		}}

	
}