/*
 * *@author- Vishnu Belkone
 * *@Description - This class return ContactServiceBodyWrapper with values for contact post/put service.
*/
public class ContactPostPutServiceJsonBuilder {     
    public ContactServiceBodywrapper populateFieldsForContactService(Contact singleContact){
        ContactServiceBodywrapper contactWrapper = new ContactServiceBodywrapper();
        
        Boolean SalesContact = False;
        
        
        /*If (singleContact.Product_IntoScience_Count__c > 0 || singleContact.Product_Mathletics_count__c > 0 || singleContact.Product_ReadingEggs_count__c > 0 || singleContact.Product_Spellodrome_Count__c > 0)
        {
            SalesContact = True;
        }*/
        
        If (singleContact.CountContactRolesIntoScience__c > 0 || singleContact.CountContactRolesMathletics__c > 0 || singleContact.CountContactRolesReadEggs__c > 0 || singleContact.CountContactRolesSpellodrome__c > 0)
        {
            SalesContact = True;
        }
        
        
        contactWrapper.Id = singleContact.C3_Id__c != null ? Integer.valueOf(singleContact.C3_Id__c) : null;
        contactWrapper.CustomerId = singleContact.account.C3_Id__c != null ? Integer.valueOf(singleContact.account.C3_Id__c) : null;
        contactWrapper.Title = null;
        contactWrapper.FirstName =  singleContact.FirstName;
        contactWrapper.LastName =   singleContact.LastName;
        contactWrapper.Name =   singleContact.Name;
        contactWrapper.Phone =  singleContact.Phone;
        contactWrapper.Fax =    singleContact.Fax;
        contactWrapper.Email =  singleContact.Email;
        contactWrapper.Mobile = singleContact.MobilePhone;
        contactWrapper.IsMainSalesContact = SalesContact;
        contactWrapper.IsMainAccountContact = null; 
        contactWrapper.IsActive = singleContact.Is_Active__c;
        contactWrapper.Description = singleContact.Description; 
        //contactWrapper.MainContactFor = null;
        contactWrapper.JobTitle =   singleContact.Job_Function__c;
        contactWrapper.ExternalId = singleContact.Id;
        contactWrapper.IsIntoScienceContact = singleContact.CountContactRolesIntoScience__c > 0 ? True : False;
        contactWrapper.IsMathleticsContact = singleContact.CountContactRolesMathletics__c > 0 ? True : False;
        contactWrapper.IsReadingEggsContact = singleContact.CountContactRolesReadEggs__c > 0 ? True : False;
        contactWrapper.IsSpellodromeContact = singleContact.CountContactRolesSpellodrome__c > 0 ? True : False;
        //contactWrapper.IsIntoScienceContact = singleContact.Product_IntoScience_Count__c > 0 ? True : False;
        //contactWrapper.IsMathleticsContact = singleContact.Product_Mathletics_count__c > 0 ? True : False;
        //contactWrapper.IsReadingEggsContact = singleContact.Product_ReadingEggs_count__c > 0 ? True : False;
        //contactWrapper.IsSpellodromeContact = singleContact.Product_Spellodrome_Count__c > 0 ? True : False;
        return contactWrapper;
    }
}