global class CreateUpsellOpportunityfromAssetButton {

    /*webservice static string CreateUpsellOpportunityFromExistingOpportunity(Id opportunityId, Id assetId) {       
         
         
         try {
             
           
             UpsellOpportunitywithProducts upsellOpportunitywithProducts  =new UpsellOpportunitywithProducts();

             UpsellOpportunitywithProducts_Bulk upsellOpportunitywithProducts_bulk  =new UpsellOpportunitywithProducts_Bulk();
             SchoolExcessLicensingProcessor schoolExcessLicensingProcessor = new SchoolExcessLicensingProcessor();
             Asset asset = upsellOpportunitywithProducts.getAsset(assetId);

             List<Asset> assets = new List<Asset>();

             assets.add(asset);

             if(asset.Status != 'Provisioned' || asset.UsageEndDate < date.today()  )
             {
                throw new ValidationException('Cannot create upsell opportunity for expired or not provisioned licences');
             }

               List<OpportunityAsset> opportunityAssets = upsellOpportunitywithProducts_bulk.CreateUpsellOpportunity(assets, null);

              List<Opportunity> createdOpportunities = schoolExcessLicensingProcessor.InsertOpportunity(opportunityAssets);
            
             // Opportunity opportunity =   upsellOpportunitywithProducts.CreateUpsellOpportunity(asset, opportunityId);
           
               if(!createdOpportunities.isEmpty() && createdOpportunities[0].Id !=null)
                {

                    OpportunityLineItem opportunityLineItem= [select Id from OpportunityLineItem where OpportunityId = : createdOpportunities[0].Id limit 1];

                    if(opportunityLineItem != null)
                    {                         
                        return opportunityLineItem.Id;                      
                    }
                    else {

                        return createdOpportunities[0].Id;
                    }
                    
                }        
      
       
        }
         catch(Exception e) {

             System.debug('Exception in CreateUpsellOpportunityfromAssetButton:'+e.getMessage());

             return e.getMessage();
         }

         return assetId;
    }
*/
     webservice static string CreateUpsellOpportunity(Id assetId) {       
         
        try 
        {

         UpsellOpportunitywithProducts upsellOpportunitywithProducts  = new UpsellOpportunitywithProducts();

             UpsellOpportunitywithProducts_Bulk upsellOpportunitywithProducts_bulk  =new UpsellOpportunitywithProducts_Bulk();
             SchoolExcessLicensingProcessor schoolExcessLicensingProcessor = new SchoolExcessLicensingProcessor();
             Asset asset = upsellOpportunitywithProducts.getAsset(assetId);

             Account account = [select Id, School_Type__c, Territory__c from account where Id = :asset.accountId];

             List<Asset> assets = new List<Asset>();

             assets.add(asset);

              List<OpportunityAsset> opportunityAssets = upsellOpportunitywithProducts_bulk.CreateUpsellOpportunity(assets, null,account.Territory__c,account.School_Type__c);

              List<Opportunity> createdOpportunities = schoolExcessLicensingProcessor.InsertOpportunity(opportunityAssets);
            

             if(!createdOpportunities.isEmpty() && createdOpportunities[0].Id !=null)
            {
               OpportunityLineItem opportunityLineItem= [select Id from OpportunityLineItem where OpportunityId = : createdOpportunities[0].Id limit 1];

                    if(opportunityLineItem != null)
                    {                         
                        return opportunityLineItem.Id;                      
                    }
                    else {

                        return createdOpportunities[0].Id;
                    }
            }
           
        
         } catch(Exception e) {

            System.debug('Exception in CreateUpsellOpportunityfromAssetButton:'+e.getMessage());

             return e.getMessage();
         }

         return assetId;        
    }

  
}