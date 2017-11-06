public class NewContactRolePlus3rdParty {

    public Contact cont{get;set;}
    public Account acc{get;set;}
    public Contact_Roles__c acc3rdparty {get;set;}
    public Contact_Roles__c ConRol{get;set;}
    public Id CurrConId{get; set;}
    public PageReference page{get; set;}
    ApexPages.StandardController v_cr = null;
    
    Public NewContactRolePlus3rdParty(ApexPages.StandardController sc)
    {
        
        v_cr = sc;
        CurrConId = v_cr.getId();
        cont = queryContact(CurrConId);        
        ConRol = queryContactRoles(CurrConId);
        acc3rdparty = query3rdPartyAccount(CurrConId);
    }
    
    public Contact queryContact(Id conqueryid)
    {
        Contact NewCon = new Contact();
        
        String userName = UserInfo.getUserName();
            User activeUser = [Select id,Region_Text__c From User where Username = : userName limit 1];
        String userRegion = activeUser.Region_Text__c;
        String ownerid = activeUser.id;
        
        if(conqueryid != null){
            String queryStr = 'Select ' + sObjectGetAllFields(NewCon).trim() + ' From Contact Where Id= : conqueryid';          
            try{
                NewCon = Database.query(queryStr); 
            }
            catch(Exception e){
                system.debug('****** Quering Contact Exception: ' + e.getMessage());    
            }                                      
        }        
        else{                        
            NewCon.OwnerId = ownerid;            
            NewCon.AccountId = ApexPages.currentPage().getParameters().get('con4_lkid');                     
            NewCon.School_Territory__c = userRegion;
            NewCon.Status__c = 'Current';
            // add New fields from Contacts
            // Associating Account's Billing Address with 
             
            acc = [select Id,BillingAddress,BillingCity,BillingCountry,BillingState,BillingPostalCode,BillingStreet, Phone, Fax from Account where Id = : NewCon.AccountId limit 1];
            
            NewCon.MailingCity = acc.BillingCity;
            NewCon.MailingCountry =acc.BillingCountry;
            NewCon.MailingState =acc.BillingState;
            NewCon.MailingPostalCode = acc.BillingPostalCode;
            NewCon.MailingStreet = acc.BillingStreet;
            NewCon.Phone = acc.Phone;
            NewCon.Fax=acc.Fax;
        }
        
        
        return NewCon;
    }
    
    public Contact_Roles__c queryContactRoles(Id conrolqueryid)
    {
        Contact_Roles__c NewConRole = new Contact_Roles__c();
        
        if(conrolqueryid != null){
            String queryStr = 'Select ' + sObjectGetAllFields(NewConRole).trim() + ' From Contact_Roles__c Where Contact__c= : conrolqueryid';          
            try{
                NewConRole = Database.query(queryStr); 
            }
            catch(Exception e){
                system.debug('****** Quering Contact Exception: ' + e.getMessage());    
            }                                      
        }        
        else{                      
            NewConRole.Account__c = ApexPages.currentPage().getParameters().get('con4_lkid');            
            // add New fields from Contact Roles before creation
            
        }
        
        
        return NewConRole;
        
    }
    
     public Contact_Roles__c query3rdPartyAccount(Id Acc3parqueryid)
    {
        Contact_Roles__c New3rdpartyAccount = new Contact_Roles__c();
        
        if(Acc3parqueryid!=null)
        {
            String queryStr = 'Select ' + sObjectGetAllFields(New3rdpartyAccount).trim() + ' From Contact_Roles__c Where Contact__c= : Acc3parqueryid';          
        }
        else{
            //New3rdpartyAccount.Account__c = 
            //NewConRole.Contact__c
        }
        return New3rdpartyAccount;
    }    
    /* Retrieve all fields from the specified object */
    public String sObjectGetAllFields(SObject obj){
        String str = '';                   
        Map<String, Schema.SObjectField> map_fields = obj.getSObjectType().getDescribe().fields.getMap();
        List<Schema.SObjectField> li_fields = map_fields.values();
        
        for(Schema.SObjectField field : li_fields){
            str+= field + ',';       
        }
        
        return str.substring(0,str.length()-1);
    }
    
    public PageReference saveContact() {
        Boolean result=False;
        Boolean NoRole=False;        
        String myString = ConRol.Role__c;
        
        System.Debug('myString -- Checking Null Role' + myString);
        try{
        if(ConRol.Role__c != null)
        {
           result=myString.contains('3rd Party');           
        } else
        
        if (ConRol.Role__c == '1 - None')
        {
            NoRole=myString.contains('1 - None');
        } else
        
        if (ConRol.Role__c == null)
        {
            NoRole=True;
        }
        
        if(!NoRole && ConRol.Role_Status__c == null)
        {
            Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.Error,'Please select the Role Status'));
            return null;
        }        
       
        if(!NoRole && !ConRol.MInfluencer__c && !ConRol.SInfluencer__c && !ConRol.RInfluencer__c && !ConRol.IInfluencer__c && !ConRol.MSInfluencer__c)
        {
            Apexpages.addMessage(new Apexpages.message(ApexPages.Severity.Error,'Select at least one product for the new Contact & Role'));
            return null;
        }
        
        if(cont.Id == null){             
            insert cont;           
        }
        else{
            update cont;
        }        
        
        if(result){
                
            if(ConRol.Id == null){
                ConRol.Contact__c = cont.Id;
                ConRol.Account__c = cont.AccountId ;
                insert ConRol;            
                }
                else{
                    update ConRol;
                }
                cont.AccountId = acc3rdparty.Account__c;
                update cont;       
        }
        else if(!NoRole)
        {
                if(ConRol.Id == null){
                    ConRol.Contact__c = cont.Id;
                    insert ConRol;            
                }
                else{
                    update ConRol;
                }
         }
        return new ApexPages.StandardController(cont).view();
     } 
     catch(DMLException e){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return null;
     }
        
    }        
}