/**
* @author: Asif A Khan
* @description: The class is to insert exception logs into custom objects.
* @tTestClass: ExceptionLogData_Test
*/

public  class ExceptionLogData {

    public static Id InsertExceptionlog(Id recordId, Logginglevel level, string module, Exception ex, Boolean mustNotifyDeveloper, Boolean mustNotifyUser, String additionalInformation, String specialNoteforUser)
    {
        try
        {
            system.debug('Request Received: '+ recordId);
            
            String salesforceBaseUrl = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');
                    

            ExceptionLog__c  exceptionObj = new ExceptionLog__c();

            if(ex != null)
            {
                Exception causeException                = ex.getCause();

                if(causeException != null)
                {
                    exceptionObj.Cause__c       = causeException.getMessage();
                } 

                exceptionObj.Name                       = ex.getTypeName();
                exceptionObj.AdditionalInformation__c   = GetAdditionalInfo(ex);
                exceptionObj.SpecialNoteforUser__c      = GetSpecialNote(ex);
                exceptionObj.LineNumber__c              = ex.getLineNumber();
                exceptionObj.Message__c                 = ex.getMessage();
                exceptionObj.StackTrace__c              = ex.getStackTraceString();
                exceptionObj.Type__c                    = ex.getTypeName();

            }
            else
            {
                exceptionObj.AdditionalInformation__c   = additionalInformation;
                exceptionObj.SpecialNoteforUser__c      = specialNoteforUser;
            }
            
            exceptionObj.RecordId__c                = recordId;
            exceptionObj.Level__c                   = String.valueof(level);
            exceptionObj.Module__C                  = module;            
            exceptionObj.MustNotifyDeveloper__c     = mustNotifyDeveloper;
            exceptionObj.MustNotifyUser__c          = mustNotifyUser;
        
                    
                           
            exceptionObj.RecordLink__c  = salesforceBaseUrl+'/'+  recordId;
            
            exceptionObj.User__c      = UserInfo.getUserId();
                    
            
            insert exceptionObj;
            
            system.debug('Successfully Inserted: '+ exceptionObj.Id);
            
            return exceptionObj.Id;
    
        }
        catch(Exception exp)
        {
            system.debug('Error in InsertExceptionlog method with Exception '+ exp.getMessage() + ' StackTrace: ' + exp.getStackTraceString());
        }
        
        return null;
    }


    public static String GetAdditionalInfo(Exception ex)
    {

        system.debug('Exception type for Setting Info  '+ ex.getTypeName());

        ExceptionMessages__c exceptionMessage = ExceptionMessages__c.getValues(ex.getTypeName());

        if(exceptionMessage != null)     
        {
            system.debug('Setting Info  '+ exceptionMessage.AdditionalInfo__c);

            return exceptionMessage.AdditionalInfo__c;
        }  
        
        return '';


    }

    public static String GetSpecialNote(Exception ex)
    {
        
        ExceptionMessages__c exceptionMessage = ExceptionMessages__c.getValues(ex.getTypeName());

        if(exceptionMessage != null)     
        {
            return exceptionMessage.SpecialNote__c;
        }  
        
        return '';

    }

}