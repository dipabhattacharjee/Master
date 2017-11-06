public interface IDiscount {

	 DiscountedPriceModel GetDiscount(decimal price);

	 void SetCode(String code);
}