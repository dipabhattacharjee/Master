global class SchoolExcessLicensingSchedular implements Schedulable{
	
	 global void execute(SchedulableContext sc) {

	 	 String excessLicensingConfigQuery = 'SELECT '
				 	 						 	+'Id, '
				 	 						 	//+'Global_School_Type__c, '
				 	 						 	+'School_Type__c, '
				 	 						 	+'Ignore_Threshold__c, '
				 	 						 	+'Less_Than_Threshold_Required_Task__c, '
				 	 						 	+'Less_Than_Threshold_Stage__c,'
				 	 						 	+'More_Than_Threshold_Required_Task__c, '
				 	 						 	+'More_Than_Threshold_Stage__c, '
				 	 						 	+'Product_Family__c, '
				 	 						 	+'Territory__c ,'
				 	 						 	+'Threshold__c ,'
				 	 						 	+'Sales_User__c '
				 	 						 	+'FROM '
				 	 						 	+'Excess_Licensing__c '
				 	 						 	+'WHERE '
				 	 						 	+'IsActive__c = true;';

		Integer batchSize = 5;

        Database.executeBatch(new StatelessBatchExecutor(new SchoolExcessLicensingBatch(), excessLicensingConfigQuery, null), batchSize);
	 }


}