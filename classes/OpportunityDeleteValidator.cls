/**
*This class is getting called from opportunityBeforeDeleteTriggerHandller
*This class contains funtionality to validate opportunity befor getting deleted and give errors.
**/
public class OpportunityDeleteValidator {

    
    public OpportunityDeleteValidator(){}
    Public List<Opportunity> validate(List<Opportunity> oppList){
        return ValidateOpportunityWasConverted(ValidateOpportunityHasSalesOrder(ValidateOpportunityHasQuote(ValidateOpportunityHasLicence(ValidateOpportunityType(ValidateOpportunityStage(oppList))))));
    }
    
    /**
	*This function is to check Opportunity stages and give error if the stage is greater than Sold
	*/
    public List<Opportunity> ValidateOpportunityStage(List<Opportunity> opportunityList){
        
        
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>();
        Map<String,OpportunityDeletetStagesNotAllowed__c> OpportunityDeletetStagesNotAllowedMap = OpportunityDeletetStagesNotAllowed__c.getAll();
        //Set<String> oppprtunityStages = OpportunityDeletetStagesNotAllowedMap.keySet();
        for(Opportunity Opty : opportunityList)
        {
            if(OpportunityDeletetStagesNotAllowedMap.containsKey(Opty.stageName))
            {
                Opty.addError('Cannot delete Opportunities in this Stage. Please move to LOST with a valid reason selected.');                
            }
            else {
                canDeleteOpportunity.add(Opty);
            }            
            
        }
        return canDeleteOpportunity;
    }
    
    /**
	*This function is to check Opportunity type and give error if the type is renewal or Up Sell
	*/
    public List<Opportunity> ValidateOpportunityType(List<Opportunity> opportunityList){
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>();
        Map<String,OpportunityDeletetTypeNotAllowed__c> OpportunityDeletetTypeNotAllowed = OpportunityDeletetTypeNotAllowed__c.getAll();
        for(Opportunity Opty : opportunityList)
          {            
            if(OpportunityDeletetTypeNotAllowed.containsKey(Opty.Type))
            {                
            	Opty.addError('Cannot delete Opportunities of Type Upsell or Renewal. Please move to LOST with a valid reason selected.');    
            }else{
				  canDeleteOpportunity.add(Opty);             
            }          
          }
        return canDeleteOpportunity;
    }
    
    /**
	*This function checks If the opportunity has licences then give an error. 
	*/
    public List<Opportunity> ValidateOpportunityHasLicence(List<Opportunity> opportunityList){
        Map<Id,List<Asset>> oppIdVsAssetListMap = getOpportunityIdVsAssetList(new Map<Id,Opportunity>(opportunityList).keySet());
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>(); 
        for(Opportunity opp: opportunityList){
            If(oppIdVsAssetListMap.containsKey(opp.Id)){
                opp.addError('Cannot delete opportunity with a licence. Please move to LOST with a valid reason selected.');
            }else{
                canDeleteOpportunity.add(opp);
            }
        }
        return canDeleteOpportunity;
    }
    
    /**
	*This function checks If the opportunity has Quote then give an error. 
	*/
    public List<Opportunity> ValidateOpportunityHasQuote(List<Opportunity> opportunityList){
        Map<Id,List<Quote>> oppIdVsQuoteListMap = getOpportunityIdVsQuoteList(new Map<Id,Opportunity>(opportunityList).keySet());
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>(); 
        for(Opportunity opp: opportunityList){
            If(oppIdVsQuoteListMap.containsKey(opp.Id)){
                opp.addError('Cannot delete opportunity with a quote. Please move to LOST with a valid reason selected.');
            }else{
                canDeleteOpportunity.add(opp);
            }
        }
        return canDeleteOpportunity;
    }
    
    /**
	*This function checks If the opportunity has Sales Order then give an error. 
	*/
    public List<Opportunity> ValidateOpportunityHasSalesOrder(List<Opportunity> opportunityList){
        Map<Id,List<ACTNSCRM__Actian_Sales_Order__c>> oppIdVsSalesOrderListMap = getOpportunityIdVsSalesOrderList(new Map<Id,Opportunity>(opportunityList).keySet());
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>(); 
        for(Opportunity opp: opportunityList){
            If(oppIdVsSalesOrderListMap.containsKey(opp.Id)){
                opp.addError('Cannot delete opportuntiy with a SalesOrder. Please move to LOST with a valid reason selected.');
            }else{
                canDeleteOpportunity.add(opp);
            }
        }
        return canDeleteOpportunity;
    }
    
