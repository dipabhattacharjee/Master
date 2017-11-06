/**
 * @author: Amit Shirude
 * @Description: This class implement the StatelessBatchExecutor to Update Licence Status.
 * @Test Class:    UpdateLicenceStatus_Test
 * @History: 
	21/04/2016 created.
 */
public class UpdateLicenceStatus implements StatelessBatchExecutor.CustomBatchable{
    public void execute(List<Asset> scope){    
        RecordType__c LicenceRecordType = RecordType__c.getValues('Asset Full Licence');
           Id Full_licenceRecordTypeId = LicenceRecordType.RecordTypeId__c;
        
        List<Asset> actualScope = [SELECT Id, UsageEndDate, Status FROM Asset
        WHERE Status IN ('Expired','Provisioned')
        // AND RecordTypeId = : Full_licenceRecordTypeId
        AND Id IN :scope];        
        updateAssetstoExpired(actualScope);		
    }   
   

	/**
	 * @author: Amit Shirude
	 * @Description: Method to update Licences to Expired.
	 * @Param : Asset List to update.	 
	 * @History: 
		21/04/2016 created.
	 */
    public void updateAssetstoExpired(List<Asset> AssetList){
       try{           
           //Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');		   
           //myCS1.Block_Trigger_Execution__c = True;           
           //Update myCS1;
           
           for(Asset Aset : AssetList){
                if(Aset.Status == 'Provisioned' ){
                    if(Aset.UsageEndDate < System.today()){
                        Aset.Status = 'Expired';
                    }
                }
               else if(Aset.Status == 'Expired'){                    
                    if(Aset.UsageEndDate < System.Today()-90){                        
                        Aset.Status = 'Lost';
                    }
               }
            }
           Update AssetList;
       }catch(Exception ex){
           //List<Trigger_Handler__c> li_trigger_status_insert = new List<Trigger_Handler__c>();           
           //Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');		   
           //myCS1.Block_Trigger_Execution__c = False;           
           //Update myCS1;
           System.debug('Exception -' +ex);		   
       }        
    }
     public void finish(){           
           //Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');		   
           //myCS1.Block_Trigger_Execution__c = False;           
           //Update myCS1;
    }
}