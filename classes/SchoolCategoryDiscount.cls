public  class SchoolCategoryDiscount implements IDiscount{
	
	 decimal discountPercentage {get; set;}
	 boolean isVisible {get; set;}
	 boolean isAvailable {get; set;}
	 String code;
	 List<School_Category_Discount__mdt> discountList ;
	
	public SchoolCategoryDiscount() {
        
		isVisible = false;
		 discountList = [select Discount__c,Code__c,School_category__R.Name__c 
															 from School_Category_Discount__mdt];

	}


	public SchoolCategoryDiscount(string code) {
        
        this.code = code; 
		isVisible = false;		

	}

	public void SetCode(string code)
	{
		if(code=='' || code == null)
		{
			throw new ValidationException('Code cannont be null or empty');
		}
		
		this.code = code;
	}
    public void Initialise(String schoolCategory)
    {
		List<School_Category_Discount__mdt> tempList = new List<School_Category_Discount__mdt>();

		for(School_Category_Discount__mdt item : discountList)
		{
			if(item.Code__c == code && item.School_category__R.Name__c == schoolCategory)
			{
				tempList.add(item);
			}
		}
      

		if(tempList == null || tempList.size() == 0)
		{ 
			isAvailable = false;
			system.debug(Logginglevel.ERROR, 'SchoolCategory Discount code:'+code +' is not available');
			return;
		}	
		
		discountPercentage 	= tempList[0].Discount__c;
		system.debug('Setting SchoolCategory Discount Percentage:' + discountPercentage );
		isAvailable = true;
    }

    
	public DiscountedPriceModel GetDiscount(decimal amount)
	{
		DiscountedPriceModel model=new 	DiscountedPriceModel();
		model.name 		='School Category Discount - ' + code;
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