public with sharing class PppLearningResponseExtender {
	public PppLearningResponseExtender() {
		
	}

	public static String GetMessage(HttpResponse response)
	{
		JSONParser parser = JSON.createParser(response.getBody());
		String message = '';

        while (parser.nextToken() != null) 
        {
       		// If its field and the field name is Message
	        if((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
	          (parser.getText() == 'Message')) 
	        	{
        			// Get the value.
			        parser.nextToken();        			

        			message  = parser.getText();
        			break;
				}
    	}

    	return message;
	}


	public static boolean ValidateResponse(HttpResponse response)
	{
		//TODO this part need to improved
		if(response.getStatusCode() == 200)
		{			
			return true;
		}

		if (response.getStatusCode() == 503)
		{
			throw new IntegrationException('The service is unavailable');
		}

		String message = PppLearningResponseExtender.GetMessage(response);

		
		if (response.getStatusCode() == 401)
		{
			throw new AuthorizationException(message);
		}

		if (response.getStatusCode() == 500)
		{
			throw new IntegrationException(message);
		}

		if (response.getStatusCode() == 400)
		{
			System.debug('Code: ' + response.getStatusCode() + ' Message: ' + message);
			throw new  ServiceValidationException(message);	
		}	

		//log 
		return false;
	}
}