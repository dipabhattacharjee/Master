/**
* @author Amit Shirude
* @description - this is class is to create and send Asset-Year Group License service 
* @TestClass: AssetYearGLicenseService_Test
* @History:
* 18/10/2015 Created
*/
public class AssetYearGLicenseService_Async { 
    public HttpResponse assetYearLicense(Id assetId){                   
            List<Asset> assets = fetchAseetRecord(assetId);      
            Map<Id,List<Year_Group__c>> assetVsYearGroupMap = fetchAssetVsYearGroupMap(assetId);
            HttpResponse response;                          
            List<Asset> assetList = [SELECT Id,Name,C3_Id__c,School_C3_Id__c,License_Cap__c,Product_Type__c,InstallDate,UsageEndDate,
                                License_Type__c, School_Country__c, School_State__c,Status FROM Asset WHERE Id = :assetId];
            //if (assets != null && assets.size() > 0 && assetVsYearGroupMap != null){
            if(System.isFuture() == false && assets != null && assets.size() > 0 && assetVsYearGroupMap != null){
                postPutAssetYGLicenseRequest(assetId);
            }                                    
            //}
            return response;            
    }   
    
    @future(callout=true)
    public static Void postPutAssetYGLicenseRequest(Id assetId){
            List<Asset> assetToUpdate = new List<Asset>();
        	//List<Asset> assets = fetchAseetRecord(assetId);
        
        	List<Asset> assetList = [SELECT Id,Name,C3_Id__c,School_C3_Id__c,License_Cap__c,Product_Type__c,InstallDate,UsageEndDate,
                                License_Type__c, School_Country__c, School_State__c,Status FROM Asset WHERE Id = :assetId];
        
        	//Map<Id,List<Year_Group__c>> assetVsYearGroupMap = fetchAssetVsYearGroupMap(assetId);
        	//List<Year_Group__c> yearGroupList = fetchYearGroupList(assetId);
	        List<Year_Group__c> yearGroupList = [SELECT Id,Name,C3_Year_Group__c,Provision__c,Asset__c FROM Year_Group__c
                                            WHERE Asset__c = :assetId AND Provision__c = true];
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
        	HttpResponse response;
        	List<String> lstToAddresses = New List<String>();
        	response = new AssetYGLicenseRequestGeneratorAndSender().licenseRequestGeneraterAndSender(assetList,assetVsYearGroupMap);
        
        	LicenceEmailFlag__c myCS1 = LicenceEmailFlag__c.getInstance('Donotsend');		   
            if (myCS1.SendEmails__c == True)           
            {
                lstToAddresses.add(UserInfo.getUserEmail());
            }
            lstToAddresses.add('amit.shirude@3plearning.com');
        	//lstToAddresses.add('amir.pour@3plearning.com');
        
        	System.debug('Testing Before email If');
            if (response.getStatusCode() == 500 || response.getStatusCode() == 200)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
                mail.setToAddresses(lstToAddresses);              
                mail.setReplyTo('OperationalSystems@3plearning.com');                
                mail.setSenderDisplayName(UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
                mail.setSubject('Applying Licence Failed for Product: ' + assetList[0].Product_Type__c + '; Customer C3 Id: ' + assetList[0].School_C3_Id__c);
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody(response.getBody());
                System.debug('Testing Before email');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }

            if (response.getStatusCode() == 200 )
            {
            
                if (assetList[0].C3_Id__c == null){assetList[0].C3_Id__c = Integer.valueOf(response.getBody());}                
                assetToUpdate.add(assetList[0]);
            }        
            update assetToUpdate;




        System.debug('Testing Before after email');
    }   

    @TestVisible    
    private static List<Asset> fetchAseetRecord(Id assetId){
        List<Asset> assetList = [SELECT Id,Name,C3_Id__c,School_C3_Id__c,License_Cap__c,Product_Type__c,InstallDate,UsageEndDate,
                                License_Type__c, School_Country__c, School_State__c,Status FROM Asset WHERE Id = :assetId];
        return assetList;
    }

    @TestVisible
    private static Map<Id,List<Year_Group__c>> fetchAssetVsYearGroupMap(Id assetId){
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
    private static List<Year_Group__c> fetchYearGroupList(Id assetId){
        List<Year_Group__c>yearGroupList = [SELECT Id,Name,C3_Year_Group__c,Provision__c,Asset__c FROM Year_Group__c
                                            WHERE Asset__c = :assetId AND Provision__c = true];
        return yearGroupList;
    } 
}