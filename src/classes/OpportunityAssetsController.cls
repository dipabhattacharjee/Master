/*
 * @author Vishnu Belkone
 * @description This class is to display all Assets for the Account which is associated to the Opportunity .
 * @TestClass: OpportunityAssetsController_Test
*/
public class OpportunityAssetsController {
   //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // the actual lead
    private Opportunity opp;
    private List<Opportunity> OppList{get;Set;}
    public List<Asset>assetListForCurrentOpp{get;Set;}
    public OpportunityAssetsController(ApexPages.StandardController stdController){
        this.controller = stdController;
        this.opp = (Opportunity)controller.getRecord();
        OppList = [select Id,name,AccountId from Opportunity where Id = :opp.Id];
        If(OppList != null && OppList.size() > 0){
            getAssetsForOpportunity(OppList[0]);
			//this.controller.setPageSize(5);
        }       
        
    }
    public void getAssetsForOpportunity(Opportunity opp){
        assetListForCurrentOpp = [Select Id,name,Product2.name,Product2.Family,PurchaseDate,UsageEndDate,InstallDate,Trial_License__c,License_Cap__c,Type_of_License__c,Status from Asset where AccountId = :opp.AccountId];
    }
	
   
}