/**
* @author: vishnu.belkone
* @description: This is class to check if account shipping address is null and billing addrress is not null then set billingaddress as shippingaddress.
* @Test Class:    CheckAndSetShippingAddress_Test
* @History: 
15/09/2015 created.
*/
public class CheckAndSetShippingAddress {
	/**
	* @author: vishnu.belkone
	* @description: This functioncheck and set shipping address.
	* @History: 
		15/09/2015 created.
	*/
    public void setShippingAddress(List<Account>accountList){
    
        if (accountList != null && accountList.size() > 0)
        {       
            for (Account acc : accountList)
            {
                if ((acc.ShippingCountry == null && acc.ShippingPostalCode == null && acc.ShippingState == null && acc.ShippingStreet == null) &&
                    (acc.BillingCountry != null || acc.BillingPostalCode != null || acc.BillingState != null) )
                {     
                    
                    acc.ShippingPostalCode = acc.BillingPostalCode;
                    acc.ShippingState = acc.State__c;
                    acc.ShippingCity = acc.BillingCity;
                    acc.ShippingStreet = acc.BillingStreet; 
                    acc.ShippingCountryCode = acc.billingCountryCode;
                    acc.ShippingCountry = acc.Country__c;
                    acc.billingCountry = acc.Country__c;
                    acc.BillingState = acc.State__c;
                    
                                    
                }
          
            }
        }
    }    
    
}