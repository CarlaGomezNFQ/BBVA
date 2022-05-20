/*
 * Interface used for ChangeTriggers from Change Data Capture
 */
global interface Clib_IChangeTriggerHandler {
	void afterInsert(SObject[] newItems);
}