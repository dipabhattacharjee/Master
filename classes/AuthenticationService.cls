/**
 * @author: Vishnu Belkone
 * @Description: This class is to authenticate 3p and get security token.
 * @Test Class:    AuthenticationService_Test
 * @History: 
	15/09/2015 created.
 */
public class AuthenticationService {
	public static String securityToken {get;set;}
  

	public String authenticate(){
		
		
		httpCallOut();	
	
		System.debug('Security Token' +securityToken);
		return securityToken;
    }
   
	/**
	* @author: Vishnu Belkone
	* @Description: This function is call HTTPCallOut class with request to make call out and get security token.	
	* @History: 
		15/09/2015 created.
	*/
    public static Void httpCallOut(){     
		HttpRequest req = generateHTTPRequest();
		HttpResponse res = new HttpResponse();
		ServicesErrorLogs errorLog = new ServicesErrorLogs();

		if (!Test.isRunningTest())
		{
			try 
			{				
				res =new HTTPCallOut().sendRequest(req);

				System.debug('Authentication Response,root:'+res.getBody());

				Dom.Document doc = res.getBodyDocument();

				CheckForExceptionInResponse(doc);				

				securityToken = GetAuthToken(doc);  
			} 			
			catch(Exception ex) {
				
				errorLog.NotifyDevelopers(res, req, 'Authentication', '', ex); 		
			}	

			  
		}	
		else
		{
			securityToken= 'abcdefghijkl';
		}	

    }
    @TestVisible
   private static void CheckForExceptionInResponse(Dom.Document response)
   {
   		if(response == null)
   		{
   			System.debug('Authentication Reponse is null');
   			throw new AuthorizationException('3PLearning Authentication service is not accessible');
   		}

		Dom.XMLNode root = response.getRootElement();

		System.debug('CheckForExceptionInResponse, begin');				

        Dom.XMLNode body 					= root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        String nameSpace					= 'http://PppLearning.Security.AuthenticationService';
        Dom.XMLNode authenticateResponse 	= body.getChildElement('AuthenticateResponse', nameSpace);
 		Dom.XMLNode authenticateResult 		= authenticateResponse.getChildElement('AuthenticateResult', nameSpace);
 		Dom.XMLNode isError 				= authenticateResult.getChildElement('IsError', nameSpace);

		boolean hasError=  Boolean.valueOf(isError.getText());

		if(hasError)
		{		
			throw new AuthorizationException('3PLearning Authentication failed');
		}
   }
   @TestVisible
    private static String GetAuthToken(Dom.Document response)
   {
		Dom.XMLNode root = response.getRootElement();

		System.debug('GetAuthToken, begin');				
		Dom.XMLNode body 					= 	root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        String nameSpace					= 'http://PppLearning.Security.AuthenticationService';
        Dom.XMLNode authenticateResponse 	= body.getChildElement('AuthenticateResponse', nameSpace);
 		Dom.XMLNode authenticateResult 		= authenticateResponse.getChildElement('AuthenticateResult', nameSpace);
 		Dom.XMLNode authToken 				= authenticateResult.getChildElement('AuthToken', nameSpace);

		String token =  authToken.getText();

		return token;
   }
	/**
	* @author: Vishnu Belkone
	* @Description: This function create return soap request to send for callout.	
	* @History: 
		15/09/2015 created.
	*/
	@TestVisible
		private static HttpRequest generateHTTPRequest(){    
			

			PppLearningServiceEndpoints     endpoints = new  PppLearningServiceEndpoints();     

			Authenticate_Service_Details__c authenticationservice_detail=Authenticate_Service_Details__c.getInstance('3pLearning') ;
				HttpRequest req = new HttpRequest();

			if(authenticationservice_detail != null)
			{

				String username 	= authenticationservice_detail.User_Name__c ;
				String password 	= authenticationservice_detail.Password__c ;
				String productId 	= authenticationservice_detail.ProductID__c;
			
			   	String body = '<?xml version="1.0" encoding="utf-8"?>'+
	                            '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
	                              '<soap:Body>'+
	                                '<Authenticate xmlns="http://PppLearning.Security.AuthenticationService">'+
	                                  '<request>'+
	                                   '<Username>' + username+ '</Username>'+
	                                    '<Password>' + password+ '</Password>'+
	                                    '<ProductID>' + productId+ '</ProductID>'+
	                                  '</request>'+
	                               '</Authenticate>'+
	                              '</soap:Body>'+
	                            '</soap:Envelope>';

	        
				req.setMethod('POST');			
	        	req.setHeader('Content-Type','text/xml; charset=utf-8'); 			
	        	req.setBody(body);				
	            req.setEndpoint(endpoints.AuthenticationServiceUri); 
       
         	
         }
         else
         {
         	System.debug(Logginglevel.ERROR ,'Authenticate_Service_Details__c.getInstance(3pLearning) does not exist!');
         }

		return req;
    }    
	


}