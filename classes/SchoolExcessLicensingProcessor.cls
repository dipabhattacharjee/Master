public with sharing class SchoolExcessLicensingProcessor {

        //IgnoreThreshold is zero for now, we might need it in future
        //school type is like Private
        //Terrotory value is like APAC
        //Threshold :
        //1) If the difference between licence used and licence cap is less than threshold
        //And more than ignoreThreshold then
        //Upsell opty with sold stage needs to be created and quantity need to be the difference

        //2) If the difference between licence used and licence cap is more than threshold
        // Upsell opty with verbal aggreement stage needs be created
        // plus a task needs to be created and assign account manager with High priority
        public void SchoolExcessLicensingProcessor(Excess_Licensing__c config) {
        
            ServicesErrorLogs serviceErrorLog = new ServicesErrorLogs();
            String territory        = config.Territory__c;
            //String globalSchoolType = config.Global_School_Type__c;
            String schoolType       = config.School_Type__c;
            Integer threshold       = Integer.valueOf(config.Threshold__c);
            Integer ignoreThreshold = Integer.valueOf(config.Ignore_Threshold__c);
            String  productFamily   = config.Product_Family__c;

            boolean less_Than_Threshold_Required_Task =config.Less_Than_Threshold_Required_Task__c;
            boolean more_Than_Threshold_Required_Task =config.More_Than_Threshold_Required_Task__c;

            String less_Than_Threshold_Stage =  config.Less_Than_Threshold_Stage__c;
            String more_Than_Threshold_Stage =  config.More_Than_Threshold_Stage__c;
            Id designatedSalesUserId = null;

            if(config.Sales_User__R != null)
            {   
                 designatedSalesUserId = config.Sales_User__R.Id;
            }

            system.debug(config);

            EmailApi emailApi   = new EmailApi();

            Set<Id> accountIds  = GetActiveAccounts(territory, schoolType);
            
            List<Asset> assets  = GetProvisionedLicenses(accountIds, productFamily, ignoreThreshold);
                         
            system.debug('less_Than_Threshold_Stage:'+less_Than_Threshold_Stage);

              UpsellOpportunitywithProducts_Bulk upsellOpportunitywithProducts_Bulk = new    UpsellOpportunitywithProducts_Bulk();

        

            //Generating opportunity for less that defined threshold in CAP
            if(!String.isBlank(less_Than_Threshold_Stage))
            {
                List<Asset> assets_CapUsed_LessThan_Threshold  = GetAsset_withCAPUsed_LessThan_Threshold(assets, threshold);

               // List<Opportunity>   opportunities_1 = CreateUpsellOpportunity(assets_CapUsed_LessThan_Threshold, designatedSalesUserId );
                
               List<OpportunityAsset> opportunityAssets= upsellOpportunitywithProducts_Bulk.CreateUpsellOpportunity(assets_CapUsed_LessThan_Threshold, designatedSalesUserId, territory, schoolType);

               List<Opportunity> createdOpportunities =InsertOpportunity(opportunityAssets);


                MoveOpportunityToStage(createdOpportunities, less_Than_Threshold_Stage);

                if(less_Than_Threshold_Required_Task)
                {
                    CreateTaskForAccountManagers(createdOpportunities, productFamily);                    
                }
                emailApi.SendEmail(serviceErrorLog.getDevelopersEmail(), 'Excess licensing - Auto '+less_Than_Threshold_Stage +' opportunities,' +createdOpportunities.size(), createdOpportunities);

            }

            system.debug('more_Than_Threshold_Stage:'+more_Than_Threshold_Stage);
            if(!String.isBlank(more_Than_Threshold_Stage))
            {
                //Generating opportunity for more that defined threshold in CAP

                List<Asset> assets_CapUsed_MoreThan_Threshold  = GetAsset_withCAPUsed_MoreThan_Threshold(assets, threshold);

               // List<Opportunity>   opportunities_2 = CreateUpsellOpportunity(assets_CapUsed_MoreThan_Threshold,designatedSalesUserId);
                List<OpportunityAsset> opportunityAssets =  upsellOpportunitywithProducts_Bulk.CreateUpsellOpportunity(assets_CapUsed_MoreThan_Threshold, designatedSalesUserId, territory, schoolType);

                List<Opportunity> createdOpportunities =InsertOpportunity(opportunityAssets);

                MoveOpportunityToStage(createdOpportunities, more_Than_Threshold_Stage);

                if(more_Than_Threshold_Required_Task)
                {
                    CreateTaskForAccountManagers(createdOpportunities, productFamily);                  
                }

                emailApi.SendEmail(serviceErrorLog.getDevelopersEmail(), 'Excess licensing - Auto '+ more_Than_Threshold_Stage +' opportunities,' +createdOpportunities.size(), createdOpportunities);
            }
        }


    public List<opportunity> InsertOpportunity(List<OpportunityAsset> opportunityAssets)
    {
       

        List<Opportunity> filteredopportunities = new List<Opportunity>();
        List<OpportunityLineItem> filteredopportunityLineItem = new List<OpportunityLineItem>();

        for(OpportunityAsset opportunityAsset : opportunityAssets)
        {
            if(opportunityAsset.assetId == null || opportunityAsset.opportunity== null || opportunityAsset.opportunityLineItem== null)
                continue;
            
            filteredopportunities.add(opportunityAsset.opportunity);
            
        }

        insert filteredopportunities;        

        filteredopportunities = getOpportunitieswithTaxFields(filteredopportunities);
        //Set Tax for opportunities
        new DetermineTaxRatesOpportunity().calculateTaxRatesOnOpportunity(filteredopportunities);        

        update filteredopportunities;

        System.Debug('filteredopportunities : after update' + filteredopportunities);

        for(Opportunity opportunity :filteredopportunities ){

              for(OpportunityAsset opportunityAsset : opportunityAssets)
              {
                if(opportunityAsset.opportunity.AccountId == opportunity.AccountId &&
                   opportunityAsset.opportunity.Name == opportunity.Name)
                {
                    opportunityAsset.opportunityLineItem.opportunityId= opportunity.Id;
                    filteredopportunityLineItem.add(opportunityAsset.opportunityLineItem);
                }
              }
        }   
        if(!Test.isRunningTest())
        insert filteredopportunityLineItem;     

        return filteredopportunities;
        
    }

    public List<Opportunity> getOpportunitieswithTaxFields(List<Opportunity> filteredopportunities)
    {
        if(filteredopportunities.Size()>0){
            Set<Id> resultIds = (new Map<Id,SObject>(filteredopportunities)).keySet();
        

        List<Opportunity> opportunitiesWithTaxFields = [Select Id,School_Site_Country__c,AccountTerritory__c,AccountId,Type,
                                                        recordTypeId,StageName,CloseDate,Name,CurrencyISOCode,Pricebook2Id,
                                                        TaxCode__c,TaxCodeInternalID__c,TaxRate__c, Account.OwnerId,OwnerId
                                                         from Opportunity
                                                        where Id IN :resultIds];

        System.debug('opportunitiesWithTaxFields : ' + opportunitiesWithTaxFields);
        return opportunitiesWithTaxFields;

        }        
        return filteredopportunities;        
    }

   /* public void InsertOpportunityLineItemInBatch(List<OpportunityLineItem> opportunityLineItems)
    {
        List<OpportunityLineItem> opportunityLineItemBatch= new  List<OpportunityLineItem>();

        Integer batchSize=5;
        
        Insert_Batch_Size__c insert_Batch_Size= Insert_Batch_Size__c.getInstance('OpportunityLineItem');
        
        if(insert_Batch_Size != null)
        {
            batchSize= insert_Batch_Size.Batch_Size__c.intValue();
        }  

        if(batchSize >= opportunityLineItems.size())
        {
            insert opportunityLineItems;  
            return;
        }

        for(Integer i = 0; i < opportunityLineItems.size(); i++) 
        {
            if(opportunityLineItemBatch.size() < batchSize)
            {
                opportunityLineItemBatch.add(opportunityLineItems[i]);
            }                
            
            if(opportunityLineItemBatch.size() == batchSize )
            {
                
                insert opportunityLineItemBatch;
                opportunityLineItemBatch= new  List<OpportunityLineItem>();
            } 

            //We are in the last insert
            if(opportunityLineItemBatch.size()>0 &&  opportunityLineItemBatch.size() == math.mod(opportunityLineItems.size(), batchSize))
            {
                 insert opportunityLineItemBatch;
            }              

        }



    }
*/
    public Set<Id> GetActiveAccounts(String territory,String schoolType)
    {

        List<Account> accounts = [select Id 
                                    from account 
                                    where 
                                        Status__c in ('New Customer','Existing Customer','Returned Customer')
                                        And
                                        Territory__c     = :territory
                                        And
                                        School_Type__c   =  :schoolType
                                        And 
                                        Disable_Auto_upsell__c  = false];

        Set<Id> accountIds = (new Map<Id,SObject>(accounts)).keySet();

        return accountIds;

    }

    //Map<AccountId, List of asset for the account> 
    public List<Asset> GetProvisionedLicenses(Set<Id> accountIds, String productFamily,Integer ignoreThreshold)
    {
        Date maxdate = System.today().addDays(25);
        List<Asset> assets = [select Id, AccountId , Registered_students_licence_cap__c, 
                                     Product2Id ,Product2.Family, InstallDate, UsageEndDate,
                                     Original_End_Date__c, Opportunity__R.Id,
                                     Opportunity_Product_Id__c, Status, License_Cap__c,Account.CurrencyISOCode, Account.Territory__c, Account.ShippingCountry
                                from 
                                    Asset
                                where
                                    Registered_students_licence_cap__c > :ignoreThreshold
                                and accountId           in  :accountIds
                                and status              =   'Provisioned'
                                and Product2.Family     =   :productFamily
                                and UsageEndDate        >   :maxdate];

        system.debug('assets.count:'+ assets.size());
        system.debug('assets:'+ assets);

        return assets ;
    }

    public  List<Asset> GetAsset_withCAPUsed_LessThan_Threshold( List<Asset> assets,Integer threshold)
    {
        //Map<AccountId, List<Asset>>
        List<Asset> assetLessThanThreshold  = new   List<Asset>();

        for(Asset asset : assets)
        {
            if(asset.Registered_students_licence_cap__c <= threshold )
            {
                assetLessThanThreshold.add(asset);
            }
        }

        system.debug('GetAsset_withCAPUsed_LessThan_Threshold.Count:'+ assetLessThanThreshold.size());

        return assetLessThanThreshold;
    }

    public List<Asset> GetAsset_withCAPUsed_MoreThan_Threshold(List<Asset> assets,Integer threshold)
    {
        //Map<AccountId, List<Asset>>
        List<Asset> assetMoreThanThreshold  = new   List<Asset>();

        for(Asset asset : assets)
        {
            if(asset.Registered_students_licence_cap__c > threshold )
            {
                assetMoreThanThreshold.add(asset);
            }
        }

        system.debug('GetAsset_withCAPUsed_MoreThan_Threshold.Count:'+ assetMoreThanThreshold.size());

        return assetMoreThanThreshold;
    }

   

    

    public void MoveOpportunityToStage(List<Opportunity> opportunities , String stageName)
    {
      
        for(Opportunity opportunity : opportunities)
        {
            opportunity.stageName = stageName;
        }

        update opportunities;
    }

    
    public void CreateTaskForAccountManagers(List<Opportunity> opportunities, String productFamily)
    {
        List<Task> tasks = new List<Task>();

        for(Opportunity opportunity : opportunities)
        {
            Task task               = new Task();
            task.OwnerId            = opportunity.OwnerId;
            task.WhatId             = opportunity.Id;
            task.Subject            = opportunity.Name + ' - Reminder';
            task.priority           = 'High';   
            task.Activity_Subtype__c= 'Agreement';
            task.Activity_Type__c   = 'Email';
            task.Description        = 'Excess licensing negotiation remidner for '+ opportunity.Name ;
            task.Subject            = 'Excess licensing negotiation reminder';
            task.ActivityDate       = system.today().addDays(7);

            if(productFamily == 'Mathletics')
            {
                task.Product_Mathletics__c = true;
            }

            if(productFamily == 'Spellodrome')
            {
                task.Product_Spellodrome__c = true;
            }

            if(productFamily == 'IntoScience')
            {
                task.Product_IntoScience__c = true;
            }

            if(productFamily == 'ReadingEggs')
            {
                task.Product_ReadingEggs__c = true;
            }
            tasks.add(task);
        }

        insert tasks;

       
        
    }

}