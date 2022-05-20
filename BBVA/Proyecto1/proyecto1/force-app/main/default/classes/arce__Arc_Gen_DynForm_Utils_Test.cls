/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_DynForm_Utils_Test
* @Author   alexander.munguia.contractor@bbva.com
* @Date     Created: 29/10/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Test class that covers: Arc_Gen_DynForm_Utils
* -----------------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_DynForm_Utils_Test {
    /**
    * @description makeData
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @TestSetup
    static void makeData() {
        Test.loadData(dyfr__Template__c.sObjectType, 'Arc_Gen_templates');
        Test.loadData(dyfr__Tab__c.sObjectType, 'Arc_Gen_tabs');
        Test.loadData(dyfr__Field_Config__c.sObjectType, 'Arc_Gen_fieldConfigs');
        Test.loadData(dyfr__Dependent_value__c.sObjectType, 'Arc_Gen_dataValues');
    }

    /**
    * @description getTabsByTemplate method test
    * @author amunguia.contractor@bbva.com | 11-05-2020
    **/
    @isTest
    public static void getTabsByTemplateTest() {
        final dyfr__Tab__c current = [select Id, Name, dyfr__Template__r.Name from dyfr__Tab__c LIMIT 1];
        Test.startTest();
        final Map<String, dyfr__Tab__c> result = Arc_Gen_DynForm_Utils.getTabsByTemplate(new Set<String> {current.dyfr__Template__r.Name}, new List<String> {current.Name});
        Test.stopTest();
        System.assertEquals(current.Name, result.get(current.Id).Name, 'different tab');
    }
}