/**
* @author Vishnu Belkone 
* @description - Renew Licenses for opportunity products. 
* @TestClass: RenewLicencesForProduct_Test
* @History:
* 18/11/2015 Created
*/
public class RenewLicencesForProduct {
    public String multiAssetError{get;Set;}
    public Boolean isError{get;Set;}    
    public String renewLicences(Id opportunityId){
         Savepoint recordsavePoint = Database.setSavepoint();
        try 
        {           
            List<OpportunityLineItem> oppLineItemList = getOpplineItemList(opportunityId);
            List<Opportunity> oppList = getOpportunityDetails(opportunityId);       
            Map<String,List<Asset>>productFamilyVsAsset = getAssetListForAccount(oppList);        
            List<Asset>assetList = getAssetToRenew(oppList[0],oppLineItemList,productFamilyVsAsset);
            List<License_Renewal__c>licenceRenewalsListToInsert = getLicenceRenewalsList(assetList);
        
            if (licenceRenewalsListToInsert != null && licenceRenewalsListToInsert.size() > 0)
            {
                insert licenceRenewalsListToInsert;
                return 'SUCCESS';
            }else if(isError == true){
                return multiAssetError;
            }else{
                return 'There are no Provisioned Licences found to renew please check and amend as necessary';
            }
            
        }
        catch (Exception ex)
        {
            Database.rollback(recordsavePoint);
            return ex.getMessage();
        }
          
    }


    private  List<License_Renewal__c> getLicenceRenewalsList(List<Asset>assetList){
        List<License_Renewal__c>licenceRenewalsListToInsert = new List<License_Renewal__c>();
        License_Renewal__c singleLicence;
        if (assetList != null && assetList.size() > 0)
        {
            for (Asset singleAsset : assetList)
            {
                singleLicence = new License_Renewal__c();
                singleLicence.Renewal_Date__c = System.today();
                singleLicence.Asset__c = singleAsset.Id;
                licenceRenewalsListToInsert.add(singleLicence);
            }
        }
        return licenceRenewalsListToInsert;
    }
     @TestVisible
     private List<Asset> getAssetToRenew(Opportunity opp,List<OpportunityLineItem> oppLineItemList, Map<String,List<Asset>>productFamilyVsAsset){
        List<License_Renewal__c>licenceRenewalToInsertList = new List<License_Renewal__c>();
        List<Asset>assetList = new List<Asset>();
        License_Renewal__c licenceToRenew = new License_Renewal__c();
        if (oppLineItemList != null && oppLineItemList.size() > 0)
        {
            for (OpportunityLineItem lineItem : oppLineItemList)
                {
                    if (productFamilyVsAsset != null && productFamilyVsAsset.size() > 0)
                    {
                        if (productFamilyVsAsset.containsKey(lineItem.Product2.Family))
                        {   
                            if (productFamilyVsAsset.get(lineItem.Product2.Family).size() == 1)
                            {
                                productFamilyVsAsset.get(lineItem.Product2.Family)[0].Product2Id = lineItem.Product2Id;
                                assetList.add(productFamilyVsAsset.get(lineItem.Product2.Family)[0]);
                                lineItem.IsRenewed__c = true;
                            }else{
                                isError = true;
                                multiAssetError = 'Multiple active Licences found please correct and retry';
                            }
                            
                        }
                    }
            
                }
        }
        update oppLineItemList;
        return assetList;
     }

     @TestVisible
    private Map<String,List<Asset>> getAssetListForAccount(List<Opportunity> oppList){
        List<Asset>assetList = new List<Asset>();
        String recordTypeId;
        Map<String,List<Asset>>productFamilyVsAsset = new Map<String,List<Asset>>();      
        recordTypeId = fetchBankRecordTypeIdFullAsset();    
        System.debug('Licence to Id' + recordTypeId + 'Account ' +oppList[0].accountId);    
        assetList = [select Id,name,Product2.Family,Product2Id from Asset where accountId = :oppList[0].accountId and RecordTypeId  = :recordTypeId and Status = 'Provisioned'];             
        System.debug('Licence to List' + assetList);
        if (assetList != null && assetList.size() > 0)
        {
            for(Asset singleasset : assetList){
                if (productFamilyVsAsset.containsKey(singleasset.Product2.Family))
                {
                    productFamilyVsAsset.get(singleasset.Product2.Family).add(singleasset);
                }else{
                    productFamilyVsAsset.put(singleasset.Product2.Family,new List<Asset>{singleasset});
                }               
            }
        }         
        return productFamilyVsAsset;
    }


     @TestVisible
    private List<OpportunityLineItem> getOpplineItemList(Id oppId){
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();      
            oppLineItemList = [select Id,name,Product2.Family,Product2Id from OpportunityLineItem where  Renew_Licence__c = true and OpportunityId = :oppId];             
        return oppLineItemList;
    }

    @TestVisible
    private List<Opportunity> getOpportunityDetails(Id opportunityId){
        List<Opportunity> oppList = [SELECT Id,name,accountId,account.Name from Opportunity where id = :opportunityId];
        return  oppList;
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