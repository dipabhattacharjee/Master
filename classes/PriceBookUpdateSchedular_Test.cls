@isTest
public class PriceBookUpdateSchedular_Test {
	public static testMethod void testPriceBookSchedule(){
		Test.StartTest();
			PriceBookUpdateSchedular schedular = new PriceBookUpdateSchedular();
			String sch = '0 0 23 * * ?';
			system.schedule('Test priceBook Update schedular', sch, schedular);
		Test.stopTest();
	}
}