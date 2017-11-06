public with sharing class AccountBillingAddressUpdateHelperClass {
	public AccountBillingAddressUpdateHelperClass() {
		
	}

	//This function will return Map of All the shared service centers
	
    public Map<Id,Account> getShareServiceAccountIdVsRecordMap(Id recordTypeId){
        Map<Id,Account> IdVsAccountMap = new Map<Id,Account>([Select Id,Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry, BillingLatitude, BillingLongitude From Account where
                         RecordTypeId = :recordTypeId]);
        return IdVsAccountMap;
        
    }
    
    //This function will return Id of the shared service center record type
   
    public Id fetchSSCRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where (DeveloperName = 'Shared_Service_Center' ) And sObjectType = 'Account'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }

   //This function will return Id of the share record type
  
    public Id fetchSchoolRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where (DeveloperName = 'School' ) And sObjectType = 'Account'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }

       //This function will return Id of the shared service center record type
   
    public Id fetchClusterRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where (DeveloperName = 'Cluster' ) And sObjectType = 'Account'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }
}