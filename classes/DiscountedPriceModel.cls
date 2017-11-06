public class DiscountedPriceModel
{
	public decimal discountAmount {get; set;}
	public decimal amount {get; set;}
	public decimal discountPercentage {get; set;}
	public boolean isDiscountAvailable {get; set;}
	//indicate if discount should be visible on invoice and to customers
	public boolean isDiscountVisible {get; set;}

	public string name {get;set;}

	public DiscountType discountType{get; set;}

	public DiscountedPriceModel()
	{
		amount 					= 0;
		discountAmount 			= 0;
		discountPercentage 		= 0;
		isDiscountAvailable 	= false;
		isDiscountVisible 		= false;
	}
}