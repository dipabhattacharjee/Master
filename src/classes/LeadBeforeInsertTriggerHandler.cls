public class LeadBeforeInsertTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {
    process(tp.newList);
  }
  
  private static void process(List<Lead>leadList) {     
  //new CheckAndSetLeadCurrency().setLeadCurrency(leadList);
  }
}