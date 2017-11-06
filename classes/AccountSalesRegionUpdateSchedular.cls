/**
 * @author- Harry Alderman
 * @Description This class schedular to schedul UpdateAccountSalesRegion batch.
 * @Test Class:    
 * @History: 
    22/04/2016 created.
 */

global class AccountSalesRegionUpdateSchedular implements Schedulable{    
    
    global void execute(SchedulableContext sc) {
        String AccountQuery = 'SELECT Id, Sales_Region__c  FROM Account WHERE Id IN (SELECT ObjectId FROM ObjectTerritory2Association WHERE LastModifiedDate>YESTERDAY AND ASSOCIATIONCAUSE=\'Territory2AssignmentRule\')';
        Database.executeBatch(new StatelessBatchExecutor(new UpdateAccountSalesRegion(),AccountQuery,null),200);
    }
}