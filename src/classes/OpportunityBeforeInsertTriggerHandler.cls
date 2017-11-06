public class OpportunityBeforeInsertTriggerHandler extends TriggerHandlerBase { 
    public override void mainEntry(TriggerParameters tp) {
       process(tp.newList);
    }
  
    private static void process(List<Opportunity>opportunityList) {     
    
       // new OpportunityAssociateCurrency().setCurrency(opportunityList);
        
    }

}