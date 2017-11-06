/**
 * @author- Vishnu Belkone
 * @Description This class schedular to schedul priceboockupdater batch.
 * @Test Class:    PriceBookUpdateSchedular_Test
 * @History: 
	15/09/2015 created.
 */
global class PriceBookUpdateSchedular implements Schedulable{
    global void execute(SchedulableContext sc) {
        String priceBoockQuery = 'select id,Name,Start_Date__c,IsActive,End_Date__c from Pricebook2';
        Database.executeBatch(new StatelessBatchExecutor(new PriceBookUpdater(),priceBoockQuery,null),200);
    }
}