public class CurrencySynchroniser {
	

   
  
     public static void SyncOptyCurrencytoAccounts(set<id> OpportunityIds)
     {
       

         List<Opportunity> oppList = [select id, accountid,account.CurrencyCopy__c, CurrencyIsoCode,ACTNSCRM__NS_Currency__c  from opportunity where Id in :OpportunityIds];

         system.debug('SyncOptyCurrencytoAccounts.oppList:'+oppList);

        Map<Id, Id> opportunitiesCurrencies = new Map<Id, Id>();

        for(Opportunity opportunity : oppList) {
            if(!opportunitiesCurrencies.containsKey(opportunity.Id))
            {
                opportunitiesCurrencies.put(opportunity.AccountId, opportunity.ACTNSCRM__NS_Currency__c);
                system.debug('SyncOptyCurrencytoAccounts.opportunitiesCurrencies.put:'+opportunity.AccountId + ',ACTNSCRM__NS_Currency__c: '+opportunity.ACTNSCRM__NS_Currency__c);
            }

        }

        system.debug('SyncOptyCurrencytoAccounts.opportunitiesCurrencies:'+opportunitiesCurrencies);


       Map<Id, List<Id>>  accountCurrenciesMap = LookupOpportunityCurrencyInAccountCurrency(opportunitiesCurrencies.keySet());

       
       List<ACTNSCRM__Account_Currency__c> accountCurrencies_insert= new List<ACTNSCRM__Account_Currency__c>();

        for(Id accountId : opportunitiesCurrencies.keySet()) 
        {                       
            if( accountCurrenciesMap!=null && 
                accountCurrenciesMap.containsKey(accountId) &&
                opportunitiesCurrencies.containsKey(accountId))
            {
                if(!OpportunityCurrencyExist(accountCurrenciesMap.get(accountId), opportunitiesCurrencies.get(accountId)))
                {
                    accountCurrencies_insert.add(CreateAccountCurrency(accountId, opportunitiesCurrencies.get(accountId)));
                }
            }   
           
        }

        if(accountCurrencies_insert.size()>0) 
            insert accountCurrencies_insert;
     }     

     public static Boolean OpportunityCurrencyExist(List<Id> accountCurrencies, Id currencyCode)   
     {
        if(accountCurrencies == null)
        {
            return false;
        }
        
        for(Id accountCurrencyId : accountCurrencies)
        {
            if(accountCurrencyId == currencyCode)
            {
                return true;
            }
        } 

        return false;
     }    
    
   
     private static Map<Id, List<Id>> LookupOpportunityCurrencyInAccountCurrency(Set<Id> accountIds)
    {
        Map<Id, List<Id>> accountCurrenciesMap = new Map<Id, List<Id>>();
         
         if(accountIds==null)
            return accountCurrenciesMap;

        
        List<ACTNSCRM__Account_Currency__c> accCurrencies = [Select ACTNSCRM__Account__c, ACTNSCRM__Currency__c
                                                             from ACTNSCRM__Account_Currency__c
                                                              where 
                                                              ACTNSCRM__Account__c = : accountIds];  

        system.debug('LookupOpportunityCurrencyInAccountCurrency.accCurrencies:' + accCurrencies);
        
        if(accCurrencies== null  || accCurrencies.size() == 0)
        {
            return accountCurrenciesMap;
        }

         for(ACTNSCRM__Account_Currency__c account_Currency : accCurrencies) {

                
            if(!accountCurrenciesMap.containsKey(account_Currency.ACTNSCRM__Account__c))
            {
                List<Id> temp_ops= new List<Id>();
                temp_ops.add( account_Currency.ACTNSCRM__Currency__c);
                accountCurrenciesMap.put(account_Currency.ACTNSCRM__Account__c,temp_ops);
            }
            else {
                accountCurrenciesMap.get(account_Currency.ACTNSCRM__Account__c).add(account_Currency.ACTNSCRM__Currency__c);
            }

        }

       system.debug('LookupOpportunityCurrencyInAccountCurrency.accountCurrenciesMap:' + accountCurrenciesMap);

       return accountCurrenciesMap;
    }
   
    private static ACTNSCRM__Account_Currency__c CreateAccountCurrency(Id accountId, String newCurrency)
    {
        ACTNSCRM__Account_Currency__c AcntCurr = new ACTNSCRM__Account_Currency__c(ACTNSCRM__Account__c = accountId, ACTNSCRM__Currency__c = newCurrency);
       	return AcntCurr;
    }  

}