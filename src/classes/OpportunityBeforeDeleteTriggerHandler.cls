public class OpportunityBeforeDeleteTriggerHandler extends TriggerHandlerBase{

    
    public override void mainEntry(TriggerParameters tp) {
       System.debug('Before Opportunity Delete Call');
        
        if(!TriggerSetting.IsTriggerBlocked() && !TriggerSetting.IsCurrentUserIntegrationUser())
        {
          process(tp.oldList, tp);       
       }
    }
    
    
    private static void process(List<Opportunity> opportunityList, TriggerParameters tp) {
        
        System.debug('New Before Count: ' + opportunityList.size());
        
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>();     
        
        canDeleteOpportunity = new OpportunityDeleteValidator().validate(opportunityList); 
	}
}