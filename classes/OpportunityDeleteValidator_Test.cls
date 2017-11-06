@isTest
public class OpportunityDeleteValidator_Test {
    
    @testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();


    }
    
    @isTest private static void DeleteOpportunity_SoldStage_OpportunityShouldNotBeDeleted()
    {
     
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

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;
        
        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
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
        fullOpportunity.EBS_Approval__c = true;
        Update fullOpportunity;
        
        String responseMessage = '';
        try 
        {           
            delete fullOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete Opportunities in this Stage. Please move to LOST with a valid reason selected.'));      
        
        
    }
    
    @isTest private static void DeleteOpportunity_InterestStage_OpportunityShouldBeDeleted()
    {
          
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;
        
        Delete fullOpportunity;
        
        List<Opportunity> opps =  [select Id FROM Opportunity WHERE AccountId = :account.Id];
        
        System.assertEquals(0, opps.size());
        
    }
    
     @isTest private static void DeleteOpportunity_TypeUpsell_OpportunityShouldNotBeDeleted()
    {
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account;
        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.Type = 'Up Sell';
        insert fullOpportunity;
        
        String responseMessage = '';
        try 
        {           
            delete fullOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete Opportunities of Type Upsell or Renewal. Please move to LOST with a valid reason selected.'));
    }
    
    @isTest private static void DeleteOpportunity_TypeRenewal_OpportunityShouldNotBeDeleted()
    {
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.Type = 'Renewal';
        insert fullOpportunity;
        
        String responseMessage = '';
        try 
        {           
            delete fullOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete Opportunities of Type Upsell or Renewal. Please move to LOST with a valid reason selected.'));
        
    }
    
    @isTest private static void DeleteOpportunity_TypeNewBusiness_OpportunityShouldBeDeleted()
    {
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.Type = 'New Business';
        insert fullOpportunity;
        
        Delete fullOpportunity;
        
        List<Opportunity> opps =  [select Id FROM Opportunity WHERE AccountId = :account.Id];
        
        System.assertEquals(0, opps.size());
    }
    
    @isTest private static void DeleteOpportunity_TypeCrossSell_OpportunityShouldBeDeleted()
    {
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account; 

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.Type = 'Cross Sell';
        insert fullOpportunity;
        
        Delete fullOpportunity;
        
        List<Opportunity> opps =  [select Id FROM Opportunity WHERE AccountId = :account.Id];
        
        System.assertEquals(0, opps.size());
        
    }
    
    @isTest private static void DeleteOpportunity_WithQuote_OpportunityShouldNotBeDeleted()
    {
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

        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        insert fullOpportunity;
        
        OpportunityLineItem fullOpportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(fullOpportunity, 1 ,1 );
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
        
        String responseMessage = '';
        try 
        {           
            delete fullOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete opportunity with a quote. Please move to LOST with a valid reason selected.'));
        
    }
    
    @isTest private static void DeleteOpportunity_WithValidLicence_OpportunityShouldNotBeDeleted()
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
            delete trialOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete opportunity with a licence. Please move to LOST with a valid reason selected.'));

         
    }
    
    @isTest private static void DeleteOpportunity_WithInactiveLicence_OpportunityShouldNotBeDeleted()
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
        
        assets[0].Status = 'Cancelled';
        update assets;
        
        String responseMessage = '';
        try 
        {           
            delete trialOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete opportunity with a licence. Please move to LOST with a valid reason selected.'));

    }
    
    @isTest private static void DeleteOpportunity_WithSalesOrder_OpportunityShouldNotBeDeleted()
    {
        Account account  = FakeObjectFactory.GetSchoolAccount();
        insert account;
        
        Opportunity fullOpportunity = FakeObjectFactory.GetStandardOpportunity();   
        TestUtility.AssignOpportunityToAccount(fullOpportunity, account);
        fullOpportunity.Type = 'Cross Sell';
        insert fullOpportunity;
        
        ACTNSCRM__Actian_Sales_Order__c salesOrder = new ACTNSCRM__Actian_Sales_Order__c();
		salesOrder.ACTNSCRM__Opportunity__c = fullOpportunity.Id;
		salesOrder.ACTNSCRM__Account__c = account.Id;
		insert salesOrder;
        
        String responseMessage = '';
        try 
        {           
            delete fullOpportunity;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Cannot delete opportuntiy with a SalesOrder. Please move to LOST with a valid reason selected.'));
    }
    
    @isTest private static void DeleteOpportunity_ConvertedFromLead_OpportunityShouldNotBeDeleted()
    {
        Lead lead = createFakeLead();        
        insert lead;      
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        System.assert(lcr.getAccountId() != null);
        System.assert(lcr.getOpportunityId() != null);
        System.assert(lcr.getContactId() != null);
        
        Opportunity ops = [Select Id from Opportunity where Id = :lcr.getOpportunityId()];
        
        String responseMessage = '';
        try 
        {           
            delete ops;              
        } 
        catch(Exception e) 
        {           
            responseMessage = e.getMessage();         
        }   
        
        // This Line will always execute even after the catch block
        System.debug('Response Message: ' + responseMessage);
        System.assert(responseMessage.contains('Opportunity Converted from Lead cannot be deleted. Please move to LOST with a valid reason selected.')); 
    }
    
    private static Lead createFakeLead()
	{
	    // Create the Lead object
	    Lead testLead = new Lead(
			FirstName    = 'Demo 100800',
			LastName 	 = 'Demo 100800 UnitTest',
			Status	     = 'Qualified',
			company      = 'Lacosta',
			street       = '1211 E I-40 Service Rd',
			city		 = 'NS',
            state		 = 'New South Wales',
            country		 = 'Australia',
            PostalCode = '2000'  
  	    ); 
        return testLead;
    
    }    
}