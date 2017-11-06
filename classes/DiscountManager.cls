public  class DiscountManager {
   
   
    public Map<string, IDiscount> discounts {get;set;}
    List<Discount_Tier__mdt> discountMasterlist ;
    List<Discount_Type__mdt> discountTypes ;

     public DiscountManager() {

     discountMasterlist =  [select   Pricebook__c	, Product_Family__R.Name__c, Pricebook__R.Name__c,
                                Discount_Type__R.Name__c, Code__c,   Territory__R.Name__c, Country__R.Code__c 																			
										from 
        						Discount_Tier__mdt];

    discountTypes = [select name__c from Discount_Type__mdt];

    system.debug('discountMasterlist.size():' + discountMasterlist.size() + ', discountTypes.size(): ' + discountTypes.size() );

     discounts = new Map<string, IDiscount>();

     for(Discount_Type__mdt discountType: discountTypes)
        {
             system.debug(' discountType.Name__c:' +  discountType.Name__c);

            if( discountType.Name__c == 'Country')
            {   
                // String code = discountTiersFinal.get(discountType.Name__c).Code__c;
                 discounts.put(discountType.Name__c, new CountryDiscount());  
                 system.debug('Adding(discountTiersFinal) Country Discount:'+discountType.Name__c); 
            }
            else if(discountType.Name__c == 'Multiyear')
            {   
                // String code = discountTiersFinal.get(discountType.Name__c).Code__c;
                 discounts.put(discountType.Name__c, new MultiyearDiscount());  
                 system.debug('Adding(discountTiersFinal) Multiyear Discount:'+ discountType.Name__c); 
            }
            else if( discountType.Name__c == 'Quantity')
            {   
                 //String code = discountTiersFinal.get(discountType.Name__c).Code__c;
                 discounts.put(discountType.Name__c, new TierdDiscount());  
                 system.debug('Adding(discountTiersFinal) Quantity Discount:'+ discountType.Name__c); 
            }
            else if(discountType.Name__c == 'Decile')
            {   
                // String code = discountTiersFinal.get(discountType.Name__c).Code__c;
                 discounts.put(discountType.Name__c, new SocialEconomicDiscount()); 
                 system.debug('Adding(discountTiersFinal) Decile Discount:'+ discountType.Name__c);  
            }
            else if(discountType.Name__c == 'SchoolCategory')
            {   
                 //String code = discountTiersFinal.get(discountType.Name__c).Code__c; 
                 discounts.put(discountType.Name__c, new SchoolCategoryDiscount());  
                 system.debug('Adding(discountTiersFinal) SchoolCategory Discount:'+ discountType.Name__c); 
            }
        }

     }

    public Map<string, IDiscount> GetDiscountTiers(string territory, string countryCode, string pricebookName, string productFamily)
    {
        if(territory == null)
		{
			throw new ValidationException('Territory cannot be null');
		}

        if(countryCode == null)
		{
			throw new ValidationException('CountryCode cannot be null');
		}
        	if(pricebookName == null)
		{
			throw new ValidationException('PricebookName cannot be null');
		}

		if(productFamily == null)
		{
			throw new ValidationException('ProductFamily cannot be null');
		}

        List<Discount_Tier__mdt> discountTiers =new List<Discount_Tier__mdt> ();
        
        for(Discount_Tier__mdt item : discountMasterlist)
        {
           system.debug('item.Pricebook__R.Name__c :' + item.Pricebook__R.Name__c  +', item.Product_Family__R.Name__c:' + item.Product_Family__R.Name__c + ', item.Territory__R.Name__c:' + item.Territory__R.Name__c 
           + ', item.Country__R.Code__c: ' + item.Country__R.Code__c);

            if( (item.Pricebook__R.Name__c      == pricebookName && 
                item.Product_Family__R.Name__c 	== productFamily &&
                item.Territory__R.Name__c       == territory) &&
                (item.Country__R.Code__c 		== countryCode   ||     item.Country__R.Code__c == 'All'))
                {
                    system.debug('Adding to discountTiers: '+ item);
                    discountTiers.add(item);
                }
        }
	
        system.debug('Territory:'+ territory + ', countryCode:'+ countryCode+
				     ', pricebook Name:'+pricebookName+ ', productFamily:'+productFamily + ', records:' + discountTiers.size());

		
        Map<String, Discount_Tier__mdt> discountTiersFinal= new    Map<String, Discount_Tier__mdt>();

        //If discount is available on Country level, That discount would be used, otherwise territory discount would be used if there is any
        for(Discount_Type__mdt discountType: discountTypes)
        {
            //First trying to find country specific discount 
            for(Discount_Tier__mdt item : discountTiers)
            {
                system.debug('Start Checking Country Specific Discounts, type:' +discountType.Name__c );

                if(item.Discount_Type__R.Name__c == discountType.Name__c && item.Country__R.Code__c == countryCode)
                {
                      discountTiersFinal.put(item.Discount_Type__R.Name__c, item);
                      system.debug('Adding Country Discount:'+item.Discount_Type__R.Name__c+ ', Country:'+countryCode);      
                }               
            }


            system.debug('Check if there is any default discount available');
            //second trying to find territoty specific discount if available
             for(Discount_Tier__mdt item : discountTiers)
            {
                if(item.Discount_Type__R.Name__c == discountType.Name__c && discountTiersFinal.containsKey(item.Discount_Type__R.Name__c) == false)
                {
                      discountTiersFinal.put(item.Discount_Type__R.Name__c, item);
                      system.debug('Adding Default Discount:'+item.Discount_Type__R.Name__c);    
                } 
            } 

        }

        
        for(Discount_Tier__mdt item : discountTiersFinal.values())	
		{            
			system.debug('Territory__R.Name__c:'+item.Territory__R.Name__c + ',Country__R.Code__c:'+ item.Country__R.Code__c +
				',Type__c:'+item.Discount_Type__R.Name__c+ ', Code__c:'+item.Code__c);            
		}


        Map<string, IDiscount> discountEntities= new Map<string, IDiscount>();

        //TODO: Can be moved to a factory class
        for(Discount_Type__mdt discountType: discountTypes)
        {
            if(discountTiersFinal.containsKey(discountType.Name__c))
            {
                String code = discountTiersFinal.get(discountType.Name__c).Code__c;
                Idiscount discount = discounts.get (discountType.Name__c);  
                discount.SetCode(code);

                discountEntities.put(discountType.Name__c, discount);
            }
        }

        return discountEntities;   
    }

    // public DiscountManager(string territory, string countryCode, string pricebookName, string productFamily) {
        
        
    //     if(territory == null)
	// 	{
	// 		throw new ValidationException('Territory cannot be null');
	// 	}

    //     if(countryCode == null)
	// 	{
	// 		throw new ValidationException('CountryCode cannot be null');
	// 	}
    //     	if(pricebookName == null)
	// 	{
	// 		throw new ValidationException('PricebookName cannot be null');
	// 	}

	// 	if(productFamily == null)
	// 	{
	// 		throw new ValidationException('ProductFamily cannot be null');
	// 	}

	

    //     //Retieve all available discount for territory/ Country and default Of Territory
    //     List<Discount_Tier__mdt> discountTiers =  [select   Pricebook__c	, Product_Family__R.Name__c, Pricebook__R.Name__c, Discount_Type__R.Name__c, Code__c,
    //                                                         Territory__R.Name__c, Country__R.Code__c 																			
	// 																		from 
    //     																		Discount_Tier__mdt
	// 																		Where 
	// 																			Product_Family__R.Name__c 	= :productFamily AND
	// 																			Pricebook__R.Name__c 		= :pricebookName AND 
	// 																			(Country__R.Code__c 		= :countryCode   OR     Country__R.Code__c = 'All') AND
    //                                                                             Territory__R.Name__c        = :territory ];

 
    //     List<Discount_Type__mdt> discountTypes = [select name__c from Discount_Type__mdt];


	
    //     system.debug('Territory:'+ territory + ', countryCode:'+ countryCode+
	// 			     ', pricebook Name:'+pricebookName+ ', productFamily:'+productFamily + ', records:' + discountTiers.size());

		
    //     Map<String, Discount_Tier__mdt> discountTiersFinal= new    Map<String, Discount_Tier__mdt>();

    //     //If discount is available on Country level, That discount would be used, otherwise territory discount would be used if there is any
    //     for(Discount_Type__mdt discountType: discountTypes)
    //     {
    //         //First trying to find country specific discount 
    //         for(Discount_Tier__mdt item : discountTiers)
    //         {
    //             system.debug('Start Checking Country Specific Discounts, type:' +discountType.Name__c );

    //             if(item.Discount_Type__R.Name__c == discountType.Name__c && item.Country__R.Code__c == countryCode)
    //             {
    //                   discountTiersFinal.put(item.Discount_Type__R.Name__c, item);
    //                   system.debug('Adding Country Discount:'+item.Discount_Type__R.Name__c+ ', Country:'+countryCode);      
    //             }               
    //         }


    //         system.debug('Check if there is any default discount available');
    //         //second trying to find territoty specific discount if available
    //          for(Discount_Tier__mdt item : discountTiers)
    //         {
    //             if(item.Discount_Type__R.Name__c == discountType.Name__c && discountTiersFinal.containsKey(item.Discount_Type__R.Name__c) == false)
    //             {
    //                   discountTiersFinal.put(item.Discount_Type__R.Name__c, item);
    //                   system.debug('Adding Default Discount:'+item.Discount_Type__R.Name__c);    
    //             } 
    //         } 

    //     }

        
    //     for(Discount_Tier__mdt item : discountTiersFinal.values())	
	// 	{            
	// 		system.debug('Territory__R.Name__c:'+item.Territory__R.Name__c + ',Country__R.Code__c:'+ item.Country__R.Code__c +
	// 			',Type__c:'+item.Discount_Type__R.Name__c+ ', Code__c:'+item.Code__c);            
	// 	}

    //     discounts = new Map<string, IDiscount>();
    //     //TODO: Can be moved to a factory class
    //     for(Discount_Type__mdt discountType: discountTypes)
    //     {
    //         if(discountTiersFinal.containsKey(discountType.Name__c) && discountType.Name__c == 'Country')
    //         {   
    //              String code = discountTiersFinal.get(discountType.Name__c).Code__c;
    //              discounts.put(discountType.Name__c, new CountryDiscount(code));  
    //              system.debug('Adding(discountTiersFinal) Country Discount:'+discountType.Name__c); 
    //         }
    //         else if(discountTiersFinal.containsKey(discountType.Name__c) && discountType.Name__c == 'Multiyear')
    //         {   
    //              String code = discountTiersFinal.get(discountType.Name__c).Code__c;
    //              discounts.put(discountType.Name__c, new MultiyearDiscount(code));  
    //              system.debug('Adding(discountTiersFinal) Multiyear Discount:'+ discountType.Name__c); 
    //         }
    //         else if(discountTiersFinal.containsKey(discountType.Name__c) && discountType.Name__c == 'Quantity')
    //         {   
    //              String code = discountTiersFinal.get(discountType.Name__c).Code__c;
    //              discounts.put(discountType.Name__c, new TierdDiscount(code));  
    //              system.debug('Adding(discountTiersFinal) Quantity Discount:'+ discountType.Name__c); 
    //         }
    //          else if(discountTiersFinal.containsKey(discountType.Name__c) && discountType.Name__c == 'Decile')
    //         {   
    //              String code = discountTiersFinal.get(discountType.Name__c).Code__c;
    //              discounts.put(discountType.Name__c, new SocialEconomicDiscount(code)); 
    //              system.debug('Adding(discountTiersFinal) Decile Discount:'+ discountType.Name__c);  
    //         }
    //           else if(discountTiersFinal.containsKey(discountType.Name__c) && discountType.Name__c == 'SchoolCategory')
    //         {   
    //              String code = discountTiersFinal.get(discountType.Name__c).Code__c;
    //              discounts.put(discountType.Name__c, new SchoolCategoryDiscount(code));  
    //              system.debug('Adding(discountTiersFinal) Category Discount:'+ discountType.Name__c); 
    //         }
    //     }
    // }

     public void InitialingDiscountTiers(Map<string, IDiscount> discountTiers, integer term, boolean isPaymentUpfront, integer quantity, Integer decile, String schoolCategory)
    {
        for(string discountType : discountTiers.keySet())
        {
            if(discountTiers.containsKey(discountType) && discountType == 'Country')
            {   
                CountryDiscount discount = (CountryDiscount)discountTiers.get(discountType);
                discount.Initialise();
               //Country Discount is not required any initialization
            }
            else if(discountTiers.containsKey(discountType) && discountType == 'Multiyear')           
            {   
                MultiYearDiscount discount = (MultiYearDiscount)discountTiers.get(discountType);
                discount.Initialise(Integer.valueOf(term) , isPaymentUpfront);
            }
            else if(discountTiers.containsKey(discountType) && discountType == 'Quantity')
            {   
                TierdDiscount discount = (TierdDiscount)discountTiers.get(discountType);
                discount.Initialise(quantity);
            }
            else if(discountTiers.containsKey(discountType) && discountType == 'Decile')
            {   
                SocialEconomicDiscount discount = (SocialEconomicDiscount)discountTiers.get(discountType);
                discount.Initialise(decile);
            }
             else if(discountTiers.containsKey(discountType) && discountType == 'SchoolCategory')
            {   
                SchoolCategoryDiscount discount = (SchoolCategoryDiscount)discountTiers.get(discountType);
                discount.Initialise(schoolCategory);
            }
        }
    }


    // public void InitialingDiscountParameters(integer term, boolean isPaymentUpfront, integer quantity, Integer decile, String schoolCategory)
    // {
    //     for(string discountType : discounts.keySet())
    //     {
    //         if(discounts.containsKey(discountType) && discountType == 'Country')
    //         {   
    //             CountryDiscount discount = (CountryDiscount)discounts.get(discountType);
    //             discount.Initialise();
    //            //Country Discount is not required any initialization
    //         }
    //         else if(discounts.containsKey(discountType) && discountType == 'Multiyear')           
    //         {   
    //             MultiYearDiscount discount = (MultiYearDiscount)discounts.get(discountType);
    //             discount.Initialise(Integer.valueOf(term) , isPaymentUpfront);
    //         }
    //         else if(discounts.containsKey(discountType) && discountType == 'Quantity')
    //         {   
    //             TierdDiscount discount = (TierdDiscount)discounts.get(discountType);
    //             discount.Initialise(quantity);
    //         }
    //         else if(discounts.containsKey(discountType) && discountType == 'Decile')
    //         {   
    //             SocialEconomicDiscount discount = (SocialEconomicDiscount)discounts.get(discountType);
    //             discount.Initialise(decile);
    //         }
    //          else if(discounts.containsKey(discountType) && discountType == 'SchoolCategory')
    //         {   
    //             SchoolCategoryDiscount discount = (SchoolCategoryDiscount)discounts.get(discountType);
    //             discount.Initialise(schoolCategory);
    //         }
    //     }
    // }

     public Map<Integer, DiscountedPriceModel> Calculate(Map<string, IDiscount> discountTiers, decimal initialAmount)
    {
        Map<Integer,DiscountedPriceModel> discountedAmounts = new Map<Integer,DiscountedPriceModel>();

        Decimal amount = initialAmount;

        Integer discountNumber=1;

        //  for(string discountType : discountTiers.keySet())
        // {
        //     system.debug('Start calculating '+ discountType+' Discount'); 
        //     DiscountedPriceModel discount = discountTiers.get(discountType).GetDiscount(amount);
        //     system.debug('End calculating'+discountType+' Discount'); 
        //     discountedAmounts.put(discountNumber, discount);
        //     discountNumber=discountNumber+1;
        //     amount = discount.amount;
        // }

        if(discountTiers.containsKey('Country') )
        {   
            system.debug('Start calculating Country Discount'); 
            DiscountedPriceModel discount = discountTiers.get('Country').GetDiscount(amount);
            system.debug('End calculating Country Discount'); 
            discountedAmounts.put(discountNumber, discount);
            discountNumber=discountNumber+1;
            amount = discount.amount;
        }

        if(discountTiers.containsKey( 'Multiyear')  )         
        {   
            DiscountedPriceModel discount = discountTiers.get('Multiyear').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);   
            discountNumber=discountNumber+1;         
            amount = discount.amount;
            
        }

        if(discountTiers.containsKey('Quantity'))
        {   
            DiscountedPriceModel discount = discountTiers.get('Quantity').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);
            discountNumber=discountNumber+1;
            amount = discount.amount;
        }

        if(discountTiers.containsKey('Decile'))
        {   
            DiscountedPriceModel discount = discountTiers.get('Decile').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);
            
            amount = discount.amount;
        }

         if(discountTiers.containsKey('SchoolCategory'))
        {   
            DiscountedPriceModel discount = discountTiers.get('SchoolCategory').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);
            
            amount = discount.amount;
        }
       

        return discountedAmounts;
    }

     public Map<Integer, DiscountedPriceModel> CalculateDiscounts(decimal initialAmount)
    {
        Map<Integer,DiscountedPriceModel> discountedAmounts = new Map<Integer,DiscountedPriceModel>();

        Decimal amount = initialAmount;

        Integer discountNumber=1;

        if(discounts.containsKey('Country') )
        {   
            system.debug('Start calculating Country Discount'); 
            DiscountedPriceModel discount = discounts.get('Country').GetDiscount(amount);
            system.debug('End calculating Country Discount'); 
            discountedAmounts.put(discountNumber, discount);
            discountNumber=discountNumber+1;
            amount = discount.amount;
        }

        if(discounts.containsKey( 'Multiyear')  )         
        {   
            DiscountedPriceModel discount = discounts.get('Multiyear').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);   
            discountNumber=discountNumber+1;         
            amount = discount.amount;
            
        }

        if(discounts.containsKey('Quantity'))
        {   
            DiscountedPriceModel discount = discounts.get('Quantity').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);
            discountNumber=discountNumber+1;
            amount = discount.amount;
        }

        if(discounts.containsKey('Decile'))
        {   
            DiscountedPriceModel discount = discounts.get('Decile').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);
            
            amount = discount.amount;
        }

         if(discounts.containsKey('SchoolCategory'))
        {   
            DiscountedPriceModel discount = discounts.get('SchoolCategory').GetDiscount(amount);
            discountedAmounts.put(discountNumber, discount);
            
            amount = discount.amount;
        }
       

        return discountedAmounts;
    }
}