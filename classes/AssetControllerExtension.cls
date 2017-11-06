public with sharing class AssetControllerExtension {

    public String SyncMessage {
        get 
        {
            return syncMsg;
        }
        set;
    }
    
    public String MessageType {
        get 
        {
            return msgType;
        }
        set;
    }

    public String LastModifiedDate {
        get 
        {
            return lastModified;
        }
        set;
    }
    
    private String syncMsg;
    
    private String msgType;

    private Asset asset;

    private String lastModified;
    
    private ApexPages.StandardController stdController;

    public AssetControllerExtension (ApexPages.StandardController stdController) 
    {
        this.asset = (Asset)stdController.getRecord();
        this.stdController = stdController;
        this.getSyncMsg();
    }

    private void getSyncMsg() {
        
        List<AssetSyncStatus__c> assetSyncStatus  = [SELECT Message__c, MessageType__c, LastModifiedDate FROM AssetSyncStatus__c WHERE Asset__c = :asset.Id ORDER BY LastModifiedDate DESC LIMIT 1];
        
        if(assetSyncStatus.size() > 0)
        {
            syncMsg = assetSyncStatus[0].Message__c;
            msgType = assetSyncStatus[0].MessageType__c;        
            lastModified = 'Updated: ' + string.valueOfGmt(assetSyncStatus[0].LastModifiedDate);
        }
        else if(asset.C3_Id__c > 0)
        {
            syncMsg = 'Licence synchronised successfully';
            msgType = 'Success';
            lastModified = '';
        }
        else
        {
            syncMsg = 'Licence is not synchronised';
            msgType = 'Error';
            lastModified = '';
        }                
    }

}