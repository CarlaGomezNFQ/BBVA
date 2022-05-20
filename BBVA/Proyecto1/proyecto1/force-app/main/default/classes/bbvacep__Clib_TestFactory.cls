//No sonar added because this class insert data of sample object on which have no permissions
public class Clib_TestFactory {//NOSONAR

    @testVisible private static List <clib_Src_Parent_Sample__ChangeEvent> createSourceWithHeader (Decimal numberOfRecords, String eventType) {
		
        List <clib_Src_Parent_Sample__ChangeEvent> changeEventList = new List <clib_Src_Parent_Sample__ChangeEvent>();
        List <clib_Src_Parent_Sample__c> recordList = createSourceParents(numberOfRecords);
        for(Integer i = 0; i < recordList.size(); i++) {
            clib_Src_Parent_Sample__ChangeEvent event = new clib_Src_Parent_Sample__ChangeEvent();
            EventBus.ChangeEventHeader header = new EventBus.ChangeEventHeader();
            header.changeType = eventType;
            header.entityName = 'bbvacep__clib_Src_Parent_Sample__c';
            header.changedFields = new List <String> {'Name', 'bbvacep__clib_Field_1__c'};
            header.recordids  = new List <String> {recordList[i].Id};
            event.put('Name', recordList[i].Name);
            event.put('clib_Field_1__c', recordList[i].clib_Field_1__c);
            event.changeEventHeader = header;
            changeEventList.add(event);
        }
        return changeEventList;
    }

    private static List <clib_Src_Parent_Sample__c> createSourceParents(Decimal numberOfRecords) {

        List <clib_Src_Parent_Sample__c> recordList = new List <clib_Src_Parent_Sample__c>();
        for(Integer i = 1; i <= numberOfRecords; i++) {
            bbvacep__clib_Src_Parent_Sample__c source = new bbvacep__clib_Src_Parent_Sample__c ();
            source.Name = 'Sample Name' + i;
            source.clib_Field_1__c = 'Sample Value' + i;
            recordList.add(source);
        }
        insert recordList;
        return recordList;
    }

    @testVisible private static List <clib_Src_Child_Sample__ChangeEvent> createChildSourceWithParentAndHeader (Decimal numberOfRecords, String eventType) {
		
        List <clib_Src_Child_Sample__ChangeEvent> changeEventList = new List <clib_Src_Child_Sample__ChangeEvent>();
        List <clib_Src_Parent_Sample__c> parentList = createSourceParents(numberOfRecords);
        createParentDestinationFromChildSource(parentList);
        List <clib_Src_Child_Sample__c> childList = createSourceChildsFromParents(parentList);
        for(Integer i = 0; i < childList.size(); i++) {
            clib_Src_Child_Sample__ChangeEvent event = new clib_Src_Child_Sample__ChangeEvent();
            EventBus.ChangeEventHeader header = new EventBus.ChangeEventHeader();
            header.changeType = eventType;
            header.entityName = 'bbvacep__clib_Src_Child_Sample__c';
            header.changedFields = new List <String> {'Name', 'bbvacep__clib_Src_Child_Field_1__c', 'bbvacep__clib_Src_Parent_Sample__c'};
            header.recordids  = new List <String> {childList[i].Id};
            event.put('Name', childList[i].Name);
            event.put('clib_Src_Child_Field_1__c', childList[i].clib_Src_Child_Field_1__c);
            event.put('bbvacep__clib_Src_Parent_Sample__c', childList[i].clib_Src_Parent_Sample__c);
            event.changeEventHeader = header;
            changeEventList.add(event);
        }
        return changeEventList;
    }

    private static List <clib_Src_Child_Sample__c> createSourceChildsFromParents(List <clib_Src_Parent_Sample__c> parents) {

        List <clib_Src_Child_Sample__c> recordList = new List <clib_Src_Child_Sample__c>();
        for(Integer i = 0; i < parents.size(); i++) {
            clib_Src_Child_Sample__c child = new clib_Src_Child_Sample__c();
            child.Name = 'Sample Name' + i;
            child.clib_Src_Child_Field_1__c = 'Sample Value' + i;
            child.clib_Src_Parent_Sample__c = parents[i].Id;
            recordList.add(child);
        }
        insert recordList;
        return recordList;
    }
    
    @testVisible private static List <clib_Dst_Parent_Sample__c> createDestinationFromSource(List <clib_Src_Parent_Sample__ChangeEvent> sourceList) {
        List <clib_Dst_Parent_Sample__c> recordList = new List <clib_Dst_Parent_Sample__c>();
        for(Integer i = 0; i < sourceList.size(); i++) {
            clib_Dst_Parent_Sample__c destination = new clib_Dst_Parent_Sample__c();
            destination.clib_Key_Field__c = ((EventBus.ChangeEventHeader)sourceList[i].get('ChangeEventHeader')).recordIds[0];
            destination.Name = 'Diferent Name' + i;
            recordList.add(destination);
        }
        insert recordList;
        return recordList;
    }

    @testVisible private static List <clib_Dst_Child_Sample__c> createDestinationFromSource(List <clib_Src_Child_Sample__ChangeEvent> sourceList) {
        List <clib_Dst_Child_Sample__c> recordList = new List <clib_Dst_Child_Sample__c>();
        for(Integer i = 0; i < sourceList.size(); i++) {
            clib_Dst_Child_Sample__c destination = new clib_Dst_Child_Sample__c();
            destination.clib_Key_Field__c = ((EventBus.ChangeEventHeader)sourceList[i].get('ChangeEventHeader')).recordIds[0];
            destination.Name = 'Diferent Name' + i;
            recordList.add(destination);
        }
        insert recordList;
        return recordList;
    }

    private static void createParentDestinationFromChildSource(List <clib_Src_Parent_Sample__c> sourceList) {
        List <clib_Dst_Parent_Sample__c> recordList = new List <clib_Dst_Parent_Sample__c>();
        for(Integer i = 0; i < sourceList.size(); i++) {
            clib_Dst_Parent_Sample__c destination = new clib_Dst_Parent_Sample__c();
            destination.clib_Key_Field__c = sourceList[i].Id;
            destination.Name = 'Diferent Name' + i;
            recordList.add(destination);
        }
        insert recordList;
    }
}