public with sharing class TriggerSetting {
    
    public static boolean IsTriggerBlocked()
    {
        
        Trigger_Handler__c blockTrigger= Trigger_Handler__c.getInstance('Block Trigger');
        
        if(blockTrigger != null)
        {
             return blockTrigger.Block_Trigger_Execution__c;
        }
        else
        { 
            return false;
        }
    }

    public static boolean IsCurrentUserIntegrationUser()
    {       
        String currentUserAlias = getCurrentUserAlias();

        if(currentUserAlias == 'iuser')
        {
            return true;
        }
        
        return false;
    }

    private static String getCurrentUserAlias(){

        List<User> currentUserAliases = [Select Id,name,Alias from User Where Id = :UserInfo.getUserId()];

        if(currentUserAliases.isEmpty())
        {
            System.debug(loggingLevel.Error, 'currentUserAliase is empty' );

            return 'NoAliase';
        }

    return currentUserAliases[0].Alias;
  }

  public static Boolean CanTriggerProcessRun()
  {
        if(!TriggerSetting.IsTriggerBlocked() && !TriggerSetting.IsCurrentUserIntegrationUser())
        {
            return true;
        }

        return false;
  }

}