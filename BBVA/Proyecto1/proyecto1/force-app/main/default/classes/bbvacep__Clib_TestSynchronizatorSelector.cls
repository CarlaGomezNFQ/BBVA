@isTest
public class Clib_TestSynchronizatorSelector {

    private static final String EXTERNAL_NAME = 'External Id';

    @isTest static void selectByIdTest() {
        clib_Dst_Child_Sample__c record = createRecord();
        Test.startTest();
            Set <schema.SObjectField> setFields = new Set <schema.SObjectField>{clib_Dst_Child_Sample__c.Name, clib_Dst_Child_Sample__c.clib_Key_Field__c};
            List <clib_Dst_Child_Sample__c> recordList = (List <clib_Dst_Child_Sample__c>)new Clib_SynchronizatorSelector().selectById(clib_Dst_Child_Sample__c.SObjectType, setFields, new Set <String>{record.Id});
        Test.stopTest();
        System.assertEquals(recordList.size(), 1);
        System.assertEquals(recordList[0].clib_Key_Field__c, EXTERNAL_NAME);
        System.assertEquals(recordList[0].Name, 'Sample Name');
    }

    @isTest static void selectByExternalNameTest() {
        clib_Dst_Child_Sample__c record = createRecord();
        Test.startTest();
            Set <schema.SObjectField> setFields = new Set <schema.SObjectField>{clib_Dst_Child_Sample__c.Name, clib_Dst_Child_Sample__c.clib_Key_Field__c};
            List <clib_Dst_Child_Sample__c> recordList = (List <clib_Dst_Child_Sample__c>)new Clib_SynchronizatorSelector().selectByExternalName(clib_Dst_Child_Sample__c.SObjectType, setFields, new Set <String>{record.clib_Key_Field__c}, clib_Dst_Child_Sample__c.clib_Key_Field__c);
        Test.stopTest();
        System.assertEquals(recordList.size(), 1);
        System.assertEquals(recordList[0].clib_Key_Field__c, EXTERNAL_NAME);
        System.assertEquals(recordList[0].Name, 'Sample Name');
    }

    private static clib_Dst_Child_Sample__c createRecord() {
        clib_Dst_Child_Sample__c record = new clib_Dst_Child_Sample__c();
        record.Name = 'Sample Name';
        record.clib_Key_Field__c = EXTERNAL_NAME;
        insert record;
        return record;
    }
}