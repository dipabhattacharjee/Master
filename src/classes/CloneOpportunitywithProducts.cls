/**
* @author: vishnu belkone
* @description: this class is to clone opportunity and its products, it is called from opportunity trigger.
* @TestClass: CloneOpportunitywithProducts_Test
*/
public class CloneOpportunitywithProducts { 
    public void cloneOpptyWithProducts(Set<Id> oppIds){
        try 
        {           
            System.debug('cloneOpptyWithProducts oppIds:' + oppIds.size());
            List<Opportunity>oppList = getOpptyVsProducts(oppIds);
            System.debug('cloneOpptyWithProducts oppList:' + oppList.size());
            Map<Opportunity,List<OpportunityLineItem>>oppMapToInsert = getOpportunityMapToClone(oppList, oppIds);
            List<Opportunity> oppListToCLone = new List<Opportunity>();            
            List<OpportunityLineItem>oppLineItemesToInsert = new List<OpportunityLineItem>();            
        }
        catch (Exception   ex)
        {
            system.debug(loggingLevel.error, ex);
            throw ex;           
        }         
    }

    public Map<Opportunity,List<OpportunityLineItem>> getOpportunityMapToClone(List<Opportunity> oppListToClone,Set<Id> oppIds){
        List<Opportunity>opportunityListToInsert = new List<Opportunity>();// = new List<Opportunity>();        
        Map<Opportunity,List<OpportunityLineItem>> oppVsLineItemsMap = new Map<Opportunity,List<OpportunityLineItem>> ();
        List<Opportunity> Donotdeletelist = new List<Opportunity>();
        Set<Opportunity> SettoDelete = New Set<Opportunity>();
        
        Map<Id,List<OpportunityLineItem>>oppIdVsProduct = fetchOppVsProduct(oppIds);
        Opportunity oppToClone;
        OpportunityLineItem oppLineItem;
        List<OpportunityLineItem>oppLineItemList = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLineItemes = new List<OpportunityLineItem>();
        System.debug('Hi this is to test the data oppListToClone' + oppListToClone);               
        if (oppListToClone != null && oppListToClone.size() > 0)
        {
            for (Opportunity opp : oppListToClone)
            {
            System.debug('Hi this is to oppLineItem List ' + opp.opportunityLineItems[0]);
                if (opp.StageName == 'Sold - Invoiced')
                {   
                    oppToClone = new Opportunity();
                    oppToClone.RecordTypeId = opp.RecordTypeId;
                    oppToClone = opp.clone(false,true,false,true);
                    oppToClone.Auto_Renewal__c = opp.Auto_Renewal__c;
                    if(opp.name.length() > 110)
                    {
                        oppToClone.name = opp.name.Substring(0,110);
                    } 
                    else{
                    oppToClone.name = opp.name.removeEnd(' - Renewal');
                    }
                    oppToClone.name = oppToClone.name +' - ' + 'Renewal'; 

                    //oppToClone.name = opp.name +' - ' + 'Renewal';
                    oppToClone.StageName = 'Interest';
                    //oppToClone.CloseDate = date.today() + 365;                
                    if(opp.MinLicenceEndDate__c != null)    
                    {oppToClone.CloseDate =  opp.MinLicenceEndDate__c.toStartOfMonth()-1 ;}
                    else{oppToClone.CloseDate = date.today() + 365;}
                        
                        //DATE(YEAR(opp.MinLicenceEndDate__c + 365),MONTH(opp.MinLicenceEndDate__c + 365),1)-1;


                    
                   If(opp.Multi_Year_Deal__c && opp.Number_of_years__c!= null && Integer.valueOf(opp.Number_of_years__c) > 2){
                        oppToClone.Number_of_years__c = String.valueOf(Integer.valueOf(opp.Number_of_years__c) -1);                    
                   }else if(opp.Multi_Year_Deal__c && opp.Number_of_years__c!= null && Integer.valueOf(opp.Number_of_years__c) > 0){
                        oppToClone.Number_of_years__c = null;
                   }

                   
                   If(opp.Number_of_years__c != null && Integer.valueOf(opp.Number_of_years__c) > 1 ){
                        oppToClone.Multi_Year_Deal__c = true;
                   }else{
                    oppToClone.Multi_Year_Deal__c = false;
                   }
                    
                    oppToClone.Payment_Timing__c = null;                                                          
                    oppToClone.CurrencyIsoCode = opp.CurrencyIsoCode;
                    oppToClone.ACTNSCRM__NS_Currency__c = opp.ACTNSCRM__NS_Currency__c;
                    oppToClone.ownerId = oppToClone.account.OwnerId;
                    oppToClone.Type = 'Renewal';
                    insert oppToClone;
                    
                    if (oppIdVsProduct.get(opp.Id) != null && oppIdVsProduct.get(opp.Id).size() > 0 )
                    {
                        for (OpportunityLineItem oppLine : oppIdVsProduct.get(opp.Id))
                        {
                            oppLineItem = new OpportunityLineItem();
                            oppLineItem = oppLine.clone(false,true,false,true);
                            oppLineItem.OpportunityId = oppToClone.Id;
                            If(oppToClone.Multi_Year_Deal__c == true){
                                oppLineItem.Discount = oppLine.Discount;
                                oppLineItem.DiscountReason__c = oppLine.DiscountReason__c;
                                oppLineItem.Description  = oppLine.Description;
                            }else {
                                
                                oppLineItem.Discount = null;
                                oppLineItem.DiscountReason__c = null;
                                oppLineItem.Description  = null;
                            }
                            if(oppLine.SubscriptionEndDate__c != null && oppLine.SubscriptionStartDate__c != null){
                                oppLineItem.SubscriptionStartDate__c = oppLine.SubscriptionEndDate__c + 1;
                                If(oppLineItem.Licence_Months__c >= 24 ){
                                    oppLineItem.SubscriptionEndDate__c = (oppLineItem.SubscriptionStartDate__c.addMonths(24)).addDays(-1);
                                    //oppLine.SubscriptionEndDate__c + oppLine.SubscriptionStartDate__c.daysBetween(oppLine.SubscriptionEndDate__c);
                                }else{
                                    oppLineItem.SubscriptionEndDate__c = (oppLineItem.SubscriptionStartDate__c.addMonths(12)).addDays(-1);
                                }
                                
                            }
                            if (oppLineItem.Family__c <> 'Other')
                            {
                               oppLineItemList.add(oppLineItem);
                               Donotdeletelist.add(oppToClone);
                               SettoDelete.remove(oppToClone);                                                              
                               System.debug('SettoDelete in not Other' + SettoDelete);
                               System.debug('Donotdeletelist in not Other' + Donotdeletelist);
                            }
                            else if (oppLineItem.Family__c == 'Other')
                            {                                
                                SettoDelete.add(oppToClone);                                
                                System.debug('SettoDelete in Other' + SettoDelete);
                            }
                            
                        }   
                    }
                
                    System.debug('oplineItem to insert ' + oppLineItemList);
                    oppVsLineItemsMap.put(oppToClone,oppLineItemList);  
                    opportunityListToInsert.add(oppToClone);
                }
                
            }
        }
        List<Opportunity> OptytoDelete = New List<Opportunity>();
        System.debug('SettoDelete End ' + SettoDelete);        
        System.debug('Donotdeletelist End ' + Donotdeletelist);        
                
        if(SettoDelete.size() > 0)
        {
             SettoDelete.removeAll(Donotdeletelist);
        }   
        
        System.debug('SettoDelete End 2' + SettoDelete);        
        
        if(SettoDelete.size() > 0)
        {           
            OptytoDelete.addAll(SettoDelete);
        }
        delete OptytoDelete;        
        
        System.debug('Map to insert ' + oppVsLineItemsMap);
        if (oppLineItemList != null && oppLineItemList.size() > 0)
        {        
            insert oppLineItemList;
        }
        
        return oppVsLineItemsMap;
    }

