/**
* @author Vishnu Belkone
* @date 04/01/2016
* @description This class extends the TriggerDispatcherBase to provide the dispatching functionality for the trigger actions 
*        on the Opportunity object. The event handlers support allowing and preventing actions for reentrant scenarios. 
*        This is controlled by the flag isBeforeXxxxx and isAfterXxxxx member variables. These variables need to be set
*        to true before invoking the handlers and set to false after the invocation of the handlers. Resetting is MUST
*        as otherwise unit tests MAY fail. The actual actions should be placed in the handlers (in a separate class).
*/
public class OpportunityTriggerDispatcher extends TriggerDispatcherBase{ 
	private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
	private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false; 
    private static Boolean isBeforeDeleteProcessing = false; 
  
	/** 
	* @author Vishnu Belkone
	* @date 04/01/2016
	* @description Called by the trigger framework to carry out the actions before the records are inserted. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the records that is getting inserted.
	*/
	public virtual override void beforeInsert(TriggerParameters tp) {
	if(!isBeforeInsertProcessing) {
		isBeforeInsertProcessing = true;
		system.debug('OpportunityTriggerDispatcher beforeInsert Start');
		execute(new OpportunityBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
		system.debug('OpportunityTriggerDispatcher beforeInsert End');
		//isBeforeInsertProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}
  
	/** 
	* @author Vishnu Belkone
	* @date 04/01/2016
	* @description Called by the trigger framework to carry out the actions before the records are updated. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the records that is getting updated.
	*/
	public virtual override void beforeUpdate(TriggerParameters tp) {
	if(!isBeforeUpdateProcessing) {
		isBeforeUpdateProcessing = true;
		system.debug('OpportunityTriggerDispatcher beforeUpdate Start');
		execute(new OpportunityBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
		system.debug('OpportunityTriggerDispatcher beforeUpdate End');
		//isBeforeUpdateProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
	}

	/** 
	* @author Vishnu Belkone
	* @date 04/01/2016
	* @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	*/
	public virtual override void afterInsert(TriggerParameters tp) {
	if(!isAfterInsertProcessing) {
		isAfterInsertProcessing = true;
		system.debug('OpportunityTriggerDispatcher afterInsert Start');
		execute(new OpportunityAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
		system.debug('OpportunityTriggerDispatcher afterInsert End');
		//isAfterInsertProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}

	/** 
	* @author Vishnu Belkone
	* @date 04/01/2016
	* @description Called by the trigger framework to carry out the actions after the records are updated. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
	*/  
	public virtual override void afterUpdate(TriggerParameters tp) {
	if(!isAfterUpdateProcessing) {
		isAfterUpdateProcessing = true;
		system.debug('OpportunityTriggerDispatcher afterUpdate Start');
		execute(new OpportunityAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
		system.debug('OpportunityTriggerDispatcher afterUpdate End');
		//isAfterUpdateProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
    
    /** 
	* @author Vishnu Belkone
	* @date 31/05/2017
	* @description Called by the trigger framework to carry out the actions before the records are deleted. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the records that is getting deleted.
	*/
	public virtual override void beforeDelete(TriggerParameters tp) {
	if(!isBeforeDeleteProcessing) {
		isBeforeDeleteProcessing = true;
		system.debug('OpportunityTriggerDispatcher beforeDelete Start');
		execute(new OpportunityBeforeDeleteTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeDelete);
		system.debug('OpportunityTriggerDispatcher beforeDelete End');
		//isBeforeDeleteProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.beforeDelete);
	}
    
}