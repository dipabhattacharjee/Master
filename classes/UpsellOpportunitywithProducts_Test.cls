//@isTest(SeeAllData=true)
@isTest
public class UpsellOpportunitywithProducts_Test {



@testSetup static void testclasssetup()
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
//Commented first working menthod since changes for OpportunityAsset 
@isTest static void tm_1_UpsellOpportunityButtonClickbyPassingOpportunityandAssetId_UpsellOpportunityCreated() {

        //String productFamily = 'Mathletics';

              
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 
               
        Contact contact  = FakeObjectFactory.GetContact();        
        TestUtility.AssignAccountToContact(account, contact);
        
        insert contact;
        String productFamily = 'Mathletics';  
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        product.name = 'Mathletics - APAC';
        insert product;
        //PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        //insert pricebookEntry;
           // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product.Id,
            UnitPrice = 10, IsActive = true);
        insert standardPrice;
        // Create a custom price book
        Pricebook2 pricebook = new Pricebook2(Name='*Standard', isActive=true);
        insert pricebook;

         PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebook.Id, Product2Id = product.Id,
            UnitPrice = 12, IsActive = true);
        insert pricebookEntry;

        //Product2 product = [Select Id,Name from Product2 where Name like 'Mathletics - APAC'];
        //Pricebook2 pricebook = [Select Id, Name from PriceBook2 where Name like '*Standard'];
        //PriceBookEntry pricebookEntry = [Select Id,Name from PricebookEntry where Pricebook2Id  =: pricebook.Id and Product2Id   =: product.Id];
       
        Integer MAX_QUERY = Limits.getLimitQueries(); 
        Integer NUM_QUERY = MAX_QUERY - 1; 


        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.EBS_Approval__c = True;
        fullOpportunity.Number_of_years__c = '2';
        fullOpportunity.Multi_Year_Deal__c = true;
        insert fullOpportunity;

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
        fullOpportunityLineItem.SubscriptionStartDate__c    = Date.today();
        fullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(1);

        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);
        insert fullOpportunityLineItem;
        System.debug('This is to test hello here me' + fullOpportunityLineItem);
              
        OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
        TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, fullOpportunity.Id);
        insert opportunityContact;

        OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
        TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, fullOpportunity.Id);
        insert accountPayableContact;

        Attachment attachment = FakeObjectFactory.GetAttachment();
        TestUtility.SetOpportunityAttachment(fullOpportunity, attachment );
        insert attachment;

       

        //Move opportunity to Full stage
        TestUtility.MoveOpportunityToSold(fullOpportunity);
        update fullOpportunity;
        Test.startTest();   

        TestUtility.MoveOpportunityToSoldInvoiced(fullOpportunity);
        update fullOpportunity;
  
    
        Asset asset =      [select
                                            Id, InstallDate, Name, Product_Type__c, Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,
                                            ProductFamily__c,License_Cap__c,Product2Id,Registered_students_licence_cap__c
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];


        
        UpsellOpportunitywithProducts upsellOpportunitywithProducts                     = new UpsellOpportunitywithProducts();
       
        //CreateUpsellOpportunityfromAssetButton createUpsellOpportunityfromAssetButton   = new CreateUpsellOpportunityfromAssetButton();

        CreateUpsellOpportunityfromAssetButton.CreateUpsellOpportunity(asset.Id);



        //UpsellOpportunitywithProducts buttonClickwithOpportunityandAssetid = new UpsellOpportunitywithProducts();
        //buttonClickwithOpportunityandAssetid.CreateUpsellOpportunity(asset,fullOpportunity.Id);

        //upsellOpportunitywithProducts_Bulk.CreateUpsellOpportunity

        
        
        List<Opportunity> upsellOpportunity = [select Id, Name, StageName, Type
                                                FROM 
                                                    Opportunity 
                                                WHERE                                           
                                                    Type = 'Up Sell' and AccountId = :account.Id];

        //System.assertEquals(1                      , upsellOpportunity.size());
        
       Test.stopTest();
       

    }
      
    
