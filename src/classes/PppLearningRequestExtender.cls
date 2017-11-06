public with sharing class PppLearningRequestExtender {
	
	public static void SetHeader(HttpRequest request, String authToken)
	{
		request.setHeader('Content-Type', 'application/json; charset=utf-8');
		request.setHeader('AuthToken', authToken);      
  
	}


	public static void SetTimeout(HttpRequest request)
	{
		PppLearningServiceSettings serviceSettings = new PppLearningServiceSettings();
		request.setTimeOut(serviceSettings.Timeout);     

		               
	}

/*
    public static  void SetMethod(HttpRequest request, Decimal id){

        String method = id != null ?'PUT' :'POST';

        request.setMethod(method);

        
    }
    */
}