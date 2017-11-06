public class AccountAfterInsertTriggerHandler extends TriggerHandlerBase {
  public static List<Account> accountListAssociatedWithSSC{get;set;}  
  public static Set<Id> accountIdstAssociatedWithSSC{get;set;}

  public override void mainEntry(TriggerParameters tp) {
	
  
    if(TriggerSetting.CanTriggerProcessRun())
     {
		    process(tp,tp.newList);
     }
	
  
  }
  
  private static void process(TriggerParameters tp,List<Account>accountList) {     
    new AccountServices().runServices(tp.newMap.keyset());

     new AccountAfterInsertTriggerHandler().getAccountListSeperatedAsPerTheAssociatedSSc(accountList);
    if(accountListAssociatedWithSSC != null && accountListAssociatedWithSSC.size() > 0){
     new UpdateBillingAddressOnChangeSSCOnAccount().updateBillingAddressOnAcount(accountListAssociatedWithSSC,accountIdstAssociatedWithSSC);  
    }   
  }   
   public void getAccountListSeperatedAsPerTheAssociatedSSc(List<Account> accountList){
     accountListAssociatedWithSSC = new List<Account>();
     accountIdstAssociatedWithSSC = new Set<Id>();
     
      for(Account acc : accountList){          
              If(acc.Shared_Service_Center__c  != null ){
                  accountListAssociatedWithSSC.add(acc);
                  accountIdstAssociatedWithSSC.add(acc.Id);
              }          
      }

  }
  
}