/**
* @author Amit Shirude
* @date 11/05/2015
* @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
*        on the Asset object. The event handlers support allowing and preventing actions for reentrant scenarios. 
*        This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*        to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*        as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
*/
public class AssetTriggerDispatcher extends TriggerDispatcherBase {
  private static Boolean isBeforeInsertProcessing = false;
  private static Boolean isBeforeUpdateProcessing = false;
  private static Boolean isAfterInsertProcessing = false;
  private static Boolean isAfterUpdateProcessing = false;    
  
  /** 
  * @author Amit Shirude
  * @date 11/05/2015
  * @description Called by the trigger framework to carry out the actions before the records are inserted. If there is an
  *        existing call running on the same context, the rentrant call will utilize the handler that was created
  *        in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
  */
  public virtual override void beforeInsert(TriggerParameters tp) {
    if(!isBeforeInsertProcessing) {
      isBeforeInsertProcessing = true;
        system.debug('#This is to test assset beforeInsert');
      execute(new AssetBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
      //isBeforeInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
  }
  
  /** 
  * @author Amit Shirude
  * @date 11/05/2015
  * @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
  *        existing call running on the same context, the rentrant call will utilize the handler that was created
  *        in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
  */
  public virtual override void beforeUpdate(TriggerParameters tp) {
    if(!isBeforeUpdateProcessing) {
      isBeforeUpdateProcessing = true;
        system.debug('#This is to test assset beforeUpdate');
      execute(new AssetBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
      //isBeforeUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
  }

  /** 
  * @author Amit Shirude
  * @date 11/05/2015
  * @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
  *        existing call running on the same context, the rentrant call will utilize the handler that was created
  *        in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
  */
  public virtual override void afterInsert(TriggerParameters tp) {
    if(!isAfterInsertProcessing) {
      isAfterInsertProcessing = true;
        system.debug('#This is to test assset beforeUpdate');
      execute(new AssetAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
     // isAfterInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }

  /** 
  * @author Amit Shirude
  * @date 11/05/2015
  * @description Called by the trigger framework to carry out the actions after the records are updated. If there is an
  *        existing call running on the same context, the rentrant call will utilize the handler that was created
  *        in the original call.
  * @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
  */  
  public virtual override void afterUpdate(TriggerParameters tp) {
    if(!isAfterUpdateProcessing) {
      isAfterUpdateProcessing = true;
        system.debug('#This is to test assset afterUpdate');
      execute(new AssetAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
      //isAfterUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
  }
}