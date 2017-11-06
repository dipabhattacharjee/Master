public with sharing class ProductSelector {
	public ProductSelector() {
		
	}

	 public Map<Id, Product2> GetProducts()
     {
     	Map<Id, Product2> products =new Map<Id, Product2>([select Id, Family, IsActive,
     														Related_Product__R.Id, Related_Product__C
     														from Product2]);

     	return products;

     }

    public  Product2 GetActiveProduct(Product2  product , Map<Id, Product2> products){ 

    if(product.IsActive)
      return product;

    if(product.Related_Product__C == null)
    {
      System.debug(Logginglevel.WARN, 'ProductId:' + product.Id +' is inactive and doesnt have the related product');
      return null;
    }

    Product2 replacedProduct1 =  products.get(product.Related_Product__R.Id); 

    if(replacedProduct1.IsActive)
      return replacedProduct1;

      if(replacedProduct1.Related_Product__C == null)
    {
      System.debug(Logginglevel.WARN, 'ProductId:' + replacedProduct1.Id +' is inactive and doesnt have the related product, 1st level');
      return null;
    }

    Product2 replacedProduct2 =  products.get(replacedProduct1.Related_Product__R.Id); 

    if(replacedProduct2.IsActive)
      return replacedProduct2;

      if(replacedProduct2.Related_Product__C == null)
    {
      System.debug(Logginglevel.WARN, 'ProductId:' + replacedProduct2.Id +' is inactive and doesnt have the related product, 2nd level');
     
    }

    return null;
    
        
    }
}