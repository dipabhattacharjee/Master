/*
 * @author: Mahesh Gaikwad
 * @description: This class is responsible for calculating quote tax for opportunity owner belongs to 'EME' region
 */

public with sharing class EMERegionTaxService {
	
    /*
     * Description : calculate tax rates for users in 'EME' region
     * @Param : 1. Quote object,for which we need to calulate tax
                2. Quote opportunity
                3. QuoteTaxRate object which hold tax related custom setting.
     * @Return : 
     */
	public void calculateEMERegionTax(Quote qt, Opportunity oppty, QuoteTaxRate quoteTax) {
        
        // early exit check, which will help us to avoid null pointer exception
        if(qt == null || oppty == null || quoteTax == null)
        return;
        
        /*
         * rules specified in "EMETaxSetting__c" are applied in following logic.
         */
        if(oppty.Account.ShippingCountry.equalsIgnoreCase('united kingdom')){

            quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsEMETax.get('eme-unitedkingdom')); //EME-United Kingdom

        }else if(quoteTax.EUCountries.contains(oppty.Account.ShippingCountry.toLowerCase())){
              
            if(String.isBlank(oppty.Account.VAT_Number__c) && quoteTax.nameVsEMETax.containsKey('euwithoutvat') == true){ //EU without VAT

                quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsEMETax.get('euwithoutvat'));

            }else if(quoteTax.nameVsEMETax.containsKey('euwithvat') == true){ //EU with VAT
               
                quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsEMETax.get('euwithvat'));
            }
        }else if(quoteTax.nameVsEMETax.containsKey('notukoreu') == true){  //Not UK or EU

        	quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsEMETax.get('notukoreu'));
        }
	}
    
    /*
     * Description : calculate tax rates for users in 'EME' region
     * @Param : 1. Opportunity object,for which we need to calulate tax
                2. QuoteTaxRate object which hold tax related custom setting
     * @Return : 
     */
	public void calculateEMERegionTaxOpportunity(Opportunity oppty, QuoteTaxRate opportunityTax) {
        
        // early exit check, which will help us to avoid null pointer exception
        if(oppty == null || opportunityTax == null)
        return;
        
        /*
         * rules specified in "EMETaxSetting__c" are applied in following logic.
         */
       if(oppty.School_Site_Country__c.equalsIgnoreCase('united kingdom')){
        //if(oppty.Account.ShippingCountry.equalsIgnoreCase('united kingdom')){

            opportunityTax.applyTaxRateForOpportunity(oppty, opportunityTax.nameVsEMETax.get('eme-unitedkingdom')); //EME-United Kingdom

        //}else if(opportunityTax.EUCountries.contains(oppty.Account.ShippingCountry.toLowerCase())){
            }else if(opportunityTax.EUCountries.contains(oppty.School_Site_Country__c.toLowerCase())){
              
            if(String.isBlank(oppty.Account_VAT__c) && opportunityTax.nameVsEMETax.containsKey('euwithoutvat') == true){ //EU without VAT

                opportunityTax.applyTaxRateForOpportunity(oppty, opportunityTax.nameVsEMETax.get('euwithoutvat'));

            }else if(opportunityTax.nameVsEMETax.containsKey('euwithvat') == true){ //EU with VAT
               
                opportunityTax.applyTaxRateForOpportunity(oppty, opportunityTax.nameVsEMETax.get('euwithvat'));
            }
        }else if(opportunityTax.nameVsEMETax.containsKey('notukoreu') == true){  //Not UK or EU

        	opportunityTax.applyTaxRateForOpportunity(oppty, opportunityTax.nameVsEMETax.get('notukoreu'));
        }
	}
}