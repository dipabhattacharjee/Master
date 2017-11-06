@isTest
private class MultiyearDiscount_Test
{
	@isTest
	static void GetDiscount_PassingNull_As_DiscountCode_ThrowValidationException()
	{
			    
      try{
       	MultiyearDiscount discount = new MultiyearDiscount();
		discount.SetCode(null);
       
	    }catch(ValidationException e){
          System.assertEquals('Code cannont be null or empty', e.getMessage());
        }      
	}

	@isTest
	static void GetDiscount_1TermAndUPfrontPayment_NoDiscount()
	{
		//MultiyearDiscount multiyearDiscount = new MultiyearDiscount(1, true, 'Mathletics', 'Standard').GetDiscount(10);

		MultiyearDiscount multiyearDiscount = new MultiyearDiscount();
		multiyearDiscount.SetCode('M01');
		multiyearDiscount.Initialise(1, true);
		DiscountedPriceModel model = multiyearDiscount.getDiscount(10);

		System.assertEquals(0, model.discountAmount);  		
		System.assertEquals(0, model.discountPercentage);     	 
	}

	@isTest
	static void GetDiscount_2TermAndUpfrontPayment_5PercentDiscountShouldBeAvailable()
	{
		
		MultiyearDiscount multiyearDiscount = new MultiyearDiscount();
		multiyearDiscount.SetCode('M01');
		multiyearDiscount.Initialise(2, true);
		DiscountedPriceModel model = multiyearDiscount.getDiscount(10);

		System.assertEquals(0.5, model.discountAmount);  		
		System.assertEquals(5, model.discountPercentage);     	
	}

	@isTest
	static void GetDiscount_3TermAndYearlyPayment_10PercentDiscountShouldBeAvailable()
	{
		MultiyearDiscount multiyearDiscount = new MultiyearDiscount();
		multiyearDiscount.SetCode('M01');
		multiyearDiscount.Initialise(3, false);
		DiscountedPriceModel model = multiyearDiscount.getDiscount(10);

		System.assertEquals(0.25, model.discountAmount);  		
		System.assertEquals(2.5, model.discountPercentage);     	
	}
}