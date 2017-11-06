public class AccountBeforeUpdateTriggerHandler extends TriggerHandlerBase {
   public override void mainEntry(TriggerParameters tp) {
    process(tp.newList,tp.oldMap.values());
  }
  
  private static void process(List<Account>accountList,List<Account>oldAccountList) {   
	new CheckAndSetShippingAddress().setShippingAddress(accountList);  
    new AccountTerritoryManager().assignTerritory(accountList);
	new accountTypeCategoryMapping().typeCategoryMapping(accountList,new Map<Id,Account>(oldAccountList));    
  }
}