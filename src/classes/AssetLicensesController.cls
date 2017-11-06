/**
* @author: vishnu belkone
* @description: this is class is an controller to retrive licences and display on page 
* @TesstClass: AssetLicensesController_Test
*/
public with sharing class AssetLicensesController {
    public Opportunity opp{get;set;}
    public OpportunityLineItem oppLineItem{get;set;}  
    public String territoryType{get;set;}
    public Boolean isSelected{get;set;}
    public Boolean isValidated{get;set;}
    public List<Asset> assetList{get;set;}
    public List<AssetLicencesWrapperForRenewal> assetWrapperList {get; set;}
  public Set<Id>assetIds {get;Set;}
    public AssetLicensesController (){
     this.opp  = new Opportunity();
   assetIds = new Set<Id>();
    }

    //method to do a call to assetwrapper and get list of licenses to display.
    public pageReference search(){      
       validationsOnInput();
        if(isValidated != false){
            assetWrapperList = new AssetLicencesWrapperForRenewal().assetWrapper(opp.Start_Date__c,opp.End_Date__c,opp.CloseDate,territoryType,opp.OwnerId); 
      if (assetWrapperList == null || assetWrapperList.size() == 0)
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There are no licences for selected search criteria, please change search criteria and try again.'));
      }
    }
      
      system.debug('----assetWrapperList---'+assetWrapperList);
      return null;
   }

   //validate to check all fields are mandatory.
    public void validationsOnInput(){
       isValidated = true;
       if( opp.Start_Date__c == null || opp.End_Date__c == null || opp.CloseDate == null){          
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide all required Details required.'));            
          isValidated = false;
       }else If(territoryType == 'My Territory' && opp.OwnerId == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'If \'My Territory Schools\' is selected then User should be selected.'));            
            isValidated = false;
       }
   }

    public PageReference createOpportunities(){
        Savepoint recordsavePoint = Database.setSavepoint();
        try{
      
       if (assetWrapperList != null && assetWrapperList.size() > 0 )
      {
        assetIds =   new CreateOpportunitiesForLicencesRenewal().opportuniiesForRenewal(assetWrapperList,opp.closeDate,opp.Pricebook2Id,assetIds);
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Opportunities Created Successfully'));
        
        // return null;
      }else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No records are selected to create opportunities, please select at least one record to create opportunity.'));
      }         
          return null;
        }catch(Exception ex){
          Database.rollback(recordsavePoint);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));    
          return null;        
        }
        
    }

    //method to add options of radio button in list.
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('My','My Schools')); 
        options.add(new SelectOption('My Territory','My Territory Schools')); return options; 
    }
}