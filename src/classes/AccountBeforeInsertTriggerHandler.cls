public class AccountBeforeInsertTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {
   process(tp.newList);
   
  }
  
  private static void process(List<Account>accountList) {     
    new CheckAndSetShippingAddress().setShippingAddress(accountList);
    new AccountTerritoryManager().assignTerritory(accountList);
    system.debug('this is test category'+accountList);
    new accountTypeCategoryMapping().typeCategoryMappingForInsert(accountList);
    new AccountAssociateRegion().setRegion(accountList);
    new AccountSubsidiaryMapping().setSubsidiary(accountList);
    //new AccountCurrencyMapping().setCurrency(accountList);
  }
}