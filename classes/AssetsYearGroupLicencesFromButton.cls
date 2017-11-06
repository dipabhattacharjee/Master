/**
* @author Vishnu Belkone
* @date 18/11/2015
* @description - Webservice class to call licences service. 
*/
global class AssetsYearGroupLicencesFromButton {
    webservice static string serviceCall(Id assetId) {
			    
		
		//HttpResponse response = new AssetYearGLicenseService().assetYearLicense(assetId) ; 
		PppLearningLicenceService pppLearningLicenceService = new PppLearningLicenceService();
       
        try
        {
            AssetData assetData = new AssetData();
            Asset asset = assetData.GetAsset(assetId);
            // throw new ValidationException('Test Exception');
            pppLearningLicenceService.UpsertLicence(asset);
            return 'SUCCESS';
        }
        catch(ValidationException ex)
        {
            return 'Validation failed, ' + ex.getMessage();
        }
        catch(AuthorizationException ex)
        {
            return 'Authorization error- Cannot connect to Licence service';
        }
        catch(IntegrationException ex)
        {
            return 'Licence service is not working properly';
        }
        catch(CalloutException ex)
        {
            return 'Cannot connect to Licence service';
        }
         catch(Exception ex)
        {
            return 'Licence cannot created.';            
        }

    }
}