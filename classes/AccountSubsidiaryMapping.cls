/**
* @author: Scott McCallum
* @description:
*/
public class AccountSubsidiaryMapping {
    public void setSubsidiary(List<Account>accountList){
       
        for (Account acc : accountList)
        {
    
            string sub = acc.Territory__c;
            system.debug('Territory Name =' + sub);
            string subid = getrollupSubsidiary(sub);
            system.debug('Subsidiary Id =' + subid);
            if (subid <> '' && subid !=null)
            {
                acc.ACTNSCRM__Subsidiary_Lookup__c = subid;
            }
        }
    }
    
    
    public String getrollupSubsidiary(String sub){
    List<ACTNSCRM__Actian_Subsidiary__c> SubList = [Select Id,name from ACTNSCRM__Actian_Subsidiary__c Where  Territory__c = :sub];
    if (SubList.size()>0)
    {
        return SubList[0].Id;

    }
    else
    {
      return null;
     }
    
      }  
    
}