global class EBSInboundEmailHandler implements Messaging.InboundEmailHandler {
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                         Messaging.Inboundenvelope envelope) {
Opportunity opportunity;
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();


try {


	if(String.isBlank(email.subject))
	{
	    result.success = false;
	    result.message = ('Cannot process inbound email without a subject');
	    return result;
	}

	// Look for Opportunity whose name is the subject and create it if necessary
	if ([select count() from Opportunity where Id=:email.subject] > 0) 
	{
	  opportunity = [select Id from Opportunity where Id=:email.subject];  
	  system.debug('Opportunity found' + opportunity);
	}

	if(opportunity == null)
	{
	    result.success = false;
	    result.message = ('OpportunityID:['+ email.subject + '] not found!');
	    return result;
	}

   if(email.binaryAttachments != null)
    {
        for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
          Attachment attachment = new Attachment();
         
          attachment.Name = bAttachment.fileName;
          attachment.Body = bAttachment.body;
          attachment.ParentId = opportunity.Id;
          insert attachment;
        }
    }      

	result.success = true;


    }
     catch (Exception e) {

      result.success = false;

      result.message = 'Opportunity['+ email.subject +']attachment failed, message failed. Error : '+e.getMessage();
    }
   
    return result;
  }
}