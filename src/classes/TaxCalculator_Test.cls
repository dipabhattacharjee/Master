@IsTest
public class TaxCalculator_Test {
   
   	@testSetup static void setup()
    {
    	  insert new RegionTaxSetting__c( Name                  = 'APAC-Australia',
                                        RegionName__c           = 'APAC',
                                        SiteCountry__c          = 'Australia',
                                        TaxCode__c              = 'TS-AU',
                                        TaxCodeInternalId__c    = '10',
                                        TaxRate__c              = 10); 
    }

@isTest
public static void TaxCalculator_test()
{
    TaxCalculator taxCal=new TaxCalculator('APAC', 'AU');

    TaxModel taxModel= taxCal.getTax(10);

    System.assertEquals(10, taxModel.TaxRate);
}

}