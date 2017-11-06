/**
* @author: Asif A Khan
* @description: The class is to insert Sync Msg into custom objects.
* @Class: AssetSyncStatus__c
*/

public  class AssetSyncStatusData {

    public static void InsertAssetSyncStatus(Id assetId, String msg, AssetSyncMsgTypeEnum type)
    {
        try
        {
            system.debug('Request Received to Log Sync Status Msg: '+ assetId);                                

            AssetSyncStatus__c  syncStatusObj = new AssetSyncStatus__c();
                    
            syncStatusObj.Asset__c                  = assetId;
            syncStatusObj.Message__c                = msg;
            syncStatusObj.MessageType__c            = type.name();
            
            insert syncStatusObj;
            
            system.debug('Successfully Inserted Log Sync Status Msg: '+ syncStatusObj.Id);            
    
        }
        catch(Exception exp)
        {
            system.debug('Error in InsertAssetSyncStatus method with Exception '+ exp.getMessage() + ' StackTrace: ' + exp.getStackTraceString());

            ExceptionLogData.InsertExceptionlog(assetId, LoggingLevel.ERROR, 'AssetSyncStatus', exp, true, false, null, null);
        }        
    }

}