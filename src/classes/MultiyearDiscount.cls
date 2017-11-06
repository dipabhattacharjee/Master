public class MultiyearDiscount implements IDiscount {
	
	 decimal discountPercentage {get; set;}
	 boolean isVisible {get; set;}
	 boolean isAvailable {get; set;}

	  String code {get; set;}
	  List<Multiyear_Discount__mdt> multiyearDiscounts;

	public void SetCode(String code)
	{
		if(code=='' || code == null)
		{
			throw new ValidationException('Code cannont be null or empty');
		}

		this.code = code;
	}

	public MultiyearDiscount()
	{
		multiyearDiscounts = [select Discount__c, 	Pay_Upfront__C ,Code__c, Term__c
								from Multiyear_Discount__mdt ];
	}

	public MultiyearDiscount(string code)
	{
		

		this.code = code;
		multiyearDiscounts = [select Discount__c, 	Pay_Upfront__C ,Code__c, Term__c
								from Multiyear_Discount__mdt ];
	}

	public void Initialise(Integer  term, boolean isPaymentUpfront)
	{
		isVisible = true;
		Decimal multiYearDiscount;
		List<Multiyear_Discount__mdt> tempDiscounts = new  List<Multiyear_Discount__mdt>();

		for(Multiyear_Discount__mdt item : multiyearDiscounts)
		{
			system.debug('Multiyear_Discount__mdt : '+item.Code__c +' == ' + code +' && ' + item.Pay_Upfront__c +' == ' + isPaymentUpfront +' && ' + item.Term__c +' == ' + String.ValueOf(term));

			if(item.Code__c == code && item.Pay_Upfront__c == isPaymentUpfront && item.Term__c == String.ValueOf(term))
			{
				tempDiscounts.add(item);
			}
		}		

		if(tempDiscounts == null || tempDiscounts.size() == 0)
		{ 
			isAvailable = false;
			system.debug(Logginglevel.ERROR, 'MultiyearDiscount code:'+code +' is not available');
			return;
		}	

		
		if(tempDiscounts!= null && tempDiscounts.size() > 0){

			discountPercentage = tempDiscounts[0].Discount__c;
			isAvailable=true;		
		}			
	}
	

	 public DiscountedPriceModel GetDiscount(decimal price)
	 {
	 	DiscountedPriceModel model=new 	DiscountedPriceModel();
		model.name = 'Multi year discount - ' + code;
		model.discountType 			= DiscountType.Multiyear; 
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