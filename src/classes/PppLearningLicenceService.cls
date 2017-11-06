public with sharing class PppLearningLicenceService {

    private String ServiceEndPoint;

    private ServicesErrorLogs errorLog ;

    private AssetData assetData;

    private AuthenticationService authenticationService;

    private AssetValidator  assetValidator;

    public PppLearningLicenceService() {

        //Getting licence service endpoints from custom settings
        Service_EndPoints__c serviceEndpoint=Service_EndPoints__c.getInstance('School Licence Service');
        
        if(serviceEndpoint != null)
        {
             this.ServiceEndPoint=serviceEndpoint.Endpoint_URL__c;
        }
        else
        {
            ExceptionLogData.InsertExceptionlog(null, LoggingLevel.ERROR, 'Licence', null, true, false,
                'Service_EndPoints__c.getInstance(School Licence Service) does not exist!', 
                'Service_EndPoints__c.getInstance(School Licence Service) does not exist!');
            System.debug(Logginglevel.ERROR, 'Service_EndPoints__c.getInstance(School Licence Service) does not exist!');
        }

            
        authenticationService   = new AuthenticationService();   
        errorLog                = new ServicesErrorLogs();
        assetData               = new AssetData();
        assetValidator          = new AssetValidator();
            
    }

    

    @future(callout=true)
    public static void UpsertLicenceAsync(Id assetId)
    {       
        PppLearningLicenceService licenceService = new  PppLearningLicenceService();
        
        try
        {
            AssetData assetData = new AssetData();
            Asset asset = assetData.GetAsset(assetId);
            licenceService.UpsertLicence(asset);        
        }
        catch(Exception ex)     
        {

            //ExceptionLogData.InsertExceptionlog(assetId, LoggingLevel.Error, 'Licence', ex, true, false, null, null);
            System.debug(Logginglevel.ERROR, '[' +assetId+ '] UpsertLicenceAsync failed');
        }
    }

    @future(callout=true)
    public static void CreateLicenceAsync(Id assetId)
    {       
        PppLearningLicenceService licenceService = new  PppLearningLicenceService();
        
        try
        {
            AssetData assetData = new AssetData();
            Asset asset = assetData.GetAsset(assetId);

            if(asset.C3_Id__c == null || asset.C3_Id__c <= 0)
            {
                licenceService.CreateLicence(asset);
            }            
        }
        catch(Exception ex)     
        {
            //ExceptionLogData.InsertExceptionlog(assetId, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            System.debug(Logginglevel.ERROR, '[' +assetId+ '] CreateLicenceAsync failed');
        }
    }

    @future(callout=true)
    public static void UpdateLicenceAsync(Id assetId)
    {       
        PppLearningLicenceService licenceService = new  PppLearningLicenceService();
        
        try
        {

            AssetData assetData = new AssetData();
            Asset asset = assetData.GetAsset(assetId);

            if(asset.C3_Id__c != null && asset.C3_Id__c > 0)
            {
                licenceService.UpdateLicence(asset);            
            }
            else
            {
                licenceService.CreateLicence(asset);
            }
            
        }
        catch(Exception ex)     
        {
            //ExceptionLogData.InsertExceptionlog(assetId, LoggingLevel.Error, 'Licence', ex, true, false, null, null);

            System.debug(Logginglevel.ERROR, '[' +assetId+ '] UpdateLicenceAsync failed');
        }
    }


    public void CreateLicence(Asset asset)
    {   

        HttpRequest request     = new HttpRequest();
        HttpResponse response   = new HttpResponse();

        AssetSyncMsgTypeEnum syncStatusMsgtype = AssetSyncMsgTypeEnum.Success;
        String syncStatus = 'Licence synchronised successfully';

        try
        {       
            
            assetValidator.ValidateForCreate(asset);

            request     = GenerateRequest(asset );
            response    = new HttpResponse();

            request.setMethod('POST');
            response    = CallLicenceService(request);

            //Set PppLearning LicenecId
            if (asset.C3_Id__c == null)
            {
                asset.C3_Id__c = Integer.valueOf(response.getBody());           
            }    
            
            if(asset.AvoidTriggerExecution__c == null)
            asset.AvoidTriggerExecution__c=0;
            
            asset.AvoidTriggerExecution__c = asset.AvoidTriggerExecution__c + 1;           

        }       
        catch(AuthorizationException ex)        
        {                   
            syncStatus  = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());
            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);
            
            throw ex;
        }

        catch(ValidationException ex)       
        {         
         
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, false, false, null, null);
            
            throw ex;
        }      
        catch(ConflictException ex)       
        {        

            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());   

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;           

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, false, false, null, null);

            throw ex;
        }
        catch(IntegrationException ex)       
        {        
           
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());   

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;           

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            throw ex;
        }
        catch(ServiceValidationException ex)       
        {
                        
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());   

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;           

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            throw ex;
        }
        catch(Exception ex)     
        {        
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());              

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            throw ex;
        }


        finally
        {        
            AssetSyncStatusData.InsertAssetSyncStatus(asset.Id, syncStatus, syncStatusMsgtype);

            if(syncStatusMsgtype == AssetSyncMsgTypeEnum.Success)
            {
                update asset;
            }           
        }       
           
    }

    public void UpdateLicence(Asset asset)
    {
    
        HttpRequest request     = new HttpRequest();
        HttpResponse response   = new HttpResponse();

        AssetSyncMsgTypeEnum syncStatusMsgtype = AssetSyncMsgTypeEnum.Success;
        String syncStatus = 'Licence synchronised successfully';

        try
        {
            
            assetValidator.ValidateForUpdate(asset);


            request     = GenerateRequest(asset );
            response    = new HttpResponse();       
            

            request.setMethod('PUT');
            response    = CallLicenceService(request);

            //Set PppLearning LicenecId
            if (asset.C3_Id__c == null)
            {
                asset.C3_Id__c = Integer.valueOf(response.getBody());               
            }

             if(asset.AvoidTriggerExecution__c == null)
            asset.AvoidTriggerExecution__c=0;
            
            asset.AvoidTriggerExecution__c = asset.AvoidTriggerExecution__c + 1;           


        }       
        catch(AuthorizationException ex)        
        {
            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());
            
            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            throw ex;
        }

        catch(ValidationException ex)       
        {
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());
            
            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, false, false, null, null);

            throw ex;
        }              
        catch(ConflictException ex)       
        {           
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());   

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;           

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, false, false, null, null);

            throw ex;
        }
        catch(IntegrationException ex)       
        {            
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());              

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            throw ex;
        }
        catch(ServiceValidationException ex)       
        {           
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());   

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;           

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            throw ex;
        }
        catch(Exception ex)     
        {            
            
            syncStatus = 'Failed, ' + ex.getMessage();
            System.debug(Logginglevel.ERROR, ex.getMessage());              

            syncStatusMsgtype = AssetSyncMsgTypeEnum.Error;

            ExceptionLogData.InsertExceptionlog(asset.Id, LoggingLevel.ERROR, 'Licence', ex, true, false, null, null);

            throw ex;
        }

        finally
        {
           AssetSyncStatusData.InsertAssetSyncStatus(asset.Id, syncStatus, syncStatusMsgtype);
        }       
       
    }

    public void UpsertLicence(Asset asset)
    {
        
        if(asset.C3_Id__c == null || asset.C3_Id__c <= 0)
        {
            CreateLicence(asset);
        }
        
        if (asset.Status == 'Provisioned' ||  asset.Status == 'Cancelled'||  asset.Status == 'Lost')
        {
            UpdateLicence(asset);
        }       
    }

    

    private HttpRequest GenerateRequest(Asset asset){

        HttpRequest request = new HttpRequest();

        String requestBody = SerializeRequestBody(asset);    

        if(this.ServiceEndPoint != null)    
        {   
            String authToken = authenticationService.authenticate();
            
            PppLearningRequestExtender.SetHeader(request, authToken);
            PppLearningRequestExtender.SetTimeout(request);
            
            request.setEndpoint(this.ServiceEndPoint);          
            request.setBody(requestBody);
        }
      
       return request;
    }
    @TestVisible
    private HttpResponse CallLicenceService(HttpRequest request){
        
        HttpResponse response = new HttpResponse();

        if (!Test.isRunningTest())
        {           
            response = new HTTPCallOut().sendRequest(request);              
        }

        PppLearningResponseExtender.ValidateResponse(response);             
         
        return response;
    }  

    @TestVisible
    private static String SerializeRequestBody(Asset asset){  

        AssetYearGLicenseWrapper licenceProxy   = new AssetYearGLicenseWrapper();
        LicenceProxyBuilder builder             = new LicenceProxyBuilder();

        licenceProxy = builder.GeneratePppLearningLicenceProxy(asset);        
        return JSON.serialize(licenceProxy);
    } 

}