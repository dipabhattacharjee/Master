public class UpdateTerritoriesOnOppnAcct 
{     
    @InvocableMethod     
    public static void UpdateTerritory(List<Id> AccountIds)     
    {         
        system.debug('Inside 1 UpdateTerritoriesOnOppnAcct');
        
//        List<Opportunity> oppList=[select id, accountid, territory2id from opportunity
//                            where StageName<>'Sold - Invoiced' and StageName<>'Sold - Adjustment' and Opportunity.accountid in :AccountIds];
        
        List<Account> acctList = [SELECT Id, Sales_Region__c  FROM Account 
                                WHERE Id in :AccountIds];
                                     
        List<ObjectTerritory2Association> acctTerr = [SELECT ObjectID, Territory2Id, ObjectTerritory2Association.Territory2.Name 
                                                FROM ObjectTerritory2Association WHERE ASSOCIATIONCAUSE='Territory2AssignmentRule' AND ObjectId IN :AccountIds];
            
            Map<String,String> AccTerrMap = new Map<String,String>();
//            Map<String,String> OppTerrMap = new Map<String,String>();
            for (ObjectTerritory2Association t : acctTerr){
               AccTerrMap.put(t.ObjectID, t.Territory2.Name);
            } 
            
/*            for (ObjectTerritory2Association r : acctTerr){
               OppTerrMap.put(r.ObjectID, r.Territory2Id);
            } 
*/            
              
            for(Account a : acctList){
                if(AccTerrMap.containsKey(a.Id)){
                    a.Sales_Region__c = AccTerrMap.get(a.ID);
                    }
            }
            
            
/*            for(Opportunity o : oppList){
                if(OppTerrMap.containskey(o.accountid)){
                    o.Territory2id = OppTerrMap.get(o.accountid);
                }
            }
*/             
        if(acctList.size() != 0 ){update acctList;}
            
//        if(oppList.size() != 0 ){
//            update oppList;}    
    } 
}