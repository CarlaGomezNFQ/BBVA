@isTest
public class Clib_TestMDTTriggerExtensionSelector {

    @isTest static void selectActiveByObjectNameTest() {
        List <clib_TriggerExtension__mdt> triggerExtensions = Clib_MDTTriggerExtensionSelector.newInstance().selectActiveByObjectName('SampleObject__c');
        System.assert(triggerExtensions.isEmpty());
    }
}