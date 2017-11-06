@isTest
private class SocialEconomicDiscount_Test
{
	 @testSetup static void setup()
    {
        FakeObjectFactory.testclasssetup();
    }

	@isTest
	static void GetDiscount_PassingNull_As_DiscountCode_ThrowValidationException()
	{
			    
      try{
       	SocialEconomicDiscount discount = new SocialEconomicDiscount();
		discount.SetCode(null);
       
	    }catch(ValidationException e){
          System.assertEquals('Code cannont be null or empty', e.getMessage());
        }      
	}

	@isTest
	static void SocialEconomicDiscount_LowDecile_AU_ShouldReturn37Dot5PercentDiscount()
	{   	 	
    	
    	SocialEconomicDiscount socialEconomicDiscount 	= new SocialEconomicDiscount();
		socialEconomicDiscount.SetCode('S01');		
		socialEconomicDiscount.Initialise(1);

    	DiscountedPriceModel model =socialEconomicDiscount.GetDiscount(10);

    	System.assertEquals(3.75, model.discountAmount);  		
		System.assertEquals(37.5,model.discountPercentage);    
	}

	@isTest
	static void SocialEconomicDiscount_NormalDecile_AU_ShouldReturnNoDiscount()
	{   	 	
    	
    	SocialEconomicDiscount socialEconomicDiscount 	= new SocialEconomicDiscount();
		socialEconomicDiscount.SetCode('S01');	
		socialEconomicDiscount.Initialise(1000);

    	DiscountedPriceModel model =socialEconomicDiscount.GetDiscount(10);

    	System.assertEquals(0, model.discountAmount);  		
		System.assertEquals(0,model.discountPercentage);    
	}

	
}