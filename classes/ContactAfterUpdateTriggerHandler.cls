public class ContactAfterUpdateTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {
     
     if(TriggerSetting.CanTriggerProcessRun())
     {
       process(tp);
     }
  }
  
  private static void process(TriggerParameters tp) {
      system.debug('#This is to test' + tp.newMap.keyset());
   new ContactServices().runServices(tp.newMap.keyset());
  }
  
  public override void inProgressEntry(TriggerParameters tp) {
    System.debug('This is an example for reentrant code...');
  }
}