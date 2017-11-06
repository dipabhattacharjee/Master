@isTest
public class PriceBookUpdater_Test {
	public static testMethod void testPriceBookUpdater(){
		List<Pricebook2>priceBookList = new List<Pricebook2>();
		priceBookList = [select Id,name,Start_Date__c,End_Date__c,IsActive from Pricebook2];
		PriceBookUpdater priceUpdate = new PriceBookUpdater();
		priceUpdate.execute(priceBookList);
		System.assertEquals(priceUpdate.updatePriceBooks(priceBookList),2);
		priceUpdate.finish();
	}

	@testSetup static void getPriceBooks(){
		Pricebook2 priceBook = new Pricebook2();
		Pricebook2 priceBookTest = new Pricebook2();
		List<Pricebook2>priceBookList = new List<Pricebook2>();
		priceBookTest.Start_Date__c = System.today().addDays(-1);
		priceBookTest.End_Date__c = System.today().addDays(-1);
		priceBookTest.Name = 'priceBook2';

		priceBook.Start_Date__c = System.today();
		priceBook.End_Date__c = System.today().addDays(1);
		priceBook.Name = 'testPrice';
		insert priceBook;
		insert priceBookTest;
		priceBookList.add(priceBook);
		priceBookList.add(priceBookTest);
		//return priceBookList;
	}
}