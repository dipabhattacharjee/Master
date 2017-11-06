/*
* @author: Amit Shirude
* @description: This class is to fetch contacts which have reference.
* @TestClass: ContactsWithReferenceControllerOpty_Test
* @History:
* 18/10/2015 Created
*/
public class ContactsWithReferenceControllerOpty {
     //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // the actual opty
    private Opportunity opty;
    public List<Contact> contactsWithRefrence{get;set;}
    private List<Opportunity> currentOpty {get;set;}
    public ContactsWithReferenceControllerOpty(ApexPages.StandardController stdController){        
        this.controller = stdController;         
        this.opty = (Opportunity)controller.getRecord();        
        currentOpty = [SELECT School_Site_City__c,School_Site_State__c,School_Site_Country__c,Interest_IntoScience__c,Interest_Mathletics__c,Interest_Spellodrome__c,
                       Interest_ReadingEggs__c FROM Opportunity where ID = :this.opty.ID];
        contactsWithRefrence = new List<Contact>();
    }
    public PageReference contactsWithReferences() {
        if (contactsWithRefrence == null) {
            contactsWithRefrence = new List<Contact>(); // init the list if it is null
        } else {
            contactsWithRefrence.clear(); // clear out the current results if they exist
        }
        Id contactRecordtypeId = fetchBankRecordTypeId();
        date todayDate = System.today();
         system.debug('@This is to test' +currentOpty);
        List<Contact>contactsWithRefrenceToIterate = [SELECT id,name,account.name,Reference_Contact__c,account.ShippingCity,Reference_Products__c,Reference_End_Date__c,Reference_Start_Date__c,
                                Reference_IntoScience__c,Reference_Mathletics__c,Reference_ReadingEggs__c,Reference_Spellodrome__c
                                FROM contact 
								WHERE Reference_Contact__c = true AND RecordTypeId = :contactRecordtypeId
                                AND (
										(account.ShippingCity = :currentOpty[0].School_Site_City__c AND account.ShippingCountry = :currentOpty[0].School_Site_Country__c AND account.ShippingCountry = 'United Kingdom') OR 
										(account.ShippingCountry = :currentOpty[0].School_Site_Country__c AND account.ShippingCountry <> 'United Kingdom' AND account.ShippingState = :currentOpty[0].School_Site_State__c)
									)  
								AND
                               Reference_End_Date__c >= :todayDate AND Reference_Start_Date__c <= :todayDate];
        
		for(Contact singleContact : contactsWithRefrenceToIterate){
            if((singleContact.Reference_IntoScience__c == true && currentOpty[0].Interest_IntoScience__c == true) ||
              (singleContact.Reference_Mathletics__c == true && currentOpty[0].Interest_Mathletics__c == true)||
              (singleContact.Reference_ReadingEggs__c == true && currentOpty[0].Interest_ReadingEggs__c == true) ||
              (singleContact.Reference_Spellodrome__c == true && currentOpty[0].Interest_Spellodrome__c == true )){
                   contactsWithRefrence.add(singleContact);
               }
        }
        system.debug('@This is to test' +contactsWithRefrence);
        return null;
    }
    
    @TestVisible
    private Id fetchBankRecordTypeId(){
        List<RecordType> recTypeList = [Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'School_Personnel'  And sObjectType = 'Contact'];
        if(recTypeList != null && recTypeList.size() > 0) {
            return recTypeList[0].Id;
        }
        return null;
    }
}