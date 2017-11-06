public  class PriceCalculator {
	 
  	String territory;
	 String country;
	 DiscountManager discountManager;
	 Map<string, IDiscount> discountTiers;
	
	public PriceCalculator()
	 {		
		 discountManager = new DiscountManager();
	 }

	 	
	 public void SetDiscountTiers(string territory, string countryCode, string pricebookName, string productFamily)
	 {
		 try{
		 this.territory=territory;
		 country= countryCode;
		 discountTiers = discountManager.GetDiscountTiers(territory, countryCode, pricebookName, productFamily);
		 }catch(Exception ex)
		 {
			 system.debug(loggingLevel.Error, ex);
		 }
		 
	 }
	
	public AdvancedPriceModel GetPrice(decimal initialPrice , integer quantity , integer term, boolean isPaymentUpfront, string decile,   String schoolCategory)
	{
		system.debug('initialPrice:' + initialPrice);
		system.debug('quantity:' + quantity);
		system.debug('term:' + term);
		system.debug('isPaymentUpfront:' + isPaymentUpfront); 
		system.debug('decile:' + decile);

		if(decile == null)
		{
			decile = '-1';
		}

		system.debug('schoolCategory:' + schoolCategory);

		AdvancedPriceModel advancedPriceModel = new AdvancedPriceModel();
		advancedPriceModel.InitialUnitPrice = initialPrice;
		if(initialPrice==null || initialPrice==0)
		{
			system.debug('initialPrice is null or 0');
			advancedPriceModel.InitialUnitPrice= 0;
			return advancedPriceModel;
		}

		if(isPaymentUpfront == true)
		{
			advancedPriceModel.InitialAmount =  initialPrice * quantity * term;
			
		}
		else
		{
			advancedPriceModel.InitialAmount =  initialPrice * quantity ;
			
		}	

		if(discountTiers== null || discountTiers.size()==0)
		{
			system.debug('Discount Tiers is empty or null');

			return advancedPriceModel;
		}
		discountManager.InitialingDiscountTiers(discountTiers, term, isPaymentUpfront, quantity, integer.valueOf( decile), schoolCategory);

		Map<Integer, DiscountedPriceModel> discountedAmounts = discountManager.Calculate(discountTiers, advancedPriceModel.InitialAmount);

		system.debug('discountedAmounts.size:'+ discountedAmounts.size());

		if(discountedAmounts.size()>0)
		{
			advancedPriceModel.Discounts = 	discountedAmounts.values();
		}

		decimal finalAmount;
		decimal finalDiscountAmount;

		finalAmount = advancedPriceModel.InitialAmount;
		
		advancedPriceModel.FinalAmountExcludeTax = advancedPriceModel.InitialAmount;
		finalDiscountAmount = 0;

		if(discountedAmounts.size()>0)
		{
			finalAmount = discountedAmounts.get(discountedAmounts.size()).Amount;
			finalDiscountAmount = discountedAmounts.get(discountedAmounts.size()).discountAmount;

			advancedPriceModel.FinalAmountExcludeTax = finalAmount; // (finalAmount - finalDiscountAmount) ;
		}

		
		advancedPriceModel.UnitPriceExcludeTax 	= advancedPriceModel.FinalAmountExcludeTax / quantity;
		advancedPriceModel.AnualUnitPrice 		= advancedPriceModel.UnitPriceExcludeTax;
		
		if(isPaymentUpfront == true && term > 0)
		{
			advancedPriceModel.AnualUnitPrice =  advancedPriceModel.AnualUnitPrice / term;
			
		}

		advancedPriceModel.AnualUnitPrice =advancedPriceModel.AnualUnitPrice .setScale(2);
		
		TaxCalculator taxCalculator 			= new TaxCalculator(territory, country);
		
		//advancedPriceModel.MonthlyUnitPrice			= advancedPriceModel.AnualUnitPrice / 12;
		// advancedPriceModel.MonthlyUnitPrice 		= advancedPriceModel.MonthlyUnitPrice;
	
		TaxModel tax = taxCalculator.GetTax(advancedPriceModel.FinalAmountExcludeTax);
 
		advancedPriceModel.TaxAmount 				= tax.amount.SetScale(2); 
		advancedPriceModel.TaxRate 					= tax.TaxRate;
		advancedPriceModel.FinalAmountIncludeTax 	= (advancedPriceModel.FinalAmountExcludeTax + advancedPriceModel.TaxAmount).setScale(2);
		advancedPriceModel.UnitPriceIncludeTax 		= (advancedPriceModel.FinalAmountIncludeTax / quantity).setScale(2) ; 
		advancedPriceModel.FinalAmountExcludeTax 	= advancedPriceModel.FinalAmountExcludeTax.setScale(2);
		advancedPriceModel.UnitPriceExcludeTax      = advancedPriceModel.UnitPriceExcludeTax.setScale(2);
		
		return advancedPriceModel;
	}
}