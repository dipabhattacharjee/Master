public class AssetAfterUpdateTriggerHandler extends TriggerHandlerBase {
  public override void mainEntry(TriggerParameters tp) {
   
     if(TriggerSetting.CanTriggerProcessRun())
    {
      process(tp,tp.newList,tp.oldMap.values());
    }
    
  }  
 
  private static void process(TriggerParameters tp, List<Asset> newAssetLists, List<Asset> oldAssetLists) {
      system.debug('#This is to test AssetLists in after update' + newAssetLists);      
     
      Map<Id, Asset> assetOldMap = new Map<Id,Asset>(oldAssetLists);

      For(Asset asset : newAssetLists) 
      {        
   
        if ( asset.Status == 'Provisioned' ||  asset.Status == 'Cancelled')
        { 
          //To avoid C3 Id update
          if(assetOldMap.get(asset.Id).AvoidTriggerExecution__c != asset.AvoidTriggerExecution__c)
          {
              continue;
          }          
          if(System.isFuture() == false && System.isBatch() == false )   
          {               
            PppLearningLicenceService.UpdateLicenceAsync(asset.Id);
            system.debug('AssetAfterUpdateTriggerHandler updating licence for assetId:' + asset.Id+ ', recordTypeId:' + asset.recordTypeId);                    
          }
        }

   	    }  
  } 
  
  public override void inProgressEntry(TriggerParameters tp) {
    System.debug('This is an example for reentrant code...');
  }
}