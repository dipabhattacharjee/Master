public class PostcodeMappAfterInsertTriggerHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
       System.debug('@This is to test map = ' + tp.oldMap);
       process(tp.newList);
    }
    private static void process(List<Postcode_Mapping__c>postCodeMapList) {        
        new PostCodeMappingWithAccount().updateAccountOnInsertPostMapp(postCodeMapList);
    }
}