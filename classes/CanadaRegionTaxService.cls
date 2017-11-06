/*
 * @author: Mahesh Gaikwad
 * @description: This class is responsible for calculating quote tax for opportunity owner belongs to 'Canada' region
 */
public with sharing class CanadaRegionTaxService {
	

	/*
     * Description : calculate tax rates for users in 'canada' region
     * @Param : 1. Quote object,for which we need to calulate tax
                2. Quote opportunity
                3. QuoteTaxRate object which hold tax related custom setting.
     * @Return : 
     */

	public void calculateCanadaRegionTax(Quote qt, Opportunity oppty, QuoteTaxRate quoteTax) {
        
        // early exit check
        if(qt == null || oppty == null || quoteTax == null)
        return;
        
        /*
         * rules specified in CanadaProvinceTaxSetting__c, RegionTaxSetting__c are applied in following logic for country canada and provinces.
         */
        if(oppty.Account.ShippingCountry.equalsIgnoreCase('canada') == false){

        	quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsRegionTax.get('canada'));
            
        }else if(oppty.Account.ShippingCountry.equalsIgnoreCase('canada') == true){
         
            if(oppty.Account.Tax_Exempt__c == true){

                quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsRegionTax.get('canada-canada'));

            }else if(oppty.Account.Tax_Exempt__c == false && String.isNotBlank(oppty.Account.ShippingState) == true){

                if(quoteTax.nameVsCanadaProvinceTax.containsKey(oppty.Account.ShippingState.toLowerCase().replace(' ','')) == false){
                    
                    quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsCanadaProvinceTax.get('other'));

                }else if(quoteTax.nameVsCanadaProvinceTax.containsKey(oppty.Account.ShippingState.toLowerCase().replace(' ','')) == true){

                    quoteTax.applyTaxRateForQuote(qt, quoteTax.nameVsCanadaProvinceTax.get(oppty.Account.ShippingState.toLowerCase().replace(' ','')));
                }
            }
        } 
	}
    
    
    /*
     * Description : calculate tax rates for users in 'canada' region
     * @Param : 1. Opportunity object,for which we need to calulate tax
                2. QuoteTaxRate object which hold tax related custom setting               
     * @Return : 
     */
    public void calculateCanadaRegionTaxOpty(Opportunity oppty, QuoteTaxRate quoteTax) {
        
        // early exit check
        if(oppty == null || quoteTax == null)
        return;
        
        /*
         * rules specified in CanadaProvinceTaxSetting__c, RegionTaxSetting__c are applied in following logic for country canada and provinces.
         */
        if(oppty.School_Site_Country__c.equalsIgnoreCase('canada') == false){

        	quoteTax.applyTaxRateForOpportunity(oppty, quoteTax.nameVsRegionTax.get('canada'));
            
        }else if(oppty.School_Site_Country__c.equalsIgnoreCase('canada') == true){
         
            if(oppty.School_Tax_Exempt__c == true){

                quoteTax.applyTaxRateForOpportunity(oppty, quoteTax.nameVsRegionTax.get('canada-canada'));

            }else if(oppty.School_Tax_Exempt__c == false && String.isNotBlank(oppty.School_Site_State__c) == true){
                                
                                System.debug('Opty Test' + oppty.School_Site_State__c);
                                System.debug('Opty Map' + quoteTax.nameVsCanadaProvinceTax.containsKey(oppty.School_Site_State__c.toLowerCase().replace(' ','')));
                                System.debug('Whole Map' + quoteTax.nameVsCanadaProvinceTax);
                                if(quoteTax.nameVsCanadaProvinceTax.containsKey(oppty.School_Site_State__c.toLowerCase().replace(' ','')) == false){
                                    
                                    quoteTax.applyTaxRateForOpportunity(oppty, quoteTax.nameVsCanadaProvinceTax.get('other'));

                                }else if(quoteTax.nameVsCanadaProvinceTax.containsKey(oppty.School_Site_State__c.toLowerCase().replace(' ','')) == true){

                                    quoteTax.applyTaxRateForOpportunity(oppty, quoteTax.nameVsCanadaProvinceTax.get(oppty.School_Site_State__c.toLowerCase().replace(' ','')));
                                }
            }
        } 
	}   
    
}