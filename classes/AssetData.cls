public with sharing class AssetData {
    
    public boolean ExtendTrialAsset(Asset asset)
    {
        if(asset !=null)
            {
                //Check if end date of trial asset is less than the default trial duration (14) then extend the trial
                if(asset.UsageEndDate.daysBetween(Date.today()) < AssetFactory.TrialLicenceDurationInDays)
                {
                    asset.UsageEndDate          = Date.today().addDays(AssetFactory.TrialLicenceDurationInDays); 
                    asset.Extension_Reason__c   = 'Pending Sale Confirmation';
                    update asset;
                }

                return true;
            }

         return false;
    }

    public boolean UpdateNumberOfStudent(Asset asset, Decimal quantity)
    {
        if(asset !=null)
        {
            asset.License_Cap__c = asset.License_Cap__c + quantity;

            update asset;

            return true;
        }

        return false;
    }

    public boolean UpdateAsset(Asset asset, Date startDate, Date expiryDate, Decimal quantity, String extentionReason)
    {
        if(asset !=null)
        {
            asset.License_Cap__c        = quantity;
            asset.InstallDate           = startDate;
            asset.UsageEndDate          = expiryDate;     
            asset.Extension_Reason__c   = extentionReason;
            update asset;

            return true;
        }

        return false;
    }




    public List<Asset> FindAssets(Id opportunityId)
    {
        List<Asset> existingAssets= [select Id, InstallDate,Name,Product_Type__c,Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c, License_Cap__c,
                                            ProductFamily__c, C3_Id__c, AccountId, AvoidTriggerExecution__c
                                        FROM 
                                            Asset 
                                        WHERE 
                                            (Status         = 'Provisioned'     OR
                                             Status         = 'New')            AND 
                                            Opportunity__c  = :opportunityId];

        if(existingAssets.isEmpty() == false)
        {
            return existingAssets;
        }


        return null;

    }

    
    public Asset FilterAsset( List<Asset> assets, String licence_type, String productFamily)
    {
        if(assets == null)
        {
            return null;
        }
        for(Asset asset : assets)
        {

            if(asset.Type_of_License__c.equalsIgnoreCase(licence_type) && asset.ProductFamily__c.equalsIgnoreCase(productFamily))
            return asset;
        }

        return null;

    }

     public Asset FilterAsset( List<Asset> assets, String licence_type, String productFamily, Date endDate)
    {
        if(assets == null)
        {
            return null;
        }
        for(Asset asset : assets)
        {
            if(asset.Type_of_License__c     == licence_type &&
               asset.ProductFamily__c       == productFamily  &&
               asset.UsageEndDate           == endDate)
                               return asset;  
        }

        return null;

    }

    public List<Asset> FilterAsset( List<Asset> assets, Id excludeAssetId)
    {
        List<Asset> filteredAsset = new List<Asset>();
        
        for(Asset asset : assets)
        {

            if(asset.Id == excludeAssetId)
            {
                continue;
            }
            
            filteredAsset.add(asset);
        }

        return filteredAsset;

    }

    public List<Asset> GetProvisionedAssets(Id accountId)
    {
        //Get all provisioned assets 
        List<Asset> existingAssets= [select
                                             Id,    InstallDate,Name,Product_Type__c,Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,License_Cap__c, 
                                            ProductFamily__c, C3_Id__c, AccountId, AvoidTriggerExecution__c

                                        FROM 
                                            Asset                                         
                                        WHERE 
                                            Status              = 'Provisioned'  AND 
                                            AccountId           = :accountId    ];

        return existingAssets;
    }

    public List<Asset> GetAssets(Id accountId)
    {
        //Get all provisioned assets 
        List<Asset> existingAssets= [select
                                             Id,    InstallDate,Name,Product_Type__c,Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,License_Cap__c, 
                                            ProductFamily__c, C3_Id__c, AccountId, AvoidTriggerExecution__c

                                        FROM 
                                            Asset 
                                        WHERE                                             
                                            AccountId           = :accountId];

        return existingAssets;
    }


    public List<Asset> GetAssets(Id accountId, String productFamily)
    {
        //Get all provisioned assets 
        List<Asset> existingAssets= [select
                                             Id,    InstallDate,Name,Product_Type__c,Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,License_Cap__c, 
                                            ProductFamily__c, C3_Id__c, AccountId, AvoidTriggerExecution__c

                                        FROM 
                                            Asset 
                                        WHERE 
                                            Status              = 'Provisioned'  AND 
                                            AccountId           = :accountId    AND                                     
                                            ProductFamily__c    = :productFamily];

        return existingAssets;
    }

    public Asset GetAsset(Id assetId)
    {
        List<Asset> assetList = [SELECT 
                                    Id, Name, C3_Id__c, School_C3_Id__c, License_Cap__c, Product_Type__c,
                                    InstallDate, UsageEndDate, License_Type__c, School_Country__c,  
                                    Status, School_State__c , ProductFamily__c, Licence_Sync_Status__c,
                                    Kindergarten__c, Year1__c,Year2__c,Year3__c,Year4__c,Year5__c,
                                    Year6__c,Year7__c,Year8__c,Year9__c,Year10__c,Year11__c,Year12__c, AccountId, AvoidTriggerExecution__c
                                FROM 
                                    Asset
                                WHERE
                                    Id = :assetId];

        if(!assetList.isEmpty())
        {
            Asset asset = assetList[0];
            return asset;
        }

        System.debug(Logginglevel.ERROR , 'AssetId[' + assetId + '] does not exist!');

        return null;
    }


}