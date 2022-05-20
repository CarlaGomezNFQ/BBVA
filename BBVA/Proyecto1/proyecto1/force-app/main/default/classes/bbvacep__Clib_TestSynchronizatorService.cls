@isTest
public class Clib_TestSynchronizatorService {

    @isTest static void insertTest() {
        List <clib_Src_Parent_Sample__ChangeEvent> sources = Clib_TestFactory.createSourceWithHeader(2, 'CREATE');
        Test.startTest();
            Clib_SynchronizatorService.synchronize(sources);
        Test.stopTest();
        Set <Id> idSet = getIds(sources);
        Map <String, clib_Dst_Parent_Sample__c> destinationMap = getParentDestinations(getIds(sources));
        for(Integer i = 0; i < sources.size(); i++) {
            System.assertEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
            System.assertEquals(sources[i].get('clib_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Field_1__c);
        }
    }
    
    @isTest static void updateTest() {
        List <clib_Src_Parent_Sample__ChangeEvent> sources = Clib_TestFactory.createSourceWithHeader(2, 'UPDATE');
        List <clib_Dst_Parent_Sample__c> destinations = Clib_TestFactory.createDestinationFromSource(sources);
        Map <String, clib_Dst_Parent_Sample__c> destinationMap = new Map <String, clib_Dst_Parent_Sample__c>();
        for(Integer i = 0; i < destinations.size(); i++) {
            destinationMap.put(destinations[i].clib_Key_Field__c, destinations[i]);
        }
        for(Integer i = 0; i < sources.size(); i++){
           System.assertNotEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
           System.assertNotEquals(sources[i].get('clib_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Field_1__c); 
        }
        Test.startTest();
            Clib_SynchronizatorService.synchronize(sources);
        Test.stopTest();
        Set <Id> idSet = getIds(sources);
        destinationMap = getParentDestinations(getIds(sources));
        for(Integer i = 0; i < sources.size(); i++) {
            System.assertEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
            System.assertEquals(sources[i].get('clib_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Field_1__c);
        }
    }

    @isTest static void updateUnexistingTest() {
        List <clib_Src_Parent_Sample__ChangeEvent> sources = Clib_TestFactory.createSourceWithHeader(2, 'UPDATE');
        Test.startTest();
            Clib_SynchronizatorService.synchronize(sources);
        Test.stopTest();
        Map <String, clib_Dst_Parent_Sample__c> destinationMap = getParentDestinations(getIds(sources));
        for(Integer i = 0; i < sources.size(); i++) {
            System.assertEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
            System.assertEquals(sources[i].get('clib_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Field_1__c);
        }
    }

    @isTest static void deleteTest() {
        List <clib_Src_Parent_Sample__ChangeEvent> sources = Clib_TestFactory.createSourceWithHeader(2, 'DELETE');
        List <clib_Dst_Parent_Sample__c> destinations = Clib_TestFactory.createDestinationFromSource(sources);
        Map <String, clib_Dst_Parent_Sample__c> destinationMap = new Map <String, clib_Dst_Parent_Sample__c>();
        for(Integer i = 0; i < destinations.size(); i++) {
            destinationMap.put(destinations[i].clib_Key_Field__c, destinations[i]);
        }
        for(Integer i = 0; i < sources.size(); i++){
           System.assertNotEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
           System.assertNotEquals(sources[i].get('clib_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Field_1__c); 
        }
        Test.startTest();
            Clib_SynchronizatorService.synchronize(sources);
        Test.stopTest();
        System.assert([SELECT Id FROM clib_Dst_Parent_Sample__c].isEmpty());
    }

    @isTest static void insertWithParentTest() {
        List <clib_Src_Child_Sample__ChangeEvent> sources = Clib_TestFactory.createChildSourceWithParentAndHeader(2, 'CREATE');
        Test.startTest();
            Clib_SynchronizatorService.synchronize(sources);
        Test.stopTest();
        Set <Id> idSet = getIds(sources);
        Map <String, clib_Dst_Child_Sample__c> destinationMap = getChildDestinations(getIds(sources));
        for(Integer i = 0; i < sources.size(); i++) {
            System.assertEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
            System.assertEquals(sources[i].get('clib_Src_Child_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Dst_Child_Field_1__c);
            System.assertEquals(sources[i].get('clib_Src_Parent_Sample__c'), destinationMap.get(getSourceId(sources[i])).clib_Dst_Parent_Sample__r.clib_Key_Field__c);
        }
    }

    @isTest static void updateWithParentTest() {
        List <clib_Src_Child_Sample__ChangeEvent> sources = Clib_TestFactory.createChildSourceWithParentAndHeader(2, 'UPDATE');
        List <clib_Dst_Child_Sample__c> destinations = Clib_TestFactory.createDestinationFromSource(sources);
        Map <String, clib_Dst_Child_Sample__c> destinationMap = new Map <String, clib_Dst_Child_Sample__c>();
        for(Integer i = 0; i < destinations.size(); i++) {
            destinationMap.put(destinations[i].clib_Key_Field__c, destinations[i]);
        }
        System.debug(destinationMap);
        for(Integer i = 0; i < sources.size(); i++){
            System.debug(getSourceId(sources[i]));
            System.assertNotEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
            System.assertNotEquals(sources[i].get('clib_Src_Child_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Dst_Child_Field_1__c); 
         }
        Test.startTest();
            Clib_SynchronizatorService.synchronize(sources);
        Test.stopTest();
        Set <Id> idSet = getIds(sources);
        destinationMap = getChildDestinations(getIds(sources));
        for(Integer i = 0; i < sources.size(); i++) {
            System.assertEquals(sources[i].get('Name'), destinationMap.get(getSourceId(sources[i])).Name);
            System.assertEquals(sources[i].get('clib_Src_Child_Field_1__c'), destinationMap.get(getSourceId(sources[i])).clib_Dst_Child_Field_1__c);
            System.assertEquals(sources[i].get('clib_Src_Parent_Sample__c'), destinationMap.get(getSourceId(sources[i])).clib_Dst_Parent_Sample__r.clib_Key_Field__c);
        }
    }
    
    private static Set <Id> getIds (List <SObject> events) {
        Set <Id> idSet = new Set <Id>();
        for(Integer i = 0; i < events.size(); i++) {
            idSet.add(((EventBus.ChangeEventHeader)events[i].get('ChangeEventHeader')).recordIds[0]);
        }
        return idSet;
    }
    
    private static Id getSourceId(SObject event) {
        return ((EventBus.ChangeEventHeader)event.get('ChangeEventHeader')).recordIds[0];
    }
    
    private static Map <String, clib_Dst_Parent_Sample__c> getParentDestinations(Set <Id> idSet){
        Map <String, clib_Dst_Parent_Sample__c> dstMap = new Map <String, clib_Dst_Parent_Sample__c>();
        List <clib_Dst_Parent_Sample__c> dstList = [SELECT Name, clib_Field_1__c, clib_Key_Field__c 
                                                    FROM clib_Dst_Parent_Sample__c 
                                                    WHERE clib_Key_Field__c IN: idSet];
        for(Integer i = 0; i < dstList.size(); i++) {
            dstMap.put(dstList[i].clib_Key_Field__c, dstList[i]);
        }
        return dstMap;
    }

    private static Map <String, clib_Dst_Child_Sample__c> getChildDestinations(Set <Id> idSet){
        Map <String, clib_Dst_Child_Sample__c> dstMap = new Map <String, clib_Dst_Child_Sample__c>();
        List <clib_Dst_Child_Sample__c> dstList = [SELECT Name, clib_Dst_Child_Field_1__c, clib_Key_Field__c, clib_Dst_Parent_Sample__r.clib_Key_Field__c
                                                    FROM clib_Dst_Child_Sample__c 
                                                    WHERE clib_Key_Field__c IN: idSet];
        for(Integer i = 0; i < dstList.size(); i++) {
            dstMap.put(dstList[i].clib_Key_Field__c, dstList[i]);
        }
        return dstMap;
    }
}