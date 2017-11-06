/**
* @author vishnu belkone
* @description  This class return fields for populate fields for account post/put service.
*/
public class AssetYearGLicenseJsonBuilder {
    public AssetYearGLicenseWrapper populateFields (List<Asset>assetList , Map<Id,List<Year_Group__c>> assetVsYearGroupMap){
        AssetYearGLicenseWrapper assetWrapper = new AssetYearGLicenseWrapper();
        assetWrapper.CustomerId = assetList[0].School_C3_Id__c != null ? Integer.valueOf(assetList[0].School_C3_Id__c) :null;
        System.debug('This is to test asset'+assetList[0]);
        assetWrapper.Licence = getlicense(assetList,assetVsYearGroupMap);
        return assetWrapper;
    } 
    private AssetYearGLicenseWrapper.cls_Licence getlicense(List<Asset>assetList ,  Map<Id,List<Year_Group__c>> assetVsYearGroupMap){
        AssetYearGLicenseWrapper.cls_Licence assetLicence = new AssetYearGLicenseWrapper.cls_Licence();
       assetLicence.Id = assetList[0].C3_Id__c == null ? null :Integer.valueOf(assetList[0].C3_Id__c); 
        
        assetLicence.CapUsed = 0;
        
        assetLicence.CapCount = assetList[0].License_Cap__c != null ? Integer.valueOf(assetList[0].License_Cap__c) :null;
        
        assetLicence.ProductType = assetList[0].Product_Type__c;
       
        assetLicence.StartDate = assetList[0].InstallDate;
       
        assetLicence.EndDate = assetList[0].UsageEndDate;
        assetLicence.LicenceType = assetList[0].License_Type__c;
        assetLicence.SchoolYearGroupLicences = fetchSchoolYearGroupLicense(assetList ,assetVsYearGroupMap);
        assetLicence.ExternalId = assetList[0].Id;
		 
        return assetLicence;

    }

    private List<AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences> fetchSchoolYearGroupLicense(List<Asset>assetList ,  Map<Id,List<Year_Group__c>> assetVsYearGroupMap){
        List<AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences> schoolYearGLicenseList = new List<AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences>();
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences shoolYearGLicense;
        if (assetList != null && assetList.size() > 0 && assetVsYearGroupMap != null){
            if(assetVsYearGroupMap.containsKey(assetList[0].Id)){
                for (Year_Group__c yearGroup : assetVsYearGroupMap.get(assetList[0].Id) )
                {
                     shoolYearGLicense = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();
                     shoolYearGLicense.YearGroup = yearGroup.C3_Year_Group__c;
                     shoolYearGLicense.IsActive = yearGroup.Provision__c;
                     schoolYearGLicenseList.add(shoolYearGLicense);
                }
            }
        }
        return schoolYearGLicenseList;
    }

}