@isTest
public class CloneOpportunitywithProducts_Test{
   

   static Opportunity testOpportunity;
    static Account testAccount;
 
 private static PricebookEntry GetPriceBookEntry(Product2 product, Pricebook2 pricebook, Decimal unitPrice)
    {       
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebook.Id;
        standardPrice.Product2Id = product.Id;
        standardPrice.unitPrice  = unitPrice;
        standardPrice.IsActive   = true;
       

        return standardPrice;
    }

    @testSetup static void setup()
    {

        FakeObjectFactory.testclasssetup();

         Service_EndPoints__c licenceEndpoint = new Service_EndPoints__c();
        licenceEndpoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        licenceEndpoint.Name = 'School Licence Service';
        insert licenceEndpoint;

        Account__c employeeId = new Account__c();//.getInstance('C3 User Id');
        employeeId.name='C3 User Id';
        employeeId.Id__c=1;
        insert employeeId;

        Service_EndPoints__c authenticationEndpoint = new Service_EndPoints__c();
        authenticationEndpoint.Endpoint_URL__c = 'anytesturl.com';//can replace if service call needs to test
        authenticationEndpoint.Name = 'Authorization Service';
        insert authenticationEndpoint;
      
 
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
        role.Is_Account_same_as_Contact_Account__c=true;
        insert role;

        Contact_Roles__c contactRole=[select id,Account__c,Contact__c,Role__c from Contact_Roles__c where Id= :role.Id ][0];
        
        system.debug('getting contact role ' + contactRole);
      
      
        Product2 product = FakeObjectFactory.GetProduct(productFamily);
        insert product;
        PricebookEntry standardPricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert standardPricebookEntry;
       


        
        testOpportunity = FakeObjectFactory.GetStandardOpportunity();
        TestUtility.AssignOpportunityToAccount(testOpportunity, testAccount);
        testOpportunity.EBS_Approval__c = true;


        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name='Any name';
        //pricebook.UseStandardPrice = true ;
        insert pricebook;

       // pricebook2 stdPriceBook    = [select id, name from Pricebook2 where id = :pricebookId limit 1];
        system.debug('stdPriceBook:' + pricebook);
        testOpportunity.pricebook2Id = pricebook.Id;

       PricebookEntry pricebookEntry=   GetPriceBookEntry(product , pricebook, 10 );
        insert pricebookEntry;      
        
        insert testOpportunity;

        
        
        OpportunityLineItem opportunityLineItem1 = FakeObjectFactory.GetFullOpportunityLineItem(testOpportunity, 1 ,1 );
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

        TestUtility.MoveOpportunityToSold(testOpportunity);
        update testOpportunity;


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
    static void CloneOpportunity_CallingGetOpptyVsProducts_ShouldReturnTwoOpportunities()
    {    
       Opportunity opportunity = [select Id, StageName,CloseDate,Type,Start_Date__c,End_Date__c,RecordTypeId from Opportunity ][0];
        system.debug('opportunity:' + opportunity); 

     
        Account account = [select Id, Name from Account ][0];

        opportunity.StageName = 'Sold - Invoiced';

        update opportunity;
        
        List<Opportunity> opportunities = [select Id, StageName,CloseDate,Type,Start_Date__c,End_Date__c,RecordTypeId from Opportunity Where AccountId = :account.Id];

        system.debug('opportunities.size():' + opportunities.size());
        System.assert(opportunities.size() ==2 , 'should return Two opportunities');      
        System.assert( opportunities[0].type == 'Renewal' || opportunities[1].type == 'Renewal','should return one renewal opportunity');
        System.assert( opportunities[0].type == 'New Business' || opportunities[1].type == 'New Business','should return one New Business opportunity');     
                
    }


//     public static testMethod void testCloneOpportunities(){
                 
//     Set<Id>oppIds = new Set<Id>();
//     Opportunity opp = [select id,recordTypeId from Opportunity where name= 'New Opportunity'];    
    
//     oppIds.add(opp.Id);
//     List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Standard_Opportunity'  And sObjectType = 'Opportunity'];
//     opp.recordTypeId = recTypeList[0].Id;
//     update opp;
//     CloneOpportunitywithProducts cloneOpp = new CloneOpportunitywithProducts();
//     cloneOpp.cloneOpptyWithProducts(oppIds);
//    }
    
    /*@isTest private static void OpportunityWithAccountCurrency()
    {
    
    List<ACTNSCRM__Actian_Subsidiary__c> SubList = [Select Id,name from ACTNSCRM__Actian_Subsidiary__c];
    System.debug('ACTNSCRM__Actian_Subsidiary__c List ' + SubList);

    Account Acc = [Select Id,Territory__c,ACTNSCRM__Subsidiary_Lookup__c from Account where Name = 'Account Name'];    
    Acc.ACTNSCRM__Subsidiary_Lookup__c = SubList[0].Id;
    Update Acc;

    System.debug('Accounts Territory' + Acc.Territory__c);
    System.debug('Accounts ACTNSCRM__Subsidiary_Lookup__c' + Acc.ACTNSCRM__Subsidiary_Lookup__c);

    Set<Id>oppIds = new Set<Id>();
    Opportunity opp = [select id,recordTypeId,StageName,Type,AccountId from Opportunity where Name = 'New Opportunity'];    
    Opp.StageName = 'Sold - Invoiced';
    Update Opp;
    oppIds.add(opp.Id);
    CloneOpportunitywithProducts cloneOpp = new CloneOpportunitywithProducts();
    cloneOpp.cloneOpptyWithProducts(oppIds);

    System.debug('Checking Opportunity in Class OpportunityWithAccountCurrency' + opp);
    List<Opportunity> oppList = [Select Id,ACTNSCRM__Currency__c,ACTNSCRM__NS_Currency__c from Opportunity where AccountId = : Acc.Id];
    System.debug('Opp.oppList in Test Class' + oppList[0]);    
    System.assert(oppList.size() == 1);
    }*/

//    @testSetup static void insertRecords(){
//         //insert Trigger_Handler__c custom setting 
//     Trigger_Handler__c handler = new Trigger_Handler__c();
//     handler.Name = 'Block Trigger';
//     handler.Block_Trigger_Execution__c = true;
//     insert handler;

//         List<sObject> regionTax = Test.loadData(RegionTaxSetting__c.sObjectType, 'RegionTaxCSV');
//         List<sObject> EMETax = Test.loadData(EMETaxSetting__c.sObjectType, 'EMETaxCSV');
//         List<sObject> canadaProvinceTax = Test.loadData(CanadaProvinceTaxSetting__c.sObjectType, 'CanadaProvinceTaxRates');

//         ACTNSCRM__Actian_Subsidiary__c subsidiary = new ACTNSCRM__Actian_Subsidiary__c();
//         subsidiary.CurrencyIsoCode = 'AUD';
//         subsidiary.ACTNSCRM__NS_Internal_ID__c = '1';
//         subsidiary.ACTNSCRM__NetSuite_Internal_ID__c = '1';
//         subsidiary.Territory__c = 'APAC';
//         insert subsidiary;

//         //insert Service_EndPoints__c custom setting
//         Service_EndPoints__c endPoint = new Service_EndPoints__c();
//         endPoint.Endpoint_URL__c = 'abc.com';
//         endPoint.Name = 'Authorization Service';
//         insert endPoint;        
        
//         //insert postCode_Mapping record
//         Postcode_Mapping__c postMap = new Postcode_Mapping__c();
//         postMap.Country__c = 'AU';
//         postMap.Post_Zip_Code__c = '2060';
//         postMap.Territory__c = 'NSW South & ACT';
//         insert postMap;

//         ACTNSCRM__Currency__c australianCurrency = FakeObjectFactory.CreateFakeCurrency('AUD');
//         insert australianCurrency;
         
//         String productFamily = 'Mathletics';    
//         Account account  = FakeObjectFactory.GetSchoolAccount();
//         account.ACTNSCRM__Subsidiary_Lookup__c = subsidiary.Id;        
//         account.ShippingPostalCode = 'test';
//         account.ACTNSCRM__Currency__c = australianCurrency.id;
//         insert account;
        
//         Contact contact  = FakeObjectFactory.GetContact();
//         TestUtility.AssignAccountToContact(account, contact);
//         insert contact;

//         Product2 product = FakeObjectFactory.GetProduct(productFamily);
//         insert product;
//         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
//         insert pricebookEntry;
        
//         Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
//         opportunity.ACTNSCRM__NS_Currency__c = australianCurrency.Id;
//         opportunity.Type = 'Renewal';

//         TestUtility.AssignOpportunityToAccount(opportunity, account);
//         insert opportunity;

//         OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 ,1 );
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
//         Test.startTest();
//         update opportunity;
//         Test.stopTest();

//         /*
//         //Get all assets for the created account
//         List<Asset> assets =         [select
//                                             Id, InstallDate, Name, Product_Type__c, Status,
//                                             Type_of_License__c, UsageEndDate , Opportunity__c,
//                                             ProductFamily__c
//                                         FROM 
//                                             Asset 
//                                         WHERE                                           
//                                             AccountId           = :account.Id];

//         //Move opportunity to Trial stage
//         TestUtility.MoveOpportunityToSold(opportunity);
//         update opportunity;
       
        
//         TestUtility.MoveOpportunityToSoldInvoice(opportunity);
//         update opportunity; */
//   }
}