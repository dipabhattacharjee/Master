@isTest
public class ExceptionLogData_Test 
{
    @testSetup static void setup()
    {        

        ExceptionMessages__c exceptionMsg = new ExceptionMessages__c();
        exceptionMsg.AdditionalInfo__c = 'There is a Data Validation issue';
        exceptionMsg.SpecialNote__c = 'PLEASE CORRECT THE DATA AND TRY AGAIN!';
        exceptionMsg.Name = 'ValidationException';
        insert exceptionMsg;

        System.debug('setup done');

    }
     public static testMethod void testInsertExceptionlog()
     {
        Id createdRecordId;
        string exceptionType;
        
        try
        {
            Integer test = 34/0;
        }
        catch(Exception ex)
        {
            exceptionType = ex.getTypeName();            
            createdRecordId = ExceptionLogData.InsertExceptionlog('00Qp0000002RPOQ', Logginglevel.ERROR, 'Math', ex, true, false, null, null);        
        }        
        finally
        {
            List<ExceptionLog__c> exceptionObj = [select Id, Type__c, level__c FROM ExceptionLog__c WHERE Id  = :createdRecordId];
            
            system.debug('this is the Exception '+ exceptionObj[0].Id + ' Type: ' + exceptionObj[0].Type__c + 'Exception Type: ' + exceptionType);
            
            System.assertEquals(exceptionType, exceptionObj[0].Type__c);
            System.assertEquals(String.valueof(Logginglevel.ERROR), exceptionObj[0].level__c);
        }
     }


     public static testMethod void testInsertExceptionlogForValidationException()
     {
        Id createdRecordId;
        string exceptionType;
        
        try
        {
            throw new ValidationException();
        }
        catch(Exception ex)
        {
            exceptionType = ex.getTypeName();            
            createdRecordId = ExceptionLogData.InsertExceptionlog('00Qp0000002RPOQ', Logginglevel.ERROR, 'Licence', ex, true, false, null, null);        
        }        
        finally
        {
            List<ExceptionLog__c> exceptionObj = [select Id, Type__c, Level__c, AdditionalInformation__c  FROM ExceptionLog__c WHERE Id  = :createdRecordId];
            
            system.debug('this is the Exception '+ exceptionObj[0].Id + ' Type: ' + exceptionObj[0].Type__c + 'Exception Type: ' + exceptionType);
            
            System.assertEquals(exceptionType, exceptionObj[0].Type__c);
            System.assertEquals('There is a Data Validation issue', exceptionObj[0].AdditionalInformation__c);
        }
     }
}