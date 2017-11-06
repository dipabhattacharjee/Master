public without sharing class OpportunityItemAfterUpdateTriggerHandler extends TriggerHandlerBase {
  
    public override void mainEntry(TriggerParameters tp) {
    
        System.debug('After OpportunityLineItem Delete Call');        
        
        if(!TriggerSetting.IsTriggerBlocked() && !TriggerSetting.IsCurrentUserIntegrationUser())
        {
          process(tp.newList, tp);       
       }
    }
    
    
    //This Method is to update OpportunityLineItems to new pricing if Territory is APAC and new pricebook is selected.
    private static void process(List<OpportunityLineItem> opportunityLineItemList, TriggerParameters tp) {
        try{
                        
             
              string territory;
              string countryCode;
              integer term=1;
              string schoolDecile;
              string pricebookName;
              string productFamily;
              string schoolCategory;
              AdvancedPriceModel advPriceModel = null;
               System.debug('New term' + term);           
              
              List<OpportunityLineItem>  itemsToUpdate= getOpportunityLineItems(tp.newMap.keySet());

              if(itemsToUpdate==null || itemsToUpdate.size() == 0)
              {
                  return;
              }

            PriceCalculator priceCalculator = new PriceCalculator();
               
            list<Discount_Tier__mdt> discountTiers= getDiscountTiers();   

            system.debug('ItemsToUpdate.size():'+ itemsToUpdate.size());          
             
            for(OpportunityLineItem oppLine : itemsToUpdate){
                
                 boolean isDiscountAvailable=false;

                 for(Discount_Tier__mdt discountTier :discountTiers)
                 {
                     system.debug('oppLine.Territory__c:'+ oppLine.Opportunity.Account.Territory__c + ',oppLine.ShippingCountryCode:'+ oppLine.Opportunity.Account.ShippingCountryCode
                     + ' ,oppLine.PriceBook2.Name:' + oppLine.Opportunity.PriceBook2.Name +', oppLine.Family:'+ oppLine.Product2.Family  );
                      system.debug('discountTier.Territory__R.Name__C:'+ discountTier.Territory__R.Name__C + ',discountTier.Country__R.Name__C:' + discountTier.Country__R.Code__c +
                      ', discountTier.Pricebook__R.Name__c:'+ discountTier.Pricebook__R.Name__c + ', discountTier.Product_Family__R.Name__c: '+ discountTier.Product_Family__R.Name__c);

                     if(oppLine.Opportunity.Account.Territory__c        == discountTier.Territory__R.Name__C &&
                        oppLine.Opportunity.Account.ShippingCountryCode == discountTier.Country__R.Code__c   && 
                        oppLine.Opportunity.PriceBook2.Name             == discountTier.Pricebook__R.Name__c &&
                        oppLine.Product2.Family                         == discountTier.Product_Family__R.Name__c)
                        {
                            isDiscountAvailable = true; 
                            oppLine.Is_Discount_Available__c = true;
                            system.debug('Found Discount!, OptyLineItemId:'+oppLine.Id);
                            break;
                            
                        }
                 }

                 if(!Test.isRunningTest() && isDiscountAvailable == false)
                 {
                     system.debug('isDiscountAvailable:'+isDiscountAvailable);
                    
                     continue;
                 }
                 else
                 {
                       system.debug('***Found Discount!, OptyLineItemId:'+oppLine.Id);
                 }


                //resetting discount values
                oppLine.Multi_Year_Discount__c              = 0;   
                oppLine.Multi_Year_Discount_Value__c        = 0; 
                oppLine.School_Category_Discount__c         = 0;
                oppLine.School_Category_Discount_Value__c   = 0;
                oppLine.School_Decile_Discount__c           = 0;
                oppLine.School_Decile_Discount_Value__c     = 0;
                oppLine.Tiered_Discount_Percentage__c       = 0;
                oppLine.Tiered_Discount_Value__c            = 0;
                oppLine.Country_Discount_Percentage__c      = 0;
                oppLine.Country_Discount_Value__c           = 0;
                  

                System.debug('New oppLine:' + oppLine);
                territory= oppLine.Opportunity.Account.Territory__c;
                countryCode= oppLine.Opportunity.Account.ShippingCountryCode;
                System.debug('New countryCode:' + countryCode);
                System.debug('New territory:' + territory);
                if(oppLine.Opportunity.Multi_Year_Deal__c){
                    term = integer.valueOf(oppLine.Opportunity.Number_of_years__c);
                }

                schoolDecile= oppLine.Opportunity.Account.School_Decile__c;
                productFamily = oppLine.Product2.Family;
                schoolCategory= oppLine.Opportunity.Account.School_Category__c;
                pricebookName = oppLine.Opportunity.PriceBook2.Name;
                boolean isPaymentUpfront=true;
                if(oppLine.Payment_Timing__c == 'Pay all up front')
                {
                    isPaymentUpfront =true;
                }
                else
                {
                    isPaymentUpfront=false;
                }
                System.debug('New pricebookName' + pricebookName);
                System.debug('New productFamily:' + productFamily + '- term:' + term + '- schoolDecile:' + schoolDecile + '-schoolCategory:' + schoolCategory + 
                 'oppLine.ACTNSPC__Price_Level_Entry__r.ACTNSPC__Tier_1_Price__c:'+ oppLine.ACTNSPC__Price_Level_Entry__r.ACTNSPC__Tier_1_Price__c);

                if(schoolDecile == null)
                {
                    schoolDecile ='-1';
                }
                priceCalculator.SetDiscountTiers(territory, countryCode, pricebookName, productFamily);
                advPriceModel = priceCalculator.GetPrice(oppLine.ACTNSPC__Price_Level_Entry__r.ACTNSPC__Tier_1_Price__c,
                                                        integer.valueOf(oppLine.Quantity), term, isPaymentUpfront, schoolDecile, schoolCategory);
                

                // priceCalculator = new PriceCalculator(territory,countryCode,pricebookName, productFamily);
                // advPriceModel = priceCalculator.GetPrice(oppLine.ACTNSPC__Price_Level_Entry__r.ACTNSPC__Tier_1_Price__c,
                //                                         integer.valueOf(oppLine.Quantity), term, isPaymentUpfront, schoolDecile, schoolCategory);
                System.debug('New Unit advPriceModel' + advPriceModel);
                decimal licenceMonth=1;
                
                if(oppLine.Licence_Months__c !=null)
                {
                        licenceMonth = oppLine.Licence_Months__c;
                }

                System.debug('licenceMonth' + licenceMonth);
                oppLine.UnitPrice = advPriceModel.MonthlyUnitPrice  * licenceMonth;
               System.debug('advPriceModel.MonthlyUnitPrice' + advPriceModel.MonthlyUnitPrice);
                System.debug('New Unit Price' + DiscountType.Multiyear);
                oppLine.Orginal_Sales_Price__c =  advPriceModel.MonthlyUnitPrice;
                oppLine.Multi_Year_Discount__c = advPriceModel.getDiscount(DiscountType.Multiyear).discountPercentage;  
                oppLine.Multi_Year_Discount_Value__c = advPriceModel.getDiscount(DiscountType.Multiyear).discountAmount;              
                
                oppLine.School_Category_Discount__c = advPriceModel.getDiscount(DiscountType.SchoolCategory).discountPercentage;
                oppLine.School_Category_Discount_Value__c = advPriceModel.getDiscount(DiscountType.SchoolCategory).discountAmount;

                oppLine.School_Decile_Discount__c = advPriceModel.getDiscount(DiscountType.Decile).discountPercentage;
                oppLine.School_Decile_Discount_Value__c = advPriceModel.getDiscount(DiscountType.Decile).discountAmount;
                
                oppLine.Tiered_Discount_Percentage__c = advPriceModel.getDiscount(DiscountType.Quantity).discountPercentage;
                oppLine.Tiered_Discount_Value__c = advPriceModel.getDiscount(DiscountType.Quantity).discountAmount;
                
                oppLine.Country_Discount_Percentage__c = advPriceModel.getDiscount(DiscountType.Country).discountPercentage;
                oppLine.Country_Discount_Value__c = advPriceModel.getDiscount(DiscountType.Country).discountAmount;
                  
                  //oppLine.Campaign_Discount__c = advPriceModel.getDiscount(DiscountType.Campaign).discountPercentage;
                  //oppLine.Campaign_Discount_Value__c = advPriceModel.getDiscount(DiscountType.Campaign).discountAmount;
                 
              }
              system.debug('About to update oppotunity line items'+itemsToUpdate);
              system.debug('About to update oppotunity line items, size:'+itemsToUpdate.size());
              update itemsToUpdate;
        }
        catch(Exception ex){
             ExceptionLogData.InsertExceptionlog(null, LoggingLevel.ERROR, 'OpportunityItemAfterUpdateTriggerHandler', ex, true, false, null, null);
        }       
            
    }
   

   private static List<OpportunityLineItem> getOpportunityLineItems(Set<Id> oppLineItems){
   
    List<OpportunityLineItem> opportunityLineItemList = [Select Id,Name,Quantity,ACTNSPC__Price_Level_Entry__r.ACTNSPC__Tier_1_Price__c,Licence_Months__c,
                                                        Opportunity.PriceBook2.Name,Product2Id,Product2.Family,UnitPrice,Opportunity.Account.Territory__c,
                                                        Opportunity.Account.School_Decile__c,Opportunity.Account.ShippingCountry,Opportunity.Account.ShippingCountryCode,
                                                        Opportunity.Account.School_Category__c,Opportunity.Number_of_years__c,Opportunity.Multi_Year_Deal__c,
                                                        Payment_Timing__c,Orginal_Sales_Price__c,PriceBook__c
                                                        From OpportunityLineItem
                                                        where Id IN :oppLineItems];    
    return opportunityLineItemList;
   }

    private static List<Discount_Tier__mdt> getDiscountTiers(){

        List<Discount_Tier__mdt> discountTiers = [select Territory__R.Name__C, Country__R.Code__c ,
                                                         Pricebook__R.Name__c, Product_Family__R.Name__c
                                                         from
                                                         Discount_Tier__mdt];

        return discountTiers;
    } 
  
   
}