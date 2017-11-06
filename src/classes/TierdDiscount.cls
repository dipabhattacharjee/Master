public  class TierdDiscount implements IDiscount {

	decimal discountPercentage {get; set;}
 	boolean isVisible {get; set;}
 	boolean isAvailable {get; set;}
	integer quantity {get; set;} 
	String code {get; set;}
	List<Tiered_Discount__mdt> tierdDiscountList;

	public TierdDiscount()
	{
		tierdDiscountList=[select Discount__c,Low_Tiered__c,High_Tiered__c ,Code__c
														from Tiered_Discount__mdt order by Code__c,Low_Tiered__c ];
		

	}

	public TierdDiscount(String code)
	{
		tierdDiscountList=[select Discount__c,Low_Tiered__c,High_Tiered__c ,Code__c
														from Tiered_Discount__mdt order by Code__c,Low_Tiered__c ];
		this.code = code;

	}

	public void SetCode(String code)
	{
		if(code=='' || code == null)
		{
			throw new ValidationException('Code cannont be null or empty');
		}

		this.code = code;
	}


	public void Initialise( integer quantity)
	{
		isVisible= true;
		
		if(quantity <= 0)										
		{
			isAvailable=false;
			system.debug(Logginglevel.WARN, 'code:'+code +' is not available');
			return;
		}

		integer remainingQuantity=quantity;
	
		List<Tiered_Discount__mdt> tempDiscount = new List<Tiered_Discount__mdt>();
		for(Tiered_Discount__mdt item : tierdDiscountList)
		{
			if(item.code__c == code)
			{
				tempDiscount.add(item);
			}
		}

		decimal discounted_amount = 0;
		decimal total_price=0;
		integer last_High_Tierd = 0;

		total_price = quantity ;

		for(Tiered_Discount__mdt TierdDiscount : tempDiscount)
		{
			system.debug(quantity+'***DiscountPercentage:'+TierdDiscount.Discount__c +', Low_Tiered__c:'+
						  TierdDiscount.Low_Tiered__c + ', High_Tiered__c:'+TierdDiscount.High_Tiered__c);

			if(last_High_Tierd + remainingQuantity >= TierdDiscount.Low_Tiered__c &&
			   last_High_Tierd + remainingQuantity <= TierdDiscount.High_Tiered__c)
			{
				system.debug('last_High_Tierd '+last_High_Tierd+'+ remainingQuantity:'+remainingQuantity+' >= Low_Tiered__c:'+TierdDiscount.Low_Tiered__c);
				discounted_amount = discounted_amount + GetDiscount(remainingQuantity, TierdDiscount.Discount__c);                  
				system.debug('between-discounted_amount:'+ discounted_amount);

                break;
			}

			if((TierdDiscount.High_Tiered__c == null || TierdDiscount.High_Tiered__c == 0) && last_High_Tierd + remainingQuantity > TierdDiscount.Low_Tiered__c - 1)
			{
					system.debug('*** lastest High_Tierd:'+last_High_Tierd+'+remainingQuantity:'+remainingQuantity+' > TierdDiscount.Low_Tiered__c:' + TierdDiscount.Low_Tiered__c);
					
					
					integer range = Integer.valueOf(last_High_Tierd + remainingQuantity - ( TierdDiscount.Low_Tiered__c -1 )  ) ;
					discounted_amount = discounted_amount + GetDiscount(range  , TierdDiscount.Discount__c);
					system.debug('*** lastest discounted_amount:'+ discounted_amount + ' ,range:'+ range);
					break;
			}

			if(last_High_Tierd + remainingQuantity > TierdDiscount.High_Tiered__c)
			{
				system.debug('last_High_Tierd:'+last_High_Tierd+'+remainingQuantity:'+remainingQuantity+' > TierdDiscount.High_Tiered__c:' + TierdDiscount.High_Tiered__c);

				Integer low_Tiered = Integer.valueOf(TierdDiscount.Low_Tiered__c);

				if(low_Tiered>0) 
				{
					low_Tiered = low_Tiered-1;
				}

				integer range = Integer.valueOf(TierdDiscount.High_Tiered__c -  low_Tiered ) ;
                discounted_amount = discounted_amount + GetDiscount(range , TierdDiscount.Discount__c);
				system.debug('Higher-discounted_amount:'+ discounted_amount+ ' ,range:'+ range);
				last_High_Tierd =  Integer.valueOf(TierdDiscount.High_Tiered__c);
				system.debug('last_High_Tierd:'+ last_High_Tierd);

				if (remainingQuantity - range > 0)
					remainingQuantity = remainingQuantity - range;

				system.debug('-remainingQuantity:'+ remainingQuantity);

			}			
		}

		if(discounted_amount == 0)
               {
				   	discountPercentage = 0;
					isAvailable=false;
			   }  

            else
                {
					discountPercentage = discounted_amount * 100 / quantity;
					isAvailable=true;
				}
		
		system.debug('DiscountPercentage:'+ discountPercentage);
	}

	 public DiscountedPriceModel GetDiscount(decimal price)
	 {
	 	DiscountedPriceModel model=new 	DiscountedPriceModel();
		model.name 			= 'Tiered Discount - ' + code;
		model.discountType 	= DiscountType.Quantity;
		model.amount 		= price;
		model.isDiscountVisible 	= isVisible;

	 	if(isAvailable == true)
		{
			model.discountPercentage 	= discountPercentage;
			system.debug('GetDiscount-DiscountPercentage:'+ model.discountPercentage );

			if(discountPercentage == 0)
			{
				model.discountAmount 		= 0;
				model.isDiscountAvailable 	= false;
			}
			else {
				model.discountAmount 		= price*discountPercentage/100;
				model.isDiscountAvailable 	= true;
			}
			
			system.debug('GetDiscount-discountAmount:'+ model.discountAmount);
		
			model.amount = price - model.discountAmount;

			return model;
		}

		model.isDiscountAvailable=false;
		return model;

	 }

	 private  decimal GetDiscount(decimal quantity, decimal discountPercentage)
        {
           
            if (discountPercentage == 0 || quantity==0)
            {
                return 0;
            }  

            return  quantity * discountPercentage / 100;
        }

	
}