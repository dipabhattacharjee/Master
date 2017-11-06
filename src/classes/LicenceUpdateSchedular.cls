/**
 * @author- Amit Shirude
 * @Description This class schedular to schedul UpdateLicenceStatus batch.
 * @Test Class:    LicenceUpdateSchedular_Test
 * @History: 
	22/04/2016 created.
 */

global class LicenceUpdateSchedular implements Schedulable{    
    
    global void execute(SchedulableContext sc) {        
        String LicenceQuery = 'select id,UsageEndDate,Status from Asset where Status IN (\'Expired\',\'Provisioned\') and UsageEndDate < Today and RecordTypeId = \'012280000001tREAAY\'';
        Database.executeBatch(new StatelessBatchExecutor(new UpdateLicenceStatus(),LicenceQuery,null),200);
    }
}