@isTest(SeeAllData=true)
public class RHX_TEST_Opportunity {
    static testMethod void RHX_Testmethod() {
    
        List<sObject> sourceList = [SELECT Id 
            FROM Opportunity Where Quote_Count__c > 1 AND Number_Attachments__c > 1 LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    FakeObjectFactory.GetStandardOpportunity() 
            );
        }
        rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}