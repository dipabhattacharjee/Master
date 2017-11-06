/*
 * @author: Mahesh Gaikwad
 * @description: This class determines appropriate tax rule to be applied for quote.
 */

public with sharing class DetermineTaxRates {
   
    /*
     * Description : calculate tax rates for quote on insert
     * @Param : list of Quote
     * @Return : 
     */
    public void calculateTaxRatesOnQuoteInsert(List<Quote> quotes){
        calculateQuoteTaxRate(quotes);
    }
    
    

    /*
     * Description : Recalculate tax rates on quote if quote is synced with opportunity
                     1. calculate tax rates for quote
                     2. populate tax rates on opportuniy with synced quote tax rates.
     * @Param : list of Quote, Map of old quote id vs quote.
     * @Return : 
     */
    
    public void calculateTaxRatesOnQuoteUpdate(List<Quote> quotes, Map<Id, Quote> idVsQuoteOld){
        
        List<Opportunity> opptiesToUpdate = new List<Opportunity>();
        List<Quote> quotesToUpdate = new List<Quote>();

        for(Quote qt : quotes){
            
            // filter quote records which are actually synced and ignore other.
            if(qt.IsSyncing == true && qt.IsSyncing != idVsQuoteOld.get(qt.Id).IsSyncing){
                quotesToUpdate.add(qt);
            }
        }
        
        // early exit check
        if(quotesToUpdate.isEmpty())
        return;

        calculateQuoteTaxRate(quotesToUpdate);
        
        // polulate tax rated on opportunity // Commented by Amit on 8th Aug 2016 
        /*for(Quote qt : quotesToUpdate){

            Opportunity opp = new Opportunity();
            opp.Id = qt.opportunityId;
            opp.TaxCode__c = qt.TaxCode__c; 
            opp.TaxCodeInternalID__c = qt.TaxCodeInternalID__c;
            opp.TaxRate__c = qt.TaxRate__c;
            opptiesToUpdate.add(opp);
        }
        update opptiesToUpdate;*/
    }

    /*
     * Utility method which calulates tax for passed list of quote records.
     */
    private void calculateQuoteTaxRate(List<Quote> quotes){
        
        QuoteTaxRate quoteTax = new QuoteTaxRate();
        CanadaRegionTaxService canadaRegTax = new CanadaRegionTaxService();
        EMERegionTaxService emeRegTax = new EMERegionTaxService();

        Map<Id,Opportunity> oppIdVsOpptyRecord = getoppIdVsOpptyRecord(quotes);
        
        for(Quote qt : quotes){

             // fetch opportunity related to quote
            Opportunity opp = oppIdVsOpptyRecord.get(qt.opportunityId);
            
            // early check
            if(String.isBlank(opp.Owner.Region__c) || String.isBlank(opp.Account.ShippingCountry)){
                qt.addError('Please contact system admin for creating tax rate entry ');
                return;
            }
            
            
            // prepare key to fetch region custom setting
            String key =  (opp.Owner.Region__c+'-'+opp.Account.ShippingCountry).toLowerCase().replace(' ','');
            String region = opp.Owner.Region__c.toLowerCase().replace(' ','');

            // reset the values of tax fields
            qt.TaxCode__c = '';
            qt.TaxCodeInternalID__c = '';
            qt.TaxRate__c = null;
             
            /*
             * depending on the opportunity owner region invoke appropriate tax calulation service
             */
            if(opp.Owner.Region__c.equalsIgnoreCase('canada') == true){

                canadaRegTax.calculateCanadaRegionTax(qt, opp, quoteTax);

            }else if(opp.Owner.Region__c.equalsIgnoreCase('EME') == true){

                emeRegTax.calculateEMERegionTax(qt, opp, quoteTax);

            }else if(quoteTax.nameVsRegionTax.containsKey(key)){

                quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsRegionTax.get(key));

            }else if(quoteTax.nameVsRegionTax.containsKey(region)){

                quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsRegionTax.get(region));
            }
            
            // check if tax data is populated on quote object
            if(String.isBlank(qt.TaxCode__c) && String.isBlank(qt.TaxCodeInternalID__c) && qt.TaxRate__c == null){
                qt.addError('Please contact system admin for creating tax rate entry ');
            }
        } 
    } 
    
    /*
     * utility method which retrieve quote related opportunity along with required fields on oppty.
     */
    private Map<Id, Opportunity> getoppIdVsOpptyRecord(List<Quote> quotes){
        set<Id> opportunityIds = new set<Id>();
        
        for(Quote qt : quotes){
            if(String.isNotBlank(qt.OpportunityId)){
                opportunityIds.add(qt.OpportunityId);
            }            
        }
        
        return New Map<Id, Opportunity>([SELECT Id, ownerId, Owner.Region__c, Account.ShippingCountry, Account.ShippingState, Account.Tax_Exempt__c, Account.VAT_Number__c
                                        FROM Opportunity
                                        WHERE Id IN :  opportunityIds
                                       ]);
    }
}