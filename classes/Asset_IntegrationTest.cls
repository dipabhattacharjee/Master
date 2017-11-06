@isTest
public class Asset_IntegrationTest
{
    static Opportunity testOpportunity;
    static Account testAccount;

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
                                        SiteCountry__c          = 'Australia',
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

         Service_EndPoints__c licenceEndpoint = new Service_EndPoints__c();
        licenceEndpoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        licenceEndpoint.Name = 'School Licence Service';
        insert licenceEndpoint;

        Service_EndPoints__c authenticationEndpoint = new Service_EndPoints__c();
        authenticationEndpoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        authenticationEndpoint.Name = 'Authorization Service';
        insert authenticationEndpoint;

        System.debug('setup done');

        System.debug('Setting up new account and opportunity');

        String productFamily = 'Mathletics';    
        testAccount  = FakeObjectFactory.GetSchoolAccount();        
        insert testAccount; 
        
        Contact contact  = FakeObjectFactory.GetContact();  
        TestUtility.AssignAccountToContact(testAccount, contact);
        insert contact;

      

        Contact_Roles__c role = new Contact_Roles__c();
        role.Account__c =  testAccount.Id;
        role.Contact__c =  contact.Id;
        role.Role__c    = 'Accounts Payable';
        role.MInfluencer__c = true;
        role.Role_Status__c = 'Current';
        role.School_Territory__c  = 'APAC';
        insert role;

        Contact_Roles__c contactRole=[select id,Account__c,Contact__c,Role__c from Contact_Roles__c where Id= :role.Id ][0];
        
        system.debug('getting contact role ' + contactRole);

        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;
        
        testOpportunity = FakeObjectFactory.GetStandardOpportunity();
        testOpportunity.Type = 'Renewal';        
        TestUtility.AssignOpportunityToAccount(testOpportunity, testAccount);
        testOpportunity.EBS_Approval__c = true;
        insert testOpportunity;
 
       
        
         OpportunityLineItem opportunityLineItem1 = FakeObjectFactory.GetTrialOpportunityLineItem(testOpportunity, 1 ,1 );
        TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem1, pricebookEntry);
        insert opportunityLineItem1;

        OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
        TestUtility.SetOpportunityContact(opportunityContact, testAccount.Id , contact.Id, testOpportunity.Id);
        
        insert opportunityContact;

        OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
        TestUtility.SetOpportunityContact(accountPayableContact, testAccount.Id , contact.Id, testOpportunity.Id);
        insert accountPayableContact;
 
        Attachment attachment = FakeObjectFactory.GetAttachment();
        TestUtility.SetOpportunityAttachment(testOpportunity, attachment );
        insert attachment;

        // Quote quote = FakeObjectFactory.GetQuote();

        // quote.OpportunityId = opportunity.Id;
        // insert quote;

        // QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
        // quoteLineItem.QuoteId = quote.Id;
        // quoteLineItem.Product2Id = product.Id;
        // insert quoteLineItem;

        // quote.Status = 'Approved';
        // update quote;


    }

    @isTest
    static void RenewalMathleticsOpportunity_WithoutHavingAnyExistingTrialAssets_OneTrialAssetShouldBeCreated()
    {    
       Opportunity opportunity = [select Id, StageName,CloseDate,Type,Start_Date__c,End_Date__c from Opportunity ][0];
        Account account = [select Id, Name from Account ][0];
        //Move opportunity to Trial stage
        TestUtility.MoveOpportunityToTrial(opportunity);

        Database.update(opportunity); 
        

        System.debug('Opportunity Id: ' + opportunity.Id + ' StageName: '+ opportunity.StageName + ' Type: ' + opportunity.Type + ' Account Id: ' + account.Id + 
                ' Start Date: ' + opportunity.Start_Date__c + ' End Date: ' + opportunity.End_Date__c + ' Close Date: ' + opportunity.CloseDate);

        //Get all assets for the created account
        List<Asset> assets =         [select
                                            Id, InstallDate, Name, Product_Type__c, Status,
                                            Type_of_License__c, UsageEndDate , Opportunity__c,
                                            ProductFamily__c
                                        FROM 
                                            Asset 
                                        WHERE                                           
                                            AccountId           = :account.Id];

                                        
        
        System.assertEquals(1                        , assets.size());
        System.assertEquals('Trial Licence'           , assets[0].Type_of_License__c);
        System.assertEquals('Provisioned'            , assets[0].Status);
        System.assertEquals(Date.today()             , assets[0].InstallDate);      
                
    }



    


   

 
//    @isTest
//     static void NewMathleticsOpportunity_HavingAccountWithProvisionedTrialLicence_MoveOpportunityToSoldWithDateConflicts_ThrowsValidationException()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         insert account; 
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
//         TestUtility.AssignOpportunityToAccount(trialOpportunity, account);
//         insert trialOpportunity;

//         OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
//         insert trialOpportunityLineItem ;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(trialOpportunity);

//         update trialOpportunity;

//         System.debug('First OPTY Converted: ' + trialOpportunity.StageName);

//         List<Asset> assets =        [select
//                                         Id, InstallDate, Name, Product_Type__c, Status,
//                                         Type_of_License__c, UsageEndDate , Opportunity__c,
//                                         ProductFamily__c
//                                     FROM 
//                                         Asset 
//                                     WHERE                                           
//                                         AccountId           = :account.Id];

                                        
        
//         System.assertEquals(1                    , assets.size());
//         System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'        , assets[0].Status);

