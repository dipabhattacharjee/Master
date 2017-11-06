/**
* @author: vishnu belkone
* @description:
*/
public class accountTypeCategoryMapping {
    public void typeCategoryMapping(List<Account>accountList,Map<Id,Account>oldMap){
        List<Type_Category_Mapping__c> typecategoryList = new List<Type_Category_Mapping__c>();
        typecategoryList    = gettpeCategoryMap();
        for (Account acc : accountList)
        {
            if (oldMap != null && oldMap.containsKey(acc.Id))
            {
                if (acc.Territory__c != oldMap.get(acc.Id).Territory__c || acc.School_Type__c != oldMap.get(acc.Id).School_Type__c ||  acc.School_Category__c != oldMap.get(acc.Id).School_Category__c)
                {
                    setGlobalFields(acc,typecategoryList);
                }
            }
        }
    }
    
    public void typeCategoryMappingForInsert(List<Account>accountList){
        List<Type_Category_Mapping__c> typecategoryList = new List<Type_Category_Mapping__c>();
        typecategoryList    = gettpeCategoryMap();
        for (Account acc : accountList)
        {
            setGlobalFields(acc,typecategoryList);
        }
        
    }

    private void setGlobalFields(account acc, List<Type_Category_Mapping__c> typeCateList)
    {
        if (typeCateList != null && typeCateList.size() > 0)
        {
            for (Type_Category_Mapping__c typeCate : typeCateList)
            {
               if (acc.Territory__c == typeCate.Country__c && typeCate.Field__c == 'Type' && acc.School_Type__c == typeCate.Source_Value__c)
               {
                    acc.Global_School_Type__c = typeCate.Target_Value__c;
               }
               else if(acc.Territory__c == typeCate.Country__c && typeCate.Field__c == 'Category' && acc.School_Category__c == typeCate.Source_Value__c)
               {
                    acc.Global_School_Category__c = typeCate.Target_Value__c;
               }
             }
            }
        if (  acc.School_Type__c == null || acc.School_Type__c == '')
        {
          acc.Global_School_Type__c = null;
         }
         if (  acc.School_Category__c == null || acc.School_Category__c == '')
        {
          acc.Global_School_Category__c = null;
         }
           system.debug('this is to test category' + acc); 
     }
    
    
    private List<Type_Category_Mapping__c> gettpeCategoryMap(){
        List<Type_Category_Mapping__c> typeCatMapList = [Select Id,name,Country__c,Field__c,Source_Value__c,Target_Value__c From Type_Category_Mapping__c];
        Map<String,Type_Category_Mapping__c> typecategoryMap = new Map<string,Type_Category_Mapping__c>();
        for (Type_Category_Mapping__c typeCatMap : typeCatMapList)
        {
            typecategoryMap.put(typeCatMap.Country__c,typeCatMap);
        }
        return typeCatMapList;
    }
}