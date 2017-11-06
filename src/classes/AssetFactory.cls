public  class AssetFactory {

        
        
    public static Asset CreateFullAsset (Opportunity opportunity, OpportunityLineItem oppLineItem){
      
        Asset asset = new Asset();       
       
        asset.AccountId         = opportunity.accountId;
        asset.name              = opportunity.AccountName__c + '&' + System.today();
        asset.Opportunity__c    = opportunity.Id;      
        asset.Status            = 'Provisioned';
        asset.PurchaseDate      = System.today();
        asset.Product2Id        = oppLineItem.Product2Id;
        asset.License_Cap__c    = oppLineItem.Quantity;       
        
        asset.InstallDate       = GetStartDate(oppLineItem.SubscriptionStartDate__c);       
     
        asset.usageEndDate      = oppLineItem.SubscriptionEndDate__c;      

        Id licenceRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Full Licence').getRecordTypeId();

        asset.recordTypeId      = licenceRecordTypeId;
        SetYearGroups(asset);

        System.debug('Creating Full Licence , OpportunityId:' 
                    + opportunity.Id        + ', Product:' 
                    + asset.Product2Id      + ',Start_Date:' 
                    +  asset.InstallDate    + ',End_Date:' 
                    +  asset.usageEndDate + ',RecordTypeId:'      
                    +  asset.recordTypeId  );       
        
        return asset;
    }


    public static Asset CreateTrialAsset (Opportunity opportunity, OpportunityLineItem oppLineItem){
   
        Asset asset = new Asset();

        asset.AccountId         = opportunity.accountId;
        asset.name              = opportunity.AccountName__c + '&' + System.today();
        asset.Opportunity__c    = opportunity.Id;
        asset.Status            = 'Provisioned';
        asset.PurchaseDate      = System.today();
        asset.Product2Id        = oppLineItem.Product2Id;
        asset.InstallDate       = oppLineItem.Trial_Start_Date__c;
        asset.usageEndDate      = oppLineItem.Trial_Start_Date__c.addDays(TrialLicenceDurationInDays);    
        asset.License_Cap__c    = oppLineItem.Quantity;       
        Id trialLicenceRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Trial Licence').getRecordTypeId();
     
        asset.recordTypeId      = trialLicenceRecordTypeId;
        SetYearGroups(asset);

        System.debug('Creating Trial Licence , OpportunityId:' 
                    +  opportunity.Id        + ', Product:' 
                    +  asset.Product2Id      + ',Start_Date:' 
                    +  asset.InstallDate     + ',End_Date:' 
                    +  asset.usageEndDate    + ', Quantity:'
                    +  asset.License_Cap__c  +',RecordTypeId:'      
                    +  asset.recordTypeId );
        

        return asset;   
    }  


    /* DEFAULT TRIAL EXTENTION PERSIOD
    */
    public static Integer TrialLicenceDurationInDays {get {return 14;}}

    private static void SetYearGroups(Asset asset)
    {        
        asset.Kindergarten__c   = true;
        asset.Year1__c          = true;
        asset.Year2__c          = true;
        asset.Year3__c          = true;
        asset.Year4__c          = true;
        asset.Year5__c          = true;
        asset.Year6__c          = true;
        asset.Year7__c          = true;
        asset.Year8__c          = true;
        asset.Year9__c          = true;
        asset.Year10__c         = true;
        asset.Year11__c         = true;
        asset.Year12__c         = true;
    }


    //Its possible that the start date of opportunity is in the past but since 
    //licence cannot get started in the past so in that scenario today date would be 
    //consider as start date of the licence
    private static Date GetStartDate(Date possibleStartDate)
    {                
        if(possibleStartDate < date.today())
        {
            return date.today();
        }
        else {
              return possibleStartDate;
        }
    }


   
}