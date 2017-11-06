@isTest
public class AuthenticationService_Test {

	public static testMethod void GetAuthenticationToken_From_AuthenticationServiceResponse(){
		AuthenticationService authenticate = new AuthenticationService();
		//authenticate.authenticate();
		//AuthenticationService.httpCallOut();
		AuthenticationService.generateHTTPRequest();
		String responseXML = '<?xml version="1.0" encoding="utf-8"?>' +
			'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
			    '<soap:Body>'+
			        '<AuthenticateResponse xmlns="http://PppLearning.Security.AuthenticationService">'+
			            '<AuthenticateResult>'+
			                '<IsError>false</IsError>'+
			                '<ResponseCode>0</ResponseCode>'+
			                '<AuthToken>abcdefghijkl</AuthToken>'+
			            '</AuthenticateResult>'+
			       ' </AuthenticateResponse>'+
			    '</soap:Body>'+
		'</soap:Envelope>';

		Dom.Document doc = new  Dom.Document();

		doc.load(responseXML);
		String token = AuthenticationService.GetAuthToken(doc);

		System.assertEquals('abcdefghijkl', token);
	} 

	public static testMethod void GettingNullResonse_From_AuthenticationService_ThrowsException()
	{
		String excpetionMessage = '';

		try {
			AuthenticationService.CheckForExceptionInResponse(null);
		} catch(AuthorizationException e) {
			excpetionMessage = e.getMessage();

		}

		System.assert(excpetionMessage.contains('3PLearning Authentication service is not accessible'));
		
	}


public static testMethod void AuthenticationServiceResponse_HasError_Then_ItShouldThrowsException()
	{
		AuthenticationService authenticate = new AuthenticationService();
		//authenticate.authenticate();
		//AuthenticationService.httpCallOut();
		AuthenticationService.generateHTTPRequest();
		String responseXML = '<?xml version="1.0" encoding="utf-8"?>' +
			'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
			    '<soap:Body>'+
			        '<AuthenticateResponse xmlns="http://PppLearning.Security.AuthenticationService">'+
			            '<AuthenticateResult>'+
			                '<IsError>true</IsError>'+
			                '<ResponseCode>0</ResponseCode>'+
			                '<AuthToken></AuthToken>'+
			            '</AuthenticateResult>'+
			       ' </AuthenticateResponse>'+
			    '</soap:Body>'+
		'</soap:Envelope>';

		Dom.Document doc = new  Dom.Document();

		doc.load(responseXML);

		String excpetionMessage = '';

		try{
			AuthenticationService.CheckForExceptionInResponse(doc);
		}
	    catch(AuthorizationException e) {
			excpetionMessage = e.getMessage();

		}		

		System.assert(excpetionMessage.contains('3PLearning Authentication failed'));
		
	}


	public static testMethod void AuthenticationServiceResponse_IsErroFalse_Then_NoException()
	{
		AuthenticationService authenticate = new AuthenticationService();
		//authenticate.authenticate();
		//AuthenticationService.httpCallOut();
		AuthenticationService.generateHTTPRequest();
		String responseXML = '<?xml version="1.0" encoding="utf-8"?>' +
			'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
			    '<soap:Body>'+
			        '<AuthenticateResponse xmlns="http://PppLearning.Security.AuthenticationService">'+
			            '<AuthenticateResult>'+
			                '<IsError>false</IsError>'+
			                '<ResponseCode>0</ResponseCode>'+
			                '<AuthToken></AuthToken>'+
			            '</AuthenticateResult>'+
			       ' </AuthenticateResponse>'+
			    '</soap:Body>'+
		'</soap:Envelope>';

		Dom.Document doc = new  Dom.Document();

		doc.load(responseXML);

				
		AuthenticationService.CheckForExceptionInResponse(doc);
		

		System.assert(true);
		
	}


	

}