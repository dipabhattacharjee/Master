public class AccountAfterUpdateTriggerHandler extends TriggerHandlerBase {
  
  public static List<Account> accountListAssociatedWithSSC{get;set;}
  public  static List<Account> accountListDisAssociatedWithSSC{get;set;}
  
  public static Set<Id> accountIdstAssociatedWithSSC{get;set;}
  public  static Set<Id> accountIdstDisAssociatedWithSSC{get;set;}
  
  public override void mainEntry(TriggerParameters tp) { 
  
    
     if(TriggerSetting.CanTriggerProcessRun())
  
    {
       process(tp,tp.newList,tp.oldMap.values());  
    }   
  }
  
  private static void process(TriggerParameters tp,List<Account>accountList,List<Account>oldAccountList) {     
    new AccountServices().runServices(tp.newMap.keyset());

    new AccountAfterUpdateTriggerHandler().getAccountListSeperatedAsPerTheAssociatedSSc(accountList,new Map<Id,Account>(oldAccountList));
    if(accountListAssociatedWithSSC != null && accountListAssociatedWithSSC.size() > 0){
     new UpdateBillingAddressOnChangeSSCOnAccount().updateBillingAddressOnAcount(accountListAssociatedWithSSC,accountIdstAssociatedWithSSC);  
    }
    if(accountListDisAssociatedWithSSC != null && accountListDisAssociatedWithSSC.size() > 0 ){
      new UpdateBillAddToPrev3RdPartyAddOnRemSSC().updateThirdPartyAddressToUpdateAccBillingAddress(accountListDisAssociatedWithSSC,new Map<Id,Account>(oldAccountList),accountIdstDisAssociatedWithSSC);  
      new DelApContactFromOppOnRemoveSSCOnAccount().deleteApConfromOppOnUnlinkSSCFromAcc(accountListDisAssociatedWithSSC,new Map<Id,Account>(oldAccountList),accountIdstDisAssociatedWithSSC);
    }
    
  }
  
  public override void inProgressEntry(TriggerParameters tp) {
   
  } 


  public void getAccountListSeperatedAsPerTheAssociatedSSc(List<Account> accountList,Map<Id,Account>oldAccountMAp){
     accountListAssociatedWithSSC = new List<Account>();
     accountIdstAssociatedWithSSC = new Set<Id>();
     accountListDisAssociatedWithSSC = new List<Account>();
     accountIdstDisAssociatedWithSSC = new Set<Id>();
      for(Account acc : accountList){
          If(oldAccountMAp.containskey(acc.Id)){
              If(oldAccountMap.get(acc.Id).Shared_Service_Center__c !=  acc.Shared_Service_Center__c  && acc.Shared_Service_Center__c  != null ){
                  accountListAssociatedWithSSC.add(acc);
                  accountIdstAssociatedWithSSC.add(acc.Id);
              }else If(oldAccountMap.get(acc.Id).Shared_Service_Center__c !=  null  && acc.Shared_Service_Center__c  == null){
                  accountListDisAssociatedWithSSC.add(acc);
                  accountIdstDisAssociatedWithSSC.add(acc.Id);
              }
          }
      }

  }
 
}