/**
 * @author: Harry Alderman
 * @Description: This class implement the StatelessBatchExecutor to Update Account Records.
 * @Test Class:    
 * @History: 
  10/05/2016 created.
 */
public class UpdateAccountSalesRegion implements StatelessBatchExecutor.CustomBatchable{
    public void execute(List<Account> scope){
    try{  
            Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');       
            myCS1.Block_Trigger_Execution__c = True;           
            Update myCS1;    
      
            List<Account> acctList = [SELECT Id, Sales_Region__c  FROM Account 
                                WHERE Id IN (SELECT ObjectId FROM ObjectTerritory2Association
                                            WHERE LastModifiedDate>YESTERDAY AND ASSOCIATIONCAUSE='Territory2AssignmentRule') AND Id IN :scope]; 
            List<ObjectTerritory2Association> acctTerr = [SELECT ObjectID, Territory2Id, ObjectTerritory2Association.Territory2.Name 
                                                FROM ObjectTerritory2Association WHERE LastModifiedDate>YESTERDAY AND ASSOCIATIONCAUSE='Territory2AssignmentRule' AND ObjectId IN :scope];
            Map<String,String> AccTerrMap = new Map<String,String>();
            for (ObjectTerritory2Association t : acctTerr){
               AccTerrMap.put(t.ObjectID, t.Territory2.Name);
            } 
            
            for(Account a : acctList){
                if(AccTerrMap.containsKey(a.Id)){
                    a.Sales_Region__c = AccTerrMap.get(a.ID);
                    }
            }
             
            update acctList;  
        
    } catch(Exception ex){
        Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');       
        myCS1.Block_Trigger_Execution__c = False;           
        Update myCS1;
        System.debug('Exception - ' +ex);
        }  
    }
    
    public void finish(){           
           Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');       
           myCS1.Block_Trigger_Execution__c = False;           
           Update myCS1;
    }
}