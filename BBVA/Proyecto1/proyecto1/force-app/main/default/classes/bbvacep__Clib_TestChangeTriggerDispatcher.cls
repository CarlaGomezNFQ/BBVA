@isTest
public class Clib_TestChangeTriggerDispatcher {
	
    public class SampleHandler implements Clib_IChangeTriggerHandler {
        Boolean executed = false;
        public void afterInsert(List <SObject> lstSobj){
            executed = true;
        }
    }
    
    @isTest static void runTest() {
        SampleHandler sample = new SampleHandler(); 
        Clib_ChangeTriggerDispatcher.run(sample, System.TriggerOperation.AFTER_INSERT);
        //generic assertion because you can´t assert anything
        System.assert(sample.executed);
    }
}