/**
* @author vishnu belkone
* @description This class will create opportunities and product for Licences renewal
* @TestClass: CreateOpportunitiesForLicencesRenewal_Test
*/
public class CreateOpportunitiesForLicencesRenewal {
    public String crossCurrencyError{get;Set;}
    public Boolean isError{get;Set;}
   public Set<Id> opportuniiesForRenewal(List<AssetLicencesWrapperForRenewal> assetListWrapper,Date closeDate,Id pricrebookId,Set<Id>assetIdsToCheck){
      Set<Id> assetIds =  createOpportunities(assetListWrapper,closeDate,pricrebookId,assetIdsToCheck);
      return assetIds;
    }


    private Set<Id> createOpportunities(List<AssetLicencesWrapperForRenewal> assetListWrapper,Date closeDate,Id pricrebookId,Set<Id>assetIds){
        List<Opportunity>oppToCreateList =  new List<Opportunity>();
        List<OpportunityLineItem>oppLineItemToCreateList =  new List<OpportunityLineItem>();
        Opportunity opp;
        OpportunityLineItem oppLineItem;
        //Set<Id>assetIds = new Set<Id>();
        Asset singleAsset;
        //Map<Id,Map<Id,OpportunityLineItem>>oppLineItemMap = getIdVsOppLineItems();
        
        Map<Id,Map<Id,PricebookEntry>>pricebookEntryMap = getPriceBookEntries(pricrebookId);        
       
        Map<Opportunity,opportunityLineItem>oppVsLineItem = new Map<Opportunity,opportunityLineItem>();
        for (AssetLicencesWrapperForRenewal wrapper :assetListWrapper)
        {
            opp = new Opportunity();
            if (!assetIds.contains(wrapper.singleAsset.Id))
            {
                if(wrapper.isSelected == true){
                    opp.Name = wrapper.singleAsset.account.name + ' & Renewal';
                    opp.StageName = 'Interest';
                    opp.Type = 'Renewal';               
                    opp.closeDate = closeDate;  
                    opp.priceBook2Id =  pricrebookId;   
                    opp.CurrencyIsoCode = wrapper.singleAsset.account.CurrencyIsoCode; 
                    opp.accountId =  wrapper.singleAsset.AccountId; 
                    insert opp;
                    oppLineItem = new OpportunityLineItem();
                    
                    //System.debug('This is productId single' +oppLineItemMap.get(wrapper.singleAsset.Product2Id));

                    if (pricebookEntryMap.get(pricrebookId) != null && pricebookEntryMap.get(pricrebookId).size() > 0)
                    {
                   
                        if (pricebookEntryMap.get(pricrebookId).containsKey(wrapper.singleAsset.Product2Id))
                        {
                            
                            if (pricebookEntryMap.get(pricrebookId).get(wrapper.singleAsset.Product2Id).CurrencyIsoCode  == wrapper.singleAsset.account.CurrencyIsoCode)
                            {
                             
                                oppLineItem.pricebookEntryId = pricebookEntryMap.get(pricrebookId).get(wrapper.singleAsset.Product2Id).Id;
                                oppLineItem.UnitPrice = pricebookEntryMap.get(pricrebookId).get(wrapper.singleAsset.Product2Id).UnitPrice;
                            }else{
                                isError = true;
                                throw new CustomException('The some of selected licences are not valid for selected PriceBook.');
                            }
                            
                        }else{
                            throw new CustomException('There are no pricebook entries for selected pricebook and procuct.');
                        }

                    }
                   
                    oppLineItem.Quantity = 1;                               
                    oppLineItem.OpportunityId = opp.Id;                         
                    oppLineItem.Provision_Trial_License__c = false;
                    oppLineItem.Provision_Full_License__c = false;
                    oppVsLineItem.put(opp,oppLineItem);                         
                    oppLineItemToCreateList.add(oppLineItem);
                    singleAsset = new Asset();
                    assetIds.add(wrapper.singleAsset.Id);
                }           
            }
            
        }
        /*List<Opportunity> oppList = new List<Opportunity>();
        oppList.addAll(oppVsLineItem.keySet()); 
        System.debug('This is pricebook currency Map' +oppVsLineItem);
        insert oppList;
         System.debug('This is pricebook currency Map' +oppVsLineItem);
        for (opportunity oppo : oppVsLineItem.keySet())
        {
            oppVsLineItem.get(oppo).OpportunityId = oppo.Id;
        }
        insert oppVsLineItem.values();*/
        if (oppLineItemToCreateList != null && oppLineItemToCreateList.size() > 0 )
        {
            insert oppLineItemToCreateList;
            return assetIds;
            
        }  
        return null;      
    }


    //method to return map opp vs map id vs OpportunityLineItem
    /*private Map<Id,Map<Id,OpportunityLineItem>> getIdVsOppLineItems (){
        Map<Id,Map<Id,OpportunityLineItem>> oppVsOppLineItemMap = new Map<Id,Map<Id,OpportunityLineItem>>();
        List<OpportunityLineItem>oppLineItemList = new List<OpportunityLineItem>();
        oppLineItemList = [select Id,Name,ServiceDate,Description,ListPrice,Product2Id,PricebookEntryId,OpportunityId,ProductCode,Quantity,TotalPrice,License_Provisioned__c,Provision_Full_License__c,Provision_Trial_License__c,Trial_Provisioned__c,Trial_Start_Date__c from opportunityLineItem];
     if(oppLineItemList != null && oppLineItemList.size() > 0){
        for(OpportunityLineItem oppItem : oppLineItemList){
            If(oppVsOppLineItemMap.get(oppItem.OpportunityId) != null){
                oppVsOppLineItemMap.get(oppItem.OpportunityId).put(oppItem.Product2Id,oppItem);
            }else{
                oppVsOppLineItemMap.put(oppItem.OpportunityId, new Map<Id,OpportunityLineItem>{oppItem.Product2Id =>  oppItem});
            }
        }
     }
    return oppVsOppLineItemMap;
    }*/
    
    //Method to return pricebook entries 
     @TestVisible
    private Map<Id,Map<Id,PricebookEntry>> getPriceBookEntries(Id priceBookId){
        System.debug('This is before query :' + priceBookId);
         List<PricebookEntry> pricebookEntryList = [select Id,name,Pricebook2Id,UnitPrice,Product2Id from PricebookEntry where Pricebook2Id = :priceBookId];
          System.debug('This is before query :' + pricebookEntryList);
          Map<Id,Map<Id,PricebookEntry>>pricebookEntryMap = new Map<Id,Map<Id,PricebookEntry>>();
         if(pricebookEntryList != null && pricebookEntryList.size() > 0){
            for(PricebookEntry entry : pricebookEntryList){
                If(pricebookEntryMap.get(entry.Pricebook2Id) != null && pricebookEntryMap.get(entry.Pricebook2Id).size() > 0){
                    pricebookEntryMap.get(entry.Pricebook2Id).put(entry.Product2Id,entry);
                }else{
                    pricebookEntryMap.put(entry.Pricebook2Id, new Map<Id,PricebookEntry>{entry.Product2Id =>  entry});
                }
            }
         }
         return pricebookEntryMap;
    }
}