    /**
	*This function checks If the opportunity has been converted from Lead then give an error. 
	*/
    public List<Opportunity> ValidateOpportunityWasConverted(List<Opportunity> opportunityList){
        Map<Id,List<Lead>> oppIdVsLeadListMap = getOpportunityIdVsLeadList(new Map<Id,Opportunity>(opportunityList).keySet());
        List<Opportunity> canDeleteOpportunity = new List<Opportunity>(); 
        for(Opportunity opp: opportunityList){
            If(oppIdVsLeadListMap.containsKey(opp.Id)){
                opp.addError('Opportunity Converted from Lead cannot be deleted. Please move to LOST with a valid reason selected.');
            }else{
                canDeleteOpportunity.add(opp);
            }
        }
        return canDeleteOpportunity;
    }
    
    /**
	*This function returns Opportunity Id Vs Assets. 
	*/
    public Map<Id,List<Asset>> getOpportunityIdVsAssetList(Set<Id> opportunityIds){
        List<Asset> assetList = [Select Id,Name,Opportunity__c from Asset where Opportunity__c IN :opportunityIds];
        Map<Id,List<Asset>> oppIdVsAssetListMap = new Map<Id,List<Asset>>();
        
        for(Asset ast: assetList){
            If(oppIdVsAssetListMap.containsKey(ast.Opportunity__c)){
                oppIdVsAssetListMap.get(ast.Opportunity__c).add(ast);
            }else{
                oppIdVsAssetListMap.put(ast.Opportunity__c,new List<Asset>{ast});
            }
        }
        return oppIdVsAssetListMap;
    }
    
    /**
	*This function returns Opportunity Id Vs quotes. 
	*/
    public Map<Id,List<Quote>> getOpportunityIdVsQuoteList(Set<Id> opportunityIds){
        List<Quote> quoteList = [Select Id,Name,OpportunityId from Quote where OpportunityId IN :opportunityIds];
        Map<Id,List<Quote>> oppIdVsQuoteListMap = new Map<Id,List<Quote>>();
        
        for(Quote qut: quoteList){
            If(oppIdVsQuoteListMap.containsKey(qut.OpportunityId)){
                oppIdVsQuoteListMap.get(qut.OpportunityId).add(qut);
            }else{
                oppIdVsQuoteListMap.put(qut.OpportunityId,new List<Quote>{qut});
            }
        }
        return oppIdVsQuoteListMap;
    }
    
    /**
	*This function returns Opportunity Id Vs Sales Order. 
	*/
    public Map<Id,List<ACTNSCRM__Actian_Sales_Order__c>> getOpportunityIdVsSalesOrderList(Set<Id> opportunityIds){
        List<ACTNSCRM__Actian_Sales_Order__c> salesOrderList = [Select Id,Name,ACTNSCRM__Opportunity__c  from ACTNSCRM__Actian_Sales_Order__c where ACTNSCRM__Opportunity__c  IN :opportunityIds];
        Map<Id,List<ACTNSCRM__Actian_Sales_Order__c>> oppIdVsSalesOrderListMap = new Map<Id,List<ACTNSCRM__Actian_Sales_Order__c>>();
        
        for(ACTNSCRM__Actian_Sales_Order__c salesOrder: salesOrderList){
            If(oppIdVsSalesOrderListMap.containsKey(salesOrder.ACTNSCRM__Opportunity__c )){
                oppIdVsSalesOrderListMap.get(salesOrder.ACTNSCRM__Opportunity__c ).add(salesOrder);
            }else{
                oppIdVsSalesOrderListMap.put(salesOrder.ACTNSCRM__Opportunity__c, new List<ACTNSCRM__Actian_Sales_Order__c>{salesOrder});
            }
        }
        return oppIdVsSalesOrderListMap;
    }
    
    /**
	*This function returns Opportunity Id Vs Leads. 
	*/
    public Map<Id,List<Lead>> getOpportunityIdVsLeadList(Set<Id> opportunityIds){
        List<Lead> leadList = [SELECT IsConverted, ConvertedOpportunityId, Id FROM Lead where ConvertedOpportunityId  IN :opportunityIds];
        Map<Id,List<Lead>> oppIdVsLeadListMap = new Map<Id,List<Lead>>();
        
        for(Lead lead: leadList){
            If(oppIdVsLeadListMap.containsKey(lead.ConvertedOpportunityId )){
                oppIdVsLeadListMap.get(lead.ConvertedOpportunityId ).add(lead);
            }else{
                oppIdVsLeadListMap.put(lead.ConvertedOpportunityId ,new List<Lead>{lead});
            }
        }
        return oppIdVsLeadListMap;
    }
    
    
}