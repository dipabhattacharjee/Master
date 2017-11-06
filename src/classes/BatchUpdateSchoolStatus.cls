public class BatchUpdateSchoolStatus implements StatelessBatchExecutor.CustomBatchable{
    
    public void execute(List<Account> scope){        
        UpdateSchoolstoLapsed(scope);        
    }
    
    /**
     * @author: Amit Shirude
     * @Description: Method to Update Accounts based on Licence Status
     * @Param : Account List to update.  
     * @History: 
        21/04/2016 created.
     */    
    public Void UpdateSchoolstoLapsed(List<Account> AccList ){
       try{         
           //Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');           
           //myCS1.Block_Trigger_Execution__c = True;           
           //Update myCS1;
           
//=======================================================================================
           
           RecordType__c SchoolRecordType = RecordType__c.getValues('Account School');
           Id SchoolRecordTypeId = SchoolRecordType.RecordTypeId__c;
           
           RecordType__c LicenceRecordType = RecordType__c.getValues('Asset Full Licence');
           Id Full_licenceRecordTypeId = LicenceRecordType.RecordTypeId__c;           

//=======================================================================================
           
           Set<Id> set_Account_Id_NL = new Set<Id>();
           Set<Id> set_Account_Id_Lap = new Set<Id>();
           List<Account> AS_Account = new List<Account>();
           List<Account> AS_Account_Notlapsed = new List<Account>();
           Map<Id,Account> accountMap = new Map<Id,Account>([Select Id, Name,Status__c,C3NotSynched__c, 
                                                             (Select Id,Status,UsageEndDate  from Assets where RecordTypeId = : Full_licenceRecordTypeId) 
                                                             from Account Where Id in : AccList
                                                             and RecordTypeId = : SchoolRecordTypeId                                                             
                                                            ]);
           
           Map<Id, Account> NotLapsedAccount = new Map<Id, Account>();           
           Map<Id, Account> LapsedAccount = new Map<Id, Account>();
           
           System.Debug('accountMap 2'+ accountMap);
           
           for(Account Acnt : accountMap.values())
               {
                   if(accountMap.get(Acnt.Id).Assets.size() > 0)
                   {
                               for(Asset obj : accountMap.get(Acnt.Id).Assets){                           
                                            if(obj.Status == 'Provisioned'){
                                                NotLapsedAccount.put(Acnt.Id, Acnt);
                                                }
                                             else if(obj.Status == 'Expired' || obj.Status == 'Cancelled'){
                                                LapsedAccount.put(Acnt.Id, Acnt);
                                                }
                                 }                         
                    }                       
                 }
           set_Account_Id_NL = NotLapsedAccount.keySet();           
           set_Account_Id_Lap = LapsedAccount.keySet();    
           
            System.Debug('set_Account_Id_NL 2'+ set_Account_Id_NL);
            System.Debug('set_Account_Id_Lap 2'+ set_Account_Id_Lap);
           
           AS_Account_Notlapsed = [Select Id, Name, Status__c From Account Where (Id in : set_Account_Id_NL)];           
           for(Account SetAcc: AS_Account_Notlapsed)
            { set_Account_Id_Lap.remove(SetAcc.Id); }                      
           System.Debug('set_Account_Id_Lap 3'+ set_Account_Id_Lap);
           
           AS_Account = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_Account_Id_Lap)];
           
           for(Account SetAcc: AS_Account)
           {
               SetAcc.Status__c = 'Lapsed Customer';
               SetAcc.C3NotSynched__c = True;
           }
           Update AS_Account; 

//=======================================================================================

           Set<Id> set_Account_Id_NF = new Set<Id>();
           Set<Id> set_Account_Id_Former = new Set<Id>();
           List<Account> AS_Account2 = new List<Account>();
           List<Account> AS_Account_NotFormer = new List<Account>();
           
           Map<Id, Account> NotFormerAccount = new Map<Id, Account>();           
           Map<Id, Account> FormerAccount = new Map<Id, Account>();           
           System.Debug('accountMap 1'+ accountMap);
           for(Account Acnt : accountMap.values())
               {
                   if(accountMap.get(Acnt.Id).Assets.size() > 0)
                   {
                               for(Asset obj : accountMap.get(Acnt.Id).Assets){                           
                                            if(obj.Status == 'Expired' || obj.Status == 'Provisioned' ){
                                                NotFormerAccount.put(Acnt.Id, Acnt);
                                                }
                                             else if(obj.Status == 'Lost' || (obj.Status == 'Cancelled' && obj.UsageEndDate < System.Today()-90 )){
                                                FormerAccount.put(Acnt.Id, Acnt);
                                                }
                                 }                         
                    }                       
                 }           
           
           set_Account_Id_NF = NotFormerAccount.keySet();           
           set_Account_Id_Former = FormerAccount.keySet();
           
           System.Debug('set_Account_Id_NF 1'+ set_Account_Id_NF);
           System.Debug('set_Account_Id_Former 1'+ set_Account_Id_Former);
           
           AS_Account_NotFormer = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_Account_Id_NF)];           
           for(Account SetAcc: AS_Account_NotFormer)
           {
               set_Account_Id_Former.remove(SetAcc.Id);
           }           


           System.Debug('set_Account_Id_Former 2'+ set_Account_Id_Former);
           
           AS_Account2 = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_Account_Id_Former)];
           
           for(Account SetAcc: AS_Account2)
           {
               SetAcc.Status__c = 'Former Customer';
               SetAcc.C3NotSynched__c = True;
           }
           Update AS_Account2;
