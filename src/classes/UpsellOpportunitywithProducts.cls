public without sharing class UpsellOpportunitywithProducts {

    private Map<Id, Product2> products;
    private Pricebook2 priceBook;
    OpportunityDuplicateChecker opportunityDuplicateChecker;

    public UpsellOpportunitywithProducts()
    {
        ProductSelector productSelector = new ProductSelector();

        products                    = productSelector.GetProducts();
        priceBook                   = PriceBookIdentifier.GetStandardRegionalPricebook();
        opportunityDuplicateChecker = new OpportunityDuplicateChecker();
    }
      
   
    //Returns created  opportunityId
  /*  public Opportunity CreateUpsellOpportunity(Asset  asset, Id opportunityId )
    {
        //Create Upsell Opportunity based on opportunityId
        //Select the right price book
        //create opportunity line item with product productFamily and subscription dates          

        Opportunity         opportunity             = GetOpportunity(opportunityId);
        
        Product2  product                           = products.get(asset.Product2Id); 

        ProductSelector productSelector = new ProductSelector();

        //Getting the active product
        Product2 activeProduct = productSelector.GetActiveProduct( product, products);

        PriceBook2 activePricebook = PriceBookIdentifier.GetActivePricebook(opportunity.Pricebook2.Id);

         //previous product line item
        OpportunityLineItem opportunityLineItem     = GetOpportunityLineItem(opportunityId, product.Family);       
            

        //Cloning opportunities
        Opportunity         clonedOpportunity       = CloneOpportunity(opportunity, activePricebook, product.Family);
        
        SetOpportunityOwner(clonedOpportunity);

            if(!opportunityDuplicateChecker.Exist(clonedOpportunity, product.Family))
            { 
                insert clonedOpportunity;

                OpportunityLineItem clonedOpportunityLineItem;

                Decimal New_Quantity;

                if(asset.Registered_students_licence_cap__c > 0)
                {
                    New_Quantity = asset.Registered_students_licence_cap__c;
                }
                else
                {
                    New_Quantity = 10;
                }

                 if(opportunity.Pricebook2.Id != activePricebook.Id)
                {    

                       PricebookEntry pricebookEntry           = GetPricebookEntry(activeProduct.Id, activePricebook.Id);

                       if(pricebookEntry == null)
                       {
                            pricebookEntry           = GetPricebookEntry(activeProduct.Family, activePricebook.Id, clonedOpportunity.CurrencyIsoCOde);
                       }
                   
                    //If pricebook is inactivated we need to get coresponding active pricebook and pricelevel entry
                    Id priceLevelId     = PriceBookIdentifier.GetPriceLevelId(activePricebook.Id);
                    String currencyCode = PriceBookIdentifier.GetActianCurrencyCode(opportunity.CurrencyIsoCode);
                    Id priceLevelEntryId = PriceBookIdentifier.GetPriceLevelEntryId( priceLevelId, activeProduct.Id,  currencyCode); 
                   
                   
                     clonedOpportunityLineItem  = CloneOpportunityLineItem(clonedOpportunity.Id, opportunityLineItem, asset.UsageEndDate, asset.License_Cap__c,  false, New_Quantity);                                    
                     clonedOpportunityLineItem.PricebookEntryId = pricebookEntry.Id;
                     //Since the pricelevelEntryId might be different then we need to set it again
                     //clonedOpportunityLineItem.ACTNSPC__Price_Level_Entry__c     = priceLevelEntryId;
                }
                else
                {
                     clonedOpportunityLineItem   = CloneOpportunityLineItem(clonedOpportunity.Id, opportunityLineItem, asset.UsageEndDate, asset.License_Cap__c,  true, New_Quantity);

                }

                insert clonedOpportunityLineItem;
               
                return clonedOpportunity;
            }     

            return null;
        }  
                    

    public void SetOpportunityOwner(Opportunity opportunity)
    {
          Account account = [Select Id, OwnerId from Account where Id = :opportunity.AccountId limit 1] ;

          Opportunity.OwnerId = account.OwnerId;

    }
 
    //Since there is no opportunity associated to the asset, Standard pricebook would be used to create the upsell opportunity
    //Returns created  opportunityId
    public Opportunity CreateUpsellOpportunity( Asset asset )
    {

        //Create Upsell Opportunity 
        //Select the standard price book 
        //Create opportunity line item with product productFamily and subscription dates       
        
        Product2  product                       = products.get(asset.Product2Id);    

        System.Debug('CreateUpsellOpportunity + Asset value: ' + asset);

        ProductSelector productSelector = new ProductSelector();
         //Getting the active product
        Product2 activeProduct = productSelector.GetActiveProduct( product, products);

        //Since we are getting the standard active price book , no need to check for active price book
        Pricebook2 pricebook = PricebookIdentifier.GetStandardRegionalPricebook();
     
        //Cloning opportunities
        Opportunity   createdUpsellOpportunity  =  OpportunityFactory.Create('Up Sell', 'Standard Opportunity', pricebook, product.Family, asset.AccountId, asset.Account.CurrencyIsoCode) ; 

        if(!opportunityDuplicateChecker.Exist(createdUpsellOpportunity, product.Family))
        {
            SetOpportunityOwner(createdUpsellOpportunity);          

            insert createdUpsellOpportunity;

             
            //If pricebook is inactivated we need to get coresponding active pricebook and pricelevel entry
            Id priceLevelId     = PriceBookIdentifier.GetPriceLevelId(pricebook.Id);
            String currencyCode = PriceBookIdentifier.GetActianCurrencyCode(createdUpsellOpportunity.CurrencyIsoCode);
            Id priceLevelEntryId = PriceBookIdentifier.GetPriceLevelEntryId( priceLevelId, activeProduct.Id,  currencyCode); 
             
            
             PricebookEntry pricebookEntry           = GetPricebookEntry(activeProduct.Id, priceBook.Id);

            if(pricebookEntry == null)
            {
                pricebookEntry           = GetPricebookEntry(product.Family, priceBook.Id, createdUpsellOpportunity.CurrencyIsoCOde);
            }
            
           
            Decimal New_Quantity;

            if(asset.Registered_students_licence_cap__c > 0)
            {
                New_Quantity = asset.Registered_students_licence_cap__c;
            }
            else
            {
                New_Quantity = 10;
            }


            OpportunityLineItem opportunityLineItem             = OpportunityFactory.Create(createdUpsellOpportunity.Id, 
                                                                        New_Quantity, true, system.today(), asset.UsageEndDate,
                                                                        asset.License_CAP__c, pricebookEntry.Id);

            
            //opportunityLineItem.ACTNSCRM__Product__c   = activeProduct.Id;
            //opportunityLineItem.ACTNSCRM__Price_Level__c = priceLevelId;
           // opportunityLineItem.Product2 = activeProduct.Id;
            insert opportunityLineItem;
           
            return createdUpsellOpportunity;
        }
      
      return null;
    }

    public Opportunity GetOpportunity(Id opportunityId){

        Id standardOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
        Id lockedOpportunityRecordTypeId   = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Locked Opportunity').getRecordTypeId();

        List<Opportunity> opportunities = [
                                    SELECT 
                                        Id,name,RecordTypeId,CurrencyIsoCode,Multi_Year_Deal__c,Number_of_years__c,
                                        account.name,account.CurrencyIsoCode,CloseDate,Owner.name,StageName,amount,
                                        account.OwnerId,MinLicenceEndDate__c,OwnerId,Pricebook2.Id
                                    FROM 
                                        Opportunity 
                                    Where 
                                        Id = :opportunityId 
                                        AND (Type = 'New Business' OR Type = 'Cross Sell' OR Type = 'Renewal') 
                                        AND StageName ='Sold - Invoiced' 
                                        AND (recordTypeId = :standardOpportunityRecordTypeId or recordTypeId = :lockedOpportunityRecordTypeId) 
                                      
                                    ];


        if (opportunities == null || opportunities.size() == 0)
        {
            throw new ValidationException('Opportunity assigned to the Asset is not invoiced yet, opportunityId :'+ opportunityId);
        }

        if(opportunities.size() > 0)
        {
            return opportunities[0];
        } 

        return null;     
    }
*/
    public Asset GetAsset(Id assetId){

        Id fullAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Full Licence').getRecordTypeId();  

        Date maxdate = System.today().addDays(25);

        List<Asset> asset = [
                              SELECT 
                                    Id,  Product2Id,Opportunity_Product_Id__c,UsageEndDate,
                                    Original_End_Date__c,InstallDate, AccountId,Status , License_Cap__c, 
                                    Account.CurrencyIsoCode , Registered_students_Licence_cap__C, recordTypeId,
                                    Product2.Family,Opportunity__R.Id
                              FROM 
                                    Asset 
                              Where 
                                    Id = :assetId 
                                
                     ];
/*
                      Id = :assetId AND
                                (recordTypeId = :fullAssetRecordTypeId) 
                                and Status = 'Provisioned'
                                and UsageEndDate > :maxdate
                                Limit 1
                                */


        if (asset == null || asset.size() == 0)
        {
            throw new ValidationException('Asset ' + assetId+ ' does not exist!');
        }

        if(asset[0].recordTypeId != fullAssetRecordTypeId)
        {
            throw new ValidationException('Upsell is only for full licences, AssetId: ' + assetId);
        }
        if(asset[0].Status != 'Provisioned')
        {
            throw new ValidationException('Upsell can be done on Full provisioned Licences. Please select a valid asset instead of AssetId: ' + assetId);
        }

         if(asset[0].UsageEndDate < maxdate)
        {
            throw new ValidationException('This licence is going to expire before '+ maxdate +'You cannot upsell for a Licence expiring within a Month, assetId: ' + assetId);
        }

        return asset[0];
    }

   
/*
    public PricebookEntry GetPricebookEntry(Id product2Id, Id stdPriceBookId)
    {
      

        List<PricebookEntry> pricebookEntries = [   
                                                    SELECT 
                                                        Id,UnitPrice 
                                                    FROM
                                                         PricebookEntry 
                                                    WHERE 
                                                        Product2Id   = :product2Id and 
                                                        Pricebook2Id = :stdPriceBookId
                                                ];

        if(pricebookEntries == null || pricebookEntries.Size() == 0)
        {
            return null; //throw new ValidationException('Cannot find pricebookEntry for product2Id: ' + product2Id +  ' on the Asset');
        }

        return pricebookEntries[0];
    }
*/
     public static List<PricebookEntry> GetPricebookEntries()
    {      

        List<PricebookEntry> pricebookEntries = [   
                                                    SELECT 
                                                        Id, UnitPrice , Product2Id, Pricebook2Id
                                                    FROM
                                                         PricebookEntry 
                                                ];

      

        return pricebookEntries;
    }

      public static PricebookEntry FilterPricebookEntry(List<PricebookEntry> pricebookEntries, Id product2Id, Id stdPriceBookId , string currencyIsoCode)
    {      

      for(PricebookEntry pricebookEntry : pricebookEntries)
      {
            if(pricebookEntry.product2Id == product2Id && pricebookEntry.Pricebook2Id == stdPriceBookId && pricebookEntry.CurrencyIsoCode == currencyIsoCode )
            return pricebookEntry;
      }      

       throw new ValidationException('Cannot find pricebookentry ,product2Id'+product2Id + ' , Pricebook2Id'+stdPriceBookId);
    }

   

/*
    public PricebookEntry GetPricebookEntry(String productFamily, Id stdPriceBookId, String currencyIsoCode)
    {
       

        List<PricebookEntry> pricebookEntries = [   
                                                    SELECT 
                                                        Id,UnitPrice 
                                                    FROM
                                                         PricebookEntry 
                                                    WHERE 
                                                        ProductFamily__c = :productFamily
                                                     AND   
                                                        Pricebook2Id    = :stdPriceBookId
                                                     AND IsActive       = true
                                                     AND CurrencyIsoCode = : currencyIsoCode
                                                ];

        if(pricebookEntries == null || pricebookEntries.Size() == 0)
        {           
       

            return null; //throw new ValidationException('Cannot find pricebookEntry for product2Id: ' + product2Id +  ' on the Asset');
        }


        return pricebookEntries[0];
    }


    */

     
/*
    public OpportunityLineItem GetOpportunityLineItem(Id opportunityId, String productFamily){

        OpportunityLineItem opportunityLineItem = [
                                                    SELECT 
                                                        Id,Name,ServiceDate,PricebookEntryId,Description,ListPrice,OpportunityId,Product2Id,
                                                        ProductCode,Quantity,TotalPrice,License_Provisioned__c,Provision_Full_License__c,
                                                        Provision_Trial_License__c,Trial_Provisioned__c,Trial_Start_Date__c,
                                                        SubscriptionStartDate__c,SubscriptionEndDate__c ,Used_Monthly_Price__c
                                                    FROM 
                                                        OpportunityLineItem 
                                                    Where 
                                                        OpportunityId = :opportunityId and 
                                                        Family__c = :productFamily 
                                                    Limit 1
                                                ];

        if (opportunityLineItem == null)
        {
            throw new ValidationException('Cannot find Opportunity Products for the Opportunity : ' + opportunityId +  ' assigned to the Asset');
        }
        return opportunityLineItem;
    }
*/
   

}