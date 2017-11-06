/*
 * @author: Vishnu Belkone
 * @Description: This class update accounts on create or update Postcode Mapping depend on postcode.
 * @TestClass:  PostCodeMappingWithAccount_Test
*/
public class PostCodeMappingWithAccount {
    //This function will update trritory of accounts after update of postcode mapping but only if postcode changes
    public void updateAccountOnUpdatePostMapp(List<Postcode_Mapping__c>postCodeList,Map<Id,Postcode_Mapping__c>PostcodeMapOldMap){
        List<Account>accountToUpdate;
        System.debug('This is new List - '+postCodeList + 'PostCode Old Map -'+PostcodeMapOldMap );
        for(Postcode_Mapping__c postcodeMap : postCodeList){
            if(PostcodeMapOldMap.containsKey(postcodeMap.Id)){
                if(postcodeMap.Territory__c != PostcodeMapOldMap.get(postcodeMap.Id).Territory__c){
                    accountToUpdate = new List<Account>();
                    accountToUpdate = getAccountsToUpdate(postcodeMap);
                    update accountToUpdate;
                }
            }            
        }
    }
    //This function will update trritory of accounts after insert of postcode mapping.
    public void updateAccountOnInsertPostMapp(List<Postcode_Mapping__c>postCodeList){
        List<Account>accountToUpdate;
        for(Postcode_Mapping__c postcodeMap : postCodeList){
            accountToUpdate = new List<Account>();
            if(postCodeList != null && postCodeList.size() > 0){
                accountToUpdate = getAccountsToUpdate(postcodeMap); 
                update accountToUpdate;
            }             
        }
    }
    
    public List<Account> getAccountsToUpdate(Postcode_Mapping__c postcodeMap){
        List<Account>accountWithPostCodes = new List<Account>();        
        accountWithPostCodes = [select id,name,Post_Zip_Code_Territory__c,ShippingPostalCode,ShippingCountryCode from Account where 
                                    ShippingPostalCode = :postcodeMap.Post_Zip_Code__c and  ShippingCountryCode = :postcodeMap.Country__c];
     
        system.debug('This is Account' + accountWithPostCodes);
        if(accountWithPostCodes != null && accountWithPostCodes.size() > 0){
            for(Account singleAccount : accountWithPostCodes){
                singleAccount.Post_Zip_Code_Territory__c = postcodeMap.Territory__c; 
            }
        }
        
        return accountWithPostCodes;
    }   
}