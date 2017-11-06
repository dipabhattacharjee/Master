public  class LicenceProxyBuilder {
	public LicenceProxyBuilder() {
		
	}


	public AssetYearGLicenseWrapper GeneratePppLearningLicenceProxy (Asset asset ){
        AssetYearGLicenseWrapper assetWrapper = new AssetYearGLicenseWrapper();

        assetWrapper.CustomerId = asset.School_C3_Id__c != null ? Integer.valueOf(asset.School_C3_Id__c) :null;
       
        AssetYearGLicenseWrapper.cls_Licence licence = new AssetYearGLicenseWrapper.cls_Licence();

        licence.Id = asset.C3_Id__c == null ? null :Integer.valueOf(asset.C3_Id__c);         
        licence.CapUsed = 0;        
        licence.CapCount = asset.License_Cap__c != null ? Integer.valueOf(asset.License_Cap__c) :null;        
        licence.ProductType = asset.Product_Type__c;
        licence.StartDate = asset.InstallDate;       
        licence.EndDate = asset.UsageEndDate;
        licence.LicenceType = asset.License_Type__c;
        licence.SchoolYearGroupLicences = GetPppLearningLicenceYearGroupsProxy(asset);
        licence.ExternalId = asset.Id;       
        licence.Status = asset.Status == 'Cancelled' || asset.Status == 'Lost' ? 0 : 1;

        assetWrapper.Licence = licence;

        return assetWrapper;
    } 

    private List<AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences> GetPppLearningLicenceYearGroupsProxy(Asset asset){

        List<AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences> licenceYearGroups = new List<AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences>();

        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences kindergarten = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year1 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year2 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year3 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year4 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year5 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year6 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year7 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();        
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year8 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year9 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year10 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();           
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year11 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();       
        AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences year12 = new AssetYearGLicenseWrapper.cls_SchoolYearGroupLicences();       
     
       kindergarten.YearGroup = LicenceYearGroupEnum.Kindergarten.ordinal();
        kindergarten.IsActive = asset.Kindergarten__c;
        licenceYearGroups.add(kindergarten);

        year1.YearGroup = LicenceYearGroupEnum.Year1.ordinal();
        year1.IsActive = asset.Year1__c;
        licenceYearGroups.add(year1);

        year2.YearGroup = LicenceYearGroupEnum.Year2.ordinal();
        year2.IsActive = asset.Year2__c;
        licenceYearGroups.add(year2);

        year3.YearGroup = LicenceYearGroupEnum.Year3.ordinal();
        year3.IsActive = asset.Year3__c;
        licenceYearGroups.add(year3);

        year4.YearGroup = LicenceYearGroupEnum.Year4.ordinal();
        year4.IsActive = asset.Year4__c;
        licenceYearGroups.add(year4);

        year5.YearGroup = LicenceYearGroupEnum.Year5.ordinal();
        year5.IsActive = asset.Year5__c;
        licenceYearGroups.add(year5);

        year6.YearGroup = LicenceYearGroupEnum.Year6.ordinal();
        year6.IsActive = asset.Year6__c;
        licenceYearGroups.add(year6);

        year7.YearGroup = LicenceYearGroupEnum.Year7.ordinal();
        year7.IsActive = asset.Year7__c;
        licenceYearGroups.add(year7);

        year8.YearGroup = LicenceYearGroupEnum.Year8.ordinal();
        year8.IsActive = asset.Year8__c;
        licenceYearGroups.add(year8);

        year9.YearGroup = LicenceYearGroupEnum.Year9.ordinal();
        year9.IsActive = asset.Year9__c;
        licenceYearGroups.add(year9);

        year10.YearGroup = LicenceYearGroupEnum.Year10.ordinal();
        year10.IsActive = asset.Year10__c;
        licenceYearGroups.add(year10);

         year11.YearGroup = LicenceYearGroupEnum.Year11.ordinal();
        year11.IsActive = asset.Year11__c;
        licenceYearGroups.add(year11);

        year12.YearGroup = LicenceYearGroupEnum.Year12.ordinal();
        year12.IsActive = asset.Year12__c;
        licenceYearGroups.add(year12);

        
	
	return licenceYearGroups;

	}
}