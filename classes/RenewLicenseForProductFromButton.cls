/**
 * @author: Vishnu Belkone
 * @date: 18/11/2015
 * @description: Webservice class to renew licences from button.
 * @Test Class: RenewLicenseForProductFromButton_Test
 * @History:
	18/11/2015 Created.
*/
global class RenewLicenseForProductFromButton {
   /**
	* @author Vishnu Belkone	
	* @description - This function to renew licence called from custom list button "Renew Licences" on opportunityLineItem related list of opportunity. 
	* @param - Parent opportunity Id.
	* @History:
		18/11/2015 Created.
	*/
	 webservice static string renewLicences(Id opportunityId) {
		try 
		{	
		   String result = new RenewLicencesForProduct().renewLicences(opportunityId);
			if (result == 'SUCCESS')
			{
				return 'SUCCESS';	
			}else{
				return 	result;
			}		 
			
		}
		catch (Exception ex)
		{
			return 	ex.getMessage();
		}
       
	   
    }
}