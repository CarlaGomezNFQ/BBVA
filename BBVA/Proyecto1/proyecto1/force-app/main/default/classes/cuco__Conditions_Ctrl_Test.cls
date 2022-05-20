/**
* ────────────────────────────────────────────────────────────────────
* Conditions_Ctrl_Test
* Test class for Conditions_Ctrl class
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class Conditions_Ctrl_Test {

    @TestSetup
    static void setupTestData() {

        /* create catalog */

        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(1);
        insert attributes;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(2, families[0]);
        conditions[1].gf_psc_cond_flat_rate_ind_type__c = true;
        insert conditions;

        final List<ps_catalog_condition_attribute__c> conditionAttributes = Test_Utils.createPSCatalogConditonAttributes(attributes.size(), conditions[0], attributes);
        insert conditionAttributes;

        /* create conditions */

        final List<Account> accounts = Test_Utils.createAccounts(1);
        insert accounts;

        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(1, accounts[0]);
        insert profSheets;

        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(1, accounts[0]);
        profAnalysis[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[0].segment_type__c = 'BEC';
        profAnalysis[0].gf_all_ct_apply_cond_ind_type__c = false;
        profAnalysis[0].gf_pa_forced_mf_mgmt_ind_type__c = false;
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].Id;
        insert profAnalysis;

        final List<profitability_analysis_condition__c> paConditions = Test_Utils.createProfAnalysisConditons(1, profAnalysis[0], conditions[0]);
        paConditions.addAll(Test_Utils.createProfAnalysisConditons(1, profAnalysis[0], conditions[1]));
        insert paConditions;

        final List<profitability_sheet_condition__c> psConditions = Test_Utils.createProfSheetConditons(1, profSheets[0], conditions[0]);
        insert psConditions;
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final Conditions_Ctrl res = new Conditions_Ctrl();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void conditionsErrorTest() {
        Test.startTest();
            try {
                final List<Conditions_Wrapper> paConditions = Conditions_Ctrl.getConditions('a0p3N000004VmnsQAC'); //NOSONAR
                System.assert(false, 'conditionsErrorTest > Conditions_Ctrl.getConditions should have broken'); //NOSONAR
            } catch(Exception e) {  //NOSONAR
                System.assert(true, 'Conditions_Ctrl.getConditions, error not captured'); //NOSONAR
            }
        Test.stopTest();
    }

    @IsTest
    static void flatConditionsErrorTest() {
        Test.startTest();
            try {
                final List<Conditions_Wrapper> paConditions = Conditions_Ctrl.getFlatConditions('a0p3N000004VmnsQAC'); //NOSONAR
                System.assert(false, 'flatConditionsErrorTest > Conditions_Ctrl.getFlatConditions should have broken'); //NOSONAR
            } catch(Exception e) {  //NOSONAR
                System.assert(true, 'Conditions_Ctrl.getFlatConditions, error not captured'); //NOSONAR
            }
        Test.stopTest();
    }

    @IsTest
    static void getConditionsFromProfitabilityAnalysis() {

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        Test.startTest();
            final List<Conditions_Wrapper> paConditions = Conditions_Ctrl.getConditions(profitabilityAnalysis[0].Id);
            System.assertEquals(paConditions[0].attributes[0].Name, 'Attribute0', 'Expected "Attribute0". got ' + paConditions[0].attributes[0].Name );
        Test.stopTest();
    }

    @IsTest
    static void getFlatConditionsFromProfitabilityAnalysis() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);
        Test.startTest();
            final List<Conditions_Wrapper> paConditions = Conditions_Ctrl.getFlatConditions(profitabilityAnalysis[0].Id);
            System.assertEquals(1, paConditions.size(), 'Err at Conditions_Ctrl_Test - getFlatConditionsFromProfitabilityAnalysis');
        Test.stopTest();
    }

    @IsTest
    static void getFlatConditionsFromProfSheet() {
        final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector(false);
        final Set<String> psNames = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> profitabilitySheet = psSelector.selectByName(psNames);
        Test.startTest();
            final List<Conditions_Wrapper> psConditions = Conditions_Ctrl.getFlatConditions(profitabilitySheet[0].Id);
            System.assertEquals(0, psConditions.size(), 'Err at Conditions_Ctrl_Test - getFlatConditionsFromProfSheet');
        Test.stopTest();
    }

    @IsTest
    static void getConditionsFromProfSheet() {

        final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector(false);
        final Set<String> psNames = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> profitabilitySheet = psSelector.selectByName(psNames);
        Set<Id> profSheetIds = new Set<Id>{profitabilitySheet[0].Id};

        Test.startTest();
            final List<profitability_sheet_condition__c> psConditions = ProfitabilitySheetCondition_Service.getConditionsFromProfitabilitySheet(profSheetIds);
            final List<ps_catalog_condition_attribute__c> conditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromProfitabilitySheetConditions(psConditions);
            final List<Conditions_Wrapper> conditions = ProfitabilitySheetCondition_Service.getProfitabilitySheetConditionWrapper(psConditions, conditionAttributes);
            System.assertEquals(conditions[0].attributes[0].Name, 'Attribute0', 'Expected "Attribute0". got ' + conditions[0].attributes[0].Name );
        Test.stopTest();
    }

    @IsTest
    static void canAddConditions() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        Test.startTest();
            final Map<String, Object> permissions = Conditions_Ctrl.checkPermissions('addConditions', profitabilityAnalysis[0].Id, null, null);
            System.assertEquals(permissions.get('add'), true, 'Expected true. got ' + permissions.get('add'));
        Test.stopTest();
    }

    @IsTest
    static void canEditConditions() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        Test.startTest();
            final List<Conditions_Wrapper> paConditions = Conditions_Ctrl.getConditions(profitabilityAnalysis[0].Id);
            final Map<String, Object> permissions = Conditions_Ctrl.checkPermissions('editConditions', profitabilityAnalysis[0].Id, paConditions[0].familyId, null);
            System.assertEquals(permissions.get('edit'), true, 'Expected true. got ' + permissions.get('add'));
        Test.stopTest();
    }

    @IsTest
    static void canRemoveConditions() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        Test.startTest();
            final List<Conditions_Wrapper> paConditions = Conditions_Ctrl.getConditions(profitabilityAnalysis[0].Id);
            final Map<String, Object> permissions = Conditions_Ctrl.checkPermissions('removeConditions', profitabilityAnalysis[0].Id, null, paConditions[0].id);
            System.assertEquals(permissions.get('remove'), true, 'Expected true. got ' + permissions.get('add'));
        Test.stopTest();
    }

    @IsTest
    static void canManageConditions() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        Test.startTest();
            final Map<String, Object> permissions = Conditions_Ctrl.checkPermissions('manageConditions', profitabilityAnalysis[0].Id, null, null);
            System.assertEquals(permissions.get('add'), true, 'Expected true. got ' + permissions.get('add'));
        Test.stopTest();
    }
}