public with sharing class FakeObjectFactory {
    
    public static Product2 GetProduct(String productFamiliy)
    {
        Product2 prod = new Product2(Name = productFamiliy,  Family = productFamiliy );
        return prod;
    }

    public static Asset GetProvisionedAsset()
    {
        Asset asset = new Asset();
        asset.InstallDate           =  date.today().addMonths(-5);
        asset.UsageEndDate          =  date.today().addMonths(6) ;
        asset.Name                  =  'Test';
        asset.RecordTypeId          = GetFullLicenceRecordTypeId();
        asset.Status                = 'Provisioned';       
        return asset;
    }

    public static Id GetFullLicenceRecordTypeId()
    {
        RecordType fullLicenceRecordType = [Select Id from RecordType where DeveloperName = 'Full_Licence'];
        return fullLicenceRecordType.Id;
    }

    public static PricebookEntry GetPriceBook(Product2 product, Decimal unitPrice)
    {       
        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id  = pricebookId,
                                                            Product2Id   = product.Id,
                                                            UnitPrice    = unitPrice,
                                                            IsActive     = true);
        return standardPrice;
    }

    public static ACTNSCRM__Currency__c CreateFakeCurrency(String currencyCode)
    {
        ACTNSCRM__Currency__c newCurr = new ACTNSCRM__Currency__c();
        newCurr.ACTNSCRM__ISO_Code__c = currencyCode;
        newCurr.ACTNSCRM__NS_Internal_ID__c = '13';
        newCurr.ACTNSCRM__NetSuite_Internal_ID__c = '13';        
        return newCurr;
    }


    public static Account GetSchoolAccount()
    {
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
      
        Account account             = new Account();
        account.recordTypeId        = schoolRecordTypeId;
        account.Name                = 'Account Name';
        account.status__c           = 'Potential Customer';
        account.ShippingState       = 'New South Wales';
        account.ShippingCountry     = 'Australia';
        account.ShippingPostalCode  = '2060';

        account.BillingStreet       = 'School Street Address';
        account.BillingCity         = 'North Sydney';
        account.BillingState        = 'New South Wales';        
        account.BillingCountry      = 'Australia';
        account.BillingPostalCode   = '2060';

        account.Territory__c        = 'APAC';
        account.Email__c            = 'Test@Test.com';
        return account;
    }

    public static Account GetShareServiceCentreAccount()        
    {       
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Shared Service Center').getRecordTypeId();     
        
        Account account             = new Account();        
        account.recordTypeId        = accountRecordTypeId;      
        account.Name                = 'Shared Service Centre';       
        account.status__c           = 'Potential Customer';     
        account.ShippingState       = 'New South Wales';        
        account.ShippingCountry     = 'Australia';              
        account.ShippingPostalCode  = '2060';

        account.BillingStreet       = 'c/o NSW Government Schools Accounts Payable - Finance Shared Service Centre GPO Box 4037';
        account.BillingCity         = 'Sydney';
        account.BillingState        = 'New South Wales';        
        account.BillingCountry      = 'Australia';
        account.BillingPostalCode   = '2001';          
        
        account.Territory__c        = 'APAC';       
        account.Email__c            = 'Test@Test.com';      
        return account;     
    }
    
    public static Account Get3PAccount()        
    {       
          Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Internal 3PL').getRecordTypeId();     
        
        Account account             = new Account();        
        account.recordTypeId        = accountRecordTypeId;      
        account.Name                = 'Account Name';       
        account.status__c           = 'Potential Customer';     
        account.ShippingState       = 'New South Wales';        
        account.ShippingCountry     = 'Australia';      
        account.ShippingPostalCode  = '2060';       
        account.BillingState        = 'New South Wales';        
        account.BillingCountry      = 'Australia';          
        account.Territory__c        = 'APAC';       
        account.Email__c            = 'Test@Test.com';      
        return account;     
    }          

    

      public static Account GetClusterAccount()
    {
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cluster').getRecordTypeId();
      
        Account account             = new Account();
        account.recordTypeId        = schoolRecordTypeId;
        account.Name                = 'Account Name';
        account.status__c           = 'Potential Customer';
        account.ShippingState       = 'New South Wales';
        account.ShippingCountry     = 'Australia';
        account.ShippingPostalCode  = '2060';
        account.BillingState        = 'New South Wales';
        account.BillingCountry      = 'Australia';   
        account.Territory__c        = 'APAC';
        account.Email__c            = 'Test@Test.com';
        return account;
    }
    
   
    public static ISOMapping__c GetIsoMap()
    {
        ISOMapping__c isoMap    = new ISOMapping__c();
        isoMap.Geo_Code__c      = 'AUS';
        isoMap.ISO2__c          = 'AU';
        isoMap.ISO3__c          = 'AUS';

        return isoMap;
    }

    public static Trigger_Handler__c GetTriggerHandler()
    {
        Trigger_Handler__c triggerHandler                   = new Trigger_Handler__c();        
        triggerHandler.Name                                 = 'Block Trigger';
        triggerHandler.Block_Trigger_Execution__c           = false;

        return triggerHandler;
    }
    
    public static Quote GetQuote()
    {
        Quote  quote = new Quote();
        quote.Name   = 'Quote name';    
        quote.PriceBook2Id =  Test.getStandardPricebookId();
        quote.recordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Approved Quote').getRecordTypeId();
        return quote;
    }

    public static QuoteLineItem GetQuoteLineItem(PricebookEntry pricebookEntry, Integer quantity)
    {
        Id pricebookId = Test.getStandardPricebookId();

        QuoteLineItem  quoteLineItem = new QuoteLineItem();
        quoteLineItem.UnitPrice = 1;
        quoteLineItem.Quantity  = quantity;
        quoteLineItem.ServiceDate  = date.today();
        quoteLineItem.Discount = 0;
        quoteLineItem.PriceBookEntryId = pricebookEntry.Id;
        
        return quoteLineItem;
    }

    public static Attachment GetAttachment()
    {
        Attachment  attachment= new Attachment();
        attachment.body =  Blob.valueof('any attachment');
        attachment.Name = 'attchment name';

        return attachment;
    }

    public static Opportunity GetStandardOpportunity()
    {
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
       

        Opportunity opportunity     = new Opportunity();
        opportunity.Type            = 'New Business';
        opportunity.recordTypeId    = opportunityRecordTypeId;
        opportunity.StageName       = 'Interest';
        opportunity.CloseDate       = Date.today();
        opportunity.Name            = 'New Opportunity';     
        
        return opportunity;
    }

     public static Opportunity GetClusterOpportunity()
    {
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cluster Opportunity').getRecordTypeId();
       

        Opportunity opportunity     = new Opportunity();
        opportunity.Type            = 'New Business';
        opportunity.recordTypeId    = opportunityRecordTypeId;
        opportunity.StageName       = 'Interest';
        opportunity.CloseDate       = Date.today();
        opportunity.Name            = 'New Opportunity';     
        
        return opportunity;
    }

    public static Contact GetContact()
    {   
        Contact contact             = new Contact();
        contact.FirstName           = 'Test FirstName';
        contact.LastName            = 'Test LastName';
        contact.Email               = 'contact@email.com';
        contact.Job_Function__c     = 'Admin';
       
        return contact;

    }

    public static Contact GetFinanceContact()
    {   
        Contact contact             = new Contact();
        contact.FirstName           = 'Test FirstName';
        contact.LastName            = 'Test LastName';
        contact.Email               = 'contact@email.com';
        contact.Job_Function__c     = 'Accounts/Finance';
        contact.Status__c           = 'Current';
        return contact;

    }    

    public static OpportunityContacts__c GetOpportunityContact()
    {   
        OpportunityContacts__c opportunityContact           = new OpportunityContacts__c();
        opportunityContact.Role__c = 'Opportunity Contact';
        return opportunityContact;
    }

     public static OpportunityContacts__c GetAccountPayableContact()
    {   
        OpportunityContacts__c opportunityContact           = new OpportunityContacts__c();
        opportunityContact.Role__c = 'Accounts Payable';
        return opportunityContact;
    }

    public static Asset GetTrialAsset(Product2 product, Date startDate, Date endDate)
    {
        Id trialLicenceRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Trial Licence').getRecordTypeId();
     
        Asset  asset            = new Asset();
        asset.InstallDate       =  startDate;
        asset.UsageEndDate      =  endDate;
        asset.Product2Id        = product.Id;
        asset.recordTypeId      = trialLicenceRecordTypeId;        
        asset.name              = 'Test Name';        
        asset.Status            = 'Provisioned';
        asset.PurchaseDate      = System.today();        
        asset.License_Cap__c    = 1;                   
        
        return asset;
    }

     public static Asset GetFullAsset(Product2 product, Date startDate, Date endDate)
    {
        Id fullLicenceRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Full Licence').getRecordTypeId();
     
        Asset  asset            = new Asset();
        asset.InstallDate       =  startDate;
        asset.UsageEndDate      =  endDate;
        asset.Product2Id        = product.Id;
        asset.recordTypeId      = fullLicenceRecordTypeId;        
        asset.name              = 'Test Full Licence';        
        asset.Status            = 'Provisioned';
        asset.PurchaseDate      = System.today();        
        asset.License_Cap__c    = 1;                   
        
        return asset;
    }

  
    
    public static Opportunity GetCrossSellOpportunity()
    {
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
       

        Opportunity opportunity     = new Opportunity();
        opportunity.Type            = 'Cross Sell';
        opportunity.recordTypeId    = opportunityRecordTypeId;
        opportunity.StageName       = 'Interest';
        opportunity.CloseDate       = Date.today();
        opportunity.Name            = 'New Opportunity';
        
        return opportunity;
    }

    public static Opportunity GetUpSellOpportunity()
    {
        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
       

        Opportunity opportunity     = new Opportunity();
        opportunity.Type            = 'Up Sell';
        opportunity.recordTypeId    = opportunityRecordTypeId;
        opportunity.StageName       = 'Interest';
        opportunity.CloseDate       = Date.today();
        opportunity.Name            = 'New Opportunity';
        
        return opportunity;
    }

   
    public static OpportunityLineItem GetTrialOpportunityLineItem(Opportunity opportunity, Decimal quantity, Decimal totalPrice)
    {           
        OpportunityLineItem  opportunityLineItem        = new OpportunityLineItem ();
        opportunityLineItem.Quantity                    = quantity;
        opportunityLineItem.Provision_Trial_License__c  = true;
        opportunityLineItem.Trial_Start_Date__c         = Date.today();
        opportunityLineItem.OpportunityId               = opportunity.Id;
        opportunityLineItem.TotalPrice                  = totalPrice;// How this feild gets calculated


        return opportunityLineItem;
    }

    public static OpportunityLineItem GetFullOpportunityLineItem(Opportunity opportunity, Decimal quantity, Decimal totalPrice)
    {   

        
        OpportunityLineItem  opportunityLineItem        = new OpportunityLineItem ();
        opportunityLineItem.Quantity                    = quantity;
        opportunityLineItem.Provision_Full_License__c   = true;
        opportunityLineItem.SubscriptionStartDate__c    = Date.today();
        opportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(1);
        opportunityLineItem.OpportunityId               = opportunity.Id;
        opportunityLineItem.TotalPrice                  = totalPrice;// How this feild gets calculated


        return opportunityLineItem;
    }  

     public static OpportunityLineItem GetOtherOpportunityLineItem(Opportunity opportunity, Decimal quantity, Decimal totalPrice)
    {   

        
        OpportunityLineItem  opportunityLineItem        = new OpportunityLineItem ();
        opportunityLineItem.Quantity                    = quantity;   
        opportunityLineItem.OpportunityId               = opportunity.Id;
        opportunityLineItem.TotalPrice                  = totalPrice;// How this feild gets calculated


        return opportunityLineItem;
    }  


   /*public static ContractDetails__c GetValidContract(Account account, Asset asset, Product2 product, Date startDate, Date endDate, PriceBookEntry pricebookEntry, Decimal monthlyPriceUsed )
    {
        Id pricebookId = Test.getStandardPricebookId();

        ContractDetails__c contractDetails = new ContractDetails__c();
        contractDetails.Account__c = account.id;
        contractDetails.Asset__c = asset.id;
        contractDetails.ContractStartDate__c = startDate;
        contractDetails.ContractEndDate__c = endDate;
        contractDetails.ProductFamily__c = product.Family;
        contractDetails.Status__c = 'Valid';
        contractDetails.MonthlyPriceUsed__c = monthlyPriceUsed;
        contractDetails.PriceBook__c = pricebookId;
        contractDetails.LicenceCap__c = 1;

        
        return contractDetails;
    }*/

    public static Excess_Licensing__c GetExcessLicenceRecord(String region, Decimal ignoreThresholdvalue, Decimal thresholdvalue,String productFamily, Boolean aboveThresholdTask,
                                                            String  aboveThresholdStageName,Boolean belowThresholdTask, String belowThresholdStageName)
    {
        Excess_Licensing__c excessLicencing = new Excess_Licensing__c();
        excessLicencing.IsActive__c                             = true;
        excessLicencing.Territory__c                            = region;
        excessLicencing.Ignore_Threshold__c                     = ignoreThresholdvalue;
        excessLicencing.Threshold__c                            = thresholdvalue;
        excessLicencing.Product_Family__c                       = productFamily;

        excessLicencing.More_Than_Threshold_Required_Task__c    = aboveThresholdTask;        
        excessLicencing.Less_Than_Threshold_Stage__c            = aboveThresholdStageName;

        excessLicencing.Less_Than_Threshold_Required_Task__c    = belowThresholdTask;
        excessLicencing.More_Than_Threshold_Stage__c            = belowThresholdStageName;
        excessLicencing.school_type__c                          = 'Government';
        //excessLicencing.Exclusion_End__c                        = Date.today().;
        //excessLicencing.Exclusion_Start__c                      = ;   

        //excessLicencing.Sales_User__c                           = ;
        
        

        return excessLicencing;
    }
	
    public static OpportunityDeletetStagesNotAllowed__c GetOpportunityStagesWhichAreNotAllowedToDelete()
    {
        OpportunityDeletetStagesNotAllowed__c opportuntiyStages                   = new OpportunityDeletetStagesNotAllowed__c();        
        opportuntiyStages.Name                                 = 'Sold';
        opportuntiyStages.StageName__c      = 'Sold';

        return opportuntiyStages;
    }
    
    public static OpportunityDeletetTypeNotAllowed__c GetOpportunityTypesWhichAreNotAllowedToDelete()
    {
        OpportunityDeletetTypeNotAllowed__c opportuntiyTypes                   = new OpportunityDeletetTypeNotAllowed__c();        
        opportuntiyTypes.Name                                 = 'Up Sell';
        opportuntiyTypes.Type__c      = 'Up Sell';

        return opportuntiyTypes;
    }

    public static RecordType__c getRecordTypeCustomSetting()
    {
        RecordType__c recordType   = new RecordType__c();               
        recordType.Name = 'Asset Full Licence';
        recordType.RecordTypeName__c = 'Asset Full Licence';
        recordType.RecordTypeId__c = GetFullLicenceRecordTypeId();
        return recordType;
    }
    
   
    
	public static void testclasssetup()
    {
        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

        Trigger_Handler__c triggerHandler = FakeObjectFactory.GetTriggerHandler();
        insert triggerHandler;
        
        OpportunityDeletetStagesNotAllowed__c OpportunityStages = FakeObjectFactory.GetOpportunityStagesWhichAreNotAllowedToDelete();
        insert OpportunityStages;
       	
        OpportunityDeletetTypeNotAllowed__c OpportunityTypeUpSell = FakeObjectFactory.GetOpportunityTypesWhichAreNotAllowedToDelete();        
        insert OpportunityTypeUpSell;
        
        OpportunityDeletetTypeNotAllowed__c OpportunityTypeRenewal = FakeObjectFactory.GetOpportunityTypesWhichAreNotAllowedToDelete();
        OpportunityTypeRenewal.Name = 'Renewal';
        OpportunityTypeRenewal.Type__c = 'Renewal';
        insert OpportunityTypeRenewal;

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


   


}