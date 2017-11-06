public class PriceController {
    public PriceController() {
        model       = new AdvancedPriceModel();
        unitPrice   = '50';
        decileValue = '0';
        licenecNumberValue = '1';
    }


      
        public String decileValue{get;set;}
        public String licenecNumberValue{get;set;}

        public Boolean isPaymentUpfrontValue{get;set;}
        // public Id campaignId{get;set;}
        // public String campaignIdValue {get;set;}

        public AdvancedPriceModel model{get;set;}

        public String selectedCountry{get;set;}
        public String selectedTerritory{get;set;}
        public String selectedTerm{get;set;}
        public String selectedProduct{get;set;} 
        public String selectedPricebook{get;set;}
        public String selectedSchoolCategory{get;set;}
        public String unitPrice{get;set;} 

        public List<SelectOption> getCountriesOptions() {
            List<SelectOption> countryOptions = new List<SelectOption>();

            List<Country__mdt> countries = [select code__c from Country__mdt];
            for(Country__mdt item: countries)
            {
                countryOptions.add(new SelectOption(item.code__c,item.code__c));
            }          
        
            return countryOptions;
        }

          public List<DiscountedPriceModel> getDiscounts() {
           
              List<DiscountedPriceModel> discounts 	= new 	List<DiscountedPriceModel>();

              for(DiscountedPriceModel item : model.Discounts)
              {
                  if(item.isDiscountAvailable)
                  {
                      discounts.add(item);
                  }
              }

            return discounts;
        }

        public List<SelectOption> getTerritoriesOptions() {
            List<SelectOption> territoryOptions = new List<SelectOption>();

            List<Territory__mdt> territories = [select Name__c from Territory__mdt];

            for(Territory__mdt item: territories)
            {
                territoryOptions.add(new SelectOption(item.Name__c,item.Name__c));
            }   
               
            return territoryOptions;
        }
        public List<SelectOption> getProductsOptions() {
            List<SelectOption> productOptions = new List<SelectOption>();

                List<Product_Family__mdt> productFamilies = [select Name__c from Product_Family__mdt order by Name__c];

            for(Product_Family__mdt item: productFamilies)
            {
                productOptions.add(new SelectOption(item.Name__c,item.Name__c));
            }   
                        
            return productOptions;
        }

        public List<SelectOption> getPricebooksOptions() {
            List<SelectOption> pricebookOptions = new List<SelectOption>();

            List<Pricebook__mdt> pricebooks = [select Name__c from Pricebook__mdt];

            for(Pricebook__mdt item: pricebooks)
            {
                pricebookOptions.add(new SelectOption(item.Name__c,item.Name__c));
            }   
                        
            return pricebookOptions;
        }

         public List<SelectOption> getSchoolCategoriesOptions() {
            List<SelectOption> schoolCategoryOptions = new List<SelectOption>();

            List<School_Category__mdt> schoolCategories = [select Name__c from School_Category__mdt];

            for(School_Category__mdt item: schoolCategories)
            {
                schoolCategoryOptions.add(new SelectOption(item.Name__c,item.Name__c));
            }   
                        
            return schoolCategoryOptions;
        }


        public List<SelectOption> getTermsOptions() {
            List<SelectOption> termOptions = new List<SelectOption>();
            termOptions.add(new SelectOption('1','1'));    
            termOptions.add(new SelectOption('2','2'));       
            termOptions.add(new SelectOption('3','3'));               
            return termOptions;
        }

         


        public PageReference Calculate()
        {           
            
            Try{
                if(decileValue== null || decileValue == '')   
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Decile as number'));

                }

                 if(unitPrice== null || unitPrice == '')   
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Unit Price'));

                }

                
                if(licenecNumberValue== null || licenecNumberValue == '')   
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Number of students'));
                    return null;
                }

                 if(integer.valueOf(licenecNumberValue)  <= 0)   
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter a positive number for Number of students'));
                     return null;

                }
               
                decimal initialPrice=Decimal.valueOf( unitPrice);
                PriceCalculator priceCalculator = new PriceCalculator();
                priceCalculator.SetDiscountTiers(selectedTerritory, selectedCountry, selectedPricebook, selectedProduct);
                model = priceCalculator.GetPrice(initialPrice,integer.valueOf(licenecNumberValue) , integer.valueOf(selectedTerm) , isPaymentUpfrontValue,
                                                     decileValue, selectedSchoolCategory);

                system.debug('Calculated discount model:'+ model);

                // model = new PriceCalculator(selectedTerritory, selectedCountry, selectedPricebook, selectedProduct).GetPrice(initialPrice,integer.valueOf(licenecNumberValue) , integer.valueOf(selectedTerm) , isPaymentUpfrontValue,
                //                                      decileValue, selectedSchoolCategory);

            }
            catch(Exception ex)
            {
                system.debug(loggingLevel.Error, ex);
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'There was a problem, '+ ex.getMessage()));

            }

            return null;
        }
}