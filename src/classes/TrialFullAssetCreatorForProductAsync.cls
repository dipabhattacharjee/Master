/**
* @author Amit Shirude
* @date 24/05/2016
* @description - Create Licenses for opportunity products. 
* @TestClass: TrialFullAssetCreatorForProductAsync_Test
*/
public class TrialFullAssetCreatorForProductAsync {
    /*public String createLicense(Id opportunityId,String licenseType){
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
        //String[] retList = new List<String>();
        String message;
        if(oppLineItemList != null && oppLineItemList.size() > 0){
            for(OpportunityLineItem oppLineItem : oppLineItemList){
               
                If(productFamilyVsAsset.containsKey(oppLineItem.Product2.Family) || productFamilyVsAssetWithFullLicence.containsKey(oppLineItem.Product2.Family)){                   
                    System.debug('Testng Before break');
                    break;
                    //message = 'Licences already exist for this School';
                    
                }else{
                   System.debug('Testng Before Insert');
                    assetList.add(getAssetToInsert(oppList,oppLineItem,licenseType));
                    System.debug('Testng After Insert');
                }
            }
        }
        if(assetList != null && assetList.size() > 0){
            insert assetList;
            //message = 'Licence created successfully. IMPORTANT: Now activate the licence by editing the new Licence record.';
        }
        
        //retList[1] = assetList[0].id;
        return message;
    }

    @TestVisible 
    private Asset getAssetToInsert (List<Opportunity> oppList,OpportunityLineItem oppLineItem,String licenseType){
        //String recordTypeId ;
        System.debug('Testng Inside Insert');
        Asset singleAsset = new Asset();
        singleAsset.AccountId = oppList[0].accountId;
        singleAsset.name = oppList[0].account.name + '&' + System.today();
        singleAsset.Product2Id = oppLineItem.Product2Id;
        
        singleAsset.Opportunity__c = oppList[0].Id;
        singleAsset.PurchaseDate =  System.today();
       // singleAsset.Extension_Reason__c = String.valueof(oppList[0].Type)+' Opportunity'; //Added by Harry
        if(licenseType == 'Trial'){
            //singleAsset.usageEndDate = System.today().addDays(14);
            singleAsset.InstallDate = oppLineItem.Trial_Start_Date__c;
            singleAsset.usageEndDate = oppLineItem.Trial_Start_Date__c.addDays(14);
            singleAsset.recordTypeId = fetchBankRecordTypeIdOfTrialAsset(); 
            singleAsset.License_Cap__c = oppLineItem.Quantity;
            singleAsset.Status = 'Provisioned';
        }else If(licenseType == 'Full' ){
            //singleAsset.usageEndDate = System.today().addDays(365);
            //singleAsset.InstallDate = System.today();           // Commented by Amit
            singleAsset.InstallDate = oppLineItem.SubscriptionStartDate__c;
            //singleAsset.usageEndDate = System.today().addMonths(13).toStartofMonth().addDays(-1); // Commented by Amit
            singleAsset.usageEndDate = oppLineItem.SubscriptionEndDate__c;
            singleAsset.License_Cap__c = oppLineItem.Quantity;
            singleAsset.Status = 'Provisioned';
            singleAsset.recordTypeId = fetchBankRecordTypeIdFullAsset(); 
        }
        return singleAsset;
    }

    @TestVisible
    private List<Opportunity> getOpportunityDetails(Id opportunityId){
        List<Opportunity> oppList = [SELECT Id,name,accountId,account.Name, Type from Opportunity where id = :opportunityId];
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
            assetList = [select Id,name,Product2.Family,Status from Asset where accountId = :oppList[0].accountId and RecordTypeId  = :recordTypeId and Status='Provisioned'];
            System.debug('Record Type Id' + recordTypeId);
            //assetList = [select Id,name,Product2.Family from Asset where accountId = :oppList[0].accountId and RecordTypeId  = :recordTypeId and (Status='Provisioned' OR Status='New')];
            System.debug('Inside getAssetListForAccount Full Licence' + assetList);
        }       
        for(Asset singleasset : assetList){
            productFamilyVsAsset.put(singleasset.Product2.Family,singleasset);
        }
        
        System.debug('Inside getAssetListForAccount Full Licence' + productFamilyVsAsset);
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
        System.debug('Inside getAssetMapWithFullLicenceForAccount Full Licence' + productFamilyVsAsset);
        return productFamilyVsAsset;
    }

    @TestVisible
    private List<OpportunityLineItem> getOpplineItemList(Id oppId,String licenseType){
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        if(licenseType == 'Trial'){
            oppLineItemList = [select Id,name,Product2.Family,Trial_Start_Date__c,Product2Id,Quantity from OpportunityLineItem where Provision_Trial_License__c = true and OpportunityId = :oppId];
        }else if(licenseType == 'Full'){
            oppLineItemList = [select Id,name,Product2.Family,Product2Id,SubscriptionStartDate__c,SubscriptionEndDate__c,Quantity from OpportunityLineItem where Provision_Full_License__c = true and OpportunityId = :oppId];
        }       
        System.debug('getOpplineItemList Fetched Before return' + oppLineItemList);
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
        System.debug('Inside fetchBankRecordTypeIdFullAsset Full Licence' + recTypeList[0].Id);
        return null;
    }
    
    //Amit - 6/June/2016 added the below two methods for validation to stop products of same product family from being set for trail or full licenced in Opty
    public String ValidateLicence(Id opportunityId,String licenseType){
        String message;
        List<Opportunity>oppList = getOpportunityDetails(opportunityId);               
        Map<String,Asset>productFamilyVsAsset = new Map<String,Asset>();
        Map<String,Asset>productFamilyVsAssetWithFullLicence = new Map<String,Asset>();
        
        if(oppList != null && oppList.size() > 0){  
            productFamilyVsAsset = getAssetListForAccount(oppList,licenseType);            
            productFamilyVsAssetWithFullLicence = getAssetMapWithFullLicenceForAccount(oppList);    
        }
        List<OpportunityLineItem> oppLineItemList = getOpplineItemList(opportunityId,licenseType);
        System.debug('oppLineItemList Fetched ' + oppLineItemList);
        System.debug('productFamilyVsAssetWithFullLicence Fetched ' + productFamilyVsAssetWithFullLicence);
        System.debug('productFamilyVsAsset Fetched ' + productFamilyVsAsset);
        return ValidateAssetList(productFamilyVsAsset,productFamilyVsAssetWithFullLicence,oppLineItemList,oppList,licenseType);
    }
    
    @TestVisible
    private String ValidateAssetList(Map<String,Asset>productFamilyVsAsset,Map<String,Asset>productFamilyVsAssetWithFullLicence,List<OpportunityLineItem> oppLineItemList,List<Opportunity> oppList,String licenseType){
        List<Asset>assetList = new List<Asset>();
        //String[] retList = new List<String>();
        String message;
        if(oppLineItemList != null && oppLineItemList.size() > 0){
            for(OpportunityLineItem oppLineItem : oppLineItemList){               
                System.debug('Inside ValidateAssetList oppLineItemList Fetched ' + oppLineItemList );
                System.debug('Inside ValidateAssetList oppLineItemList Fetched ' + oppLineItem.Product2.Family );
		        System.debug('Inside ValidateAssetList productFamilyVsAssetWithFullLicence Fetched ' + productFamilyVsAssetWithFullLicence);
        		System.debug('Inside ValidateAssetList productFamilyVsAsset Fetched ' + productFamilyVsAsset);
                If(productFamilyVsAsset.containsKey(oppLineItem.Product2.Family) || productFamilyVsAssetWithFullLicence.containsKey(oppLineItem.Product2.Family)){							                                        
                    message = 'Alert';
                }else {message = 'No Alert';}
            }
        }
        System.Debug('Returned Mesg ' + message);
        return message;
    }
    */
}