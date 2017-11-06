@isTest
private class CountryDiscount_Test
{
	 @testSetup static void setup()
    {
        FakeObjectFactory.testclasssetup();
    }
 
	
	@isTest
	static void GetCountry_PassingNull_As_DiscountCode_ThrowValidationException()
	{
			    
      try{
       	CountryDiscount countryDiscount = new CountryDiscount();
		countryDiscount.SetCode(null);
       
	    }catch(ValidationException e){
          System.assertEquals('Code cannont be null or empty', e.getMessage());
        }      
	}


	@isTest
	static void GetCountryDiscount_AU_DiscountShouldBe30Percent()
	{
		//DiscountedPriceModel model = new CountryDiscount('C01').GetDiscount(10);

		CountryDiscount countryDiscount = new CountryDiscount();
		countryDiscount.SetCode('C01');
		countryDiscount.Initialise();
		DiscountedPriceModel model = countryDiscount.getDiscount(10);

		System.assertEquals(3.092, model.discountAmount);  		
		System.assertEquals(30.92, model.discountPercentage);     	
	}

	
}