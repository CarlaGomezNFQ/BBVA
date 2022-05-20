@isTest
public class Clib_TestMDTSynchronizatorSelector {

    @isTest static void selectByDeveloperNameTest() {
        List <clib_Synchronizator__mdt> syncronizatorList = Clib_MDTSynchronizatorSelector.newInstance().selectByDeveloperName(new Set <String> {'Sample_Parent'});
        System.assert(!syncronizatorList.isEmpty());
    }
    
    @isTest static void selectBySourceObjectNameTest() {
        List <clib_Synchronizator__mdt> syncronizatorList = Clib_MDTSynchronizatorSelector.newInstance().selectBySourceObjectName(new Set <String> {'bbvacep__clib_Src_Parent_Sample__c'});
        System.assert(!syncronizatorList.isEmpty());
    }
    
    @isTest static void selectBySourceObjectNameWithMappingsTest() {
        List <clib_Synchronizator__mdt> syncronizatorList = Clib_MDTSynchronizatorSelector.newInstance().selectBySourceObjectNameWithMappings(new Set <String> {'bbvacep__clib_Src_Parent_Sample__c'});
        System.assert(!syncronizatorList.isEmpty());
    }
}