//=======================================================================================

           
//If Account Status = Former and will be active Today, update the School to Returned Customer
// Tested with Record - 001N000000bsdLG
Map<Id,Account> accountMap6 = new Map<Id,Account>([Select Id, Name,Status__c,C3NotSynched__c, 
                                                             (Select Id,Status,InstallDate from Assets where RecordTypeId = : Full_licenceRecordTypeId) 
                                                             from Account Where Id in : AccList
                                                             and RecordTypeId = : SchoolRecordTypeId                                                             
                                                             and Status__c in ('Former Customer')
                                                            ]);
Map<Id, Account> UpdateFormertoReturnedMap = new Map<Id, Account>();
Set<Id> set_FormertoReturned = new Set<Id>();           
List<Account> AS_List_set_FormertoReturned = new List<Account>();
           
for(Account Acnt : accountMap6.values())
               {
                   if(accountMap6.get(Acnt.Id).Assets.size() > 0)
                   {
                               for(Asset obj : accountMap6.get(Acnt.Id).Assets){                           
                                            if( obj.Status == 'Provisioned' && Obj.InstallDate <= System.today() )
                                            { UpdateFormertoReturnedMap.put(Acnt.Id, Acnt); }
                                             
                                 }                         
                    }                       
                 }           
           
set_FormertoReturned = UpdateFormertoReturnedMap.keySet();

AS_List_set_FormertoReturned = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_FormertoReturned)];

for(Account SetAcc: AS_List_set_FormertoReturned)
{
   SetAcc.Status__c = 'Returned Customer';
   SetAcc.C3NotSynched__c = True;
}
Update AS_List_set_FormertoReturned;          
System.debug('AS_List_set_FormertoReturned -- Updated' + AS_List_set_FormertoReturned);
//=======================================================================================           

//If Account Status = Potential  and has been active for 1 days update the School to New Customer
//Tested with Record - 001N000000bssCu           
Map<Id,Account> accountMap4 = new Map<Id,Account>([Select Id, Name,Status__c,C3NotSynched__c, 
                                                             (Select Id,Status,InstallDate from Assets where RecordTypeId = : Full_licenceRecordTypeId) 
                                                             from Account Where Id in : AccList
                                                             and RecordTypeId = : SchoolRecordTypeId                                                             
                                                             and Status__c in ('Potential Customer')
                                                            ]);
Map<Id, Account> UpdateAccountToNewMap = new Map<Id, Account>();
Set<Id> set_Account_to_New = new Set<Id>();           
List<Account> AS_set_Account_to_New = new List<Account>();
           
for(Account Acnt : accountMap4.values())
               {
                   if(accountMap4.get(Acnt.Id).Assets.size() > 0)
                   {
                               for(Asset obj : accountMap4.get(Acnt.Id).Assets){                           
                                            if( obj.Status == 'Provisioned' && Obj.InstallDate <= System.today() )
                                            { UpdateAccountToNewMap.put(Acnt.Id, Acnt); }
                                             
                                 }                         
                    }                       
                 }           
           
set_Account_to_New = UpdateAccountToNewMap.keySet();

AS_set_Account_to_New = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_Account_to_New)];

