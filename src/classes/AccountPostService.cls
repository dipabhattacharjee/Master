/*
 * @author- Vishnu Belkone
 * @TestClass: AccountPostService_Test
 * @Description - This class is use to call out accout post service.

 public enum Http_Status_Code
{
    Succeeded= 200,
    ValidationError = 400
}

*/



public class AccountPostService {
    public static string c3Id{get;set;}
    public  static Account CreatedAccount{get;set;}
    public Static String securityToken{get;set;}
    public Account serviceCall(Account accountSingle, String token,String checkServiceMethod,Map<String,ISOMapping__c> iso2VsIso3Map,Map<String,AccountTeamMember> teamMemberRoleVsAccountTeamMember){       
        CreatedAccount = accountSingle;
        securityToken = token;
        String body = generateAccountRecordToJson(accountSingle,iso2VsIso3Map,teamMemberRoleVsAccountTeamMember);   
        HttpRequest request = generatePostRequest(accountSingle,token,checkServiceMethod,body);
        HttpResponse response = new HttpResponse();

        if (!Test.isRunningTest())
        { 
            response = postHTTPCallOut(request);
        }        
        
        if(response != null){
             if(response.getStatusCode() == 200){
               accountSingle.C3_Id__c = response.getBody();
            }
            else {
                new ServicesErrorLogs().generateErrorlogs(response, accountSingle.Id, 'Account', 'Standard');
            }
        }
        //accountSingle.C3_Id__c = c3Id;
        return accountSingle;
    }
    
    public static HttpResponse postHTTPCallOut(HttpRequest request){
        try{
           
            HttpResponse res = new HttpResponse();
            Http http = new Http();       
            
            if (!Test.isRunningTest())
        	{
            	res =  new HTTPCallOut().sendRequest(request); 
        	}
            return res;
            
        }catch(Exception ex){
             system.debug('Exception throws' +ex.getMessage());
             return null;          
        }
    }
    //Generate HttpRequest for Account service
    @TestVisible
    private static HttpRequest generatePostRequest (Account accountSingle, String token,String checkServiceMethod,String body){

        PppLearningServiceEndpoints endpoints = new PppLearningServiceEndpoints();
        //String body = generateAccountRecordToJson(accountSingle) ;         
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
            req.setEndpoint(endpoints.AccountServiceURI);                   
           
            return req;
    }
    //Generate gson to send with http request.
    @TestVisible
    private static String generateAccountRecordToJson(Account singleAccount,Map<String,ISOMapping__c> iso2VsIso3Map,Map<String,AccountTeamMember> teamMemberRoleVsAccountTeamMember){       
        AccountFieldsForServiceWrapper accountSingle = new AccountFieldsForServiceWrapper();
        AccountPostServiceJsonBuilder builder = new AccountPostServiceJsonBuilder();
        accountSingle = builder.populateFieldsForService(singleAccount,iso2VsIso3Map,teamMemberRoleVsAccountTeamMember);
        return JSON.serialize(accountSingle);
    }    
   
}