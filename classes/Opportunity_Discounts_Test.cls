@isTest
private class Opportunity_Discounts_Test {
	
	@testSetup static void setup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

        Trigger_Handler__c triggerHandler = FakeObjectFactory.GetTriggerHandler();
        insert triggerHandler;

        String mathletics = 'Mathletics';
        insert new LicencedProduct__c(ProductFamily__c = mathletics, Name = mathletics);
        
        String spellodrome = 'Spellodrome';
        insert new LicencedProduct__c(ProductFamily__c = spellodrome, Name = spellodrome);

        insert new RegionTaxSetting__c( Name                    = 'APAC',
                                        RegionName__c           = 'APAC',
                                        SiteCountry__c          = 'OTHER',
                                        TaxCode__c              = 'EXPS-AU',
                                        TaxCodeInternalId__c    = '10',
                                        TaxRate__c              = 0); 

        Service_EndPoints__c endPoint1 = new Service_EndPoints__c();
        endPoint1.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint1.Name = 'Contact Service';
        insert endPoint1;


        Service_EndPoints__c endPoint = new Service_EndPoints__c();
        endPoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        endPoint.Name = 'Account Service';
        insert endPoint;

        System.debug('setup done');

    }

	
	@isTest static void OpportunityLineItem_withoutDiscountedPrice_DiscountgivenByUser_DiscountValueRetained_0F2() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 60;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(60           , opportunityProduct[0].Discount);
		System.assertEquals('2 Year Agreement'  , opportunityProduct[0].DiscountReason__c);
	}	


	@isTest static void CreateOpportunity_AssociateCampaign_DiscountPopulated_OnOpportunityProduct() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;

        AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        //fullOpportunityLineItem.Discount = 60;
        //fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(25           , opportunityProduct[0].Discount);
		System.assertEquals('Campaign Discount'           , opportunityProduct[0].DiscountReason__c);
	}	


		@isTest static void CreateOpportunity_AssociateCampaign_DiscountPopulated_ManualDiscountMorethanCampaignDiscount_ManualDiscountPopulated() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;

        AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 60;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(60           , opportunityProduct[0].Discount);
		System.assertEquals('2 Year Agreement'  , opportunityProduct[0].DiscountReason__c);
	}


	@isTest static void CreateOpportunity_AssociateCampaign_DiscountPopulated_ManualDiscountLessthanCampaignDiscount_ManualDiscountPopulated() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;

        AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 20;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(25           , opportunityProduct[0].Discount);
		System.assertEquals('Campaign Discount'           , opportunityProduct[0].DiscountReason__c);
	}

	@isTest static void CreateOpportunity_DiscountPopulated_AssociatedCampaign_ManualDiscountLessthanCampaignDiscount_CampaignDiscountPopulated() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;       

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 20;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;

        AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(25           , opportunityProduct[0].Discount);
		System.assertEquals('Campaign Discount'           , opportunityProduct[0].DiscountReason__c);
	}

	@isTest static void CreateOpportunity_DiscountPopulated_AssociatedCampaign_ManualDiscountMorethanCampaignDiscount_ManualDiscountRetained() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;        

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 40;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;

        AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(40           , opportunityProduct[0].Discount);
		System.assertEquals('2 Year Agreement'           , opportunityProduct[0].DiscountReason__c);
	}

	@isTest static void CreateOpportunity_DiscountPopulated_AssociatedCampaign_Again_Remove_TheCampaign_Discount_Should_0_ReasonNULL() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

		Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;        

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        //fullOpportunityLineItem.Discount = 40;
       // fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;

        AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;
		fullOpportunity.CampaignId = null;
		update fullOpportunity;
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,Description,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(0          , opportunityProduct[0].Discount);
		 //System.assertEquals('Check ths'         , opportunityProduct[0].Description);
		System.assertEquals(null           , opportunityProduct[0].DiscountReason__c);
	}

	@isTest static void CreateOpportunity_DiscountPopulated_AssociatedCampaign_AndREmoveCampaign() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;  
		
		AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity;      

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 40;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;
		
		fullOpportunity.campaignId = null;
		update fullOpportunity;
		
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(40           , opportunityProduct[0].Discount);
		System.assertEquals('2 Year Agreement'           , opportunityProduct[0].DiscountReason__c);
	}

	@isTest static void CreateOpportunity_DiscountPopulated20_AssociatedCampaign25_Remove_campaign() {

		String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;       

        Campaign campaign = GetSchoolStdCampaign('New Campaign');
        insert campaign;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;  
		
		     

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 100,1000 );        
        fullOpportunityLineItem.Discount = 20;
        fullOpportunityLineItem.DiscountReason__c = '2 Year Agreement';
        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);        
        insert fullOpportunityLineItem;
		
		AssignCampaignToOpportunity(fullOpportunity, campaign);
        Update fullOpportunity; 

		fullOpportunity.campaignId = null;
		update fullOpportunity;
		
		
        List<OpportunityLineItem> opportunityProduct = [Select Id, Discount,DiscountReason__c,DiscountedPrice__c,TotalPrice,Subtotal,Name,Opportunity.CampaignId from OpportunityLineItem where OpportunityId = :fullOpportunity.Id];
        System.Debug( 'Testing opportunityProduct' + opportunityProduct);

        System.assertEquals(0           , opportunityProduct[0].Discount);
		System.assertEquals(null           , opportunityProduct[0].DiscountReason__c);
	}	

    public static Campaign GetSchoolStdCampaign(String campaignName)
    {           
        Campaign  campaign        			= new Campaign ();
        campaign.Name               		= campaignName;
        campaign.IsActive   				= true;
        campaign.Status    					= 'campaignName';
        campaign.Type      					= 'campaignName';
        campaign.Discount__c        		= 25;
        campaign.Job_Code__c        		= '1234567890';
        campaign.Product_Family__c			= 'Mathletics';
		campaign.School_Type__c				= 'School';
		campaign.Job_Code_Internal_id__c 	= '123456';

        return campaign;
    }

    public static void AssignCampaignToOpportunity(Opportunity opportunity, Campaign campaign)
    {
            opportunity.CampaignId = campaign.Id;
    }
 

}