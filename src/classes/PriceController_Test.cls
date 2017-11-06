@isTest
public  class PriceController_Test {
   
   @isTest
   public static void CalculatePrice_CheckInitialAmountShouldBe500()
   {
        PriceController controller= new     PriceController();

        controller.decileValue =    '0';
        controller.unitPrice   =    '50';
        controller.licenecNumberValue =    '10';
        controller.decileValue =    '0';
        controller.decileValue =    '0';
        controller.decileValue =    '0';
        controller.selectedTerritory = 'APAC';
        controller.selectedCountry   = 'Any Country';
        controller.selectedPricebook = 'Decile';
        controller.selectedProduct   = 'Mathletics';
        controller.selectedTerm      = '1';
        controller.selectedSchoolCategory ='';

        controller.Calculate();

        system.assertEquals(500, controller.model.InitialAmount);
        system.assertEquals(0, controller.getDiscounts().size());
        system.assertEquals(0, controller.model.getDiscount(DiscountType.Country).discountAmount);
        system.assertEquals(0, controller.model.discountAmount);
        system.assertEquals(0, controller.model.discountPercentage);
        system.assertEquals(null, controller.model.FinalAmountIncludeTax);
        system.assertEquals(null, controller.model.FinalAmountExcludeTax);
        system.assertEquals(0, controller.model.MonthlyUnitPrice);
        system.assertEquals(null, controller.model.TaxAmount);
        system.assertEquals(null, controller.model.UnitPriceExcludeTax);
        system.assertEquals(null, controller.model.TaxRate);

  }

   @isTest
   public static void CalculatePrice_FinalPriceShouldBe345()
   {
        PriceController controller= new     PriceController();

        controller.decileValue =    '0';
        controller.unitPrice   =    '50';
        controller.licenecNumberValue =    '10';
        controller.decileValue =    '0';
        controller.decileValue =    '0';
        controller.decileValue =    '0';
        controller.selectedTerritory = 'APAC';
        controller.selectedCountry   = 'AU';
     
        controller.selectedProduct   = 'Mathletics';
        controller.selectedTerm      = '1';
        controller.selectedSchoolCategory ='';

        List<Pricebook__mdt> pricebooks = [select Id, name__c from Pricebook__mdt where name__c like '%decile%'];
        Pricebook__mdt pricebook= pricebooks[0];
        controller.selectedPricebook = pricebooks[0].name__c;

        controller.Calculate();

        system.assertEquals(345.40, controller.model.FinalAmountIncludeTax);
        system.assertEquals(0, controller.model.discountAmount);
        system.assertEquals(0, controller.model.discountPercentage);
        system.assertEquals(154.60, controller.model.getDiscount(DiscountType.Country).discountAmount);
   

  }




 @isTest
   public static void CalculatePrice_getCountriesOptions_ShouldReturnOneRecord()
   {
        PriceController controller= new     PriceController();

        List<SelectOption>  options = controller.getCountriesOptions();

        system.assertEquals(3, options.size());

   }
    @isTest
   public static void CalculatePrice_getTermsOptions_ShouldReturnThreeValues()
   {
        PriceController controller= new     PriceController();

        List<SelectOption>  options = controller.getTermsOptions();

        system.assertEquals(3, options.size());

   }

    @isTest
   public static void CalculatePrice_getSchoolCategoriesOptions_ShouldReturnAtLeastOneRecord()
   {
        PriceController controller= new     PriceController();

        List<SelectOption>  options = controller.getSchoolCategoriesOptions();

        system.assert(options.size() > 0);

   }

   @isTest
   public static void CalculatePrice_getProductsOptions_ShouldReturnAtLeastOneRecord()
   {
        PriceController controller= new     PriceController();

        List<SelectOption>  options = controller.getProductsOptions();

        system.assert(options.size() > 0);

   }

@isTest
   public static void CalculatePrice_getTerritoriesOptions_ShouldReturnAtLeastOneRecord()
   {
        PriceController controller= new     PriceController();

        List<SelectOption>  options = controller.getTerritoriesOptions();

        system.assert(options.size() > 0);

   }
   
    @isTest
   public static void CalculatePrice_getPricebooksOptions_ShouldReturnAtLeastOneRecord()
   {
        PriceController controller= new     PriceController();

        List<SelectOption>  options = controller.getPricebooksOptions();

        system.assert(options.size() > 0);

   }



    
}