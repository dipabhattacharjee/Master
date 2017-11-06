public with sharing class AdvancedPriceModel {
	
	public decimal InitialAmount {get; set;}
	public decimal InitialUnitPrice {get; set;}


	public decimal FinalAmountIncludeTax {get; set;}
	public decimal FinalAmountExcludeTax {get; set;}

	public decimal AnualUnitPrice {get; set;}
	public decimal MonthlyUnitPrice {get{
		return  (AnualUnitPrice/12).setScale(2);
	}}
	

	public decimal discountAmount {get {
		decimal temp=0;
		
		if(Discounts == null || Discounts.size()==0)
		{
			return 0;
		}

		for(DiscountedPriceModel discountModel : Discounts)
		{	
			if(discountModel.isDiscountVisible)
			temp=temp+discountModel.discountAmount;
		}

		return temp.setScale(2);
	}}

	public decimal discountPercentage {get {
		decimal temp=0;
		
		if(Discounts == null || Discounts.size()==0)
		{
			return 0;
		}

		for(DiscountedPriceModel discountModel : Discounts)
		{	
			if(discountModel.isDiscountVisible)
			temp=temp+discountModel.discountPercentage;
		}

		return temp;
	}}

	public decimal TaxAmount {get; set;}

	public decimal UnitPriceExcludeTax {get;set;}
	public decimal UnitPriceIncludeTax {get;set;}
	public decimal TaxRate {get;set;}

	public List<DiscountedPriceModel> Discounts {get; set;}
	public DiscountedPriceModel getDiscount(DiscountType discountType)
	{
		
		for(DiscountedPriceModel item : Discounts)
		{
			
			if(discountType == item.discountType)
			{
				
				return  item;
			}
		}
		return new DiscountedPriceModel();
	}
	public AdvancedPriceModel()
	{
		Discounts 	= new 	List<DiscountedPriceModel>();
		AnualUnitPrice = 0;
		
	}
}