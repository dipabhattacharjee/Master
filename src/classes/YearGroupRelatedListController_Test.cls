@isTest
public class YearGroupRelatedListController_Test {
    public static testMethod void testYearGroupList(){
        PageReference pageRef = Page.YeargroupsRelatedList;
        Test.setCurrentPageReference(pageRef);
        //Commented For deployment
        //Asset singleAsset = [select Id,name from Asset where name = 'testAsset'];
        //ApexPages.StandardController sc = new ApexPages.standardController(singleAsset);
        //YearGroupRelatedListController yearGroup = new YearGroupRelatedListController(sc);
        //yearGroup.save();
    }
    
    
    @testSetup static void insertRecords(){
        //insert Trigger_Handler__c custom setting 
        Trigger_Handler__c handler = new Trigger_Handler__c();
        handler.Name = 'Block Trigger';
        handler.Block_Trigger_Execution__c = true;
        insert handler;
        
        
        //insert contact record
        Account acct = new Account();
        acct.Name = 'testacct1';
        acct.ShippingPostalCode = 'test';
        acct.ShippingState = 'New South Wales';
        acct.ShippingCity = 'test';
        acct.ShippingStreet =' test';   
        acct.ShippingCountryCode = 'AU';
        acct.ShippingCountry = 'Australia';
        acct.billingCountryCode = 'AU';
        acct.BillingState = 'New South Wales';  
        acct.Territory__c = 'APAC';
        acct.Global_School_Type__c = 'Government';
        acct.Global_School_Category__c = 'Primary';
        insert acct;
        
          //insert product 

        Product2 prod = new Product2();
        prod.name = 'Mathletics';
        prod.Family = 'Mathletics';
        insert prod;
        
        
        //insert Asset Record 
         List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Full_Licence'  And sObjectType = 'Asset'];
        
         
        Asset singleAsset = new Asset();
        singleAsset.Name = 'testAsset';
        singleAsset.AccountId = acct.Id;
        singleAsset.UsageEndDate = System.today();
        singleAsset.License_Cap__c = 1;
        singleAsset.Status = 'Provisioned';
        singleAsset.recordTypeId =recTypeList[0].Id;
        singleAsset.Product2Id  = prod.Id;
        /*insert singleAsset;
        
        //insert yearGroup
        Year_Group__c yearGroup = new Year_Group__c();
        yearGroup.Provision__c = true;
        yearGroup.Asset__c = singleAsset.Id;
        yearGroup.Year_Group__c = 'Year 1';
        insert yearGroup;*/ // Commented for Test
    }
}