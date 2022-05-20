/**
* ────────────────────────────────────────────────────────────────────
* ConditionsSelect_Ctrl Test class
* Test class for conditions_select_cmp controller
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-17
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class ConditionsSelect_Ctrl_Test {

    @TestSetup
    static void setupTestData() {

        /* create catalog */
        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(1);
        insert attributes;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(1, families[0]);
        insert conditions;

        final List<ps_catalog_condition__c> conditionsFlat = Test_Utils.createPSCatalogFlatConditons(1, families[0]);
        insert conditionsFlat;
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final ConditionsSelect_Ctrl res = new ConditionsSelect_Ctrl();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getActiveCatalogConditionsTest() {
        Test.startTest();
            final List<PsCatalogCondition_Wrapper> conditions = ConditionsSelect_Ctrl.getActiveCatalogConditions();
            System.assertEquals(string.isEmpty(conditions[0].id), false, 'Expected one id. got ' + conditions[0].id );
        Test.stopTest();
    }

    @IsTest
    static void getActiveCatalogFlatConditionsTest() {
        Test.startTest();
            final List<PsCatalogCondition_Wrapper> conditions = ConditionsSelect_Ctrl.getActiveFlatCatalogConditions();
            System.assertEquals(string.isEmpty(conditions[0].id), false, 'Expected one id. got ' + conditions[0].id );
        Test.stopTest();
    }

    @IsTest
    static void getConditionsById() {
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector();
        Test.startTest();
            final List<ps_catalog_condition__c> conditions1 = selector.selectActiveCatalogConditions();
            set<Id> ids = new set<Id>{conditions1[0].Id};
            final List<ps_catalog_condition__c> conditions2 = selector.selectById(ids);
            System.assertEquals(conditions1[0].Id, conditions2[0].Id, 'Expected matching Ids. got ' + conditions1[0].Id + ' == ' + conditions2[0].Id);
        Test.stopTest();
    }

    @IsTest
    static void getConditionsByName() {
        final List<string> fieldset = new List<String>{'cuco__Default'};
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(fieldset);
        final Set<String> names = new Set<string>{'Condition 0'};
        Test.startTest();
            final List<ps_catalog_condition__c> conditions = selector.selectByName(names);
            System.assertEquals(conditions[0].Name, 'Condition 0', 'Expected "Condition 0". got ' + conditions[0].Name);
        Test.stopTest();
    }

    @IsTest
    static void getConditionsByFamilyId() {
        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> conditions1 = selector.selectActiveCatalogConditions();
        Test.startTest();
            final List<ps_catalog_condition__c> conditions2 = selector.selectByFamily(conditions1[0].gf_psc_family_id__c);
            System.assertEquals(conditions1[0].Id, conditions2[0].Id, 'Expected matching Ids. got ' + conditions1[0].Id + ' == ' + conditions2[0].Id);
        Test.stopTest();
    }

}