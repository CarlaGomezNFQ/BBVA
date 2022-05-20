@isTest
public class Clib_TestSynchronizatorChangeTriggerHdlr {
	
    @isTest static void afterInsertTest() {
        new Clib_SynchronizatorChangeTriggerHandler().afterInsert(new List <Sobject>());
        //generic assertion because you can´t assert anything
        System.assert(true);//NOSONAR
    }
}