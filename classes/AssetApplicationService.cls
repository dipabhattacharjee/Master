public with sharing class AssetApplicationService {
    
    
    AssetData assetData ;
    AssetConflictFinder assetConflictFinder ;

    public AssetApplicationService()
    {
         assetData           = new AssetData(); 
         assetConflictFinder = new AssetConflictFinder();   
    }


    

    public boolean CheckAndExtendTrialAssets(Opportunity opportunity, List<OpportunityLineItem> oppLineItemList)
    {
        List<Asset> opportunityAssets = assetData.FindAssets(opportunity.Id);

        for(OpportunityLineItem lineItem : oppLineItemList)
            {   
                Asset asset = assetData.FilterAsset(opportunityAssets, 'Trial Licence', lineItem.Family__c);

                if(lineItem.Provision_Trial_License__c)  
                {
                    if(asset != null)
                    {
                        assetData.ExtendTrialAsset(asset);
                        return true;
                    }                   
                }           
            }

       return false;
    }

    public List<Asset> UpsertFullAssets(Opportunity opportunity, List<OpportunityLineItem> oppLineItemList)
    {       
        List<Asset> assets= new List<Asset>();      
        List<Asset> opportunityAssets = assetData.FindAssets(opportunity.Id);

        for(OpportunityLineItem lineItem : oppLineItemList)
        {   
            //Getting full licences for this opty and product
            Asset asset = assetData.FilterAsset(opportunityAssets, 'Full Licence', lineItem.Family__c);

            if(lineItem.Provision_Full_License__c)  
            {
                //If full licence hasnt been created for this product and opportunity
                if(asset == null)
                {
                    Asset newAsset = AssetFactory.CreateFullAsset(opportunity, lineItem);
                  
                    assets.add(newAsset);
                }
                else
                {   //If full licence already created, it means this is the second time this opportunity comes to sold stage
                    assetData.UpdateAsset(asset, lineItem.SubscriptionStartDate__c, lineItem.SubscriptionEndDate__c, lineItem.Quantity, 'Error Correction' );
                }   

            
            }               
            
        } 
        insert assets;
        return assets;

    }

    public List<Asset> CreateTrialAssets(Opportunity opportunity, List<OpportunityLineItem> oppLineItemList)
    {       
        List<Asset> assets= new List<Asset>();      

       

        for(OpportunityLineItem lineItem : oppLineItemList)
        {               
            if(lineItem.Provision_Trial_License__c)  
            {
                Asset newAsset = AssetFactory.CreateTrialAsset(opportunity, lineItem);
               
                System.debug('Trial licence returned, ');
            
                assets.add(newAsset);
            }               
            
        }

        insert assets;
        return assets;

    }

    public void UpdateNumberOfStudentsForFullAssets(Opportunity opportunity, List<OpportunityLineItem> oppLineItemList)
    {
        for(OpportunityLineItem lineItem : oppLineItemList)
        { 
            List<Asset> accountAssets = assetData.GetAssets(opportunity.AccountId, lineItem.Family__c);     

            if(lineItem.Provision_Full_License__c)  
            {
                Asset asset = assetData.FilterAsset(accountAssets, 'Full Licence', lineItem.Family__c, lineItem.SubscriptionEndDate__c ); 

                if(asset != null)
                {
                    assetData.UpdateNumberOfStudent(asset, lineItem.Quantity);
                }
            }
        }
    }
    
    
}