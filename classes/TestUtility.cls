public with sharing class TestUtility {

     static Integer s_num = 1;

     public static String getFakeId(Schema.SObjectType sot)
     {
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + 
           '0'.repeat(12-result.length()) + result;
     }

     public static void AssignShareServiceCentreToAccount(Account sharedServiceCentre, Account account)
    {   
       account.Shared_Service_Center__c = sharedServiceCentre.Id;
       //account.Billing_3rd_Party_ID__c = '';
    }

     public static void AssignAccountToContact(Account account, Contact contact)
    {   
       contact.AccountId = account.Id;
    }

      public static void SetGivenStatusToAccount(Account account, string status)
    {
        account.status__c           =   status;        
    }

    public static void MoveOpportunityToSold(Opportunity opportunity )
    {
        opportunity.StageName           =   'Sold';//'Sold';
        opportunity.Buying_Objective__c =   'Any objective';
        opportunity.Won_Lost_Reason__c  =   'Best product !';
    }

    public static void MoveOpportunityToSoldInvoiced(Opportunity opportunity )
    {
        opportunity.StageName           =   'Sold - Invoiced';        
    }

    public static void MoveOpportunityToSoldInvoice(Opportunity opportunity )
    {
        opportunity.StageName           =   'Sold - Invoiced';
        opportunity.Buying_Objective__c =   'Any objective';
        opportunity.Won_Lost_Reason__c  =   'Best product !';
    }

    public static void MoveOpportunityToTrial(Opportunity opportunity )
    {
        opportunity.StageName           =   'Trial';        
    }
   public static void SetOpportunityAttachment(Opportunity opportunity, Attachment attachment)
    {
        attachment.ParentId                 = opportunity.Id;
        opportunity.Number_Attachments__c   = 1;
    }


    public static void SetOpportunityContact(OpportunityContacts__c opportunityContact, Id accountId, Id contactId, Id opportunityId)
    {   
        opportunityContact.Account__c      = accountId;
        opportunityContact.Contact__c      = contactId;
        opportunityContact.Opportunity__c  = opportunityId;       
    }
    
      public static void AssignOpportunityToAccount(Opportunity opportunity, Account account)
    {
            opportunity.AccountId = account.Id;
    }

      public static OpportunityLineItem SetFullOpportunityLineItem(OpportunityLineItem opportunityLineItem, Date startDate, Date endDate)
    {   
        
        opportunityLineItem.Provision_Full_License__c   = true;
        opportunityLineItem.SubscriptionStartDate__c    = startDate;
        opportunityLineItem.SubscriptionEndDate__c      = endDate;                

        return opportunityLineItem;
    }

     public static OpportunityLineItem SetTrialOpportunityLineItem(OpportunityLineItem opportunityLineItem, Date startDate)
    {   
        
        opportunityLineItem.Provision_Trial_License__c  = true;
        opportunityLineItem.Trial_Start_Date__c         = startDate;

        return opportunityLineItem;
    }

    public static void SetOpportunityLineItem_PriceBook(OpportunityLineItem opportunityLineItem, PricebookEntry pricebookEntry)
    {
        opportunityLineItem.PricebookEntryId    = pricebookEntry.Id;
    }    
  
    public static void MoveOpportunityToNegotiation(Opportunity opportunity )
    {
        opportunity.StageName           =   'Negotiation';        
    }
    
    public static User GetSalesUser()
    {
        Map<String,ID> userRolemap = new Map<String,ID>();
        List<UserRole> userRoles = [SELECT Id, Name, DeveloperName, PortalAccountId, PortalType, PortalAccountOwnerId FROM UserRole where Name = 'Global'];
		for(UserRole ur :userRoles) 
        {
            userRolemap.put(ur.Name,ur.Id);
        }
        
        Map<String,ID> profiles = new Map<String,ID>();
      	List<Profile> ps = [select id, name from Profile where name = 
         					'Standard User' or name = 'System Administrator' or name = 'Sales User'];

        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        User testSalesUser   = new User(alias = 'standt', 
      	email			='standarduser@testorg.com', 
      	emailencodingkey='UTF-8', 
      	lastname		='Testing', languagelocalekey='en_US', 
      	localesidkey	='en_US', 
      	profileid 		= profiles.get('Sales User'), 
      	timezonesidkey	='America/Los_Angeles', 
      	username		='testSalesUser@testorg.com',
        Region__c = 'APAC',
        UserRoleId = userRolemap.get('Global'),
        ACTNSCRM__NS_Internal_ID__c = '1234');
        
        return testSalesUser;
    }
   
    public static User GetFinanceUser()
    {
        Map<String,ID> userRolemap = new Map<String,ID>();
        List<UserRole> userRoles = [SELECT Id, Name, DeveloperName, PortalAccountId, PortalType, PortalAccountOwnerId FROM UserRole where Name = 'Global'];
		for(UserRole ur :userRoles) 
        {
            userRolemap.put(ur.Name,ur.Id);
        }
        
        Map<String,ID> profiles = new Map<String,ID>();
      	List<Profile> ps = [select id, name from Profile where name = 'Country Finance' or name = 'CFO'];

        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        User userCFO   = new User(alias = 'standt', 
      	email			='testFinanceUser@testorg.com', 
      	emailencodingkey='UTF-8', 
      	lastname		='Testing', languagelocalekey='en_US', 
      	localesidkey	='en_US', 
      	profileid 		= profiles.get('CFO'), 
      	timezonesidkey	='America/Los_Angeles', 
      	username		='testFinanceUser@testorg.com',
        Region__c = 'APAC',
        UserRoleId = userRolemap.get('Global'),
        ManagerId = UserInfo.getUserId(),
        ACTNSCRM__NS_Internal_ID__c = '1234');
        
        return userCFO;
    }
    
}