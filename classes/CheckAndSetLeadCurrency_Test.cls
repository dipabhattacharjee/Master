@isTest
public class CheckAndSetLeadCurrency_Test {
    public static testMethod void testLeadCurrency(){
        Lead ld = new Lead();
        ld.LastName = 'LeadNZ';        
        ld.Company = 'NZ School';
        ld.Country = 'New Zealand';  
        List<Lead>leadList = new List<Lead>();
        leadList.add(ld);
        new CheckAndSetLeadCurrency().setLeadCurrency(leadList);
        System.assert(true);
    }
        
}