/*
 * @author- Vishnu Belkone
 * @Description This class to call contact services
 * @TestClass: ContactServices_Test
 * @History:
 * 18/10/2015 Created
 */
public class ContactServices {
    public void runServices(Set<Id> contactIds){
        if(System.isFuture() == false && System.isBatch() == false){
             postPutService(contactIds);
        }
    }
    @future(callout=true)
    public static void postPutService(Set<Id> contactIds ){
        String token;
		if (!Test.isRunningTest())
		{
			token = new AuthenticationService().authenticate();
		}else{
		    token = 'abcdefghijkl';
		}
        ContactPostPutServiceGenerator contactCreate = new ContactPostPutServiceGenerator ();
        List<Contact>contactsToUpdate = new List<Contact>();
        List<Contact> contactToSend = [SELECT ID,C3_Id__c,account.C3_Id__c,FirstName,LastName,Name,Phone,Fax,Email,MobilePhone,Status__c,Is_Active__c,
                                      Description,RecordTypeId ,Job_Function__c,Product_IntoScience_Count__c,Product_Mathletics_count__c,
                                      Product_ReadingEggs_count__c,Product_Spellodrome_Count__c, CountContactRolesIntoScience__c, CountContactRolesMathletics__c, CountContactRolesReadEggs__c, CountContactRolesSpellodrome__c
                                       FROM Contact WHERE ID IN :contactIds];
        system.debug('This is to contactToSend'+contactToSend);
        String checkServiceMethod;      
        Id schoolRecordTypeId = fetchBankRecordTypeId();
        for(Contact singleContact: contactToSend){  
            system.debug('This is to singleContact.C3_Id__c'+singleContact.C3_Id__c);
                if(singleContact.C3_Id__c != null && singleContact.C3_Id__c != ''){
                    checkServiceMethod = 'PUT';
                    contactCreate .serviceCall(singleContact,token,checkServiceMethod);
                }else{
                    checkServiceMethod = 'POST';
                    contactsToUpdate .add(contactCreate .serviceCall(singleContact,token,checkServiceMethod) );
                } 
           
        }   
        update contactsToUpdate ;
    }
    
    @TestVisible
    private static Id fetchBankRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'School Personnel'  And sObjectType = 'Contact'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }
}