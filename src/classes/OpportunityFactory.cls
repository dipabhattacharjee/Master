public without sharing class OpportunityFactory {
	
	public static Opportunity Create(String optyType, String recordType, Id pricebookId, String productFamily, Id accountId, String currencyIsoCode)
	{
 		Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
     	
     	if(opportunityRecordTypeId == null)
     	{
     		throw new ValidationException('cannot create opportunity with recordType:' + recordType);
     	}

     	if(optyType == null)
     	{
     		throw new ValidationException('cannot create opportunity without a type, like Upsell, New Business');
     	}

     	Opportunity opportunity     = new Opportunity();
        opportunity.AccountId       = accountId;
        opportunity.Type            = optyType;
        opportunity.recordTypeId    = opportunityRecordTypeId;
        opportunity.StageName       = 'Interest';
        opportunity.CloseDate       = date.today().addmonths(1);        
        opportunity.Name            = productFamily + ' - ' + optyType;     
        opportunity.CurrencyIsoCode = currencyIsoCode;
        opportunity.Pricebook2Id    = pricebookId;
          

        return opportunity;
	}
/*
	public static OpportunityLineItem Create(Id opportunityId, Decimal quantity, Boolean isFullLicence,
	 Date subscriptionStartDate, Date subscriptionEndDate, Decimal license_CAP , Id pricebookEntryId )
	{
		if(quantity == 0)
     	{
     		throw new ValidationException('cannot create opportunity without specifying a quantity!');
     	}

     	if(pricebookEntryId == null)
     	{
     		throw new ValidationException('cannot create opportunity without specifying a pricebookEntryId!');
     	}

		OpportunityLineItem  opportunityLineItem            = new OpportunityLineItem ();
        opportunityLineItem.Quantity                        = quantity;
        opportunityLineItem.Provision_Full_License__c       = isFullLicence;
        opportunityLineItem.SubscriptionStartDate__c        = subscriptionStartDate;
        opportunityLineItem.SubscriptionEndDate__c          = subscriptionEndDate;
        opportunityLineItem.OpportunityId                   = opportunityId;
        opportunityLineItem.Price_Locked__c                 = false;
        opportunityLineItem.License_CAP__c                  = license_CAP;
        opportunityLineItem.PricebookEntryId                = pricebookEntryId;

        //Since price get reset by setting Price_Locked__c to false then we can pass any value initialy
        opportunityLineItem.UnitPrice                       =1;

          system.debug('OpportunityFactory.Create OpportunityLineItem:'+opportunityLineItem);

        return opportunityLineItem;
	}
*/
    public static OpportunityLineItem Create( Decimal quantity, Boolean isFullLicence,
     Date subscriptionStartDate, Date subscriptionEndDate, Decimal license_CAP , Id pricebookEntryId )
    {
        if(quantity == 0)
        {
            throw new ValidationException('cannot create opportunity without specifying a quantity!');
        }

        if(pricebookEntryId == null)
        {
            throw new ValidationException('cannot create opportunity without specifying a pricebookEntryId!');
        }

        OpportunityLineItem  opportunityLineItem            = new OpportunityLineItem ();
        opportunityLineItem.Quantity                        = quantity;
        opportunityLineItem.Provision_Full_License__c       = isFullLicence;
        opportunityLineItem.SubscriptionStartDate__c        = subscriptionStartDate;
        opportunityLineItem.SubscriptionEndDate__c          = subscriptionEndDate;
        //opportunityLineItem.OpportunityId                   = opportunityId;
        opportunityLineItem.Price_Locked__c                 = false;
        opportunityLineItem.License_CAP__c                  = license_CAP;
        opportunityLineItem.PricebookEntryId                = pricebookEntryId;

        //Since price get reset by setting Price_Locked__c to false then we can pass any value initialy
        opportunityLineItem.UnitPrice                       =1;

          system.debug('OpportunityFactory.Create OpportunityLineItem:'+opportunityLineItem);

        return opportunityLineItem;
    }

     public static Opportunity CloneOpportunity(Opportunity opportunityrecordToClone,  Id pricebookId, String productFamily, Id standardOpportunityRecordTypeId)
    {
        Opportunity clonedUpsellOpportunity    = new Opportunity();
        
        clonedUpSellOpportunity                = opportunityrecordToClone.Clone(false,true,false,true);

        if(opportunityrecordToClone.Name.length() > 110)
        {
            clonedUpsellOpportunity.Name       = opportunityrecordToClone.name.Substring(0,110);
        } 
        else
        {
            clonedUpsellOpportunity.Name       = opportunityrecordToClone.Name.removeEnd(' - Upsell');
        }
        clonedUpsellOpportunity.Name                   = productFamily +' - ' + 'Upsell';                    
        clonedUpsellOpportunity.StageName              = 'Interest';
        clonedUpsellOpportunity.CloseDate              = date.today().addmonths(1);
        clonedUpsellOpportunity.Multi_Year_Deal__c     = false;
        clonedUpsellOpportunity.Payment_Timing__c      = null;                                                          
        clonedUpsellOpportunity.CurrencyIsoCode        = opportunityrecordToClone.CurrencyIsoCode;
        clonedUpsellOpportunity.OwnerId                = UserInfo.getUserId();
        clonedUpsellOpportunity.Type                   = 'Up Sell';
        clonedUpsellOpportunity.recordTypeId           = standardOpportunityRecordTypeId;        
        clonedUpsellOpportunity.Pricebook2Id           = pricebookId;


        return clonedUpsellOpportunity;
    }

    public static OpportunityLineItem CloneOpportunityLineItem( OpportunityLineItem opportunityLineItem, Date subscriptionEndDate, Decimal license_CAP,  Boolean pricelocked, decimal quantity)
    {
        OpportunityLineItem clonedOpportunityLine       = new OpportunityLineItem();
        clonedOpportunityLine                           = opportunityLineItem.clone(false,true,false,true);
        
        clonedOpportunityLine.SubscriptionStartDate__c  = system.today();
        clonedOpportunityLine.SubscriptionEndDate__c    = subscriptionEndDate;
        clonedOpportunityLine.Provision_Full_License__c = true;
        clonedOpportunityLine.Quantity                  = quantity; // TODO make it configurable
        clonedOpportunityLine.License_CAP__c            = license_CAP;

       // clonedOpportunityLine.Product2Id                = product.Id;
        clonedOpportunityLine.Price_Locked__c          = pricelocked; 
        
        clonedOpportunityLine.Provision_Trial_License__c = false;
        clonedOpportunityLine.Trial_Start_Date__c = null;

        clonedOpportunityLine.Discount = opportunityLineItem.Discount;
        clonedOpportunityLine.DiscountReason__c = opportunityLineItem.DiscountReason__c;
        // As tiered price info might not be available for old opportunities
        // then we need to get the fresh copy of the tiered price from the pricebook
        if(opportunityLineItem.Used_Monthly_Price__c == null ||
           opportunityLineItem.Used_Monthly_Price__c == 0 )
        {
           clonedOpportunityLine.Price_Locked__c = false; 
        }

        system.debug('CloneOpportunityLineItem.clonedOpportunityLine:'+clonedOpportunityLine);

        return clonedOpportunityLine;                               
        
    }   

}