//         assets[0].status = 'Provisioned';

//         update assets[0];   

//          assets =        [select
//                                 Id, InstallDate, Name, Product_Type__c, Status,
//                                 Type_of_License__c, UsageEndDate , Opportunity__c,
//                                 ProductFamily__c
//                             FROM 
//                                 Asset 
//                             WHERE                                           
//                                 AccountId           = :account.Id];

//         System.assertEquals('Provisioned'                , assets[0].Status);                               
        
//         Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//         TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
//         insert fullOpportunity;

//         OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);
//         insert fullOpportunityLineItem;

//         //Move opportunity to Full stage
//         TestUtility.MoveOpportunityToSold(fullOpportunity ); 

//         String responseMessage = '';
//         try 
//         {           
//             update fullOpportunity;              
//         } 
//         catch(Exception e) 
//         {           
//             responseMessage = e.getMessage();           
//         }   
        
//         // This Line will always execute even after the catch block
//         System.debug('Response Message: ' + responseMessage);
//         System.assert(responseMessage.contains('There is already a provisioned Trial licence for this product'));   
        
//     }
  
   
    
//   @isTest
//     static void NewMathleticsFutureTrialOpportunity_HavingAccountWithProvisionedTrialLicence_MoveOpportunityToTrialWithTrialStartFutureDates_FutureTrialAssetShouldBeCreated()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();        
//         insert account; 
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
//         TestUtility.AssignOpportunityToAccount(trialOpportunity, account);
//         insert trialOpportunity;

//         OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
//         insert trialOpportunityLineItem ;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(trialOpportunity);

//         update trialOpportunity;

//         System.debug('First Trial OPTY Converted: ' + trialOpportunity.StageName);

//         List<Asset> assets =        [select
//                                         Id, InstallDate, Name, Product_Type__c, Status,
//                                         Type_of_License__c, UsageEndDate , Opportunity__c,
//                                         ProductFamily__c
//                                     FROM 
//                                         Asset 
//                                     WHERE                                           
//                                         AccountId           = :account.Id];

                                        
        
//         System.assertEquals(1                    , assets.size());
//         System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'        , assets[0].Status);

//         assets[0].status = 'Provisioned';

//         update assets[0];   

//          assets =        [select
//                                 Id, InstallDate, Name, Product_Type__c, Status,
//                                 Type_of_License__c, UsageEndDate , Opportunity__c,
//                                 ProductFamily__c
//                             FROM 
//                                 Asset 
//                             WHERE                                           
//                                 AccountId           = :account.Id];

//         System.assertEquals('Provisioned'                , assets[0].Status);                               
        
//         //TODO: It's Hack needs to discuss, once one attached opportunity move to trial then second one can't even for futre because of account stage
//         //SetGivenStatusToAccount(account, 'Potential Customer');
//         //update account;
        
//         Opportunity futureTrialOpportunity = FakeObjectFactory.GetCrossSellOpportunity();    
//         TestUtility.AssignOpportunityToAccount(futureTrialOpportunity, account);
//         insert futureTrialOpportunity;
    
//         OpportunityLineItem futureTrialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(futureTrialOpportunity, 1 ,1 );
//         futureTrialOpportunityLineItem.Trial_Start_Date__c         = Date.today().addDays(15);
//         TestUtility.SetOpportunityLineItem_PriceBook(futureTrialOpportunityLineItem , pricebookEntry);
//         insert futureTrialOpportunityLineItem;
    
//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(futureTrialOpportunity);
    
//         update futureTrialOpportunity;        
        
//         assets =        [select
//                                 Id, InstallDate, Name, Product_Type__c, Status,
//                                 Type_of_License__c, UsageEndDate , Opportunity__c,
//                                 ProductFamily__c
//                             FROM 
//                                 Asset 
//                             WHERE                                           
//                                 AccountId           = :account.Id];

                                        
        
//         System.assertEquals(2                    , assets.size());
//         System.assertEquals('Trial Licence'      , assets[1].Type_of_License__c);
//         System.assertEquals('Provisioned'        , assets[1].Status);
        
//     }
//  @isTest
//     static void NewTrialMathleticsOpportunity_MovingToTrialStage_OneTrialAssetShouldBeCreated()
//     {           
//         String productFamily = 'Mathletics';
        
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         insert account;
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;
//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);    
//         insert pricebookEntry;   
        
//         Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
//         TestUtility.AssignOpportunityToAccount(opportunity, account);
//         insert opportunity;

//         OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(opportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
//         insert opportunityLineItem;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(opportunity);
//         update opportunity;
    
//         //Get all assets for the created account
//         List<Asset> assets =         [select
//                                             Id, InstallDate, Name, Product_Type__c, Status,
//                                             Type_of_License__c, UsageEndDate , Opportunity__c,
//                                             ProductFamily__c
//                                         FROM 
//                                             Asset 
//                                         WHERE                                           
//                                             AccountId           = :account.Id];
 
//         for(Asset asset: assets)
//         {
//             System.debug('productFamily:' + asset.ProductFamily__c + ', Type_of_License__c:' + asset.Type_of_License__c + ', Status:' + asset.Status );
//         }

            
//         System.assertEquals(1               , assets.size());
//         System.assertEquals('Trial Licence' , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'   , assets[0].Status);
//         System.assertEquals(Date.today()    , assets[0].InstallDate);
    
