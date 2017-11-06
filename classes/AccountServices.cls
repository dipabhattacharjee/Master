/*
 * *@author- Vishnu Belkone
 * @description: This class is to fetch contacts which have reference.
 * @TestClass: AccountServices_Test
 * @History:
 * 18/10/2015 Created
 */
public class AccountServices {
    //public static List<Account> accountstoSend{get;set;} 
    
    public void runServices(Set<Id> accountIds){
        if(System.isFuture() == false && System.isBatch() == false){
             postPutService(accountIds);
        }
    }
    
    
     @future(callout=true)
    public static void postPutService(Set<Id> accountIds ){
        String token;
        if (!Test.isRunningTest())
        {
            token = new AuthenticationService().authenticate();
        }else{
            token = 'abcdefghijkl';
        }
        
        AccountPostService postService = new AccountPostService();
        List<Account>accountsToUpdate = new List<Account>();
         List<Account> accountstoSend = fetchAccountToSend(accountIds);
        system.debug('This is to accountstoSend'+accountstoSend);
        String checkServiceMethod;
        Map<String,ISOMapping__c> iso2VsIso3Map =getIso3CountryCodeMap();
        Map<String,AccountTeamMember> teamMemberRoleVsAccountTeamMember = fetchTeamMemberRoleVsAccountTeamMember(accountIds);
        Id schoolRecordTypeId = fetchBankRecordTypeId();
        Id clusterId = fetchClusterRecordTypeId();
        for(Account singleAccount: accountstoSend){  
            if(singleAccount.RecordTypeId == schoolRecordTypeId || singleAccount.RecordTypeId == clusterId){
                if(singleAccount.C3_Id__c != null && singleAccount.C3_Id__c != ''){
                    checkServiceMethod = 'PUT';
                    postService.serviceCall(singleAccount,token,checkServiceMethod,iso2VsIso3Map,teamMemberRoleVsAccountTeamMember);
                    system.debug('This is to test c3Id' + singleAccount.C3_Id__c);
                }else{
                    checkServiceMethod = 'POST';
                    System.debug('teamMemberRoleVsAccountTeamMember' + teamMemberRoleVsAccountTeamMember.size());                                        
                    if(singleAccount.BillingCountryCode == null || singleAccount.ShippingCountryCode == null)
                    {
                        throw new ValidationException('Account BillingCountryCode or ShippingCountryCode is not set');
                    }                    
                    accountsToUpdate.add(postService.serviceCall(singleAccount,token,checkServiceMethod,iso2VsIso3Map,teamMemberRoleVsAccountTeamMember) ); //TODO uncomment this line
                } 
            }
        }   
        update accountsToUpdate;
    }
    
    @TestVisible
    private static Id fetchBankRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where (DeveloperName = 'School' ) And sObjectType = 'Account'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }
    
     @TestVisible
    private static Id fetchClusterRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where (DeveloperName = 'Cluster' ) And sObjectType = 'Account'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }
    
    
    @TestVisible
    private static Map<String,ISOMapping__c> getIso3CountryCodeMap(){       
        Map<String,ISOMapping__c>iso2VsIso3CountryCodes = new Map<String,ISOMapping__c>();
        List<ISOMapping__c>isoMappings = [select id,ISO2__c,ISO3__c,Geo_Code__c from ISOMapping__c];
        for(ISOMapping__c isoMap : isoMappings){
            iso2VsIso3CountryCodes.put(isoMap.ISO2__c, isoMap);
        }       
         return iso2VsIso3CountryCodes;
    }

    @TestVisible
    private static Map<String,AccountTeamMember> fetchTeamMemberRoleVsAccountTeamMember(Set<Id> accountIds){
         List<AccountTeamMember> accountTeamMemberList = fetchAccountTeamMemberList(accountIds);
        Map<String,AccountTeamMember> accountTeamMemberMap = new  Map<String,AccountTeamMember>();
        if(accountTeamMemberList != null && accountTeamMemberList.size() > 0){
            for(AccountTeamMember accMember :  accountTeamMemberList){
                accountTeamMemberMap.put(accMember.TeamMemberRole,accMember);
            }
        }
        return accountTeamMemberMap;
   } 
  
  @TestVisible
   private static List<AccountTeamMember> fetchAccountTeamMemberList(Set<Id> accountIds){
     List<AccountTeamMember> accountTeamMemberList = [SELECT id,AccountId,User.name,user.C3_Employee_Id__c,TeamMemberRole FROM AccountTeamMember WHERE AccountId IN :accountIds];
     return accountTeamMemberList;
   }
   @TestVisible
    private static  List<Account> fetchAccountToSend (Set<Id> accountIds){
        List<Account> accountstoSend = [select id,name,ShippingCountryCode,C3SchoolType__c,ShippingPostalCode,ShippingCity,ShippingStreet,ShippingStateCode,School_Years_Start__c,School_Years_End__c,
        BillingCountryCode,BillingStateCode,BillingState,ShippingState,BillingPostalCode,BillingCity,BillingStreet,OwnerId,Description,
        Website,Phone,Fax,School_Classification__c,Inactive__c,Owner.C3_Employee_Id__c,RecordTypeId,Status__c,C3_Id__c,School_Category__c,
        Total_Number_Students__c,Global_School_Category__c,Reading_Eggs_ID__c,VAT_Number__c
        from Account where Id IN :accountIds];
        return accountstoSend;
   }
}