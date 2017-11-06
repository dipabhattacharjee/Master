@isTest
private class AssetFactory_Test
{
    

    @isTest
    static void CreateFullAsset_LicenceDuration_And_Quantity_SetProperlyFromOpportunityLineItem()
    {
      
        Date startDate      =  Date.today();
        Date endDate        =  Date.today().addMonths(1);
        Decimal quantity    = 1;
        Decimal totalPrice  = 1;

        Product2 product = FakeObjectFactory.GetProduct('Mathletics');
        insert product;


         PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;


        Opportunity opportunity         = FakeObjectFactory.GetStandardOpportunity();
        //insert opportunity;

        OpportunityLineItem opportunityLine         = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, quantity , totalPrice);

        opportunityLine.SubscriptionStartDate__c    = startDate;
        opportunityLine.SubscriptionEndDate__c      = endDate;

        TestUtility.SetOpportunityLineItem_PriceBook(opportunityLine , pricebookEntry);

        //insert opportunityLine;
      

        Asset asset = AssetFactory.CreateFullAsset(opportunity, opportunityLine);
        
        system.assertEquals(startDate, asset.InstallDate );
        system.assertEquals(endDate, asset.UsageEndDate);
        system.assertEquals(quantity, asset.License_Cap__c );
        Id licenceRecordTypeId =Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Full Licence').getRecordTypeId();

        system.assertEquals(licenceRecordTypeId, asset.recordTypeId );

    }

    @isTest
    static void CreateFullAsset_SetOpportunitySubscriptionStartDateInPast_LicenceStartDateMustBeToday()
    {
      
        Date startDate      =  Date.today().addMonths(-1);
        Date endDate        =  startDate.addMonths(2);
        Decimal quantity    = 1;
        Decimal totalPrice  = 1;

        Product2 product = FakeObjectFactory.GetProduct('Mathletics');
        insert product;

        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;

        Opportunity opportunity         = FakeObjectFactory.GetStandardOpportunity();
        //insert opportunity;

        OpportunityLineItem opportunityLine         = FakeObjectFactory.GetFullOpportunityLineItem(opportunity, quantity , totalPrice);

        opportunityLine.SubscriptionStartDate__c    = startDate;
        opportunityLine.SubscriptionEndDate__c      = endDate;

        TestUtility.SetOpportunityLineItem_PriceBook(opportunityLine , pricebookEntry);

        //insert opportunityLine;
      

        Asset asset = AssetFactory.CreateFullAsset(opportunity, opportunityLine);
        
        system.assertEquals(Date.today(), asset.InstallDate );
        system.assertEquals(endDate, asset.UsageEndDate);
        system.assertEquals(quantity, asset.License_Cap__c );
        Id licenceRecordTypeId =Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Full Licence').getRecordTypeId();

        system.assertEquals(licenceRecordTypeId, asset.recordTypeId );

    }    

    @isTest
    static void CreateTrialAsset_LicenceDuration_And_Quantity_SetProperlyFromOpportunityLineItem()
    {
      
        Date startDate      =  Date.today();
        Date endDate        =  Date.today().addDays(AssetFactory.TrialLicenceDurationInDays);
        Decimal quantity    = 1;
        Decimal totalPrice  = 1;

        Product2 product = FakeObjectFactory.GetProduct('Mathletics');
        insert product;


        PricebookEntry pricebookEntry = FakeObjectFactory.GetPriceBook(product, 1);   
        insert pricebookEntry;


        Opportunity opportunity         = FakeObjectFactory.GetStandardOpportunity();
        //insert opportunity;

        OpportunityLineItem opportunityLine         = FakeObjectFactory.GetTrialOpportunityLineItem(opportunity, quantity , totalPrice);

        opportunityLine.Trial_Start_Date__c         = startDate;
       
        TestUtility.SetOpportunityLineItem_PriceBook(opportunityLine , pricebookEntry);
        
        Asset asset = AssetFactory.CreateTrialAsset(opportunity, opportunityLine);
        
        system.assertEquals(startDate, asset.InstallDate );
        system.assertEquals(endDate, asset.UsageEndDate);
        system.assertEquals(quantity, asset.License_Cap__c );
        Id licenceRecordTypeId =Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Trial Licence').getRecordTypeId();
    

        system.assertEquals(licenceRecordTypeId, asset.recordTypeId );


    }



}