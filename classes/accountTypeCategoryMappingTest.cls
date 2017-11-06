@isTest
public class accountTypeCategoryMappingTest { 
    public static testMethod void testAccountCategoryTypeMap()  {
        accountTypeCategoryMapping categoryTypeMap = new accountTypeCategoryMapping();
        Account acc = new Account();
		acc.Name = 'test';
        acc.School_Category__c = 'test';
        acc.School_Type__c = 'test';
        acc.Territory__c = 'test';
		insert acc;
        List<Account> accountList = new List<Account>();
        accountList.add(acc);
        Map<Id,Account>accountMap = new Map<Id,Account>(accountList );
        categoryTypeMap.typeCategoryMappingForInsert(accountList);
        categoryTypeMap.typeCategoryMapping(accountList,accountMap );

    }

    @testSetup static void insertRecords(){
        Type_Category_Mapping__c typeCat = new Type_Category_Mapping__c();
        typeCat.Country__c = 'test';
        typeCat.Field__c = 'Type';
        typeCat.Source_Value__c = 'test';
        typeCat.Target_Value__c = 'test';
        insert typeCat;

		 //insert Trigger_Handler__c custom setting 
		Trigger_Handler__c handler = new Trigger_Handler__c();
		handler.Name = 'Block Trigger';
		handler.Block_Trigger_Execution__c = true;
		insert handler;	

    }
}