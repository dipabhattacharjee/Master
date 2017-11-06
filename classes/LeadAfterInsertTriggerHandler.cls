public class LeadAfterInsertTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {
    process(tp.newList);
  }
  
  private static void process(List<Lead>leadList) {
    List<Lead> ls = new List<Lead>();

    for (Lead l : leadList) {
        ls.add(new Lead(id = l.id));
    }

    Database.DMLOptions dmo = new Database.DMLOptions();
    if(TriggerSetting.IsCurrentUserIntegrationUser())  
    {dmo.assignmentRuleHeader.useDefaultRule = true;}
    Database.update(ls, dmo);
    dmo.EmailHeader.triggerUserEmail = true;
    
  }
}