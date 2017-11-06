public class AccountAssociateRegion {
    
    public void setRegion(List<Account> accountList){
        
        for (Account acc : accountList)
        {
    
            string sub = acc.AccountOwnerRegion__c;            
            if (sub <> '' && sub !=null)
            {
                acc.Territory__c = sub;
            }
        }
    }

}