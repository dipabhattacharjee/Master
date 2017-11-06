/*
 * @author- Vishnu Belkone
 * @Description This class to generate request and send request to server. 
 * @TestClass: ContactPostPutServiceGenerator_Test
*/
public class ContactPostPutServiceGenerator {
public Contact serviceCall(Contact contactSingle, String token,String checkServiceMethod){
        String body = generateContactRecordToJson(contactSingle);   
        HttpRequest request = generateHTTPRequest(contactSingle,token,checkServiceMethod,body);
       // String c3Id =  httpRequestCallOut(request);
        
        System.debug('Thi is test contact' +contactSingle );
         HttpResponse response = httpRequestCallOut(request);
        if(response != null){
             if(response.getStatusCode() == 200){
              contactSingle.C3_Id__c = response.getBody();
            }else{
                new ServicesErrorLogs().generateErrorlogs(response, contactSingle.Id, 'Contact', 'Standard');
            }
        }
        return contactSingle;
    }

    private HttpResponse  httpRequestCallOut(HttpRequest request)
    {
        HttpResponse response = new HttpResponse();

        if (!Test.isRunningTest())
        {
            response = new HTTPCallOut().sendRequest(request);
            System.debug('Thi is test contact' +response.getBody() );
        }

        return response;
    }
    //Generate HttpRequest for Contact service
    private static HttpRequest generateHTTPRequest (Contact contactSingle, String token,String checkServiceMethod,String body){
        //String body = generateAccountRecordToJson(accountSingle) ;   
            PppLearningServiceEndpoints     endpoints = new  PppLearningServiceEndpoints();     

       system.debug('This is to test'+body);
        HttpRequest req = new HttpRequest();
        req.setTimeOut(60000);
        if(checkServiceMethod == 'POST'){
            req.setMethod('POST');
        }else if(checkServiceMethod == 'PUT'){
            req.setMethod('PUT');
        }
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('AuthToken',token);                   
            req.setBody(body);                  
            req.setEndpoint(endpoints.ContactServiceURI);  
            return req;
    }
    private static String generateContactRecordToJson(Contact singleContact){      
        ContactServiceBodywrapper contactWrapper = new ContactServiceBodywrapper();
        ContactPostPutServiceJsonBuilder builder = new ContactPostPutServiceJsonBuilder();
        contactWrapper = builder.populateFieldsForContactService(singleContact);
        System.debug('#wrapper - ' + JSON.serialize(contactWrapper ));
        //system.debug('This is to accountJSON'+json1);
        return JSON.serialize(contactWrapper );
    }    
}