//     }

    // @isTest
    // static void CreateTrialAsset_AssignToAccount_AccountShouldHaveOneTrialAsset()
    // {           
    //     String productFamily = 'Mathletics';
        
    //     Account account  = FakeObjectFactory.GetSchoolAccount();
    //     insert account;
        
    //     Product2 product = FakeObjectFactory.GetProduct(productFamily);
    //     insert product;
       
    //     Asset asset = FakeObjectFactory.GetTrialAsset(product, date.today(), date.today().addDays(20));
    //     asset.AccountId = account.Id;

    //     insert asset;
    
    //     //Get all assets for the created account
    //     List<Asset> assets =         [select
    //                                         Id, InstallDate, Name, Product_Type__c, Status,
    //                                         Type_of_License__c, UsageEndDate , Opportunity__c,
    //                                         ProductFamily__c
    //                                     FROM 
    //                                         Asset 
    //                                     WHERE                                           
    //                                         AccountId           = :account.Id];
 
    //     for(Asset asset1: assets)
    //     {
    //         System.debug('productFamily:' + asset1.ProductFamily__c + ', Type_of_License__c:' + asset1.Type_of_License__c + ', Status:' + asset1.Status );
    //     }

            
    //     System.assertEquals(1               , assets.size());
    //     System.assertEquals('Trial Licence' , assets[0].Type_of_License__c);
    //     System.assertEquals('Provisioned'   , assets[0].Status);
    //     System.assertEquals(Date.today()    , assets[0].InstallDate);
    
    // }
  
//    @isTest
//     static void NewMathleticsTrialOpportunityWithDateConflicts_HavingAccountWithProvisionedTrialLicence_MoveOpportunityToTrial_ThrowsValidationException()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         insert account; 
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity firstTrialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
//         TestUtility.AssignOpportunityToAccount(firstTrialOpportunity, account);
//         insert firstTrialOpportunity;

//         OpportunityLineItem firstTrialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(firstTrialOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(firstTrialOpportunityLineItem, pricebookEntry);
//         insert firstTrialOpportunityLineItem;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(firstTrialOpportunity);

//         update firstTrialOpportunity;

//         System.debug('First OPTY Converted: ' + firstTrialOpportunity.StageName);

//         List<Asset> assets =        [select
//                                         Id, InstallDate, Name, Product_Type__c, Status,
//                                         Type_of_License__c, UsageEndDate , Opportunity__c,
//                                         ProductFamily__c
//                                     FROM 
//                                         Asset 
//                                     WHERE                                           
//                                         AccountId           = :account.Id];

                                        
        
//         System.assertEquals(1                    , assets.size());
//         System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'        , assets[0].Status);
                        
        
//         Opportunity secondTrialOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//         TestUtility.AssignOpportunityToAccount(secondTrialOpportunity, account);
//         insert secondTrialOpportunity;

//         OpportunityLineItem secondTrialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(secondTrialOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(secondTrialOpportunityLineItem, pricebookEntry);
//         insert secondTrialOpportunityLineItem;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(secondTrialOpportunity); 

//         String responseMessage = '';
//         try 
//         {           
//             update secondTrialOpportunity;              
//         } 
//         catch(Exception e) 
//         {           
//             responseMessage = e.getMessage();           
//         }   
        
//         // This Line will always execute even after the catch block
//         System.debug('Response Message: ' + responseMessage);
//         System.assert(responseMessage.contains('There is already a provisioned Trial licence for this product'));   
        
//     }
       

//     @isTest
//     static void SettingSubscriptionDatesForFutureFullAsset_HavingAccountWithProvisionedTrialLicence_MoveOpportunityToFullWithSubscriptionFutureDates_FutureAssetShouldBeCreated()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();        
//         insert account; 
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         Contact contact  = FakeObjectFactory.GetContact();        
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();    
//         TestUtility.AssignOpportunityToAccount(opportunity, account);
//         insert opportunity;

//         OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(opportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem , pricebookEntry);
//         insert opportunityLineItem ;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(opportunity);

//         update opportunity;

//         System.debug('First Trial OPTY Converted: ' + opportunity.StageName);

//         List<Asset> assets =        [select
//                                         Id, InstallDate, Name, Product_Type__c, Status,
//                                         Type_of_License__c, UsageEndDate , Opportunity__c,
//                                         ProductFamily__c
//                                     FROM 
//                                         Asset 
//                                     WHERE                                           
//                                         AccountId           = :account.Id];

                                        
        
//         System.assertEquals(1                    , assets.size());
//         System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'        , assets[0].Status);    
        
//         //TODO: It's Hack needs to discuss, once one attached opportunity move to trial then second one can't even for futre because of account stage
//         //SetGivenStatusToAccount(account, 'Potential Customer');
//         //update account;
        
//         Test.startTest(); 

//         TestUtility.SetFullOpportunityLineItem(opportunityLineItem, Date.today().addDays(20), Date.today().addMonths(2));    

//         update opportunityLineItem;


//         OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//         TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);
//         insert opportunityContact;

//         OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//         TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);
//         insert accountPayableContact;

//         Attachment attachment = FakeObjectFactory.GetAttachment();
//         TestUtility.SetOpportunityAttachment(opportunity, attachment );
//         insert attachment;

//         Quote quote = FakeObjectFactory.GetQuote();

//         quote.OpportunityId = opportunity.Id;
//         insert quote;

//         QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//         quoteLineItem.QuoteId = quote.Id;
//         quoteLineItem.Product2Id = product.Id;
//         insert quoteLineItem;

//         quote.Status = 'Approved';
//         update quote;
            

