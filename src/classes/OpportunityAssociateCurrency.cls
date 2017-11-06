public class OpportunityAssociateCurrency {
    
    public void setCurrency(List<Opportunity> opportunityList){
            
            Map<String, Id> currencies =  getActiancurrencyids();
            for (Opportunity opp : opportunityList)
            {        
                string accountCurrency = opp.AccountCurrency__c;

                system.debug('Inside OpportunityAssociateCurrency Class - opp.accountCurrency: '+ accountCurrency + ' oppId: '+opp.Id);
                string actiancurrencyid;

                if(currencies.containsKey(accountCurrency))
                {
                    actiancurrencyid = currencies.get(accountCurrency);
                }
                else {

                    continue;
                }
                //string accountCurrency = opp.ACTNSCRM__Currency__c;
                
                if (actiancurrencyid <> '' && actiancurrencyid !=null)
            	{
                	opp.ACTNSCRM__NS_Currency__c = actiancurrencyid;                    
            	}
            }
        }
    
  
    
     public Map<String, Id> getActiancurrencyids(){
        List<ACTNSCRM__Currency__c> currList = [Select Id,name,ACTNSCRM__ISO_Code__c from ACTNSCRM__Currency__c ];

         Map<String, Id> currencyMap=new Map<String, Id>();
            
         for(ACTNSCRM__Currency__c currencyCode : currList)
         {
            if(!currencyMap.containsKey(currencyCode.ACTNSCRM__ISO_Code__c))
            {
                currencyMap.put(currencyCode.ACTNSCRM__ISO_Code__c, currencyCode.Id);
            }

         }   
            return currencyMap;
    }
}