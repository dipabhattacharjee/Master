public with sharing class UpdateBillAddToPrev3RdPartyAddOnRemSSC {
	public Set<Id> accountIdsWothoutPreviousThirdPartyAddress{get;set;}
	public UpdateBillAddToPrev3RdPartyAddOnRemSSC() {
		
	}

    public void updateThirdPartyAddressToUpdateAccBillingAddress (List<Account> newAccountList,Map<Id,Account>oldAccountMap,Set<Id>accountIds){

			//Id SSCRecordTypeId = fetchSSCRecordTypeId();
			//Map<Id,Account>SSCAccountMap = getShareServiceAccountIdVsRecordMap(SSCRecordTypeId);    
			Map<Id,List<X3rd_Party_Address__c>> accountIdVsThirdPartyAddress = getAccountIdVsThirdAddress(accountIds);
			

			List<X3rd_Party_Address__c> thirdPartyAddressToUpdate = getPreviousThirdPartyAddressToUpdate(newAccountList,accountIdVsThirdPartyAddress,oldAccountMap);

			if(thirdPartyAddressToUpdate.size() > 0 && thirdPartyAddressToUpdate != null){
				update thirdPartyAddressToUpdate;
			}
			if(accountIdsWothoutPreviousThirdPartyAddress.size() > 0 && accountIdsWothoutPreviousThirdPartyAddress != null){
				update setBillingAddressNull(accountIdsWothoutPreviousThirdPartyAddress);
			}
	}


	@TestVisible
	private List<X3rd_Party_Address__c> getPreviousThirdPartyAddressToUpdate(List<Account> accountListToAssociateThirdPartyAddress, Map<Id,List<X3rd_Party_Address__c>>accountIdVsThirdPartyaddMap,Map<Id,Account>oldAccountMap){
			List<X3rd_Party_Address__c> thirdPartyAddressToUpdate = new List<X3rd_Party_Address__c>();
			X3rd_Party_Address__c thirdPartyAddress;
			Boolean isPreviousAddressPresent;
			accountIdsWothoutPreviousThirdPartyAddress = new Set<Id>();
			AccountBillingAddressUpdateHelperClass helper = new AccountBillingAddressUpdateHelperClass();
			System.debug('This is an test third party address to insert  start' +thirdPartyAddressToUpdate);
			for(Account acc : accountListToAssociateThirdPartyAddress){
				isPreviousAddressPresent = false;
				If(oldAccountMap.get(acc.Id).Shared_Service_Center__c !=  null && acc.Shared_Service_Center__c == null && (acc.recordTypeId ==  helper.fetchSchoolRecordTypeId() || acc.recordTypeId == helper.fetchClusterRecordTypeId()) ){
					If(accountIdVsThirdPartyaddMap.size() > 0  && accountIdVsThirdPartyaddMap != null){
						If(accountIdVsThirdPartyaddMap.containsKey(acc.Id)){							
						 	for(X3rd_Party_Address__c thirdPartyAdd : accountIdVsThirdPartyaddMap.get(acc.Id)){
					 			If(thirdPartyAdd.Street_Address__c != acc.BillingStreet ) {
					 				thirdPartyAdd.Default_Address__c = true;
					 				thirdPartyAddressToUpdate.add(thirdPartyAdd);
					 				isPreviousAddressPresent = true;
					 				break;	
					 			}
						 	}
						 	if(!isPreviousAddressPresent){
						 		accountIdsWothoutPreviousThirdPartyAddress.add(acc.Id);
						 	}							 						 
						}
					}	
				}	
			}
			System.debug('This is an test third party address to insert ' +thirdPartyAddressToUpdate);
			return thirdPartyAddressToUpdate;
	}



	public Map<Id,List<X3rd_Party_Address__c>> getAccountIdVsThirdAddress(Set<Id>accountIds){

		List<X3rd_Party_Address__c> thirdPartyAddress = [Select Id,Name,Default_Address__c,Account__c,CreatedDate,Street_Address__c,City__c,State_Province__c,Postal_Code__c,Country__c,LastModifiedDate from X3rd_Party_Address__c where Account__c IN :accountIds Order By LastModifiedDate DESC];
		Map<Id,List<X3rd_Party_Address__c>> accountIdVsThirdPartyAddress = new Map<Id,List<X3rd_Party_Address__c>>();
		
		if(thirdPartyAddress.size() > 0 && thirdPartyAddress != null){
			for(X3rd_Party_Address__c address : thirdPartyAddress){
				
					if(accountIdVsThirdPartyAddress.containsKey(address.Account__c)){
						accountIdVsThirdPartyAddress.get(address.Account__c).add(address);						
					}else{
						accountIdVsThirdPartyAddress.put(address.Account__c, new List<X3rd_Party_Address__c>{address});
					}

			}	
		}
		System.debug('This is an last updated Third party address' + accountIdVsThirdPartyAddress);
		return accountIdVsThirdPartyAddress;
	}	




	private List<Account> setBillingAddressNull(Set<Id> accountIdsToSetBillingAadressNull){
		List<Account> accountList = [Select Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry From Account where Id IN :accountIdsToSetBillingAadressNull];
		Account newAcc;
		for(Account acc : accountList){
			
			acc.BillingStreet = null;
			acc.BillingCity = null;
			acc.BillingState = null;
			acc.BillingPostalCode = null;
			acc.BillingCountry = null;
			

		}
		return  accountList;
	}

}