    //fetch opportunity vs product  list 
    public List<Opportunity> getOpptyVsProducts(Set<Id> oppIds){
        Id standardRecordTypeId = fetchBankRecordTypeIdOfTrialOppty();
        Id clusterRecordTypeId = fetchBankRecordTypeIdOfCluster();
        system.debug('standardRecordTypeId:'+ standardRecordTypeId + ', clusterRecordTypeId:'+ clusterRecordTypeId + ', oppIds:' + oppIds);

        List<Opportunity> oppListToClone = [select Id,name,RecordTypeId,CurrencyIsoCode,Multi_Year_Deal__c,Number_of_years__c,
                                            account.name,account.CurrencyIsoCode,CloseDate,Owner.name,StageName,amount,account.OwnerId,MinLicenceEndDate__c,Auto_Renewal__c,ACTNSCRM__NS_Currency__c,
                                            (select Id,Name,ServiceDate,PricebookEntryId,Description,ListPrice,OpportunityId,Product2Id,ProductCode,Quantity,TotalPrice,
                                             License_Provisioned__c,Provision_Full_License__c,Provision_Trial_License__c,Trial_Provisioned__c,Trial_Start_Date__c,
                                             SubscriptionStartDate__c,SubscriptionEndDate__c,Discount,DiscountReason__c 
                                             from opportunityLineItems) from Opportunity Where Id IN :oppIds 
                                             AND (Type = 'New Business' OR Type = 'Cross Sell' OR Type = 'Renewal') 
                                             AND StageName ='Sold - Invoiced'       
                                             AND (recordTypeId = :standardRecordTypeId OR recordTypeId = :clusterRecordTypeId)];
        return oppListToClone;
    } 

