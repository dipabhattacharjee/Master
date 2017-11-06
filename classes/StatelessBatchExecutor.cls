public with sharing class StatelessBatchExecutor implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    private String query;
    private CustomBatchable contextObject;
    private set<id> idSet;
    
    public interface CustomBatchable{
        void execute(list<sObject> scope);
        void finish();
    }
    
    public StatelessBatchExecutor(CustomBatchable contextObject, string query, set<id> ids) {
        this.contextObject = contextObject;
        this.query = query;
        this.idSet = ids;
        if(ids == null){
            this.query = query;
        }else{
            this.query = query+' idSet';
        } 
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('Query is ====================== '+query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        try{
           contextObject.execute(scope);
        }catch (System.DmlException e) {
            System.debug('Exception*****DML****** '+e.getMessage()+'Line number '+e.getLineNumber());
        
        } catch(Exception e){
            System.debug('Exception***** Exceution***** '+e.getMessage()+'Line number '+e.getLineNumber());            
        }
    }
    
    public void finish(Database.BatchableContext BC) {
       contextObject.finish();
    }  
}