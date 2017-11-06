/**
* @author Vishnu Belkone
* @date 18/11/2015
* @description - Webservice class to call licences service. 
*/
global class CreateAssetLicenseForProductFromButton {
	 webservice static string createTrialFullLicense(Id opportunityId,String licenseType) {
		try 
		{	    
		  return new TrialFullAssetCreatorForProduct().createLicense(opportunityId,licenseType);		
			
		}
		catch (Exception ex)
		{
			return 	ex.getMessage();
		}
       
	   
    }


}