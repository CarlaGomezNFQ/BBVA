global class Clib_ChangeTriggerDispatcher {
	global static void run (Clib_IChangeTriggerHandler handler, System.TriggerOperation triggerEvent) {
                // Detect the current trigger context and fire the relevant methods on the trigger handler:
		switch on triggerEvent {
			when AFTER_INSERT {
				handler.afterInsert(Trigger.new);
			}
		}
	}
  public class TriggerException extends Exception {}
}