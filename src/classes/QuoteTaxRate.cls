/*
 * @author: Mahesh Gaikwad
 * @description: This class is responsible for holding Tax Rate custom settings to be applied for quote.
                All custom setting, custom label values are converted to lower case charactor to avoid case
                sensitivity issue.
 */

public with sharing class QuoteTaxRate{

    public Map<String, RegionTaxSetting__c> nameVsRegionTax;
    public Map<String, CanadaProvinceTaxSetting__c> nameVsCanadaProvinceTax;
    public Map<String, EMETaxSetting__c> nameVsEMETax;
    public Set<String> EUCountries;
    
    public QuoteTaxRate(){
         // fetch region custom setting data
        nameVsRegionTax = new Map<String, RegionTaxSetting__c>();
        for(RegionTaxSetting__c regionTax : RegionTaxSetting__c.getAll().values()){
            nameVsRegionTax.put(regionTax.name.toLowerCase().replace(' ',''), regionTax);
        }

        nameVsCanadaProvinceTax = new Map<String, CanadaProvinceTaxSetting__c>();

        for(CanadaProvinceTaxSetting__c canadaTax : CanadaProvinceTaxSetting__c.getAll().values()){
            nameVsCanadaProvinceTax.put(canadaTax.name.toLowerCase().replace(' ',''), canadaTax);
        }

        nameVsEMETax = new Map<String, EMETaxSetting__c>();

        for(EMETaxSetting__c emeTax : EMETaxSetting__c.getAll().values()){
            nameVsEMETax.put(emeTax.name.toLowerCase().replace(' ',''), emeTax);
        }

        EUCountries = new Set<String>();

        for(String str : Label.EUCountries.split(',')){
            EUCountries.add(str.toLowerCase().replace(' ',''));
        }
    }
    
    /*
     * Applies tax for quote with the passed custom setting(sobject)
     */    
    public void applyTaxRateForQuote(Quote qt, sobject obj){
        qt.TaxCode__c = (String)obj.get('TaxCode__c');
        qt.TaxCodeInternalID__c = (String)obj.get('TaxCodeInternalID__c');
        qt.TaxRate__c = (Decimal)obj.get('TaxRate__c');
    }
    
    /*
     * Applies tax for quote with the passed custom setting(sobject)
     */    
    public void applyTaxRateForOpportunity(Opportunity Opty, sobject obj){
        System.debug('Checking Opportunity ' + Opty);
        Opty.TaxCode__c = (String)obj.get('TaxCode__c');
        Opty.TaxCodeInternalID__c = (String)obj.get('TaxCodeInternalID__c');
        Opty.TaxRate__c = (Decimal)obj.get('TaxRate__c');
        System.debug('Checking Opportunity ' + Opty);
    }
    
}