    //get Standard Opportunity record type Id 
    private Id fetchBankRecordTypeIdOfTrialOppty(){

        Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();

        return opportunityRecordTypeId;

        // List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Standard_Opportunity'  And sObjectType = 'Opportunity'];
        // if(recTypeList != null && recTypeList.size() > 0) {
        //     return recTypeList[0].Id;
        // }
        // return null;
    }
    //get Cluster Opportunity record type Id 
    private Id fetchBankRecordTypeIdOfCluster(){

         Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cluster Opportunity').getRecordTypeId();

        return opportunityRecordTypeId;

        // List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Cluster_Opportunity'  And sObjectType = 'Opportunity'];
        // if(recTypeList != null && recTypeList.size() > 0) {
        //     return recTypeList[0].Id;
        // }
        // return null;
    }


    public Map<Id,List<opportunityLineItem>> fetchOppVsProduct(Set<Id> oppIds){
        Map<Id,List<opportunityLineItem>> oppVsProduct = new Map<Id,List<opportunityLineItem>>();
        List<opportunityLineItem > oppProductsList = [select Id,Name,ServiceDate,Family__c,Description,ListPrice,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Quantity,UnitPrice,
        License_Provisioned__c,ACTNSPC__Quantity_Price__c,Orginal_Sales_Price__c,Licence_Months__c,SubscriptionStartDate__c,SubscriptionEndDate__c,Provision_Full_License__c,Discount,DiscountReason__c from opportunityLineItem where opportunityId IN :oppIds];
        if (oppProductsList != null && oppProductsList.size() > 0)
        {
            for (opportunityLineItem oppItem : oppProductsList )
            {
                if (oppVsProduct.containsKey(oppItem.OpportunityId))
                {
                    oppVsProduct.get(oppItem.OpportunityId).add(oppItem);
                }else{
                    oppVsProduct.put(oppItem.OpportunityId , new List<opportunityLineItem>{oppItem});
                }
            }
           
        }
        System.debug('this is map, oppProductsList:' + oppProductsList);
        System.debug('this is map, oppVsProduct:' + oppVsProduct);
        return oppVsProduct;
    }


}