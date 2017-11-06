public class AssetLicencesWrapperForRenewal { 
    public Asset singleAsset{get;set;}
    public boolean isSelected {get; set;}
    public AssetLicencesWrapperForRenewal(){
        singleAsset = new Asset();
        isSelected = false;
    }

    //Metthod to return opportunity wrapper
    public  List<AssetLicencesWrapperForRenewal> assetWrapper(Date startDate,Date endDate,Date CloseDate,String territoryType,Id userId){
       //  return getOpportunityList(accountName,searchCriteria,startDate,endDate); 
       return convertAssetListToWrapper(getAssetList(startDate,endDate,territoryType,userId));
    }


     //method to return opportunities by filter
    public List<Asset>getAssetList(Date startDate,Date endDate,String territoryType,Id userId){        
       List<Asset> assetList = new List<Asset>();
      //  Set<String>territoryAccount = fetchAccountTerritory(accountName);       
         assetList = Database.query(getAssetQueryString(startDate,endDate,territoryType,userId));
      
       return assetList;
    }
    
    //method to createandReturn List of opportunitywrapper
    public List<AssetLicencesWrapperForRenewal> convertAssetListToWrapper(List<Asset> assetList){
        List<AssetLicencesWrapperForRenewal>assetWrapper = new List<AssetLicencesWrapperForRenewal>();
        if(assetList != null && assetList.size() > 0){
            for(Asset singleAsset : assetList ){
                AssetLicencesWrapperForRenewal wrapper = new AssetLicencesWrapperForRenewal();
                wrapper.singleAsset = singleAsset;
                assetWrapper.add(wrapper);
            }
        }
        return assetWrapper;        
    }
    
    
    //This method return query string
    public String getAssetQueryString(Date startDate,Date endDate,String territoryType,Id userId){
       String recordTyprId = fetchBankRecordTypeIdFullAsset();
        String queryString = 'select id,name,account.name,Opportunity__c,account.CurrencyIsoCode,Type_of_License__c,Product2Id,Product2.Family,Product2.name,License_Cap__c,Registered_Students__c,Login_Indicator__c,InstallDate,UsageEndDate,Owner.name,accountId ,account.OwnerId,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.owner.name from Asset '+
                                'where UsageEndDate >= '+String.valueOf(startDate)+' and UsageEndDate <= '+String.valueOf(endDate)+''+
                                'and recordTypeId = \''+recordTyprId+'\' ';
       
        if (territoryType == 'My')        {
        
            queryString = queryString + 'and account.OwnerId = \''+UserInfo.getUserId()+'\' LIMIT 10000';
        }else{
            queryString = queryString + 'and account.OwnerId = \''+userId+'\' LIMIT 10000';
        }
        return queryString;
    }

      @TestVisible
    private Id fetchBankRecordTypeIdFullAsset(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Full_Licence'  And sObjectType = 'Asset'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }
}