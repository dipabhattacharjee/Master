/**
* @author vishnu belkone
* @description 
* @TestClass: AssetYGLicenseRequestGeneratorAndSender_Test
*/

public class AssetYGLicenseRequestGeneratorAndSender {
    public HttpResponse licenseRequestGeneraterAndSender(List<Asset>assetList,Map<Id,List<Year_Group__c>>assetVsYGLicenseMap){
        String body = generateAssetYgToJson(assetList,assetVsYGLicenseMap);
        String token;
        if (!Test.isRunningTest())
        {
            token = new AuthenticationService().authenticate();
        }else{
            token = 'abcdefghijkl';
        }
        HttpRequest request = httpRequestGenerater(assetList,token,body);
         HttpResponse response = httpRequestCallOut(request);
       
        return response;
    }

    @TestVisible
     private HttpResponse  httpRequestCallOut(HttpRequest request){
        HttpResponse response;
        if (!Test.isRunningTest())
        {
            response = new HTTPCallOut().sendRequest(request);
        }
         
        return response;
    }

    @TestVisible
    private HttpRequest httpRequestGenerater(List<Asset>assetList,String token,String body){
        HttpRequest request = new HttpRequest();
        request.setMethod(getRequestType(assetList[0].C3_Id__c));
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setHeader('AuthToken',token);                   
        request.setBody(body);
        request.setTimeOut(60000); 
        request.setEndpoint(Service_EndPoints__c.getInstance('School Licence Service').Endpoint_URL__c);  
        return request;               
    }

    @TestVisible
    private String getRequestType(Decimal C3Id){
        return C3Id != null ?'PUT' :'POST';
    }
     private static String generateAssetYgToJson(List<Asset>assetList,Map<Id,List<Year_Group__c>>assetVsYGLicenseMap){      
        AssetYearGLicenseWrapper assetWrapper = new AssetYearGLicenseWrapper();
        AssetYearGLicenseJsonBuilder builder = new AssetYearGLicenseJsonBuilder();
        assetWrapper = builder.populateFields(assetList,assetVsYGLicenseMap);        
        return JSON.serialize(assetWrapper );
    } 
}