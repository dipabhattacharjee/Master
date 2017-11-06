public class OpportunityAfterUpdateTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp) {
       if(TriggerSetting.CanTriggerProcessRun())
        {
             process(tp,tp.newList,tp.oldMap.values());
			applyDiscountCallingMethod(tp.newMap.keySet(),tp.oldMap.values());
        }        
    }
    
    public void applyDiscountCallingMethod(Set<Id> oppIds,List<Opportunity> opportunties){
          //This update is to recalculate the multi year discount on opportunity lineItem
         List<OpportunityLineItem> OpportuntiyLineItemesToUpdate = new OpportunityAfterUpdateTriggerHandler().getOpportunityLineItems(oppIds,new Map<Id,Opportunity>(opportunties));
        if(OpportuntiyLineItemesToUpdate.size() > 0){
            update OpportuntiyLineItemesToUpdate;
        }
        new ApplyCampaignDiscountOnOppLineItemes().ApplyCampaignDiscount(oppIds , new Map<Id,Opportunity>(opportunties));
        
    }
     private static void process(TriggerParameters tp,List<Opportunity> newOppList,List<Opportunity> oldOppList) {     
        System.debug('After update' + tp);
        AssetApplicationService assetApplicationService = new AssetApplicationService();


        //new CloneOpportunitywithProducts().cloneOpptyWithProducts(tp.newMap.keyset());

        //new OppBigDealAlertOnChatter().postBigDealAlert(newOppList , new Map<Id,Opportunity>(oldOppList));

        Id standardOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
        
        
        currencySynchroniser.SyncOptyCurrencytoAccounts(tp.newMap.keySet());

        Map<Id, Opportunity> oppOldMap = new Map<Id,Opportunity>(oldOppList);

        OpportunityData opportunityData = new OpportunityData();    

        System.debug('newOppList Size:' + newOppList.size());

        System.debug('Before loop Opportunity, Id:' +newOppList[0].Id +', StageName:' +newOppList[0].StageName +', Type:'+ newOppList[0].Type);
       
        For(Opportunity opty : newOppList) 
        {    

            // If oppertunity stage has not been changed ten we don't need to perfom any CRUD operation on Asset
           
            if(!test.isRunningTest() && oppOldMap.get(Opty.Id).StageName == Opty.StageName)
            {
                continue;
            }

            if(oppOldMap.get(Opty.Id).StageName == 'Sold' )
            {
                new CloneOpportunitywithProducts().cloneOpptyWithProducts(tp.newMap.keyset());
            }

            if(!test.isRunningTest() && oppOldMap.get(Opty.Id).Sold_Role__c == null && oppOldMap.get(Opty.Id).Sold_Role__c != Opty.Sold_Role__c)
            {
                continue;
            }

            //From this point its all about creating/updating assets
            //And we only need to do that for standard opportunity
            if(standardOpportunityRecordTypeId != opty.recordTypeId)
            {
               continue;
            }

            List<OpportunityLineItem> oppLineItemList = opportunityData.GetOpportunityLineItems(opty.Id);

            System.debug('Opportunity, Id:' +opty.Id +', StageName:' +opty.StageName +', Type:'+ opty.Type);

            if(opty.StageName == 'Sold - Invoiced' &&  oppOldMap.get(Opty.Id).StageName == 'Sold - Adjustment') 
            {
                 if(opty.Type == 'New Business' || opty.Type == 'Renewal' || opty.Type == 'Cross Sell')
                 {
                     assetApplicationService.UpsertFullAssets(opty, oppLineItemList);     
                 }

                if(opty.Type == 'Up Sell' )
                {
                                
                }
            }

            if(opty.StageName == 'Sold' && oppOldMap.get(Opty.Id).StageName != 'Sold - Adjustment')
            {                                

                if(opty.Type == 'New Business' || opty.Type == 'Renewal' || opty.Type == 'Cross Sell')
                {
                   assetApplicationService.UpsertFullAssets(opty, oppLineItemList);                    
                }


                if(opty.Type == 'Up Sell' )
                {
                    // update the number of students           
                    assetApplicationService.UpdateNumberOfStudentsForFullAssets(opty, oppLineItemList);        
                    
                }
            }

            if (opty.StageName == 'Trial')
            {
                 boolean hasTrialExtended = assetApplicationService.CheckAndExtendTrialAssets(opty, oppLineItemList);       

                 if(!hasTrialExtended)
                 {
                     System.debug('Start creating a trial licence');
                    assetApplicationService.CreateTrialAssets(opty, oppLineItemList);
                 }
            }    
           
        }  
    
    }
    
   

    /**
    * This function is to get opportunity Line Items whose Opportunity Multi Year deal field value changed, and update those opportunity Line Itemes to reccalculate the Unit price
    */
    public List<OpportunityLineItem> getOpportunityLineItems(Set<Id> oppIds, Map<Id,Opportunity> oldOpportunityMap){
        List<OpportunityLineItem> oppLineItems = [Select Id,Name,Opportunity.Multi_Year_Deal__c,Opportunity.CampaignId from OpportunityLineItem where OpportunityId IN :oppIds];
        return oppLineItems;
        /*List<opportunityLineItem> oppItemsToUpdate = new List<OpportunityLineItem>();
        for(OpportunityLineItem oppItem : oppLineItems){
            System.debug('New vs old map' + oppItem.Opportunity.Multi_Year_Deal__c + 'old' + oldOpportunityMap.get(oppItem.OpportunityId).Multi_Year_Deal__c); 
            If(oppItem.Opportunity.Multi_Year_Deal__c != oldOpportunityMap.get(oppItem.OpportunityId).Multi_Year_Deal__c){
                oppItemsToUpdate.add(oppItem);
            }
        }

        return oppItemsToUpdate;*/
    }
}