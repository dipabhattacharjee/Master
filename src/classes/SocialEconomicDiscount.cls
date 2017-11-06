public with sharing class SocialEconomicDiscount implements IDiscount{
	
	 decimal discountPercentage {get; set;}
	 boolean isVisible {get; set;}
	 boolean isAvailable {get; set;}
	 string name {get;set;}
  	 String code {get; set;}
	 List<Social_Economic_Discount__mdt> discountTypeList;


	public SocialEconomicDiscount()
	{		
		discountTypeList = [Select Id,	DiscountDescription__c,MasterLabel,Code__c,
													IsActive__c,DiscountPercentage__c,DecileHighRange__c,
													DecileLowRange__c from Social_Economic_Discount__mdt];
	}

	public SocialEconomicDiscount(String code)
	{
		this.code = code;
		discountTypeList = [Select Id,	DiscountDescription__c,MasterLabel,Code__c,
													IsActive__c,DiscountPercentage__c,DecileHighRange__c,
													DecileLowRange__c from Social_Economic_Discount__mdt];
	}

	public void SetCode(String code)
	{
		if(code=='' || code == null)
		{
			throw new ValidationException('Code cannont be null or empty');
		}
		
		this.code = code;
	}


	public void Initialise(integer decile)
	{
		isVisible = false;
		decimal range;
		if(decile != null){
			range = Decimal.valueOf(decile); 
		}else{
			range = 0;
		}

		List<Social_Economic_Discount__mdt> tempDiscount = new List<Social_Economic_Discount__mdt>();

		for(Social_Economic_Discount__mdt item : discountTypeList)
		{
			if(item.code__c == code && item.DecileLowRange__c <= range &&  item.DecileHighRange__c  >= range)
			{
				tempDiscount.add(item);
			}
		}
	
		if(tempDiscount == null || tempDiscount.size() == 0)
		{ 
			isAvailable = false;
			system.debug(Logginglevel.ERROR, 'SocialEconomicDiscount code:'+code +' is not available');
			return;
		}
		System.debug('This is an selected discountTypeList' + tempDiscount);

		if(tempDiscount.size() > 0){
			discountPercentage  	= tempDiscount[0].DiscountPercentage__c;
			isAvailable 			= true;
			name 					= tempDiscount[0].MasterLabel;
		}	
	}

	public DiscountedPriceModel GetDiscount(decimal price)
    {
	 	DiscountedPriceModel model=new 	DiscountedPriceModel();
		model.name='Social Economic Discount - ' + code;
		if(name!=null)
		{
			model.name=model.name + ' - ' + name;
		}
		model.amount = price;
	 	if(isAvailable == true)
		{
			model.discountPercentage 	= discountPercentage;
			if(discountPercentage == 0)
			{
				model.discountAmount 		= 0;
				model.isDiscountAvailable 	= false;
			}
			else {
				model.discountAmount 		= price*discountPercentage/100;
				
				model.isDiscountAvailable 	= true;
			}
			model.isDiscountVisible 	= isVisible;
			
			model.amount = price - model.discountAmount;
			return model;
		}

		model.isDiscountAvailable=false;
		return model;

	 }
}