for(Account SetAcc: AS_set_Account_to_New)
{
   SetAcc.Status__c = 'New Customer';
   SetAcc.C3NotSynched__c = True;
}
Update AS_set_Account_to_New;
System.debug('AS_set_Account_to_New -- Updated' + AS_set_Account_to_New);              
//=======================================================================================

           
//If Account Status = New & Returned and Licence has been active for 365 days update the School to Existing Customer
// Tested for Record - 001N000000cqaLM
Map<Id,Account> accountMap3 = new Map<Id,Account>([Select Id, Name,Status__c,C3NotSynched__c, 
                                                             (Select Id,Status,InstallDate from Assets where RecordTypeId = : Full_licenceRecordTypeId) 
                                                             from Account Where Id in : AccList
                                                             and RecordTypeId = : SchoolRecordTypeId                                                             
                                                             and Status__c in ('New Customer','Returned Customer')
                                                            ]);
Map<Id, Account> UpdateAccountToExistingSet = new Map<Id, Account>();
Set<Id> set_Account_to_Existing = new Set<Id>();           
List<Account> AS_set_Account_to_Existing = new List<Account>();
           
for(Account Acnt : accountMap3.values())
               {
                   if(accountMap3.get(Acnt.Id).Assets.size() > 0)
                   {
                               for(Asset obj : accountMap3.get(Acnt.Id).Assets){                           
                                            if( obj.Status == 'Provisioned' && Obj.InstallDate.monthsBetween(System.today()) >= 6 /*Obj.InstallDate <= System.today()-365*/)
                                            { UpdateAccountToExistingSet.put(Acnt.Id, Acnt); }
                                             
                                 }                         
                    }                       
                 }           
           
set_Account_to_Existing = UpdateAccountToExistingSet.keySet();

AS_set_Account_to_Existing = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_Account_to_Existing)];

for(Account SetAcc: AS_set_Account_to_Existing)
{
   SetAcc.Status__c = 'Existing Customer';
   SetAcc.C3NotSynched__c = True;
}
Update AS_set_Account_to_Existing;
System.debug('AS_set_Account_to_Existing -- Updated' + AS_set_Account_to_Existing);           
           
//=======================================================================================           

//If Account Status = Lapsed and will be active Today, update the School to Existing Customer
// Tested - Account tested 001N000000cCADL

Map<Id,Account> accountMap5 = new Map<Id,Account>([Select Id, Name,Status__c,C3NotSynched__c, 
                                                             (Select Id,Status,InstallDate from Assets where RecordTypeId = : Full_licenceRecordTypeId) 
                                                             from Account Where Id in : AccList
                                                             and RecordTypeId = : SchoolRecordTypeId                                                             
                                                             and Status__c in ('Lapsed Customer')
                                                            ]);
Map<Id, Account> UpdateLapsedToExistingMap = new Map<Id, Account>();
Set<Id> set_LapsedToExisting = new Set<Id>();           
List<Account> AS_List_set_LapsedToExisting = new List<Account>();
           
for(Account Acnt : accountMap5.values())
               {
                   if(accountMap5.get(Acnt.Id).Assets.size() > 0)
                   {
                               for(Asset obj : accountMap5.get(Acnt.Id).Assets){                           
                                            if( obj.Status == 'Provisioned' && Obj.InstallDate <= System.today() )
                                            { UpdateLapsedToExistingMap.put(Acnt.Id, Acnt); }
                                             
                                 }                         
                    }                       
                 }           
           
set_LapsedToExisting = UpdateLapsedToExistingMap.keySet();

AS_List_set_LapsedToExisting = [Select Id, Name, Status__c,C3NotSynched__c From Account Where (Id in : set_LapsedToExisting)];

for(Account SetAcc: AS_List_set_LapsedToExisting)
{
   SetAcc.Status__c = 'Existing Customer';
   SetAcc.C3NotSynched__c = True;
}
Update AS_List_set_LapsedToExisting;           
System.debug('AS_List_set_LapsedToExisting -- Updated' + AS_List_set_LapsedToExisting);           
//=======================================================================================

//myCS1.Block_Trigger_Execution__c = False;           
//Update myCS1;           
           
       }catch(Exception ex){           
           //Trigger_Handler__c myCS1 = Trigger_Handler__c.getInstance('Block Trigger');           
           //myCS1.Block_Trigger_Execution__c = False;           
           //Update myCS1;           
           System.debug('Exception -' +ex);        
       }
    }
    
    public void finish(){
    }
}