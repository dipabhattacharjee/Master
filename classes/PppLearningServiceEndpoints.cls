public with sharing class PppLearningServiceEndpoints {
	
	public PppLearningServiceEndpoints() {
		
		
		SchoolLicenceServiceURI 	= '';
		AccountServiceURI			= '';
		ContactServiceURI 			= '';
		AuthenticationServiceUri 	= '';

		Service_EndPoints__c schoolLicence_serviceEndpoint = Service_EndPoints__c.getInstance('School Licence Service');
		
		if(schoolLicence_serviceEndpoint != null)
		{
			 SchoolLicenceServiceURI = schoolLicence_serviceEndpoint.Endpoint_URL__c;
		}
		else
		{
			System.debug(Logginglevel.ERROR, 'Service_EndPoints__c.getInstance(School Licence Service) does not exist!');
		}

		Service_EndPoints__c account_serviceEndpoint = Service_EndPoints__c.getInstance('Account Service');
		
		if(account_serviceEndpoint != null)
		{
			 AccountServiceURI = account_serviceEndpoint.Endpoint_URL__c;
		}
		else
		{
			System.debug(Logginglevel.ERROR, 'Service_EndPoints__c.getInstance(Account Service) does not exist!');
		}

		Service_EndPoints__c contact_serviceEndpoint = Service_EndPoints__c.getInstance('Contact Service');
	

		if(contact_serviceEndpoint != null)
		{
			 ContactServiceURI= contact_serviceEndpoint.Endpoint_URL__c;
		}
		else
		{
			System.debug(Logginglevel.ERROR, 'Service_EndPoints__c.getInstance(contact Service) does not exist!');
		}

		Service_EndPoints__c authentication_serviceEndpoint = Service_EndPoints__c.getInstance('Authorization Service');
	
		if(authentication_serviceEndpoint != null)
		{
			 AuthenticationServiceUri= authentication_serviceEndpoint.Endpoint_URL__c;
		}
		else
		{
			System.debug(Logginglevel.ERROR, 'Service_EndPoints__c.getInstance(authentication Service) does not exist!');
		}


	}

	public String AccountServiceURI {get; private  set;}

	public String SchoolLicenceServiceURI {get; private  set;}

	public String ContactServiceURI {get; private  set;}

	public String AuthenticationServiceUri {get; private  set;}



}