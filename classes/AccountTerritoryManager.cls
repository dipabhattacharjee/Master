/*
 * @author- Vishnu Belkone
 * @Description:  This class is to get trritory from postCode Mapping depend on postcode.
 * @Test Class:    AccountTerritoryManager_Test
 * @History: 
    15/09/2015 created.
 */
public class AccountTerritoryManager {
    public void assignTerritory(List<Account>accountList){
        try{
            Map<String,Postcode_Mapping__c>postcodeMappingMap = getMapOfPostCodeMapping();
            for(Account singleAccount : accountList){
              // if(singleAccount.ShippingCountryCode != 'GB'){
                    if(postcodeMappingMap.containsKey(singleAccount.ShippingPostalCode)){                    
                        if(singleAccount.ShippingCountryCode == postcodeMappingMap.get(singleAccount.ShippingPostalCode).Country__c){
                            singleAccount.Post_Zip_Code_Territory__c = postcodeMappingMap.get(singleAccount.ShippingPostalCode).Territory__c;
                        }else
                            {
                            singleAccount.Post_Zip_Code_Territory__c = '';
                            }
                    }else
                        {
                        singleAccount.Post_Zip_Code_Territory__c = '';
                        }     
               /* }else if(postcodeMappingMap.containsKey(singleAccount.Post_Zip_Code_Prefix__c)){                 
                    if(singleAccount.ShippingCountryCode == postcodeMappingMap.get(singleAccount.Post_Zip_Code_Prefix__c).Country__c){
                        singleAccount.Post_Zip_Code_Territory__c = postcodeMappingMap.get(singleAccount.Post_Zip_Code_No_Spaces__c).Territory__c;
                    }
                }*/
                       
            }
        }catch(Exception ex){
          
        }
    }
    
     /*
     * @author: Vishnu Belkone
     * @Description: This mehod returns Map Post_Zip_Code__c Vs Postcode_Mapping__c.     
     * @History: 
        15/09/2015 created.
     */ 
    private Map<String,Postcode_Mapping__c> getMapOfPostCodeMapping(){
        List<Postcode_Mapping__c>postcodeMappingList = new  List<Postcode_Mapping__c>();
        if (postcodeMappingList != null && postcodeMappingList.Size() > 0)
        {
            system.debug('This is not null ' + postcodeMappingList);
        }else{
         system.debug('This is not null ' + postcodeMappingList);
            postcodeMappingList = [SELECT Id,name,Post_Zip_Code__c,Country__c,Territory__c FROM Postcode_Mapping__c];
        }       
        Map<String,Postcode_Mapping__c> postcodeMappingMap = new  Map<String,Postcode_Mapping__c>();
        if(postcodeMappingList.size() > 0 && postcodeMappingList != null){
            for(Postcode_Mapping__c postcodeMap : postcodeMappingList ){
                postcodeMappingMap.put(postcodeMap.Post_Zip_Code__c, postcodeMap);
            }
        } 
        return postcodeMappingMap;
    }
    
}