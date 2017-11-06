/**
* @author Vishnu Belkone
* @description - this is class is to create and send Asset-Year Group License service 
* @TestClass: AssetYearGLicenseService_Test
* @History:
* 18/10/2015 Created
*/
public class AssetYearGLicenseService { 
    public HttpResponse assetYearLicense(Id assetId){                   
            List<Asset>assets = fetchAseetRecord(assetId);      
            Map<Id,List<Year_Group__c>> assetVsYearGroupMap = fetchAssetVsYearGroupMap(assetId);
            HttpResponse response;                          
            if (assets != null && assets.size() > 0 && assetVsYearGroupMap != null){
                response = postPutAssetYGLicenseRequest(assets,assetVsYearGroupMap);                                
            }
            return response;            
    }   
    
    @TestVisible
    private HttpResponse postPutAssetYGLicenseRequest(List<Asset>assets,Map<Id,List<Year_Group__c>> assetVsYearGroupMap){
            List<Asset>assetToUpdate = new List<Asset>();
            HttpResponse response = new AssetYGLicenseRequestGeneratorAndSender().licenseRequestGeneraterAndSender(assets,assetVsYearGroupMap);
        if (response.getStatusCode() == 200 )
        {
            
            	if (assets[0].C3_Id__c == null){assets[0].C3_Id__c = Integer.valueOf(response.getBody());}
            	System.debug('assets[0].Status before ' + assets[0].Status);
                if(assets[0].Status != 'Cancelled')		
                {
                assets[0].Status = 'Provisioned';
                }
            	System.debug('assets[0].Status after' + assets[0].Status);
            	assetToUpdate.add(assets[0]);
        }        
        update assetToUpdate;
        return response;
    }

    /*@TestVisible 
    private Boolean checkYearGroupArePresent(List<Year_Group__c>yearGroups){
        if (yearGroups != null && yearGroups.size() > 0)
        {
            return true;
        }else{
            return false;
        }
    }*/

    @TestVisible    
    private List<Asset> fetchAseetRecord(Id assetId){
        List<Asset>assetList = [SELECT Id,Name,C3_Id__c,School_C3_Id__c,License_Cap__c,Product_Type__c,InstallDate,UsageEndDate,
                                License_Type__c, School_Country__c, School_State__c,Status FROM Asset WHERE Id = :assetId];
        return assetList;
    }

    @TestVisible
    private Map<Id,List<Year_Group__c>> fetchAssetVsYearGroupMap(Id assetId){
        List<Year_Group__c> yearGroupList = fetchYearGroupList(assetId);
        Map<Id,List<Year_Group__c>> assetVsYearGroupMap = new Map<Id,List<Year_Group__c>>();
        if (yearGroupList != null && yearGroupList.size() > 0)
        {
            for (Year_Group__c yearGroup :yearGroupList)
            {
                if (assetVsYearGroupMap.containsKey(yearGroup.Asset__c))
                {
                    assetVsYearGroupMap.get(yearGroup.Asset__c).add(yearGroup);
                }else{
                    assetVsYearGroupMap.put(yearGroup.Asset__c ,new List<Year_Group__c>{yearGroup});
                }
            }
        }
        return assetVsYearGroupMap;
    }
        
    @TestVisible
    private List<Year_Group__c> fetchYearGroupList(Id assetId){
        List<Year_Group__c>yearGroupList = [SELECT Id,Name,C3_Year_Group__c,Provision__c,Asset__c FROM Year_Group__c
                                            WHERE Asset__c = :assetId AND Provision__c = true];
        return yearGroupList;
    } 
}