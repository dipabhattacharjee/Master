public class AssetAfterInsertTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {

      if(TriggerSetting.CanTriggerProcessRun())
     {
      process(tp.newList);
     }
  }
  
  private static void process(List<Asset> AssetLists) {
      system.debug('Amir #This is to test AssetLists' + AssetLists);
      For(Asset asset : AssetLists) {       
          //if (asset.Status == 'New')
            if (asset.C3_Id__c == null || asset.C3_Id__c <= 0)
            {
             //new AssetYearGLicenseService_Async().assetYearLicense(A.Id) ;
              if(System.isFuture() == false && System.isBatch() == false )   
               {
                 PppLearningLicenceService.CreateLicenceAsync(asset.Id);
                 system.debug('AssetAfterInsertTriggerHandler  for assetId:' + asset.Id+ ', recordTypeId:' + asset.recordTypeId);  
               }
          }

          //new AssetYearGLicenseService().assetYearLicense(A.Id) ;
      }
      
  }
}