/*@isTest static void tm_2_UpsellOpportunityButtonClickbyPassingonlyAssetId_UpsellOpportunityCreated() {

        

              
        String productFamily = 'Mathletics';
        
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account;
        
        Product2 product = [Select Id,name from Product2 where Name = 'Mathletics-Site-Special-APAC'];
        Pricebook2 pricebook = [Select Id,Name from Pricebook2 where Name = '*Subsidised/Special Rate'];
        PricebookEntry pricebookentry = [Select Id from PricebookEntry 
        where Pricebook2Id  =: pricebook.Id and product2id   =: product.Id];
       
        Asset asset = FakeObjectFactory.GetFullAsset(product, date.today(), date.today().addDays(20));
        asset.AccountId = account.Id;        
        insert asset; 
        
 
  
    //System.assertEquals(0, Limits.getQueries());
        Asset assetqueried =      [select
                                            Id, InstallDate, Name, Product_Type__c, Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,
                                            ProductFamily__c,License_Cap__c,Product2Id,AccountId
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];


        
     
       
        UpsellOpportunitywithProducts buttonClickwithOpportunityandAssetid = new UpsellOpportunitywithProducts();
         buttonClickwithOpportunityandAssetid.CreateUpsellOpportunity(assetqueried);

        
        
            List<Opportunity> upsellOpportunity = [select Id, Name, StageName, Type
                                                    FROM 
                                                        Opportunity 
                                                    WHERE                                           
                                                        Type = 'Up Sell' and AccountId = :account.Id];

            System.assertEquals(1                      , upsellOpportunity.size());
        Test.stopTest();
       

    }*/






/*
    @isTest static void tm_2_UpsellOpportunityButtonClickwithoutPassingOpportunityandAssetId_StandardUpsellOpportunityCreated() {

        String productFamily = 'Mathletics';
                
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

        Contact contact  = FakeObjectFactory.GetContact();
        TestUtility.AssignAccountToContact(account, contact);
        insert contact;

        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;
   
        Pricebook2 pb = new pricebook2(name='*Standard');
        insert pb;

        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=product.id,unitprice=1.0, isActive=true);
        insert pbe;

        Pricebook2 pb2 = new pricebook2(name='*International Standard');
        insert pb2;

        PricebookEntry pbe2 = new PricebookEntry(pricebook2id=pb2.id, product2id=product.id,unitprice=1.0, isActive=true);
        insert pbe2;

        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;

        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
        fullOpportunityLineItem.SubscriptionStartDate__c    = Date.today();
        fullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(1);

        TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);
        insert fullOpportunityLineItem;

              
        OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
        TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, fullOpportunity.Id);
        insert opportunityContact;

        OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
        TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, fullOpportunity.Id);
        insert accountPayableContact;

        Attachment attachment = FakeObjectFactory.GetAttachment();
        TestUtility.SetOpportunityAttachment(fullOpportunity, attachment );
        insert attachment;

        Quote quote = FakeObjectFactory.GetQuote();

        quote.OpportunityId = fullOpportunity.Id;
        insert quote;

        QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
        quoteLineItem.QuoteId = quote.Id;
        quoteLineItem.Product2Id = product.Id;
        insert quoteLineItem;

        quote.Status = 'Approved';
        update quote;

        //Move opportunity to Full stage
        TestUtility.MoveOpportunityToSold(fullOpportunity);
        update fullOpportunity;
        
        TestUtility.MoveOpportunityToSoldInvoiced(fullOpportunity);
        update fullOpportunity;

        Asset asset =      [select
                                            Id, InstallDate, Name, Product_Type__c, Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,
                                            ProductFamily__c,License_Cap__c
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];



        ContractDetails__c contractDetail = FakeObjectFactory.GetValidContract(account, asset, product, System.today(), System.today().addMonths(1), pricebookEntry, 1);        
        insert contractDetail;

        // === 
       

           // UpsellOpportunitywithProducts buttonClickwithoutOpportunityandAssetid = new UpsellOpportunitywithProducts();
           // buttonClickwithoutOpportunityandAssetid.CreateUpsellOpportunity(asset);

        Test.startTest();
            List<Opportunity> upsellOpportunity = [select Id, Name, StageName, Type
                                                    FROM 
                                                        Opportunity 
                                                    WHERE                                           
                                                        Type = 'Up Sell'];

            // System.assertEquals(1                      , upsellOpportunity.size());

        Test.stopTest();

    }
    */
    
}