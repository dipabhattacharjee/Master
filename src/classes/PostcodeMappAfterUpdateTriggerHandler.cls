public class PostcodeMappAfterUpdateTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {  
    process(tp.newList,tp.oldMap.values());
  }
   private static void process(List<Postcode_Mapping__c>postCodeMapList ,List<Postcode_Mapping__c> postcodeOldList) {
        
        new PostCodeMappingWithAccount().updateAccountOnUpdatePostMapp(postCodeMapList,new Map<Id,Postcode_Mapping__c>(postcodeOldList));
    }
}