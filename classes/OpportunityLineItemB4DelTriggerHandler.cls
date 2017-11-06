public class OpportunityLineItemB4DelTriggerHandler Extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
    
        System.debug('Before OpportunityLineItem Delete Call');        
        
        if(!TriggerSetting.IsTriggerBlocked() && !TriggerSetting.IsCurrentUserIntegrationUser())
        {
          process(tp.oldList, tp);       
       }
    }
    
    
    private static void process(List<OpportunityLineItem> opportunityLineItemList, TriggerParameters tp) {
        
        System.debug('New Before Count: ' + opportunityLineItemList.size()); 
        
        List<OpportunityLineItem> canDeleteOpportunityLineItem = new List<OpportunityLineItem>();        
        
        canDeleteOpportunityLineItem = new OpportunityLineItemDeleteValidator().ValidateOpportunityLineItemHasLicence(opportunityLineItemList);        
    }
    
    
}