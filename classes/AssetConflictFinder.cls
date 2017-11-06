public with sharing class AssetConflictFinder {
    
    public boolean HasDateConflict(Asset existingAsset ,Date startDate, Date endDate )
    {
        if(existingAsset == null)
        {
            return false;
        }

        //If startdate or enddate are between start date and end date of the exisiting asset
        if((startDate  >=  existingAsset.InstallDate   && 
            startDate  <=  existingAsset.UsageEndDate) ||
          ( endDate    >= existingAsset.InstallDate    &&
            endDate    <= existingAsset.UsageEndDate))
        {
            return true;
        }

         //If startdate or enddate of existing licence are between start date and end date 
        if(existingAsset.InstallDate   >=  startDate  &&
           existingAsset.UsageEndDate  <=  endDate)
        {
            return true;
        }


        return false;
    }
    
    public boolean Validate(List<Asset> existingAssets, String productFamily, Date startDate, Date endDate)
    {   
        
        if(existingAssets == null)
        {
                return true;
        }

        for(Asset existingAsset: existingAssets)
        {
            System.debug('AssetConflictFinder existingAsset.ProductFamily__c: '+ existingAsset.Type_of_License__c);
            if( existingAsset.ProductFamily__c != null && 
                existingAsset.ProductFamily__c.equalsIgnoreCase(productFamily))
            {
                System.debug('AssetConflictFinder existingAsset.Type_of_License__c: '+ existingAsset.Type_of_License__c);
                if (HasDateConflict(existingAsset, startDate, endDate))
                    {                        

                        if(existingAsset.Type_of_License__c == 'Demo Licence')
                        {
                            throw new DemoLicenceConflictException('There is already a provisioned Demo licence for this product within that subscription period');
                        }

                        if(existingAsset.Type_of_License__c == 'Full Licence')
                        {
                            throw new FullLicenceConflictException('There is already a provisioned Full licence for this product within that subscription period');
                        }

                        if(existingAsset.Type_of_License__c == 'Trial Licence')
                        {
                            throw new TrialLicenceConflictException('There is already a provisioned Trial licence for this product within that subscription period');
                        }                     
                }
            }
        }
        

        return true;
    }   
    


}