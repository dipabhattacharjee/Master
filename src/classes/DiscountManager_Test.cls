@isTest
public  class DiscountManager_Test {
    
    @isTest
    static void DiscountManager_PassingNullAsTerritory_ThrowValidationException()
    {
        	try{
                 DiscountManager discountManager = new DiscountManager();
                Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers(null,'Country','PricebookName','product');
    		
   		 }catch(ValidationException e){
   		 	System.assertEquals('Territory cannot be null', e.getMessage());
   		 } 
    } 

     @isTest
    static void DiscountManager_PassingNullAsCountry_ThrowValidationException()
    {
        	try{
                DiscountManager discountManager = new DiscountManager();
                 Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers('Territory',null,'PricebookName','product');
    		
    		 
   		 }catch(ValidationException e){
   		 	System.assertEquals('CountryCode cannot be null', e.getMessage());
   		 } 
    } 

     
    @isTest
    static void DiscountManager_PassingNullAsPriceBookName_ThrowValidationException()
    {
        	try{
                DiscountManager discountManager = new DiscountManager();
                 Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers('Territory','Country',null, 'product');
    		
    		 
   		 }catch(ValidationException e){
   		 	System.assertEquals('PricebookName cannot be null', e.getMessage());
   		 } 
    } 

    @isTest
    static void DiscountManager_PassingNullAsProductFamily_ThrowValidationException()
    {
        	try{
                DiscountManager discountManager = new DiscountManager();
                 Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers('Territory','Country','PricebookName',null);
    		
    		 
   		 }catch(ValidationException e){
   		 	System.assertEquals('ProductFamily cannot be null', e.getMessage());
   		 } 
    } 

     @isTest
    static void DiscountManager_PassingNoneExistingTerritoryCountryPricebookProduct_NoDiscountShouldbeReturned()
    {

      DiscountManager discountManager = new DiscountManager();
      Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers('Territory','Country','PricebookName','Product');
      //DiscountManager discountManager = new DiscountManager('Territory','Country','PricebookName','Product');
      discountManager.InitialingDiscountTiers(discountTiers, 1, true, 1, 0, 'public');

      Map<Integer, DiscountedPriceModel> result=  discountManager.CalculateDiscounts(1);

      system.assertEquals(4, result.size());

      for(DiscountedPriceModel item: result.values())
   	 {
        system.assertEquals(false, item.isDiscountAvailable);
     }
    } 

  
    @isTest
    static void DiscountManager_APAC_AU_LowDecilePriceBook_Mathletics_ShouldReturnedTwoDiscountLayer()
    {
    
   List<Pricebook__mdt> pricebooks = [select Id, name__c from Pricebook__mdt where name__c like '%decile%'];
     Pricebook__mdt pricebook= pricebooks[0];

     DiscountManager discountManager = new DiscountManager();
     Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers('APAC','AU',pricebooks[0].name__c ,'Mathletics');

   
    discountManager.InitialingDiscountTiers(discountTiers, 1, false, 1, 1, 'Private'); 
    Map<Integer, DiscountedPriceModel> results=  discountManager.Calculate(discountTiers, 1);   
     
      Integer numberOfAvailableDiscount=0;

      for(DiscountedPriceModel item:results.values())
      {          
          if(item.isDiscountAvailable)
          {
              numberOfAvailableDiscount=numberOfAvailableDiscount+1;
          }

      }

      system.assertEquals(2, numberOfAvailableDiscount);
   		 
    } 

      @isTest
    static void DiscountManager_APAC_AU_WholeSchool_Mathletics_ShouldReturnedTwoDiscountLayer()
    {
  List<Pricebook__mdt> pricebooks = [select Id, name__c from Pricebook__mdt where name__c like '%whole%'];
     Pricebook__mdt pricebook= pricebooks[0];

   
   DiscountManager discountManager = new DiscountManager();
     Map<string, IDiscount> discountTiers=   discountManager.GetDiscountTiers('APAC','AU', pricebooks[0].name__c ,'Mathletics');

     // DiscountManager discountManager = new DiscountManager('APAC','AU', 'Whole School Price','Mathletics');
      discountManager.InitialingDiscountTiers(discountTiers, 1, false, 1, 1, 'Public');

      Map<Integer, DiscountedPriceModel> results=  discountManager.Calculate(discountTiers, 1);   
     
      Integer numberOfAvailableDiscount=0;

      for(DiscountedPriceModel item:results.values())
      {          
          if(item.isDiscountAvailable)
          {
              numberOfAvailableDiscount=numberOfAvailableDiscount+1;
          }

      }

      system.assertEquals(2, numberOfAvailableDiscount);
   		 
    } 

    
    
    
    
}