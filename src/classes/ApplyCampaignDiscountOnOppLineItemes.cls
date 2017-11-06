/**
* This class is getting called from opportunity after triggers
*This claa contains funtionality to apply campaign discount to all the opportunity line items which are part part of that campaign.
**/
public class ApplyCampaignDiscountOnOppLineItemes {
    Public void ApplyCampaignDiscount(Set<Id>opportunityIds, Map<Id,Opportunity> opportunityMap){
        updateOpportunityLineItems(getOpplineItemesToUpdate(opportunityIds,opportunityMap));
        
    } 

    private void updateOpportunityLineItems(List<OpportunityLineItem> oppLineItemsWithCampaignDiscount){
       if(oppLineItemsWithCampaignDiscount.size() > 0 && oppLineItemsWithCampaignDiscount != null){
            update oppLineItemsWithCampaignDiscount;
       }
       
    }

    public List<OpportunityLineItem> getOpplineItemesToUpdate(Set<Id>OpportuntiyIds, Map<Id,Opportunity> opportunityMap){
        List<OpportunityLineItem> oppLineItems = [Select Id,Opportunity.CampaignId,OpportunityId from OpportunityLineItem where opportunityId IN :OpportuntiyIds]; 
        List<OpportunityLineItem> opportunityLineItemsToUpdated = new List<OpportunityLineItem>();
         for(OpportunityLineItem oppItem: oppLineItems ){
             if(oppItem.Opportunity.CampaignId != opportunityMap.get(oppItem.OpportunityId).CampaignId ){
                 opportunityLineItemsToUpdated.add(oppItem); 
             }
         }   
        return opportunityLineItemsToUpdated;
    }


}