public  class SchoolExcessLicensingBatch implements StatelessBatchExecutor.CustomBatchable{
	
	List<Excess_Licensing__c> excessLIcensing_configurations;

	public void execute(List<Excess_Licensing__c> configurations ){    

		excessLIcensing_configurations = configurations;

        SchoolExcessLicensingBatch(configurations);   

    }

	public Void SchoolExcessLicensingBatch(List<Excess_Licensing__c> configurations ){
		
		SchoolExcessLicensingProcessor schoolExcessLicensingProcessor = new SchoolExcessLicensingProcessor();
		EmailApi emailApi 	= new EmailApi();

		ServicesErrorLogs serviceErrorLog = new ServicesErrorLogs();

		for(Excess_Licensing__c config : configurations)
		{
			system.debug('Excess_Licensing__c: data '+config);

			try {
					//If we are in the exclusion period , this process doesnt need to run
					if(system.today() >=  config.Exclusion_Start__c &&
					   	 system.today() <=  config.Exclusion_End__c	)
					{
						system.debug('Auto Excess licensing for ' + config.Territory__c +' wont run because its excluded in exlusion date period, Id:' + config.Id );
						emailApi.SendEmail(	serviceErrorLog.getDevelopersEmail(),	'Wont execute Current Batch because its excluded ',  'Auto Excess licensing for ' + config.Territory__c +' Wont execute because its excluded in exlusion date period, Id:' + config.Id );
						
						continue;
						
					}					

					system.debug('Start processing excess licensing for ' + config.Territory__c);	

					schoolExcessLicensingProcessor.SchoolExcessLicensingProcessor(config);				

			} catch(Exception e) {
				
				String body = '<br>' + e.getMessage() +'</br>' ;
				body = body + '<br>' + e.getStackTraceString() +'</br>' ;
				emailApi.SendEmail(	serviceErrorLog.getDevelopersEmail(),	'Failed processing of Excess licensing Batch Job',  body);
			}
			
		}
	}

	public void finish(){

		EmailApi emailApi 	= new EmailApi();
		ServicesErrorLogs serviceErrorLog = new ServicesErrorLogs();
		/*String body ='';

		for(Excess_Licensing__c excess_Licensing : excessLIcensing_configurations)
		{
			body= body + '<br>'+ excess_Licensing.Territory__c +'</br>';			
		}
*/
		emailApi.SendEmail(	serviceErrorLog.getDevelopersEmail(),	'Finished processing of Excess licensing Batch Job', '' );
	}

	
}