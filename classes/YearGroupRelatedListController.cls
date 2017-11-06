/**
 * @author: vishnu.belkone@arxxus
 * @description: this class is to get and display all yeargroups of selected asset.
 * @Test Class:    YearGroupRelatedListController_Test
 * @History: 
	11/09/2015 created.
*/

public with sharing class YearGroupRelatedListController { 
     public Asset singleAsset{get;Set;}
     public List<Year_Group__c>yearGroupListToUpdate{get;Set;}
     private ApexPages.StandardController controller {get; set;}
     public Boolean isError{get;Set;}  
    
     public YearGroupRelatedListController(ApexPages.StandardController stdController){
        this.controller = stdController;
        this.singleAsset = (Asset)controller.getRecord();   
        yearGroupListToUpdate = getYearGroupList(this.singleAsset);    
     }
       
  /** 
  * @author Vishnu Belkone
  * @date 10/08/2015
  * @description - method to save yeargroups.  * 
  */
     public void save(){
        try 
        {      
             
            if (yearGroupListToUpdate != null && yearGroupListToUpdate.size() > 0)
            {                 
                Update yearGroupListToUpdate;                      
            }else{
         isError = true;
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There are no year Groups to update.'));
            }        
        }
        catch (Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));                
                
        }       
        
    }

    
  /** 
  * @author Vishnu Belkone
  * @date 10/08/2015
  * @description - method to return list of yeargroups related to asset
  * @param - TriggerParameters The trigger parameters such as the list of records before and after the update.
  */
     private List<Year_Group__c> getYearGroupList (Asset singleAsset){
        List<Year_Group__c> yearGroupList = [Select Id,name,Students__c,Year_Group__c,Provision__c From Year_Group__c Where Asset__c =:singleAsset.Id ORDER BY C3_Year_Group__c];    
    return yearGroupList;
     }     
     
}