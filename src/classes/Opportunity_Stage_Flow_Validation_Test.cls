@isTest
public without sharing class Opportunity_Stage_Flow_Validation_Test {
    
    @testSetup static void initialSetUp(){
    
        List<sObject> regionTax = Test.loadData(RegionTaxSetting__c.sObjectType, 'RegionTaxCSV');
		List<sObject> EMETax = Test.loadData(EMETaxSetting__c.sObjectType,'EMETaxCSV');
		List<sObject> canadaProvinceTax = Test.loadData(CanadaProvinceTaxSetting__c.sObjectType, 'CanadaProvinceTaxRates');

        ISOMapping__c isoMap = FakeObjectFactory.GetIsoMap();
        insert isoMap;

        String mathletics = 'Mathletics';
        insert new LicencedProduct__c(ProductFamily__c = mathletics, Name = mathletics);
        
        String spellodrome = 'Spellodrome';
        insert new LicencedProduct__c(ProductFamily__c = spellodrome, Name = spellodrome);
        
		//insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = true;
		insert handler;		
  }
    
    @isTest
    static void As_SalesUser_NewFullMathleticsOpportunity_MovingToSoldInvoicedStage_GetValidationError()
    {   
        
		User salesUser = TestUtility.GetSalesUser();
      	insert salesUser;
        
		System.runas(salesUser)
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
            
            Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
            TestUtility.AssignOpportunityToAccount(opportunity, account);
    
            insert opportunity;
    
            OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 , 1 );
            TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
    
            insert opportunityLineItem;
    
    
            OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
            TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);
    
            insert opportunityContact;
    
            OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
            TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);
    
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
            
            TestUtility.MoveOpportunityToSold(opportunity);        
            update opportunity;
                
            try 
            {           
                TestUtility.MoveOpportunityToSoldInvoiced(opportunity);
                update opportunity;             
            } 
            catch(Exception e) 
            {     
                System.assert(e.getMessage().contains('Only Finance department can update an Opportunity from Stages Sold and Sold - Invoiced'));    
            }
      	}
    }
    
    @isTest
    static void As_SalesUser_NewFullMathleticsOpportunity_SoldOpportunity_EditedtoStageBeforeSold_GetValidationError()
    {   
        
        User salesUser = TestUtility.GetSalesUser();
      	insert salesUser;
        
		System.runas(salesUser)
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
            
            Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
            TestUtility.AssignOpportunityToAccount(opportunity, account);
    
            insert opportunity;
    
            OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 , 1 );
            TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
    
            insert opportunityLineItem;
    
    
            OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
            TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);
    
            insert opportunityContact;
    
            OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
            TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);
    
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
            
            TestUtility.MoveOpportunityToSold(opportunity);        
            update opportunity;
            //string message; 
            try 
            {           
                TestUtility.MoveOpportunityToNegotiation(opportunity);
                //opportunity.StageName = 'Negotiation';
                update opportunity;             
            } 
            catch(Exception e) 
            {     
                //message = e.getMessage();
                //System.assertEquals(null, message);
                System.assert(e.getMessage().contains('Only Finance department can update an Opportunity from Stages Sold and Sold - Invoiced'));    
            }
      	}
    }
    
    @isTest
    static void As_FinanceUser_NewFullMathleticsOpportunity_SoldOpportunity_EditedtoStageBeforeSold_NoValidationError()
    {   
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User salesUser,userCFO;
        System.runAs (thisUser){
            salesUser = TestUtility.GetSalesUser();
            insert salesUser;
            userCFO  = TestUtility.GetFinanceUser();
            insert userCFO;
        System.runas(userCFO)
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
        
        Opportunity opportunity = FakeObjectFactory.GetStandardOpportunity();
        TestUtility.AssignOpportunityToAccount(opportunity, account);
        
        insert opportunity;
        
        OpportunityLineItem opportunityLineItem = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, 1 , 1 );
        TestUtility.SetOpportunityLineItem_PriceBook(opportunityLineItem, pricebookEntry);
        
        insert opportunityLineItem;
        
        
        OpportunityContacts__c opportunityContact   = FakeObjectFactory.GetOpportunityContact();
        TestUtility.SetOpportunityContact(opportunityContact, account.Id , contact.Id, opportunity.Id);
        
        insert opportunityContact;
        
        OpportunityContacts__c accountPayableContact    = FakeObjectFactory.GetAccountPayableContact();
        TestUtility.SetOpportunityContact(accountPayableContact, account.Id , contact.Id, opportunity.Id);
        
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
        
		 
        TestUtility.MoveOpportunityToSold(opportunity);        
        update opportunity;
            
            
            
            string message; 
            try 
            {           
                TestUtility.MoveOpportunityToNegotiation(opportunity);                
                update opportunity;             
            } 
            catch(Exception e) 
            {     
                message = e.getMessage();
                //System.assertEquals(null, message);
                System.assert(e.getMessage().contains('Finance Team should not move Sold Opportunities to previous stages'));    
            }
        }   
        
    	}
    }

}