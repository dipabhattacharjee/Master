@isTest
public class FullAsset_IntegrationTest
{
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
        testOpportunity.Type = 'Renewal';        
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
    static void RenewalMathleticsOpportunity_WithoutHavingAnyExistingFullAssets_OneFullAssetShouldBeCreated()
    {    
       Opportunity opportunity = [select Id, StageName,CloseDate,Type,Start_Date__c,End_Date__c from Opportunity ][0];
        Account account = [select Id, Name from Account ][0];
        //Move opportunity to Trial stage
        TestUtility.MoveOpportunityToSold(opportunity);

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
        System.assertEquals('Full Licence'           , assets[0].Type_of_License__c);
        System.assertEquals('Provisioned'            , assets[0].Status);
        System.assertEquals(Date.today()             , assets[0].InstallDate);      
                
    }
}