//         //Move opportunity to Full stage
//         TestUtility.MoveOpportunityToSold(opportunity);         

//         update opportunity;
        
//         assets =        [select
//                                 Id, InstallDate, Name, Product_Type__c, Status,
//                                 Type_of_License__c, UsageEndDate , Opportunity__c,
//                                 ProductFamily__c
//                             FROM 
//                                 Asset 
//                             WHERE                                           
//                                 AccountId           = :account.Id];

                                        
        
//         System.assertEquals(2                   , assets.size());
//         System.assertEquals('Full Licence'      , assets[1].Type_of_License__c);
//         System.assertEquals('Provisioned'       , assets[1].Status);
        
//         Test.stopTest(); 
//     }
   
    
    
//     @isTest
//     static  void NewMathleticsFutureRenewalOpportunity_HavingAccountWithProvisionedFullLicence_MoveRenewalOpportunityToFullWithSubscriptionFutureDates_FutureAssetShouldBeCreated()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();        
//         insert account; 
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         Contact contact  = FakeObjectFactory.GetContact();        
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         {
//             Opportunity firstFullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//             TestUtility.AssignOpportunityToAccount(firstFullOpportunity, account);
//             insert firstFullOpportunity;
            

//             OpportunityLineItem firstFullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(firstFullOpportunity, 1 ,1 );
//             TestUtility.SetOpportunityLineItem_PriceBook(firstFullOpportunityLineItem , pricebookEntry);
//             insert firstFullOpportunityLineItem ;

//              OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//             TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, firstFullOpportunity.Id);
//             insert opportunityContact;

//             OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//             TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, firstFullOpportunity.Id);
//             insert accountPayableContact;

//             Attachment attachment = FakeObjectFactory.GetAttachment();
//             TestUtility.SetOpportunityAttachment(firstFullOpportunity, attachment );
//             insert attachment;

//             Quote quote = FakeObjectFactory.GetQuote();

//             quote.OpportunityId = firstFullOpportunity.Id;
//             insert quote;

//             QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//             quoteLineItem.QuoteId = quote.Id;
//             quoteLineItem.Product2Id = product.Id;
//             insert quoteLineItem;

//             quote.Status = 'Approved';
//             update quote;

//             //Move opportunity to Full stage
//             TestUtility.MoveOpportunityToSold(firstFullOpportunity);

//             update firstFullOpportunity;              

//             System.debug('First Full OPTY Converted: ' + firstFullOpportunity.StageName);

//             List<Asset> assets =        [select
//                                             Id, InstallDate, Name, Product_Type__c, Status,
//                                             Type_of_License__c, UsageEndDate , Opportunity__c,
//                                             ProductFamily__c
//                                         FROM 
//                                             Asset 
//                                         WHERE                                           
//                                             AccountId           = :account.Id];

                                            
            
//             System.assertEquals(1                   , assets.size());
//             System.assertEquals('Full Licence'      , assets[0].Type_of_License__c);
//             System.assertEquals('Provisioned'       , assets[0].Status);
//         }

//         Test.startTest();     

//         {
            
//             TestUtility.SetGivenStatusToAccount(account, 'Existing Customer');
//             update account;

//             Opportunity secondFullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//             TestUtility.AssignOpportunityToAccount(secondFullOpportunity, account);        
//             secondFullOpportunity.Type = 'Renewal';
//             insert secondFullOpportunity;
            

//             OpportunityLineItem secondFullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(secondFullOpportunity, 1 ,1 );
//             TestUtility.SetOpportunityLineItem_PriceBook(secondFullOpportunityLineItem , pricebookEntry);            
//             //Setting Future Date
//             secondFullOpportunityLineItem.SubscriptionStartDate__c    = Date.today().addMonths(6);
//             secondFullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(9);
//             insert secondFullOpportunityLineItem;

//              OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//             TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, secondFullOpportunity.Id);
//             insert opportunityContact;

//             OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//             TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, secondFullOpportunity.Id);
//             insert accountPayableContact;

//             Attachment attachment = FakeObjectFactory.GetAttachment();
//             TestUtility.SetOpportunityAttachment(secondFullOpportunity, attachment );
//             insert attachment;

//             Quote quote = FakeObjectFactory.GetQuote();

//             quote.OpportunityId = secondFullOpportunity.Id;
//             insert quote;

//             QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//             quoteLineItem.QuoteId = quote.Id;
//             quoteLineItem.Product2Id = product.Id;
//             insert quoteLineItem;

//             quote.Status = 'Approved';
//             update quote;

//             //Move opportunity to Full stage
//             TestUtility.MoveOpportunityToSold(secondFullOpportunity);

//             update secondFullOpportunity;

//             List<Asset> assets =    [select
//                                     Id, InstallDate, Name, Product_Type__c, Status,
//                                     Type_of_License__c, UsageEndDate , Opportunity__c,
//                                     ProductFamily__c
//                                 FROM 
//                                     Asset 
//                                 WHERE                                           
//                                     AccountId = :account.Id];

//             System.assertEquals(2 , assets.size());

//             Test.stopTest(); 
//         }
        
//     }

/*
    @isTest
    static void NewUpSellMathleticsOpportunity_WithoutHavingAnyExistingFullAssets_MovingToSoldStage_ThrowsValidationException()
    {    
        String productFamily = 'Mathletics';    
        Account account1  = FakeObjectFactory.GetSchoolAccount();
        insert account1; 
        
        Contact contact  = FakeObjectFactory.GetContact();        
        TestUtility.AssignAccountToContact(account1, contact);
        insert contact;

        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;
        
        Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
        
        opportunity.Type = 'Up Sell';
        TestUtility.AssignOpportunityToAccount(opportunity, account1);
        insert opportunity;

        OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 ,1 );
        TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
        insert opportunityLineItem;

        OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
        TestUtility.SetOpportunityContact(opportunityContact, account1.Id , contact.Id, opportunity.Id);
        insert opportunityContact;

        OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
        TestUtility.SetOpportunityContact(accountPayableContact, account1.Id , contact.Id, opportunity.Id);
        insert accountPayableContact;

        Attachment attachment = FakeObjectFactory.GetAttachment();
        TestUtility.SetOpportunityAttachment(opportunity, attachment );
        insert attachment;

        Quote quote = FakeObjectFactory.GetQuote();

        quote.OpportunityId = opportunity.Id;
        insert quote;

        QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
        quoteLineItem.QuoteId = quote.Id;
        quoteLineItem.Product2Id = product.Id;
        insert quoteLineItem;

        quote.Status = 'Approved';
        update quote;

        //Move opportunity to Trial stage
        TestUtility.MoveOpportunityToSold(opportunity);    

        String responseMessage = '';
        boolean testSucceded = false;
        try 
        {           
            update opportunity;              
        } 
        catch(Exception e) 
        {                       
            testSucceded = true;      
            System.debug('Asif Khan ' + e.getMessage());
            System.assertEquals(e.getTypeName(), 'System.DmlException');  
            System.assert(e.getMessage().contains('is different from the  Mathletics provisioned licence, please update to the end date'));    
        }   
                
        System.assertEquals(true, testSucceded);                
        
    }
   */
//     @isTest
//     static void NewMathleticsTrialOpportunity_HavingAccountWithProvisionedFullLicence_MoveOpportunityToTrial_ThrowsValidationException()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         insert account; 
        
//         Contact contact  = FakeObjectFactory.GetContact();        
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;

//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//         TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
//         insert fullOpportunity;

//         OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);
//         insert fullOpportunityLineItem;
    

//         OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//         TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, fullOpportunity.Id);
//         insert opportunityContact;

//         OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//         TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, fullOpportunity.Id);
//         insert accountPayableContact;

//         Attachment attachment = FakeObjectFactory.GetAttachment();
//         TestUtility.SetOpportunityAttachment(fullOpportunity, attachment );
//         insert attachment;

//         Quote quote = FakeObjectFactory.GetQuote();

//         quote.OpportunityId = fullOpportunity.Id;
//         insert quote;

//         QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//         quoteLineItem.QuoteId = quote.Id;
//         quoteLineItem.Product2Id = product.Id;
//         insert quoteLineItem;

//         quote.Status = 'Approved';
//         update quote;

//         //Move opportunity to Full stage
//         TestUtility.MoveOpportunityToSold(fullOpportunity);

//         update fullOpportunity ;

//         System.debug('Full OPTY Converted: ' + fullOpportunity .StageName);

//         List<Asset> assets =        [select
//                                         Id, InstallDate, Name, Product_Type__c, Status,
//                                         Type_of_License__c, UsageEndDate , Opportunity__c,
//                                         ProductFamily__c
//                                     FROM 
//                                         Asset 
//                                     WHERE                                           
//                                         AccountId           = :account.Id];

                                        
        
//         System.assertEquals(1                   , assets.size());
//         System.assertEquals('Full Licence'      , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'       , assets[0].Status);
                                    
//         Test.startTest(); 
        
//         TestUtility.SetGivenStatusToAccount(account, 'Former Customer');
//         update account;
        
//         Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
//         TestUtility.AssignOpportunityToAccount(trialOpportunity, account);        
//         System.debug('Account Status: '+account.status__c);
        
//         System.debug('Customer_Status__c: '+ trialOpportunity.Customer_Status__c);
        
//         insert trialOpportunity;

//         OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
//         insert trialOpportunityLineItem ;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(trialOpportunity);

//         String responseMessage = '';
//         boolean succeeded = false;
//         try 
//         {           
//             update trialOpportunity;              
//         } 
//         catch(Exception e) 
//         {                       
//             succeeded = true;      
//             System.assertEquals(e.getTypeName(), 'System.DmlException');  
//         }   
        
//         // This Line will always execute even after the catch block
//         //System.debug('Response Message: ' + responseMessage);
//         //System.assert(responseMessage.contains('There is already a provisioned Full licence for this product'));
//         System.assertEquals(true, succeeded);
//         Test.stopTest(); 
        
//     }

    
    
//     @isTest
//     static void NewMathleticsFutureFullOpportunity_HavingAccountWithProvisionedFullLicence_MoveOpportunityToFullWithSubscriptionFutureDates_FutureAssetShouldBeCreated()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();        
//         insert account; 
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         Contact contact  = FakeObjectFactory.GetContact();        
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         {
//             Opportunity firstFullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//             TestUtility.AssignOpportunityToAccount(firstFullOpportunity, account);
//             insert firstFullOpportunity;
            

//             OpportunityLineItem firstFullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(firstFullOpportunity, 1 ,1 );
//             TestUtility.SetOpportunityLineItem_PriceBook(firstFullOpportunityLineItem , pricebookEntry);
//             insert firstFullOpportunityLineItem ;

//              OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//             TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, firstFullOpportunity.Id);
//             insert opportunityContact;

//             OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//             TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, firstFullOpportunity.Id);
//             insert accountPayableContact;

//             Attachment attachment = FakeObjectFactory.GetAttachment();
//             TestUtility.SetOpportunityAttachment(firstFullOpportunity, attachment );
//             insert attachment;

//             Quote quote = FakeObjectFactory.GetQuote();

//             quote.OpportunityId = firstFullOpportunity.Id;
//             insert quote;

//             QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//             quoteLineItem.QuoteId = quote.Id;
//             quoteLineItem.Product2Id = product.Id;
//             insert quoteLineItem;

//             quote.Status = 'Approved';
//             update quote;

//             //Move opportunity to Full stage
//             TestUtility.MoveOpportunityToSold(firstFullOpportunity);

//             update firstFullOpportunity;              

//             System.debug('First Full OPTY Converted: ' + firstFullOpportunity.StageName);

//             List<Asset> assets =        [select
//                                             Id, InstallDate, Name, Product_Type__c, Status,
//                                             Type_of_License__c, UsageEndDate , Opportunity__c,
//                                             ProductFamily__c
//                                         FROM 
//                                             Asset 
//                                         WHERE                                           
//                                             AccountId           = :account.Id];

                                            
            
//             System.assertEquals(1                   , assets.size());
//             System.assertEquals('Full Licence'      , assets[0].Type_of_License__c);
//             System.assertEquals('Provisioned'       , assets[0].Status);
//         }

//         Test.startTest();                
//         {

//             //TODO: It's Hack needs to discuss, once one attached opportunity move to trial then second one can't even for futre because of account stage
//             TestUtility.SetGivenStatusToAccount(account, 'Existing Customer');
//             update account;

//             Opportunity secondFullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
//             TestUtility.AssignOpportunityToAccount(secondFullOpportunity, account);        
//             secondFullOpportunity.Type = 'Renewal';
//             insert secondFullOpportunity;
            

//             OpportunityLineItem secondFullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(secondFullOpportunity, 1 ,1 );
//             TestUtility.SetOpportunityLineItem_PriceBook(secondFullOpportunityLineItem , pricebookEntry);            
//             //Setting Future Date
//             secondFullOpportunityLineItem.SubscriptionStartDate__c    = Date.today().addMonths(1).addDays(1);
//             secondFullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(2).addDays(1);
//             insert secondFullOpportunityLineItem;

//              OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//             TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, secondFullOpportunity.Id);
//             insert opportunityContact;

//             OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//             TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, secondFullOpportunity.Id);
//             insert accountPayableContact;

//             Attachment attachment = FakeObjectFactory.GetAttachment();
//             TestUtility.SetOpportunityAttachment(secondFullOpportunity, attachment );
//             insert attachment;

//             Quote quote = FakeObjectFactory.GetQuote();

//             quote.OpportunityId = secondFullOpportunity.Id;
//             insert quote;

//             QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//             quoteLineItem.QuoteId = quote.Id;
//             quoteLineItem.Product2Id = product.Id;
//             insert quoteLineItem;
           
//             quote.Status = 'Approved';
//             update quote;


//             //Move opportunity to Full stage
//             TestUtility.MoveOpportunityToSold(secondFullOpportunity);

//              Database.update(secondFullOpportunity);

//            // update secondFullOpportunity;

//             List<Asset> assets =    [select
//                                     Id, InstallDate, Name, Product_Type__c, Status,
//                                     Type_of_License__c, UsageEndDate , Opportunity__c,
//                                     ProductFamily__c
//                                 FROM 
//                                     Asset 
//                                 WHERE                                           
//                                     AccountId = :account.Id];

//             System.assertEquals(2 , assets.size());

//             Test.stopTest(); 
//         }
//     }    
    
//     @isTest
//     static void NewMathleticsFutureFullOpportunity_HavingAccountWithProvisionedTrialLicence_MoveOpportunityToFullWithSubscriptionFutureDates_FutureAssetShouldBeCreated()
//     {    
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();        
//         insert account; 


//         Contact contact  = FakeObjectFactory.GetContact();
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;
        
//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;

//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity trialOpportunity = FakeObjectFactory.GetStandardOpportunity();    
//         TestUtility.AssignOpportunityToAccount(trialOpportunity, account);
//         insert trialOpportunity;

//         OpportunityLineItem trialOpportunityLineItem = FakeObjectFactory.GetTrialOpportunityLineItem(trialOpportunity, 1 ,1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(trialOpportunityLineItem , pricebookEntry);
//         insert trialOpportunityLineItem ;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToTrial(trialOpportunity);

//         update trialOpportunity;

//         System.debug('First Trial OPTY Converted: ' + trialOpportunity.StageName);

//         List<Asset> assets =        [select
//                                         Id, InstallDate, Name, Product_Type__c, Status,
//                                         Type_of_License__c, UsageEndDate , Opportunity__c,
//                                         ProductFamily__c
//                                     FROM 
//                                         Asset 
//                                     WHERE                                           
//                                         AccountId           = :account.Id];

                                        
        
//         System.assertEquals(1                    , assets.size());
//         System.assertEquals('Trial Licence'      , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'        , assets[0].Status);
        
//         Test.startTest();

//         Opportunity fullOpportunity = FakeObjectFactory.GetCrossSellOpportunity();   
//         TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
//         insert fullOpportunity;

//         OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
//         fullOpportunityLineItem.SubscriptionStartDate__c    = Date.today().addDays(15);
//         fullOpportunityLineItem.SubscriptionEndDate__c      = Date.today().addMonths(3);

//         TestUtility.SetOpportunityLineItem_PriceBook(fullOpportunityLineItem, pricebookEntry);
//         insert fullOpportunityLineItem;

              
//         OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//         TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, fullOpportunity.Id);
//         insert opportunityContact;

//         OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//         TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, fullOpportunity.Id);
//         insert accountPayableContact;

//         Attachment attachment = FakeObjectFactory.GetAttachment();
//         TestUtility.SetOpportunityAttachment(fullOpportunity, attachment );
//         insert attachment;

//         Quote quote = FakeObjectFactory.GetQuote();

//         quote.OpportunityId = fullOpportunity.Id;
//         insert quote;

//         QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//         quoteLineItem.QuoteId = quote.Id;
//         quoteLineItem.Product2Id = product.Id;
//         insert quoteLineItem;

//         quote.Status = 'Approved';
//         update quote;

//         //Move opportunity to Full stage
//         TestUtility.MoveOpportunityToSold(fullOpportunity);         

//         update fullOpportunity;
        
//         assets =        [select
//                                 Id, InstallDate, Name, Product_Type__c, Status,
//                                 Type_of_License__c, UsageEndDate , Opportunity__c,
//                                 ProductFamily__c
//                             FROM 
//                                 Asset 
//                             WHERE                                           
//                                 AccountId           = :account.Id];

                                        
        
//         System.assertEquals(2                   , assets.size());
//         System.assertEquals('Full Licence'      , assets[1].Type_of_License__c);
//         System.assertEquals('Provisioned'       , assets[1].Status);
        
//         Test.stopTest();   
//     }
    
       
//   @isTest
//     static void NewFullMathleticsOpportunity_MovingToSoldStage_OneFullAssetShouldBeCreated()
//     {           

//         String productFamily = 'Mathletics';
                
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         insert account; 

//         Contact contact  = FakeObjectFactory.GetContact();
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;



//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;
//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
//         TestUtility.AssignOpportunityToAccount(opportunity, account);

//         insert opportunity;

//         OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 , 1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);

//         insert opportunityLineItem;


//         OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//         TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);

//         insert opportunityContact;

//         OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//         TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);

//         insert accountPayableContact;

//         Attachment attachment = FakeObjectFactory.GetAttachment();
//         TestUtility.SetOpportunityAttachment(opportunity, attachment );
//         insert attachment;

//         Quote quote = FakeObjectFactory.GetQuote();

//         quote.OpportunityId = opportunity.Id;
//         insert quote;

//         QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//         quoteLineItem.QuoteId = quote.Id;
//         quoteLineItem.Product2Id = product.Id;
//         insert quoteLineItem;

//         quote.Status = 'Approved';
//         update quote;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToSold(opportunity);        
//         update opportunity;
    
//         //Get all assets for the created account
//         List<Asset> assets =         [select
//                                             Id, InstallDate, Name, Product_Type__c, Status,
//                                             Type_of_License__c, UsageEndDate , Opportunity__c,
//                                             ProductFamily__c
//                                         FROM 
//                                             Asset 
//                                         WHERE                                           
//                                             AccountId           = :account.Id];

//         //Get the opporttunity again to check closedate
//         List<Opportunity> opps  =        [select
//                                             Id, CloseDate
//                                         FROM 
//                                             Opportunity 
//                                         WHERE                                           
//                                             Id          = :opportunity.Id];        

//         System.assertEquals(1                        , assets.size());
//         System.assertEquals('Full Licence'           , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'            , assets[0].Status);
//         System.assertEquals(Date.today()             , assets[0].InstallDate);
//         System.assertEquals(Date.today().addMonths(1), assets[0].UsageEndDate);
//         System.assertEquals(Date.today()             , opps[0].CloseDate);
//     }   

//     @isTest
//     static void NewFullMathleticsUpsellOpportunity_MovingToSoldStage_NumberOfStudentsShouldIncrease()
//     {           

//         String productFamily = 'Mathletics';
                
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         insert account; 

//         Contact contact  = FakeObjectFactory.GetContact();
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;



//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;
//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        

//         Asset asset = FakeObjectFactory.GetFullAsset(product, System.today(), System.today().addMonths(1));
//         asset.accountId = account.Id;
//         insert asset;

//         Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
//         opportunity.Type        = 'Up Sell';
//         TestUtility.AssignOpportunityToAccount(opportunity, account);

//         insert opportunity;

//         OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 2, 1 );
//         TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
    
//         insert opportunityLineItem;


//         OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
//         TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);

//         insert opportunityContact;

//         OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
//         TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);

//         insert accountPayableContact;

//         Attachment attachment = FakeObjectFactory.GetAttachment();
//         TestUtility.SetOpportunityAttachment(opportunity, attachment );
//         insert attachment;

//         Quote quote = FakeObjectFactory.GetQuote();

//         quote.OpportunityId = opportunity.Id;
//         insert quote;

//         QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
//         quoteLineItem.QuoteId = quote.Id;
//         quoteLineItem.Product2Id = product.Id;
//         insert quoteLineItem;

//         quote.Status = 'Approved';
//         update quote;

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToSold(opportunity);        
//         update opportunity;
    
//         //Get all assets for the created account
//         List<Asset> assets =         [select
//                                             Id, InstallDate, Name, Product_Type__c, Status,
//                                             Type_of_License__c, UsageEndDate , Opportunity__c,
//                                             ProductFamily__c,License_Cap__c
//                                         FROM 
//                                             Asset 
//                                         WHERE                                           
//                                             AccountId           = :account.Id];

//         //Get the opporttunity again to check closedate
//         List<Opportunity> opps  =        [select
//                                             Id, CloseDate
//                                         FROM 
//                                             Opportunity 
//                                         WHERE                                           
//                                             Id          = :opportunity.Id];        

//         System.assertEquals(1                        , assets.size());
//         System.assertEquals(3                        , assets[0].License_Cap__c);
//         System.assertEquals('Full Licence'           , assets[0].Type_of_License__c);
//         System.assertEquals('Provisioned'            , assets[0].Status);
//         System.assertEquals(Date.today()             , assets[0].InstallDate);
//         System.assertEquals(Date.today().addMonths(1), assets[0].UsageEndDate);
//         System.assertEquals(Date.today()             , opps[0].CloseDate);
//     }   

    //  @isTest
    // static void NewMathleticsClusterOpportunity_MoveToSold_NoAssetShouldBeCreated()
    // {    
    //     String productFamily = 'Mathletics';    
    //     Account account  = FakeObjectFactory.GetClusterAccount();        
    //     insert account; 
        
    //     Contact contact  = FakeObjectFactory.GetContact();        
    //     TestUtility.AssignAccountToContact(account, contact);
    //     insert contact;

    //     Product2 product = FakeObjectFactory.GetProduct(productFamily);
    //     insert product;
    //     PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
    //     insert pricebookEntry;
        
    //     Opportunity opportunity = FakeObjectFactory.GetClusterOpportunity();
    //     opportunity.Type = 'New Business';        
    //     TestUtility.AssignOpportunityToAccount(opportunity, account);
    //     insert opportunity;

    //     OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 ,1 );
    //     TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
    //     insert opportunityLineItem;

    //     OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
    //     TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);
    //     insert opportunityContact;

    //     OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
    //     TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);
    //     insert accountPayableContact;

    //     Attachment attachment = FakeObjectFactory.GetAttachment();
    //     TestUtility.SetOpportunityAttachment(opportunity, attachment );
    //     insert attachment;

    //     Quote quote = FakeObjectFactory.GetQuote();

    //     quote.OpportunityId = opportunity.Id;
    //     insert quote;

    //     QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
    //     quoteLineItem.QuoteId = quote.Id;
    //     quoteLineItem.Product2Id = product.Id;
    //     insert quoteLineItem;

    //     quote.Status = 'Approved';
    //     update quote;

    //     //Move opportunity to Trial stage
    //     TestUtility.MoveOpportunityToSold(opportunity);
    //     update opportunity;

    //     System.debug('Opportunity Id: ' + opportunity.Id + ' StageName: '+ opportunity.StageName + ' Type: ' + opportunity.Type + ' Account Id: ' + account.Id + 
    //             ' Start Date: ' + opportunity.Start_Date__c + ' End Date: ' + opportunity.End_Date__c + ' Close Date: ' + opportunity.CloseDate);

    //     //Get all assets for the created account
    //     List<Asset> assets =         [select
    //                                         Id, InstallDate, Name, Product_Type__c, Status,
    //                                         Type_of_License__c, UsageEndDate , Opportunity__c,
    //                                         ProductFamily__c
    //                                     FROM 
    //                                         Asset 
    //                                     WHERE                                           
    //                                         AccountId           = :account.Id];

                                        
        
    //     System.assertEquals(0                        , assets.size());
    
    // }  

    //  @isTest
    // static void UpsellMathleticsClusterOpportunity_MoveToSold_NoAssetShouldBeCreatedANdNoErrorShouldBeThrough()
    // {    
    //     String productFamily = 'Mathletics';    
    //     Account account  = FakeObjectFactory.GetClusterAccount();        
    //     insert account; 
        
    //     Contact contact  = FakeObjectFactory.GetContact();        
    //     TestUtility.AssignAccountToContact(account, contact);
    //     insert contact;

    //     Product2 product = FakeObjectFactory.GetProduct(productFamily);
    //     insert product; 
    //     PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
    //     insert pricebookEntry; 
        
    //     Opportunity opportunity = FakeObjectFactory.GetClusterOpportunity();
    //     opportunity.Type = 'Up sell';        
    //     TestUtility.AssignOpportunityToAccount(opportunity, account);
    //     insert opportunity;

    //     OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 ,1 );
    //     TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
    //     insert opportunityLineItem;

    //     OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
    //     TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);
    //     insert opportunityContact;

    //     OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
    //     TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);
    //     insert accountPayableContact;

    //     Attachment attachment = FakeObjectFactory.GetAttachment();
    //     TestUtility.SetOpportunityAttachment(opportunity, attachment );
    //     insert attachment;

    //     Quote quote = FakeObjectFactory.GetQuote();

    //     quote.OpportunityId = opportunity.Id;
    //     insert quote;

    //     QuoteLineItem quoteLineItem = FakeObjectFactory.GetQuoteLineItem(pricebookEntry, 1);
    //     quoteLineItem.QuoteId = quote.Id;
    //     quoteLineItem.Product2Id = product.Id;
    //     insert quoteLineItem;

    //     quote.Status = 'Approved';
    //     update quote;

    //     //Move opportunity to Trial stage
    //     TestUtility.MoveOpportunityToSold(opportunity);

    //     string message;

    //     try{

    //     update opportunity;

    //     }
    //     catch(exception ex)
    //     {
    //         message = ex.getMessage();

    //     }
 
    //      System.assertEquals(null, message);

     
    
    // }  
 
 }