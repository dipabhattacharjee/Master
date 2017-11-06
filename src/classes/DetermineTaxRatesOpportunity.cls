/*
 * @author: Amit
 * @description: This class determines appropriate tax rule to be applied for Opportunity.
*/
public class DetermineTaxRatesOpportunity {
    /*
     * Description : calculate tax rates for   on insert
     * @Param : list of Opportunity
     * @Return : 
     */
    public void calculateTaxRatesOnOpportunity(List<Opportunity> opportunity){
        calculateOpportunityTaxRate(opportunity);
    } 
    /*
     * Utility method which calulates tax for passed list of Opportunity records.
     */
    private void calculateOpportunityTaxRate(List<Opportunity> opportunities){
        
        QuoteTaxRate opptyTax = new QuoteTaxRate();
        CanadaRegionTaxService canadaRegTax = new CanadaRegionTaxService();
        EMERegionTaxService emeRegTax = new EMERegionTaxService();
        
        for(Opportunity opp : opportunities)
        {
            // early check
            if(String.isBlank(opp.AccountTerritory__c) || String.isBlank(opp.School_Site_Country__c)){    
                opp.addError('Please contact system admin for creating tax rate entry - Account Territory is Blank');
                return;        
            }
            
            // prepare key to fetch region custom setting
            String key =  (opp.AccountTerritory__c+'-'+opp.School_Site_Country__c).toLowerCase().replace(' ','');
            String region = opp.AccountTerritory__c.toLowerCase().replace(' ','');

            // reset the values of tax fields
            opp.TaxCode__c = '';
            opp.TaxCodeInternalID__c = '';
            opp.TaxRate__c = null;
             
            /*
             * depending on the opportunity owner region invoke appropriate tax calulation service
             */
            if(opp.AccountTerritory__c.equalsIgnoreCase('canada') == true){

                canadaRegTax.calculateCanadaRegionTaxOpty(opp, opptyTax);

            }else if(opp.AccountTerritory__c.equalsIgnoreCase('EME') == true){

                emeRegTax.calculateEMERegionTaxOpportunity(opp, opptyTax);

            }else if(opptyTax.nameVsRegionTax.containsKey(key)){
                
                opptyTax.applyTaxRateForOpportunity(opp, opptyTax.nameVsRegionTax.get(key));

            }else if(opptyTax.nameVsRegionTax.containsKey(region)){
                
                opptyTax.applyTaxRateForOpportunity(opp, opptyTax.nameVsRegionTax.get(region));
            }
            
            // check if tax data is populated on quote object
            if(String.isBlank(opp.TaxCode__c) && String.isBlank(opp.TaxCodeInternalID__c) && opp.TaxRate__c == null){
                opp.addError('Please contact system admin for creating tax rate entry ');
            }
        }
        //update OpportunityQuery ;
    } 
}