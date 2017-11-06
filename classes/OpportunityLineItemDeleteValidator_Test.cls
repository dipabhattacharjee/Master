@isTest
public class OpportunityLineItemDeleteValidator_Test {

    @testSetup static void setup()
    {
    	// FakeObjectFactory.testclasssetup();
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
    
    @isTest private static void DeleteOpportunityLineItem_AssetAssociatedSameFamily_OpportunityLineItemShouldNotBeDeleted()
    {
       	String productFamily = 'Mathletics';    
        Account account  = FakeObjectFactory.GetSchoolAccount();        
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;
        
        Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
        TestUtility.AssignOpportunityToAccount(trialOpportunity, account);
        insert trialOpportunity;

        OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
        TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
        insert trialOpportunityLineItem ;

        //Move opportunity to Trial stage
        TestUtility.MoveOpportunityToTrial(trialOpportunity);

        update trialOpportunity;       

        List<Asset> assets =        [select
                                        Id, InstallDate, Name, Product_Type__c, Status,
                                        Type_of_License__c, UsageEndDate , Opportunity__c,
                                        ProductFamily__c
                                    FROM 
                                        Asset 
                                    WHERE                                           
                                        AccountId           = :account.Id];

                                        
        
        System.assertEquals(1                    , assets.size());
        System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
        System.assertEquals('Provisioned'        , assets[0].Status);
        
        String responseMessage = '';
        try 
        {           
            delete trialOpportunityLineItem;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete opportuntiy LineItem having licence'));
    }
    
    @isTest private static void DeleteOpportunityLineItem_LineItemFromDifferentFamilyThanLincenceFamily_OpportunityLineItemShouldBeDeleted()
    {
       	String productFamily = 'Mathletics';   
        String productFamilySpello = 'Spellodrome';  
        Account account  = FakeObjectFactory.GetSchoolAccount();        
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
        
        Product2 productSpello = FakeObjectFactory.GetProduct(productFamilySpello);
        insert productSpello;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;
        
        PricebookEntry pricebookEntrySpello = FakeObjectFactory.GetPriceBook(productSpello, 1);   
        insert pricebookEntrySpello;
        
        Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
        TestUtility.AssignOpportunityToAccount(trialOpportunity, account);
        insert trialOpportunity;

        OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
        TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
        insert trialOpportunityLineItem ;        

        //Move opportunity to Trial stage
        TestUtility.MoveOpportunityToTrial(trialOpportunity);

        update trialOpportunity;       

        List<Asset> assets =        [select
                                        Id, InstallDate, Name, Product_Type__c, Status,
                                        Type_of_License__c, UsageEndDate , Opportunity__c,
                                        ProductFamily__c
                                    FROM 
                                        Asset 
                                    WHERE                                           
                                        AccountId           = :account.Id];

                                        
        
        System.assertEquals(1                    , assets.size());
        System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
        System.assertEquals('Provisioned'        , assets[0].Status);
        
        OpportunityLineItem trialOpportunityLineItemSpello = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
        TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItemSpello , pricebookEntrySpello);
        insert trialOpportunityLineItemSpello ;       
       
        delete trialOpportunityLineItemSpello;
        
        List<OpportunityLineItem> OLI = [Select Id from OpportunityLineItem where OpportunityId = :trialOpportunity.Id];        
        System.assertEquals(1                    , OLI.size());       
        
    }
    
    @isTest private static void TrialOpportunity_OnChangingPriceBook_OpportunityLineItemShouldBeDeleted()
    {
       	String productFamily = 'Mathletics';   
        String productFamilySpello = 'Spellodrome';  
        Account account  = FakeObjectFactory.GetSchoolAccount();        
        insert account; 
        
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
        
        Product2 productSpello = FakeObjectFactory.GetProduct(productFamilySpello);
        insert productSpello;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;
        
        Pricebook2 newpricebook = new pricebook2(name='test');
		insert newpricebook;
        //Id newpricebookId = Test.getStandardPricebookId();
        
        //PricebookEntry pricebookEntrySpello = FakeObjectFactory.GetPriceBook(productSpello, 1);   
        //insert pricebookEntrySpello;
        
        Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
        TestUtility.AssignOpportunityToAccount(trialOpportunity, account);
        insert trialOpportunity;

        OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
        TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
        insert trialOpportunityLineItem;

        //Move opportunity to Trial stage
        TestUtility.MoveOpportunityToTrial(trialOpportunity);

        update trialOpportunity;       

        List<Asset> assets =        [select
                                        Id, InstallDate, Name, Product_Type__c, Status,
                                        Type_of_License__c, UsageEndDate , Opportunity__c,
                                        ProductFamily__c
                                    FROM 
                                        Asset 
                                    WHERE                                           
                                        AccountId           = :account.Id];                                        
        
        System.assertEquals(1                    , assets.size());
        System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
        System.assertEquals('Provisioned'        , assets[0].Status);
        
        trialOpportunity.StageName = 'Negotiation';
        Update trialOpportunity;
        
        trialOpportunity.Pricebook2Id = newpricebook.Id;
        
        String responseMessage = '';
        try 
        {           
             Update trialOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('cannot change pricebook on opportunity with line items'));
        
        //List<OpportunityLineItem> OLI = [Select Id from OpportunityLineItem where OpportunityId = :trialOpportunity.Id];        
        //System.assertEquals(0                    , OLI.size());       
        
    }
    
}