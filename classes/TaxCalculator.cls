public with sharing class TaxCalculator {
    
    decimal taxRate{get; set;}

    public TaxCalculator(String territory, String countryCode) {
    
    if(territory== null && countryCode==null)
    {
        taxRate=0;
        return;        
    }     

    List<Country__mdt> countryList = [Select Code__c, Name__c from Country__mdt WHERE Code__c = :countryCode  ];

    if(countryList == null || countryList.Size() == 0)
    {
        taxRate=0;
        return;      
    }

    String country = countryList[0].Name__c;
     
    Map<String,RegionTaxSetting__c> RegionTaxSettingMap = RegionTaxSetting__c.getAll();

    if(RegionTaxSettingMap!= null && RegionTaxSettingMap.size() > 0)
    {   
        if( RegionTaxSettingMap.ContainsKey(territory +'-'+country))   
        {
            taxRate =  RegionTaxSettingMap.get(territory +'-'+country).TaxRate__c;
            return;
        }      
    }

    System.debug(loggingLevel.Error, 'Cannot find any tax rule for Territory: '+ territory + ', CountryCode:'+countryCode);
    }

    public TaxModel GetTax(Decimal amount)
    {
        TaxModel tax = new TaxModel();

        if(taxRate> 0)
        {
            tax.amount = amount * taxRate/100;
            tax.TaxRate = taxRate;
                return tax;
        }

        tax.amount = 0;
        tax.TaxRate = 0;
        return tax;
        
       
    }
}