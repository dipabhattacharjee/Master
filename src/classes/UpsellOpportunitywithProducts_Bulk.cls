public with sharing class UpsellOpportunitywithProducts_Bulk {
	public UpsellOpportunitywithProducts_Bulk() {
		
		  ProductSelector productSelector = new ProductSelector();
		  opportunityDuplicateChecker 	 = new OpportunityDuplicateChecker();
      products                    	 = productSelector.GetProducts();
      pricebooks 						         = PriceBookIdentifier.GetActivePricebooks();

        standardOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard Opportunity').getRecordTypeId();
        lockedOpportunityRecordTypeId   = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Locked Opportunity').getRecordTypeId();

        standardPricebook = PricebookIdentifier.GetStandardRegionalPricebook();
        pricebookEntries  = UpsellOpportunitywithProducts.GetPricebookEntries();
        pricebookMappingList = PricebookIdentifier.GePricebookMapping();

        

	}

	 private Map<Id, Product2> products;
 	 private Map<Id, Pricebook2> pricebooks;
	 private OpportunityDuplicateChecker opportunityDuplicateChecker;
	 Id standardOpportunityRecordTypeId;
	 Id lockedOpportunityRecordTypeId;
	 Pricebook2 standardPricebook;
	 List<PricebookEntry> pricebookEntries;
   Map<String, Map<String, Id>> pricebookMappingList;
	


	public List<Id> GetOpportunityIds(List<Asset> assets)
	{
		List<Id> opportunityIds = new List<Id>();

	system.debug('GetOpportunityIds.assets:'+assets);

			for(Asset asset : assets)
			{
				opportunityIds.add(asset.Opportunity__c);
			}

			system.debug('opportunityIds:'+opportunityIds);
		return opportunityIds;

	}

	public List<Id> GetAccountIds(List<Asset> assets)
	{
		List<Id> accountIds = new List<Id>();

			for(Asset asset : assets)
			{
				accountIds.add(asset.AccountId);
			}
		return accountIds;

	}

	public List<Id> GetRelatedOpportunityLineItem(List<Asset> assets)
	{
		List<Id> opportunityIds = new List<Id>();

		for(Asset asset : assets)
		{
			opportunityIds.add(asset.Opportunity__c);
		}

		return opportunityIds;

	}


	public Map<Id, opportunity>  GetOpportunities(List<Asset> assets)
	{
			
			List<Id> opportunityIds = GetOpportunityIds(assets);

			
		    Map<Id, Opportunity>  opportunities = new Map<Id, Opportunity> ([
                                    SELECT 
                                        Id,name,RecordTypeId,CurrencyIsoCode,Multi_Year_Deal__c,Number_of_years__c,
                                        account.name,account.CurrencyIsoCode,CloseDate,Owner.name,StageName,amount,
                                        account.OwnerId,MinLicenceEndDate__c,OwnerId,Pricebook2.Id, AccountTerritory__c,School_Site_Country__c
                                    FROM 
                                        Opportunity 
                                    Where 
                                        Id IN :opportunityIds
                                        AND (Type = 'New Business' OR Type = 'Cross Sell' OR Type = 'Renewal') 
                                        AND StageName ='Sold - Invoiced' 
                                        AND (recordTypeId = :standardOpportunityRecordTypeId or recordTypeId = :lockedOpportunityRecordTypeId) 
                                      
                                    ]);

		    system.debug('opportunities:'+opportunities + ',lockedOpportunityRecordTypeId:'+lockedOpportunityRecordTypeId+',standardOpportunityRecordTypeId:'+standardOpportunityRecordTypeId);

		    return opportunities;
	}

 public Map<Id, List<opportunity>>  GetInprogressUpSellOpportunities(List<Asset> assets)
  {
    List<Id> accountIds = GetAccountIds(assets);



    List<opportunity> opportunities = [
                                                SELECT 
                                                  Id,name,RecordTypeId,CurrencyIsoCode,Multi_Year_Deal__c,Number_of_years__c,
                                                  account.name,account.CurrencyIsoCode,CloseDate,Owner.name,StageName,amount,
                                                  account.OwnerId,MinLicenceEndDate__c,OwnerId,Pricebook2.Id, AccountId
                                              FROM 
                                                  Opportunity 
                                              Where 
                                                  AccountId IN :accountIds
                                                  AND (Type = 'Up sell') 
                                                  AND StageName IN ('Interest','Demo', 'Trial','Quote', 'Negotioation','Verbal Agreement')
                                                  AND (recordTypeId = :standardOpportunityRecordTypeId )                                                      
                                                    
                                                ];


                                                 //Map<AccountId, List<Asset>>
        Map<Id, List<Opportunity>> inprogressOppportunitty  = new   Map<Id, List<Opportunity>>();

        for(Opportunity opportunity : opportunities)
        {            
            if(!inprogressOppportunitty.containsKey(opportunity.AccountId))
            {
                List<Opportunity> temp_ops= new List<Opportunity>();
                temp_ops.add(opportunity);
                inprogressOppportunitty.put(opportunity.AccountId, temp_ops);
            }
            else {
                
                inprogressOppportunitty.get(opportunity.AccountId).add(opportunity);
            }
            
        }

        system.debug('inprogressOppportunitty.Count:'+ inprogressOppportunitty.size());

        return inprogressOppportunitty;   


  }

	public Map<Id, List<opportunityLineItem>>  GetOpportunityLineItem(List<Asset> assets)
	{
		List<Id> opportunityIds = GetOpportunityIds(assets);

		List<OpportunityLineItem> opportunityLineItems = [
                                                    SELECT 
                                                        Id,Name,ServiceDate,PricebookEntryId,Description,ListPrice,OpportunityId,Product2Id,
                                                        ProductCode,Quantity,TotalPrice,License_Provisioned__c,Provision_Full_License__c,
                                                        Provision_Trial_License__c,Trial_Provisioned__c,Trial_Start_Date__c,
                                                        SubscriptionStartDate__c,SubscriptionEndDate__c ,Used_Monthly_Price__c, Family__c, Discount,DiscountReason__c
                                                    FROM 
                                                        OpportunityLineItem 
                                                    Where 
                                                        OpportunityId = :opportunityIds                                                      
                                                    
                                                ];


                                                 //Map<AccountId, List<Asset>>
        Map<Id, List<OpportunityLineItem>> opportunityLineItemList  = new   Map<Id, List<OpportunityLineItem>>();

        for(OpportunityLineItem opportunityLineItem : opportunityLineItems)
        {            
            if(!opportunityLineItemList.containsKey(opportunityLineItem.opportunityId))
            {
                List<OpportunityLineItem> temp_ops= new List<OpportunityLineItem>();
                temp_ops.add(opportunityLineItem);
                opportunityLineItemList.put(opportunityLineItem.opportunityId, temp_ops);
            }
            else {
                
                opportunityLineItemList.get(opportunityLineItem.opportunityId).add(opportunityLineItem);
            }
            
        }

        system.debug('opportunityLineItemList.Count:'+ opportunityLineItemList.size());

        return opportunityLineItemList;		


	}

	public OpportunityLineItem FilterOpportunityLineItem(List<OpportunityLineItem>    opportunityLineItems , String productFamily)
	{
		for(OpportunityLineItem opportunityLineItem : opportunityLineItems)
		{
			if(opportunityLineItem.Family__c.equals(productFamily) )
			 return opportunityLineItem;
		}
		throw new ValidationException('Cannot find the opportunity line item for oppotunityId :' + opportunityLineItem.OpportunityId + ', ProductFamily:' +productFamily);
	}

	public Decimal GetLicenceQuantity(Asset asset)
	{
	  Decimal quantity=0;

	  system.debug('GetLicenceQuantity.asset:'+asset);

	  if(asset.Registered_students_licence_cap__c > 0)
        {
            quantity = asset.Registered_students_licence_cap__c;
        }
        else
        {
            quantity = 10;
        }

          system.debug('GetLicenceQuantity.asset.quantity:'+quantity);
		return quantity;
	}

	public List<OpportunityAsset> CreateUpsellOpportunity(List<Asset> assets, Id oppotunityOwnerId, String territory, String schoolType)
	{

		List<OpportunityAsset> opportunityAssets=new List<OpportunityAsset>();
		map<Id, Opportunity> opportunitites = GetOpportunities(assets);

		map<Id, List<OpportunityLineItem>> mapOpportunityLineItems= GetOpportunityLineItem(assets);
		ProductSelector productSelector = new ProductSelector();

		Map<Id, Id> accountOwners = GetAccountOwners(assets);

  

    map<Id, List<Opportunity>> inProgressOpportunities= GetInprogressUpSellOpportunities(assets);

		String errorMessage;

    Id accountOwnerId;

    Id selectedPricebookId = PriceBookIdentifier.GetPricebookId(territory, schoolType, pricebookMappingList) ;
    if(selectedPricebookId == null)
    selectedPricebookId= standardPricebook.Id;
		
    for(Asset asset : assets)
    {               
                
              OpportunityAsset opportunityAsset =new 	OpportunityAsset();
              opportunityAsset.assetId = asset.Id;

            	if(oppotunityOwnerId == null)
               {
               	if(accountOwners.containsKey(asset.AccountId))
               		accountOwnerId = accountOwners.get(asset.AccountId);
               }
                         

                try {                    
               

               		Product2  product                       = products.get(asset.Product2Id); 
               		Product2 activeProduct = productSelector.GetActiveProduct( product, products);

                if(asset.Opportunity__R == null)
                {  

                 Opportunity   createdUpsellOpportunity  =  OpportunityFactory.Create('Up Sell', 'Standard Opportunity', selectedPricebookId, activeProduct.Family, asset.AccountId, asset.Account.CurrencyIsoCode) ; 

                 if(oppotunityOwnerId!= null)
                 {
                  createdUpsellOpportunity.OwnerId = oppotunityOwnerId;
                 }
                 else 
                 {
                  createdUpsellOpportunity.OwnerId = accountOwnerId;                                           
                 }                        


                 opportunityAsset.opportunity =createdUpsellOpportunity;

                 PricebookEntry	pricebookEntry;
                if(opportunityDuplicateChecker.Exist(createdUpsellOpportunity, activeProduct.Family, inProgressOpportunities))
	    					{
	    					 	continue;
	    					}
	    					
	    					pricebookEntry= UpsellOpportunitywithProducts.FilterPricebookEntry( pricebookEntries, activeProduct.Id, selectedPricebookId, asset.Account.CurrencyIsoCode);
                         
                Decimal New_Quantity = GetLicenceQuantity(asset);

			           
			            	//public static OpportunityLineItem Create(Id opportunityId, Decimal quantity, Boolean isFullLicence,
	 ///Date subscriptionStartDate, Date subscriptionEndDate, Decimal license_CAP , Id pricebookEntryId )

	              OpportunityLineItem opportunityLineItem             = OpportunityFactory.Create(New_Quantity, true, system.today(), asset.UsageEndDate,
                                                                    		asset.License_CAP__c, pricebookEntry.Id);
	              opportunityAsset.opportunityLineItem=opportunityLineItem;

	              opportunityAssets.add(opportunityAsset);
                         
                    }
                    else 
                    {
                    	 system.debug('asset.Opportunity__c:'+asset.Opportunity__c);
                    	 system.debug('asset.opportunitites:'+opportunitites);

                    	  Opportunity opportunity;
                    	 opportunity            							= opportunitites.get(asset.Opportunity__c);
                         List<OpportunityLineItem>    opportunityLineItems  = mapOpportunityLineItems.get(asset.Opportunity__c);
                         OpportunityLineItem opportunityLineItem =	FilterOpportunityLineItem(opportunityLineItems,activeProduct.Family );

                          Decimal New_Quantity = GetLicenceQuantity(asset);

                          system.debug('opportunity.Pricebook2:'+opportunity);
                          if(opportunity.Pricebook2Id == null)
                          {
								            system.debug('opportunity.Pricebook2.Id is null');
                          }

                          if(pricebooks == null)
                          {
								            system.debug('pricebooks is null');
                          }

                          Pricebook2 activePricebook = PriceBookIdentifier.FilterActivePricebook(opportunity.Pricebook2Id, pricebooks);

                          Opportunity  clonedOpportunity   = OpportunityFactory.CloneOpportunity(opportunity, activePricebook.Id, 
                          										 activeProduct.Family,standardOpportunityRecordTypeId);

                           if(oppotunityOwnerId!= null)
                           {
                            clonedOpportunity.OwnerId = oppotunityOwnerId;
                           }
                           else 
                           {
                            clonedOpportunity.OwnerId = accountOwnerId;                                           
                           } 
                          
                          opportunityAsset.opportunity = clonedOpportunity;

                          if(opportunityDuplicateChecker.Exist(clonedOpportunity, activeProduct.Family,inProgressOpportunities))
                  			 {
                  			 	continue;
                  			 }

            			 OpportunityLineItem clonedOpportunityLineItem;

            			   if(opportunity.Pricebook2.Id != activePricebook.Id)
            			   {
            			   		PricebookEntry  pricebookEntry= UpsellOpportunitywithProducts.FilterPricebookEntry( pricebookEntries, activeProduct.Id, activePricebook.Id, asset.Account.CurrencyIsoCode);                   

            			   		if(pricebookEntry == null) continue;

            			   		clonedOpportunityLineItem  = OpportunityFactory.CloneOpportunityLineItem(opportunityLineItem, asset.UsageEndDate, asset.License_Cap__c,  false, New_Quantity);                                    
                    		 	clonedOpportunityLineItem.PricebookEntryId = pricebookEntry.Id;

            			   }
            			   else 
            			   {
            			   		 clonedOpportunityLineItem   = OpportunityFactory.CloneOpportunityLineItem(opportunityLineItem, asset.UsageEndDate, asset.License_Cap__c,  true, New_Quantity);
            			   }

            			    opportunityAsset.opportunityLineItem = clonedOpportunityLineItem;

            			    opportunityAssets.add(opportunityAsset);  
                    }
                   
                }                 
                catch(Exception e)
                {
                    errorMessage = '<br> Opportunited creation failed for AccountId:{' +asset.AccountId +'}, AssetId:{' + asset.Id+'} </br>';
                    errorMessage = '<br>' + e.getMessage() +'</br>' ;
                    errorMessage = errorMessage + '<br>' + e.getStackTraceString() +'</br>' ;

                    continue;
                }
           
            }

		return opportunityAssets;
	}

	 

	public Map<Id, Id>  GetAccountOwners(List<Asset> assets)
	{
			
		List<Id> accountIds = GetAccountIds(assets);

		Map<Id, Id> accountOwnerIds = new Map<Id, Id>();

    //System.debug('accountIds : '+ accountIds);

		List<Account> accounts = [Select Id, OwnerId from Account where Id = :accountIds] ;
    
		for(Account account : accounts)
		{
      
      //System.debug('accountIds : '+ accountIds);

			if(!accountOwnerIds.containsKey(account.Id))
				accountOwnerIds.put(account.Id,account.OwnerId);
		}

    //System.debug('accountOwnerIds : '+ accountOwnerIds);
		return accountOwnerIds;
	}

}