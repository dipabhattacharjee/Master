public class UpdateLineItemsWhenPriceBookChanged {



    public UpdateLineItemsWhenPriceBookChanged (){}
    
    //Allow User to delete Opportunity Line Items while changing the PriceBook on Opportunity, except Stages in Custom setting OpportunityDeletetStagesNotAllowed__c
    public void updateOpportunityLineItemsWhenPriceBookChanged(Set<Id> oppIds,List<Opportunity> opportunties,Map<Id,Opportunity> oldOpportunityMap)
    {
        System.debug('updateOpportunityLineItemsWhenPriceBookChanged ' + opportunties);
        
        Map<Id,List<OpportunityLineItem>> oppIdVsLineItemListMap = new Map<Id,List<OpportunityLineItem>>();
        oppIdVsLineItemListMap = getMapOpportunityIdVsLineItemList(oppIds);
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        Map<String,OpportunityDeletetStagesNotAllowed__c> OpportunityDeletetStagesNotAllowedMap = OpportunityDeletetStagesNotAllowed__c.getAll();
        for(Opportunity opp : opportunties){
            System.debug('oldOpportunityMap.get(opp.Id)' + oldOpportunityMap.get(opp.Id) );
             System.debug('opp current' + opp );
            If(opp.StageName != 'Interest' && opp.pricebook2Id != oldOpportunityMap.get(opp.Id).pricebook2Id && !OpportunityDeletetStagesNotAllowedMap.containsKey(opp.stageName)){
                System.debug('Pricebook changed' + opp.pricebook2Id + ' This old pricenbook ID ' + oldOpportunityMap.get(opp.Id).pricebook2Id);
                If(oppIdVsLineItemListMap.Size() > 0 && oppIdVsLineItemListMap != null){
                    
                    If(oppIdVsLineItemListMap.containsKey(opp.Id)){
                        System.debug('oppIdVsLineItemListMap' +oppIdVsLineItemListMap );
                        for(OpportunityLineItem lineItem : oppIdVsLineItemListMap.get(opp.Id)){
                            lineItem.AllowDeleteOnPriceBookChange__c = true;
                            oppLineItems.add(lineItem);
                        }
                        
                    }
                }
                
            }
        }
        System.debug('This is to check LineItems before we update' +oppLineItems);
        If(oppLineItems.Size() > 0 && oppLineItems != null){
            System.debug('This not null lineItems it should not be come here' +oppLineItems );
            update oppLineItems;
        }
        
        
    }

    public Map<Id,List<OpportunityLineItem>> getMapOpportunityIdVsLineItemList(Set<Id> opportunityIds){
        
        System.debug('getMapOpportunityIdVsLineItemList :' + opportunityIds);
        List<OpportunityLineItem> opportunityLineItemList = [Select Id,Name,OpportunityId,Opportunity.Pricebook2Id, AllowDeleteOnPriceBookChange__c 
                                                                from OpportunityLineItem 
                                                                Where OpportunityId IN :opportunityIds];
                                                                
        Map<Id,List<OpportunityLineItem>> oppIdVsLineItemListMap = new Map<Id,List<OpportunityLineItem>>();
        
        for(OpportunityLineItem OLI : opportunityLineItemList){
            
            If(oppIdVsLineItemListMap.containsKey(OLI.OpportunityId)){
                oppIdVsLineItemListMap.get(OLI.OpportunityId).add(OLI);
            }else{
                oppIdVsLineItemListMap.put(OLI.OpportunityId,new List<OpportunityLineItem>{OLI});
            }
        }
        return oppIdVsLineItemListMap;
    }
}