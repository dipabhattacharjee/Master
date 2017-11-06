public with sharing class PriceBookIdentifier {


     public static Map<String, Map<String, Id>> GePricebookMapping(){ 
        
        Map<String, Map<String, Id>> pricebookMapping = new  Map<String, Map<String, Id>>();

        List<Pricebook_Map__c> pricebookMappingList = [SELECT
                                    Id,Territory__C, School_Type__c, Price_Book__c
                                  FROM
                                    Pricebook_Map__c
                                  WHERE
                                    IsActive__C = true
                                  ORDER BY Territory__C];


        for(Pricebook_Map__c pricebook_Map:pricebookMappingList )
        {
            if(!pricebookMapping.containsKey(pricebook_Map.Territory__C))
            {
                Map<String, Id> school_type_temp = new Map<String, Id>();
                school_type_temp.put( pricebook_Map.School_Type__c, pricebook_Map.Price_Book__c);

                pricebookMapping.put(pricebook_Map.Territory__C,school_type_temp);
            }
            else {

               if(!pricebookMapping.get(pricebook_Map.Territory__C).containsKey(pricebook_Map.School_Type__c))
               {
                                    
                    pricebookMapping.get(pricebook_Map.Territory__C).put(pricebook_Map.School_Type__c, pricebook_Map.Price_Book__c );
               }
               else {
                    System.debug(Logginglevel.ERROR , 'Invalid data found in pricebook_mapping, Id:'+pricebook_Map.Id);
               }
            }
        }

     return pricebookMapping; 

    }

     public static Id GetPricebookId(String territory , String school_Type, Map<String, Map<String, Id>> pricebookMappingList){ 

      if(pricebookMappingList == null)
      return null;
      
      if(pricebookMappingList.containsKey(territory))
      {
        if(pricebookMappingList.get(territory).containsKey(school_Type))
        {
          Id pricebookId =  pricebookMappingList.get(territory).get(school_Type);

          return pricebookId;
        }
      }

      return null;

     }
    public static Pricebook2 GetStandardRegionalPricebook(){ 
    
        Pricebook2[] pricebooks = [SELECT Name FROM Pricebook2 WHERE IsActive = true ORDER BY Name ASC];
        //Id returningRecordId;        

        Set<Id> pricebookIds = (new Map<Id,SObject>(pricebooks)).keySet(); 

        List<UserRecordAccess> userAccessiblePricebooks = [SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess 
        FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId IN: pricebookIds];

        Set<Id> userAccessiblePricebookIds = (new Map<Id,SObject>(userAccessiblePricebooks)).keySet();

        Pricebook2 selectedPricebook = getPriceBook('*Standard%', userAccessiblePricebookIds);
      
        if(selectedPricebook != null){
            return selectedPricebook; 
        }

        selectedPricebook = getPriceBook('*International Standard%', userAccessiblePricebookIds);

        if(selectedPricebook != null){
            return selectedPricebook; 
        }        

        selectedPricebook = getPriceBook('%', userAccessiblePricebookIds);
        
        return selectedPricebook;
    }
      //if pricebook not available it returns null
    private Static Pricebook2 getPriceBook( String pricebookName, set<Id> pricebookIds)
    {
          Pricebook2 pricebook = [SELECT
                                             Id,Name 
                                         FROM
                                             Pricebook2
                                         WHERE
                                          IsActive = true and
                                          Name like : pricebookName and
                                          Id = : pricebookIds
                                          limit 1];

        return pricebook;
    }

     /*public static String GetActianCurrencyCode(String currencyCode)
    {

       ACTNSPC__Currency__c actianCurrency = [SELECT
                                             Id 
                                         FROM
                                             ACTNSPC__Currency__c
                                         WHERE
                                          ACTNSPC__Iso_Code__c= :currencyCode 
                                         limit 1];
        if(actianCurrency != null)
          return actianCurrency.Id;

          System.debug(Logginglevel.WARN, 'Cannot find ['+currencyCode+'] in ACTNSPC__Currency__c');

          return currencyCode;
    }*/

     public static Pricebook2 GetActivePricebook(Id pricebookId)
    { 

         Pricebook2 pricebook = [SELECT
                                             Id,Name, IsActive,Related_Price_Book__C,
                                             Related_Price_Book__R.Id
                                         FROM
                                             Pricebook2
                                         WHERE
                                          Pricebook2.Id = :pricebookId                                        
                                         limit 1];

      if(pricebook.Related_Price_Book__C == null && pricebook.IsActive == false)
      {
        throw new ValidationEXception('Pricebook ' + pricebook.Name +' associated with opportunity is inactive and does not have any related active pricebook set' );
      }

      if(pricebook.IsActive == false )
       {
             pricebook =              [SELECT
                                              Id, IsActive, Related_Price_Book__R.Id
                                         FROM
                                             Pricebook2
                                         WHERE
                                          Pricebook2.Id = : pricebook.Related_Price_Book__R.Id                                      
                                         limit 1];
       }

       return pricebook;
     }

       public static Pricebook2 FilterActivePricebook(Id pricebookId, Map<Id, Pricebook2> pricebooks)
    { 
      if(pricebooks == null)
        throw new ValidationEXception('pricebooks is null');
        
       Pricebook2 pricebook = pricebooks.get(pricebookId);

       if(pricebook.IsActive)
        return pricebook;

      if(pricebook.Related_Price_Book__C == null && pricebook.IsActive == false)
      {
        throw new ValidationEXception('Pricebook ' + pricebook.Name +' associated with opportunity is inactive and does not have any related active pricebook set' );
      }

      if(pricebook.IsActive == false )
       {
          pricebook =  pricebooks.get(pricebook.Related_Price_Book__R.Id );           
       }

       return pricebook;
     }

      public static Map<Id, Pricebook2> GetActivePricebooks()
    {  

         Map<Id, Pricebook2> pricebooks = new Map<Id, Pricebook2>([SELECT
                                             Id,Name, IsActive,Related_Price_Book__C,
                                             Related_Price_Book__R.Id
                                         FROM
                                             Pricebook2
                                         ]);

         return pricebooks;

      
     }

 /*public static Id GetPriceLevelId(Id pricebookId)
    { 

         ACTNSPC__Price_Book_Configuration__c actianPriceBookConfiguration = [SELECT
                                           ACTNSPC__Price_Level__c
                                       FROM
                                           ACTNSPC__Price_Book_Configuration__c
                                       WHERE
                                        ACTNSPC__Price_Book__c = :pricebookId  
                                       limit 1];

         if(actianPriceBookConfiguration == null)
          {        
               System.debug(Logginglevel.WARN, 'Cannot find pricebook['+pricebookId+'] in ACTNSPC__Price_Level__c');
               throw new ValidationEXception('Cannot find pricebookId:'+pricebookId);
          }

       
       return actianPriceBookConfiguration.ACTNSPC__Price_Level__c;


    }

    public static Id GetPriceLevelEntryId(Id priceLevelId, Id productId, String currencyCode)
    {

           ACTNSPC__Price_Level_Entry__c priceLevelEntry = [SELECT
                                             Id
                                         FROM
                                             ACTNSPC__Price_Level_Entry__c
                                         WHERE
                                          ACTNSPC__Currency__c    = :currencyCode and                                        
                                          ACTNSPC__Price_Level__c = :priceLevelId and
                                          ACTNSPC__Product__c     = :productId 
                                         limit 1];

          if(priceLevelEntry == null)
          {
             System.debug(Logginglevel.WARN, 'Cannot find Price_Level_Entry__c using ACTNSPC__Price_Level__c:'+priceLevelId 
              +', ACTNSPC__Product__c:'+ productId +',ACTNSPC__Currency__c: '+currencyCode);
          }

          return priceLevelEntry.Id;


    }*/

}