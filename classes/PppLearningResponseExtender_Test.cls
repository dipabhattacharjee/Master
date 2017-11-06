@isTest
private class PppLearningResponseExtender_Test
{
	@isTest
	static void CallGetMessage_WithoutHavingAnyMassage_ItSouldReturnEmptyString()
	{
		HttpResponse response = new HttpResponse();
		String body = '{"anyName": "AnyValue"}';

		response.setBody(body);

		String result = PppLearningResponseExtender.GetMessage(response);

		System.assertEquals('', result);
	}

	@isTest
	static void CallGetMessage_WithMassage_ItSouldReturnFirstMessage()
	{
		HttpResponse response = new HttpResponse();
		String body = '{"anyName": "AnyValue","Message": "1st","Error": "Error","Exception": "AnyException","Message": "2nd"}';

		response.setBody(body);

		String result = PppLearningResponseExtender.GetMessage(response);

		System.assertEquals('1st', result);
	}


	@isTest
	static void CallGetMessage_WithMassageInDeepLevelCollection_ItSouldReturnFirstMessage()
	{
		HttpResponse response = new HttpResponse();

        string expectedResult = '1st';

		String body = '{"name": "ajsie","Error": "Error","Exception": "Excep","List": [{"Inner": "One","Outer": "One","Message": "1st"}, {"Inner": "Two","Outer": "Two","Message": "2nd",}]}';

		response.setBody(body);

		String result = PppLearningResponseExtender.GetMessage(response);

		System.assertEquals('1st', result);
	}

	@isTest
	static void CallValidateResponse_WithHttpResponseCode200_ItShouldReturnTrue()
	{
		
		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(200);

		boolean result = PppLearningResponseExtender.ValidateResponse(httpResponse);

		System.assertEquals(true, result);	

	}



	@isTest
	static void CallValidateResponse_WithHttpResponseCode501_ItShouldReturnFalse()
	{
		
		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(501);

		boolean result = PppLearningResponseExtender.ValidateResponse(httpResponse);

		System.assertEquals(false, result);	

	}

	@isTest
	static void CallValidateResponse_WithHttpResponseCode400_ItShouldThrowValidationException()
	{
		
		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(400);

		try
		{
			PppLearningResponseExtender.ValidateResponse(httpResponse);
		}
		catch(ServiceValidationException ex)
		{
			System.assertNotEquals(null, ex);
		}			

	}

	@isTest
	static void CallValidateResponse_WithHttpResponseCode500_ItShouldThrowIntegrationException()
	{
		
		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(500);

		try
		{
			PppLearningResponseExtender.ValidateResponse(httpResponse);
		}
		catch(IntegrationException ex)
		{
			System.assertNotEquals(null, ex);
		}			

	}

	@isTest
	static void CallValidateResponse_WithHttpResponseCode401_ItShouldThrowAuthorizationException()
	{
		
		HttpResponse httpResponse = new HttpResponse();
		httpResponse.setStatusCode(401);

		try
		{
			PppLearningResponseExtender.ValidateResponse(httpResponse);
		}
		catch(AuthorizationException ex)
		{
			System.assertNotEquals(null, ex);
		}			

	}
}