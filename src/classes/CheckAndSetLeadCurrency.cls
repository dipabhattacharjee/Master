/**
* @author: Scott McCallum
* @description: This is to set the currency of the Lead based on Country it uses formula field to get the right currency code
* @Test Class:    CheckAndSetLeadCurrency_Test
* @History: 
10/02/2016 created.
*/
public class CheckAndSetLeadCurrency {
    
  /**
    * @author: Scott McCallum
    * @description: This function does the setting of currency.
    * @History: 
        10/02/2016 created.
    */
    public void setLeadCurrency(List<Lead>leadList){
    
    String rollUpUserAlias = getrollupUesrAlias();
    //
    
       if (leadList != null && leadList.size() > 0 && rollUpUserAlias == 'iuser' )
       {       
                 
            for (lead ld : leadList)
            {
                        
                        if (ld.CountryCode == 'NZ')
                        {
                        ld.CurrencyIsoCode = 'NZD';
                        }
                        else if (ld.CountryCode == 'AU')
                        {
                        ld.CurrencyIsoCode = 'AUD';
                        }
                        else if (ld.CountryCode == 'CA')
                        {
                        ld.CurrencyIsoCode = 'CAD';
                        }
                        else if (ld.CountryCode == 'DE')
                        {
                        ld.CurrencyIsoCode = 'EUR';
                        }
                        else if (ld.CountryCode == 'ES')
                        {
                        ld.CurrencyIsoCode = 'EUR';
                        }
                        else if (ld.CountryCode == 'FR')
                        {
                        ld.CurrencyIsoCode = 'EUR';
                        }
                        else if (ld.CountryCode == 'GB')
                        {
                        ld.CurrencyIsoCode = 'GBP';
                        }
                        else if (ld.CountryCode == 'IE')
                        {
                        ld.CurrencyIsoCode = 'EUR';
                        }
                        else if (ld.CountryCode == 'AE')
                        {
                        ld.CurrencyIsoCode = 'USD';
                        }
                        else if (ld.CountryCode == 'SG')
                        {
                        ld.CurrencyIsoCode = 'SGD';
                        }
                        else if (ld.CountryCode == 'ZA')
                        {
                        ld.CurrencyIsoCode = 'ZAR';
                        }
                         else if (ld.CountryCode == 'IN')
                        {
                        ld.CurrencyIsoCode = 'INR';
                        }
                        else
                        {
                        ld.CurrencyIsoCode = 'USD';
                        }
            }
       }
    }     
    
    public String getrollupUesrAlias(){
    List<User> rollUpUserList = [Select Id,name,Alias from User Where Id = :UserInfo.getUserId()];
    return rollUpUserList[0].Alias;
  }
}