public with sharing class EmailApi {
	
	public void SendEmail(List<string> to, String subject, List<Opportunity> opportunities) {

	
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    

		mail.setToAddresses(to);              

		mail.setReplyTo('noreply@3plearning.com');      
	
		mail.setSubject(subject +' - ' + system.today().format());
	
		mail.htmlBody = '<br>Below is Opportunity list ('+ opportunities.size()+')</br>';

		for(Opportunity opportunity : opportunities)
		{
			mail.htmlBody = mail.htmlBody+ 
			'<br>' 				+
			'OpportunityId:' 	+ Opportunity.Id 		+
			', Name:' 			+ Opportunity.Name 		+
			', AccountId:' 		+ Opportunity.AccountId +
			//', Amount:' 		+ Opportunity.Amount 	+	
			', Stage:' 			+ Opportunity.StageName +
			'</br>';
		}
		//mail.setPlainTextBody('Request:'+request.getBody() +' Response:'+  response.getBody()+ '<br/> Message:'+ ex.getMessage() + '<br/> StackTrace:' + ex.getStackTraceString());		
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

	public void SendEmail(List<string> to, String subject, String body) {

	
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    

		mail.setToAddresses(to);              

		mail.setReplyTo('noreply@3plearning.com');      
	
		mail.setSubject(subject +' - ' + system.today().format());
	
		mail.htmlBody = body;
		
		mail.htmlBody = body ;			

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}