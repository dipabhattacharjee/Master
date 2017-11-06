/*
 * @author- Amit Shirude
 * @Description This class schedular to schedul UpdateLicenceStatus batch.
 * @Test Class:    SchoolUpdateSchedular_Test
 * @History: 
    22/04/2016 created.
 */

global class SchoolUpdateSchedular implements Schedulable{    
    
    global void execute(SchedulableContext sc) {
        String SchoolQuery = 'SELECT Id, Status__c, LastModifieddate FROM Account';
        Database.executeBatch(new StatelessBatchExecutor(new BatchUpdateSchoolStatus(),SchoolQuery,null),200);
    }

}