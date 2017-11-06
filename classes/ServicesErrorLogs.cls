/**
* @author: vishnu belkone
* @description: The class is to insert error logs of all services.
* @tTestClass: ServicesErrorLogs_Test
*/



public class ServicesErrorLogs {
    public void generateErrorlogs(HttpResponse response , String objectId,String objectName,String objectType) {
        Error_Log__c  error = new Error_Log__c();
        error.Date_of_Transaction__c = System.today();
        error.Object_Id__c = objectId;
        error.Object_Name__c = objectName;
        error.Object_Type__c = objectType;
        error.Response_Message__c = response.getBody();
        insert error;
    }


 public void NotifyDevelopers(HttpResponse response , HttpRequest request, String objectName, String objectId, Exception ex) {

		List<String> developers = getDevelopersEmail();	

		if(developers.size() > 0)
		{
			String salesforceBaseUrl = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
			mail.setToAddresses(developers);              
			mail.setReplyTo('noreply@3plearning.com');      
			mail.setSenderDisplayName(UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
			mail.setSubject('Service Call failed for Name:' + objectName +',Id:' + objectId);
			mail.setBccSender(false);
			mail.setUseSignature(false);

			mail.htmlBody = '<br/> '+salesforceBaseUrl+'/' +objectId +'<br/><br/><b>Error Message:</b>'+ ex.getMessage() +'<br/><b>Request: </b>'+request.getBody() +' <br/><b>Response:</b>'+  response.getBody()+ 
							'<br/><b>StackTrace:</b>' + ex.getStackTraceString();

			//mail.setPlainTextBody('Request:'+request.getBody() +' Response:'+  response.getBody()+ '<br/> Message:'+ ex.getMessage() + '<br/> StackTrace:' + ex.getStackTraceString());		
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}	
		
		//adding the error into error log
		Error_Log__c  error = new Error_Log__c();
		error.Date_of_Transaction__c = System.today();
		error.Object_Id__c = objectId;
		error.Object_Name__c = objectName;
		//error.Object_Type__c = objectType;
		error.Response_Message__c = response.getBody();

		insert error;
    }

  

public void NotifyUser(String objectName , String objectId, String message) {

	String email=UserInfo.getUserEmail();
	
	if(email != null)
	{
		String salesforceBaseUrl = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
				
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
		mail.setToAddresses(new String[]{email});              
		mail.setReplyTo('noreply@3plearning.com');      
		mail.setSenderDisplayName(UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
		mail.setSubject('Salesforce Integration failed for ' + objectName +', Id:' + objectId);
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.htmlBody='Dear user,<br/><br/> Unfortunately ' + objectName+ ' integration failed for the following item<br/>' +salesforceBaseUrl+'/'+  objectId +'<br/><br/>Reason:' + message +'<br/><i>Another email already sent to Dev-Team and This is just for information.</i><br/><br/>Regards,<br/>3PLearning salesforce development team';		
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
		}
    }
   
    /*
    Returns list of developers email addresses
    */
    public List<string> getDevelopersEmail()
    {
    	List<string> developers = new List<string>();

    	List<Developers_email__c> developersEmails = Developers_email__c.getall().values();	 
		
		if(developersEmails == null || developersEmails.isEmpty())
		{
			System.debug(Logginglevel.WARN, 'Developers_email__c does not exist or empty!');
			
		}

		for(Developers_email__c  developer : developersEmails)  
		{
			developers.add(developer.Email__c);
		}

		return developers;
    }



}