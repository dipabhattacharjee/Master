public with sharing class UpdateBillingAddressOnChangeSSCOnAccount {
	public UpdateBillingAddressOnChangeSSCOnAccount() {
		
	}

	public void updateBillingAddressOnAcount(List<Account> newAccountList,Set<Id>accountIds){
			AccountBillingAddressUpdateHelperClass helper = new AccountBillingAddressUpdateHelperClass();
			Id SSCRecordTypeId = helper.fetchSSCRecordTypeId();
			Map<Id,Account>SSCAccountMap = helper.getShareServiceAccountIdVsRecordMap(SSCRecordTypeId);    
			List<X3rd_Party_Address__c> thirdPartyAddressToInsert = getThirdPartyAddressToInsert(newAccountList,SSCAccountMap);

			if(thirdPartyAddressToInsert.size() > 0 && thirdPartyAddressToInsert != null){
				System.debug('This is before inserting the 3rd party address' + thirdPartyAddressToInsert);
				insert thirdPartyAddressToInsert;
			}
	}


	@TestVisible
	private List<X3rd_Party_Address__c> getThirdPartyAddressToInsert(List<Account> accountListToAssociateThirdPartyAddress, Map<Id,Account>SSCAccountMap){
			List<X3rd_Party_Address__c> thirdPartyAddressToInsert = new List<X3rd_Party_Address__c>();
			X3rd_Party_Address__c thirdPartyAddress;
			System.debug('This is an test third party address to insert  start' +thirdPartyAddressToInsert);
			AccountBillingAddressUpdateHelperClass helper = new AccountBillingAddressUpdateHelperClass();
			for(Account acc : accountListToAssociateThirdPartyAddress){
				If((acc.recordTypeId == helper.fetchSchoolRecordTypeId() || acc.recordTypeId == helper.fetchClusterRecordTypeId()) ){
					If(SSCAccountMap.size() >0  && SSCAccountMap != null){
						If(SSCAccountMap.containsKey(acc.Shared_Service_Center__c)){
							 thirdPartyAddress = new X3rd_Party_Address__c();
							 thirdPartyAddress.Street_Address__c = SSCAccountMap.get(acc.Shared_Service_Center__c).BillingStreet;
	                         thirdPartyAddress.City__c = SSCAccountMap.get(acc.Shared_Service_Center__c).BillingCity;
	                         thirdPartyAddress.State_Province__c = SSCAccountMap.get(acc.Shared_Service_Center__c).BillingState;
	                         thirdPartyAddress.Postal_Code__c = SSCAccountMap.get(acc.Shared_Service_Center__c).BillingPostalCode;
	                         thirdPartyAddress.Country__c = SSCAccountMap.get(acc.Shared_Service_Center__c).BillingCountry;
	                         thirdPartyAddress.Default_Address__c = true;
	                         thirdPartyAddress.Account__c = acc.Id;
	                         thirdPartyAddressToInsert.add(thirdPartyAddress);
						}
					}	
				}	
			}
			System.debug('This is an test third party address to insert ' +thirdPartyAddressToInsert);
			return thirdPartyAddressToInsert;
	}	

}