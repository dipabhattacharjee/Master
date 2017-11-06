@isTest
private class OppLineItemAfterUpdateTriggerHandlerTest {
	@testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    }

    @isTest
	static void setOpportunityPrice_with_CountryDiscount()
	{
		Account account  = FakeObjectFactory.GetSchoolAccount();
        account.ShippingState       = 'New South Wales';
        account.ShippingCountry     = 'Australia';
        account.ShippingPostalCode  = '2000';
        account.School_Decile__c = '800';
        account.Territory__c = 'APAC';
        insert account; 
        String productFamily = 'Mathletics'; 
        Product2 product = getProduct(productFamily,'154');
        insert product;
		Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = product.Id,
        UnitPrice = 4, IsActive = true);
        insert standardPrice;   

	     ACTNSPC__Currency__c currencyToInsert = getcurrency('AUD');
	     insert currencyToInsert;
       
	   	Pricebook2 pricebookNew = new Pricebook2(Name='Decile Pricebook', isActive=true);
       	insert pricebookNew;

       	PricebookEntry pricebookEntryNew = new PricebookEntry(
        Pricebook2Id = pricebookNew.Id, Product2Id = product.Id,
        UnitPrice = 4, IsActive = true);
        insert pricebookEntryNew;

        ACTNSPC__Price_Level__c priceLevel = getPriceLevel('Base Price','1');
	    insert priceLevel;
	  
	    ACTNSPC__Price_Level_Entry__c  priceLevelEntry = getPriceLevelEntry(product,priceLevel, currencyToInsert,'154');
	    insert priceLevelEntry;

	    Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;
        
         OpportunityLineItem fullOpportunityLineItem = new OpportunityLineItem(); //OpportunityFactory.Create( 1, true,Date.today(), Date.today().addMonths(12), 1 ,pricebookEntryNew.id );
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntryNew);
       	fullOpportunityLineItem.ACTNSPC__Price_Level_Entry__c = priceLevelEntry.Id;
       	fullOpportunityLineItem.OpportunityId = fullOpportunity.Id;
        fullOpportunityLineItem.quantity = 1;
        fullOpportunityLineItem.Provision_Full_License__c = true;
        fullOpportunityLineItem.Price_Locked__c = false;
        fullOpportunityLineItem.SubscriptionStartDate__c    = Date.today();
        fullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(12);
        fullOpportunityLineItem.UnitPrice = 1;
        insert fullOpportunityLineItem;

        OpportunityLineItem lineItem = [Select Id,Name,UnitPrice from OpportunityLineItem where id = :fullOpportunityLineItem.Id];

        System.assertEquals(lineItem.UnitPrice , 21.60);



        
	}

	 @isTest
	static void setOpportunityPrice_with_AllDiscount()
	{
		Account account  = FakeObjectFactory.GetSchoolAccount();
        account.ShippingState       = 'New South Wales';
        account.ShippingCountry     = 'Australia';
        account.ShippingPostalCode  = '2000';
        account.School_Decile__c = '800';
        account.Territory__c = 'APAC';
        insert account; 
        String productFamily = 'Mathletics'; 
        Product2 product = getProduct(productFamily,'154');
        insert product;
		Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = product.Id,
        UnitPrice = 4, IsActive = true);
        insert standardPrice;   

	     ACTNSPC__Currency__c currencyToInsert = getcurrency('AUD');
	     insert currencyToInsert;
       
	   	Pricebook2 pricebookNew = new Pricebook2(Name='Decile Pricebook', isActive=true);
       	insert pricebookNew;

       	PricebookEntry pricebookEntryNew = new PricebookEntry(
        Pricebook2Id = pricebookNew.Id, Product2Id = product.Id,
        UnitPrice = 4, IsActive = true);
        insert pricebookEntryNew;

        ACTNSPC__Price_Level__c priceLevel = getPriceLevel('Base Price','1');
	    insert priceLevel;
	  
	    ACTNSPC__Price_Level_Entry__c  priceLevelEntry = getPriceLevelEntry(product,priceLevel, currencyToInsert,'154');
	    insert priceLevelEntry;

	    Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.Multi_Year_Deal__c = true;
        fullOpportunity.Number_of_years__c = '3';
        fullOpportunity.Payment_Timing__c  = 'Pay all up front';
        fullOpportunity.priceBook2Id = pricebookNew.Id;
        insert fullOpportunity;
        
        OpportunityLineItem fullOpportunityLineItem = new OpportunityLineItem();//OpportunityFactory.Create( 400, true,Date.today(), Date.today().addMonths(36), 400 ,pricebookEntryNew.id );
        
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntryNew);
       	fullOpportunityLineItem.ACTNSPC__Price_Level_Entry__c = priceLevelEntry.Id;
       	fullOpportunityLineItem.OpportunityId = fullOpportunity.Id;
        fullOpportunityLineItem.SubscriptionStartDate__c    = Date.today();
        fullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(36);
        fullOpportunityLineItem.Price_Locked__c = false;
        fullOpportunityLineItem.Provision_Full_License__c = true;
        fullOpportunityLineItem.quantity = 400;
        fullOpportunityLineItem.UnitPrice = 1;
        insert fullOpportunityLineItem;

        OpportunityLineItem lineItem = [Select Id,Name,UnitPrice from OpportunityLineItem where id = :fullOpportunityLineItem.Id];
        System.debug('Anydatatype_msg Test class' + lineItem);
        System.assertEquals(lineItem.UnitPrice , 45);



        
	}

	public static ACTNSPC__Price_Level__c getPriceLevel(String name,String internalId){
            ACTNSPC__Price_Level__c priceLevel2 = new ACTNSPC__Price_Level__c();
            priceLevel2.Name = name;
            priceLevel2.ACTNSPC__External_Id__c = internalId;
            return priceLevel2;

      }

      public static ACTNSPC__Currency__c getcurrency(String currencyCode){
            ACTNSPC__Currency__c currencyAUD = new ACTNSPC__Currency__c();
            currencyAUD.ACTNSPC__Active__c = true;
            currencyAUD.ACTNSPC__Iso_Code__c = currencyCode;
            return currencyAUD;

      }


      //This is  to get pricelevelEntry
      public static ACTNSPC__Price_Level_Entry__c getPriceLevelEntry(Product2 productWithTierprice,ACTNSPC__Price_Level__c priceLevel2,ACTNSPC__Currency__c currencyToInsert,String internalId){
            

             
             //priceLevel2.ACTNSPC__Netsuite_Item_Id__c = '545';
             ACTNSPC__Price_Level_Entry__c  priceLevel = new ACTNSPC__Price_Level_Entry__c();
             priceLevel.ACTNSPC__Tier_1_Price__c = 50;
             priceLevel.ACTNSPC__Tier_2_Price__c = 50;
             priceLevel.ACTNSPC__Tier_3_Price__c = 50;
             priceLevel.ACTNSPC__Tier_4_Price__c = 50;
             priceLevel.ACTNSPC__Tier_5_Price__c = 50;
             priceLevel.ACTNSPC__Tier_6_Price__c = 50;
            
             priceLevel.ACTNSPC__Currency__c = currencyToInsert.Id;
             priceLevel.ACTNSPC__Price_Level__c = priceLevel2.Id;
             priceLevel.ACTNSPC__External_Id__c = internalId;
             priceLevel.ACTNSPC__Netsuite_Item_Id__c = internalId;
             priceLevel.ACTNSPC__Product__c = productWithTierprice.Id;
             return priceLevel;
      }

       public static Product2 getProduct(string productFamily,String internalId){
             
            Product2 productWithTierprice = FakeObjectFactory.GetProduct(productFamily);
                     
            productWithTierprice.ACTNSCRM__NetSuite_Internal_ID__c =internalId;
            productWithTierprice.ACTNSCRM__NS_Internal_ID__c = internalId;
            return productWithTierprice;

      }


	
}