/**
 * Author: Vishnu Belkone 
 * @Description: this is an rest class to return school list from outside the salesforce.
 * @Test Class:    RestTodGetSchoolList_Test
 * @History: 
	15/08/2015 created.
 */
@RestResource(urlMapping='/fetchschools/*')
global with sharing class RestTodGetSchoolList {
	/**
	 * Author: Vishnu Belkone 
	 * @Description: Method to return list of school present in the org form rest call.	
	 * @History: 
		15/08/2015 created.
	 */
    @HttpGet
    global static List<Account> getSchoolList() {
	        
        String country = RestContext.request.params.get('country');
        String State = RestContext.request.params.get('state');
        String postcode = RestContext.request.params.get('postcode');
        List<Account> schollList = [ Select ID, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from Account where BillingCountry = :country 
                                 and BillingState = :state and BillingPostalCode = :postcode]; 
        return schollList; 
    }
    
}