@isTest
public with sharing class TierdDiscount_Test {
	
	 @testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    }
	
 @isTest
	static void GetTierdDiscount_AU_10Licences_NoDiscount()
	{
		Integer quantity=10;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(0, model.discountAmount);  		
		System.assertEquals(0, model.discountPercentage);     	
	}

 @isTest
	static void GetTierdDiscount_AU_75Licences_NoDiscount()
	{
		Integer quantity=75;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(0, model.discountAmount);  		
		System.assertEquals(0, model.discountPercentage);     	
	}

	 @isTest
	static void GetTierdDiscount_AU_100Licences_3Dot75PercentDiscount()
	{
		Integer quantity=100;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(3.75, model.discountAmount,'discount Amount');  		
		System.assertEquals(3.75, model.discountPercentage,'discountPercentage');     	
	}

	 @isTest
	static void GetTierdDiscount_AU_200Licences_10Dot625PercentDiscount()
	{
		Integer quantity=200;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(21.25, model.discountAmount,'discount Amount');  		
		System.assertEquals(10.625, model.discountPercentage,'discountPercentage');     	
	}

	 @isTest
	static void GetTierdDiscount_AU_400Licences_22Dot8128PercentDiscount()
	{
		Integer quantity=400;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(91.25, model.discountAmount,'discount Amount');  		
		System.assertEquals(22.8125, model.discountPercentage,'discountPercentage');     	
	}

	 @isTest
	static void GetTierdDiscount_NZ_400Licences_22Dot8128PercentDiscount()
	{
		Integer quantity=400;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(91.25, model.discountAmount,'discount Amount');  		 
		System.assertEquals(22.8125, model.discountPercentage,'discountPercentage');     	
	} 

	

	 @isTest
	static void GetTierdDiscount_AU_3010Licences_35Dot61PercentDiscount()
	{
		Integer quantity=3000;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);

		System.assertEquals(1491.25, model.discountAmount,'discount Amount');  		
		System.assertEquals(49.7083333333333333333333333333333, model.discountPercentage,'discountPercentage');     	
	}

	 @isTest
	static void GetTierdDiscount_AU_5000Licences_58Dot5522PercentDiscount()
	{
		Integer quantity=5000;
		TierdDiscount tieredDiscount = new TierdDiscount();
		tieredDiscount.SetCode('Q01');
		tieredDiscount.Initialise(quantity);
		DiscountedPriceModel model = tieredDiscount.GetDiscount(quantity);


		System.assertEquals(2691.25, model.discountAmount,'discount Amount');  		
		System.assertEquals(53.825, model.discountPercentage,'discountPercentage');     	
	}
}