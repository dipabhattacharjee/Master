public with sharing class CountryDiscount implements IDiscount{
	
	 decimal discountPercentage {get; set;}
	 boolean isVisible {get; set;}
	 boolean isAvailable {get; set;}
	 string code;
	List<Country_Discount__mdt> countryDiscountList;
	
	public CountryDiscount() {

		isVisible = false;
		 countryDiscountList = [select  Discount__c,Code__c
															 from Country_Discount__mdt
															 Where 
															 IsActive__c 	= true ];

	}

	public CountryDiscount(string code) {

		isVisible = false;
		this.code = code;
		
		 countryDiscountList = [select  Discount__c,Code__c
															 from Country_Discount__mdt
															 Where 
															 IsActive__c 	= true 
															  ];

	
		
	

	}

	public void SetCode(String code)
	{
		if(code=='' || code == null)
		{
			throw new ValidationException('Code cannont be null or empty');
		}

		
		this.code = code;
	}

	public void Initialise()
	{
		
		if(countryDiscountList == null || countryDiscountList.size() == 0)
		{ 
			isAvailable = false;
			system.debug(Logginglevel.ERROR, 'CountryDiscount code:'+code +' is not available');
			return;
		}	

		for(Country_Discount__mdt item : countryDiscountList)
		{
			if(item.Code__c == code)
			{
				discountPercentage 	= item.Discount__c;
				system.debug('Setting Country Discount Percentage:' + discountPercentage );
				isAvailable = true;
				break;
			}
		}

		
	}


	public DiscountedPriceModel GetDiscount(decimal amount)
	{
		DiscountedPriceModel model 	= new 	DiscountedPriceModel();
		model.name 					= 'Country Discount - '+ code ;
		model.discountType 			= DiscountType.Country; 
		model.amount 	= amount;

		if(isAvailable == true)
		{
			model.discountPercentage 	= discountPercentage;
			if(discountPercentage == 0)
			{
				model.discountAmount 		= 0;
				model.isDiscountAvailable 	= false;
			}
			else {
				model.discountAmount 		= amount * discountPercentage/100;
				model.isDiscountAvailable 	= true;
			}
			model.isDiscountVisible 		= isVisible;
			model.amount 					= amount - model.discountAmount;

			return model;
		}

		model.isDiscountAvailable = false;
		return model;

		
	}

}