public class OpportunityLineItemTriggerDispatcher extends TriggerDispatcherBase{

    
    private static Boolean isBeforeDeleteProcessing = false;
    private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
	private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false; 
    
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
		system.debug('OpportunitLineItem.beforeDelete Started');
		execute(new OpportunityLineItemB4DelTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeDelete);
		system.debug('OpportunitLineItem.beforeDelete End');
		//isBeforeDeleteProcessing = false;
	}	
	else execute(null, tp, TriggerParameters.TriggerEvent.beforeDelete);
	}


	/** 
	* @author Vishnu Belkone
	* @date 08/03/2017
	* @description Called by the trigger framework to carry out the actions after the record(s) are created. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	*/
	public virtual override void afterInsert(TriggerParameters tp) {
		System.debug('Enter OpportunitLineItem afterInsert');
	if(!isAfterInsertProcessing) {
		isAfterInsertProcessing = true;
		system.debug('OpportunitLineItem.afterUpdate Started');
		execute(new OpportunityItemAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
		system.debug('OpportunitLineItem.afterUpdate End');
		//isAfterInsertProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}

	/** 
	* @author Vishnu Belkone
	* @date 08/03/2017
	* @description Called by the trigger framework to carry out the actions after the records are updated. If there is an
	*        existing call running on the same context, the rentrant call will utilize the handler that was created
	*        in the original call.
	* @param TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
	*/  
	public virtual override void afterUpdate(TriggerParameters tp) {
	System.debug('Enter OpportunitLineItem afterUpdate');
	if(!isAfterUpdateProcessing) {
		isAfterUpdateProcessing = true;
		system.debug('OpportunitLineItem.afterUpdate Started');
		execute(new OpportunityItemAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
		system.debug('OpportunitLineItem.afterUpdate End');
		//isAfterUpdateProcessing = false;
	}
	else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
}