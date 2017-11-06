public class OpportunityAfterInsertTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp) {

      
        if(!TriggerSetting.IsTriggerBlocked() && !TriggerSetting.IsCurrentUserIntegrationUser())
        {
            process(tp);
        }


    }
  
    private static void process(TriggerParameters tp) {     
        new CreateOpportunityContactAccountPayable().InsertAccountPayableOpportunityContact(tp.newlist, tp.newMap.keySet());
    }
}