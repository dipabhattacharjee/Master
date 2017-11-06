/**
* @author Vishnu Belkone
* @date 18/11/2015
* @description - Create Licenses for opportunity products. 
* @TestClass: TrialFullAssetCreatorForProduct_Test
*/
public class TrialFullAssetCreatorForProduct {
    public String createLicense(Id opportunityId,String licenseType){
        List<Opportunity>oppList = getOpportunityDetails(opportunityId);        
        Map<String,Asset>productFamilyVsAsset = new Map<String,Asset>();
        Map<String,Asset>productFamilyVsAssetWithFullLicence = new Map<String,Asset>();
        if(oppList != null && oppList.size() > 0){  
            productFamilyVsAsset = getAssetListForAccount(oppList,licenseType);
            productFamilyVsAssetWithFullLicence = getAssetMapWithFullLicenceForAccount(oppList);    
        }

        List<OpportunityLineItem> oppLineItemList = getOpplineItemList(opportunityId,licenseType);          
             return insertAssetList(productFamilyVsAsset,productFamilyVsAssetWithFullLicence,oppLineItemList,oppList,licenseType);          
    }

    @TestVisible
    private String insertAssetList(Map<String,Asset>productFamilyVsAsset,Map<String,Asset>productFamilyVsAssetWithFullLicence,List<OpportunityLineItem> oppLineItemList,List<Opportunity> oppList,String licenseType){
        List<Asset>assetList = new List<Asset>();
        String message;
        if(oppLineItemList != null && oppLineItemList.size() > 0){
            for(OpportunityLineItem oppLineItem : oppLineItemList){
               
                If(productFamilyVsAsset.containsKey(oppLineItem.Product2.Family) || productFamilyVsAssetWithFullLicence.containsKey(oppLineItem.Product2.Family)){
                    message = 'Licences already exist for this School';
                }else{
                   
                    assetList.add(getAssetToInsert(oppList,oppLineItem,licenseType));
                }
            }
        }
        if(assetList != null && assetList.size() > 0){
            insert assetList;
            message = 'Licence created successfully. IMPORTANT: Now activate the licence by editing the new Licence record.';
        }
        return message;
    }

    @TestVisible 
    private Asset getAssetToInsert (List<Opportunity> oppList,OpportunityLineItem oppLineItem,String licenseType){
        //String recordTypeId ;
        Asset singleAsset = new Asset();
        singleAsset.AccountId = oppList[0].accountId;
        singleAsset.name = oppList[0].account.name + '&' + System.today();
        singleAsset.Product2Id = oppLineItem.Product2Id;
        
        singleAsset.Opportunity__c = oppList[0].Id;
        singleAsset.PurchaseDate =  System.today();
        if(licenseType == 'Trial'){
            //singleAsset.usageEndDate = System.today().addDays(14);
            singleAsset.InstallDate = oppLineItem.Trial_Start_Date__c;
            singleAsset.usageEndDate = oppLineItem.Trial_Start_Date__c.addDays(14);
            singleAsset.recordTypeId = fetchBankRecordTypeIdOfTrialAsset(); 
        }else If(licenseType == 'Full' ){
            //singleAsset.usageEndDate = System.today().addDays(365);
            singleAsset.InstallDate = System.today();
            singleAsset.usageEndDate = System.today().addMonths(13).toStartofMonth().addDays(-1);
            singleAsset.recordTypeId = fetchBankRecordTypeIdFullAsset(); 
        }
        return singleAsset;
    }

    @TestVisible
    private List<Opportunity> getOpportunityDetails(Id opportunityId){
        List<Opportunity> oppList = [SELECT Id,name,accountId,account.Name from Opportunity where id = :opportunityId];
        return  oppList;
    }

    @TestVisible
    private Map<String,Asset> getAssetListForAccount(List<Opportunity> oppList,String licenseType){
        List<Asset>assetList = new List<Asset>();
        String recordTypeId ;
        Map<String,Asset>productFamilyVsAsset = new Map<String,Asset>();
        if(licenseType == 'Trial'){
            recordTypeId = fetchBankRecordTypeIdOfTrialAsset();
            assetList = [select Id,name,Product2.Family from Asset where accountId = :oppList[0].accountId and RecordTypeId  = :recordTypeId and (Status='Provisioned' OR Status='New') ];
        }else If(licenseType == 'Full'){
            recordTypeId = fetchBankRecordTypeIdFullAsset();
            assetList = [select Id,name,Product2.Family from Asset where accountId = :oppList[0].accountId and RecordTypeId  = :recordTypeId and (Status='Provisioned' OR Status='New')];
        }       
        for(Asset singleasset : assetList){
            productFamilyVsAsset.put(singleasset.Product2.Family,singleasset);
        }
        return productFamilyVsAsset;
    }

    @TestVisible
    private Map<String,Asset> getAssetMapWithFullLicenceForAccount(List<Opportunity> oppList){
        List<Asset>assetList = new List<Asset>();
        Map<String,Asset>productFamilyVsAsset = new Map<String,Asset>();
        String recordTypeId = fetchBankRecordTypeIdFullAsset();
        assetList = [select Id,name,Product2.Family from Asset where accountId = :oppList[0].accountId and RecordTypeId  = :recordTypeId and (Status='Provisioned' OR Status='New')];
        for(Asset singleasset : assetList){
            productFamilyVsAsset.put(singleasset.Product2.Family,singleasset);
        }
        return productFamilyVsAsset;
    }

    @TestVisible
    private List<OpportunityLineItem> getOpplineItemList(Id oppId,String licenseType){
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        if(licenseType == 'Trial'){
            oppLineItemList = [select Id,name,Product2.Family,Trial_Start_Date__c,Product2Id from OpportunityLineItem where Provision_Trial_License__c = true and OpportunityId = :oppId];
        }else if(licenseType == 'Full'){
            oppLineItemList = [select Id,name,Product2.Family,Product2Id from OpportunityLineItem where Provision_Full_License__c = true and OpportunityId = :oppId];
        }       
        return oppLineItemList;
    }

    @TestVisible
    private Id fetchBankRecordTypeIdOfTrialAsset(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Trial_Licence'  And sObjectType = 'Asset'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
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