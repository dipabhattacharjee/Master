/**
*This class is getting called from opportunityLineItemB4DeleteTriggerHandller
*This class contains funtionality to validate opportunity befor getting deleted and give errors.
**/
public class OpportunityLineItemDeleteValidator {
    
    /**
	*This function checks If the opportunityLineItems has licences then give error. 
	*/
    public List<OpportunityLineItem> ValidateOpportunityLineItemHasLicence(List<OpportunityLineItem> opportunityLineItemList){        
        Map<Id,List<Asset>> oppIdVsAssetListMap = getOpportunityIdVsAssetList(getOpportunityIdSet(opportunityLineItemList));
        
        List<opportunityLineItem> canDeleteOpportunityLineItem = new List<opportunityLineItem>(); 
        
        for(opportunityLineItem lineItem: opportunityLineItemList){
            
            If(oppIdVsAssetListMap.containsKey(lineItem.OpportunityId)){
                
                    for(Asset ast : oppIdVsAssetListMap.get(lineItem.OpportunityId)){
                        
                        If(lineItem.Family__c == ast.ProductFamily__c && lineItem.AllowDeleteOnPriceBookChange__c == false ){
                            lineItem.addError('Cannot delete opportuntiy LineItem having licence');   
                        } 
                        else {
                        		canDeleteOpportunityLineItem.add(lineItem);
                        }
                    }                
            }else{
                canDeleteOpportunityLineItem.add(lineItem);
            }
        }
        return canDeleteOpportunityLineItem;
    } 
    
    /**
	*This function returns Opportunity Id Vs Asset. 
	*/
    public Map<Id,List<Asset>> getOpportunityIdVsAssetList(Set<Id> opportunityIds){
        List<Asset> assetList = [Select Id,Name,Opportunity__c,ProductFamily__c from Asset where Opportunity__c IN :opportunityIds];
        Map<Id,List<Asset>> oppIdVsAssetListMap = new Map<Id,List<Asset>>();
        
        for(Asset ast: assetList){
            If(oppIdVsAssetListMap.containsKey(ast.Opportunity__c)){
                oppIdVsAssetListMap.get(ast.Opportunity__c).add(ast);
            }else{
                oppIdVsAssetListMap.put(ast.Opportunity__c,new List<Asset>{ast});
            }
        }
        return oppIdVsAssetListMap;
    }
    
    /**
	*This function returns Opportunity Id Set. 
	*/
    public Set<Id> getOpportunityIdSet(List<OpportunityLineItem> oppLineItems){
        Set<Id>oppIds = new Set<Id>();
        for(OpportunityLineItem lineItem : oppLineItems){
            oppIds.add(lineItem.OpportunityId);
        }
        return oppIds;
    }

}