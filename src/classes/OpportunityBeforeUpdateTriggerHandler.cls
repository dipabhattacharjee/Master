public class OpportunityBeforeUpdateTriggerHandler extends TriggerHandlerBase{
    
    public override void mainEntry(TriggerParameters tp) {
       System.debug('Before Opportunity Update Call');
        
        if(!TriggerSetting.IsTriggerBlocked() && !TriggerSetting.IsCurrentUserIntegrationUser())
        {
          
          process(tp.newList,tp.oldMap.values());   
          updateOpportunityLineItems(tp.newMap.keySet(),tp.newList,tp.oldMap.values());  
       }
    }  
    
    public void updateOpportunityLineItems(Set<Id> oppIds,List<Opportunity> opportunties,List<Opportunity> oldOpportunities){
        new UpdateLineItemsWhenPriceBookChanged().updateOpportunityLineItemsWhenPriceBookChanged(oppIds,opportunties,new Map<Id,Opportunity>(oldOpportunities));
    }
    
    private static void process(List<Opportunity> opportunityList,List<Opportunity> oldOppList) {
        
        Map<Id, Opportunity> oppOldMap = new Map<Id,Opportunity>(oldOppList);

        System.debug('New Before Count: ' + opportunityList.size());
        System.debug('Old Before Count: ' + oldOppList.size());

        Id standardOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();


        For(Opportunity Opty : opportunityList) 
        {    

         //Only update close date of opportunity when
            //moving opty from any stage except Sold- adjustment and Sold-Invoiced                      
            if(oppOldMap.get(Opty.Id).StageName != 'Sold - Adjustment'  && 
               oppOldMap.get(Opty.Id).StageName != 'Sold - Invoiced'  && oppOldMap.get(Opty.Id).StageName != 'Sold'  )
              {
                  if(opty.StageName == 'Sold') 
                  {   
                    opty.CloseDate = date.Today();   
                  } 
              }   

              if(standardOpportunityRecordTypeId != opty.recordTypeId)
            {
               continue;
            }         
                
                                                
              
            OpportunityValidator opportunityValidator = new OpportunityValidator();

            // If oppertunity stage has not been changed ten we don't need to perfom any CRUD operation on Asset
            if(oppOldMap.get(Opty.Id).StageName == Opty.StageName)
            {
                continue;
            }

            /*  Opty.StageName == 'Sold - Adjustment' */
                          
              try
              {  
                if (Opty.StageName == 'Trial' ||
                    Opty.StageName == 'Sold'  )
                { 
                  if(opty.Type == 'Up Sell' )
                  {
                      opportunityValidator.ValidateUpSell(Opty);
                  } 
                  else
                  {   
                      System.debug('Validating Opty');             
                      opportunityValidator.Validate(Opty);                    
                  } 
                }
              }
              catch(ValidationException ex)
              {
                  Opty.AddError(ex.getMessage());
              }
              catch(ConflictException ex)
              {
                  Opty.AddError(ex.getMessage());
              }



        }    
        //new OpportunityAssociateCurrency().setCurrency(opportunityList);
        new DetermineTaxRatesOpportunity().calculateTaxRatesOnOpportunity(opportunityList);
        
    }
}