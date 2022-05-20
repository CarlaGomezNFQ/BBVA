/**
* ────────────────────────────────────────────────────────────────────
* ConditionsRemove_Ctrl Test class
* Test class for conditions_remove_cmp controller
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-08
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class ConditionsRemove_Ctrl_Test {

    @TestSetup
    static void setupTestData() {

        /* create catalog */

        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(1);
        insert attributes;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(1, families[0]);
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
        insert paConditions;

    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final ConditionsRemove_Ctrl res = new ConditionsRemove_Ctrl();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getConditionNameTest() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
        final List<profitability_analysis_condition__c> paConditions = pacSelector.selectByProfitabiliyAnalysisId(new Set<Id>{profitabilityAnalysis[0].Id});

        Test.startTest();
            final Map<String, Object> result = ConditionsRemove_Ctrl.getConditionName(paConditions[0].id);
            System.assertEquals(result.get('name'), 'Condition 0', 'Expected "Condition 0". got ' + result.get('name'));
        Test.stopTest();
    }

    @IsTest
    static void removeConditionsTest() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
        final List<profitability_analysis_condition__c> paConditions = pacSelector.selectByProfitabiliyAnalysisId(new Set<Id>{profitabilityAnalysis[0].Id});

        Test.startTest();
            final Utils.DML_Wrapper result = ConditionsRemove_Ctrl.removeCondition(profitabilityAnalysis[0].Id, paConditions[0].id);
            System.assertEquals(result.isSuccess, true, 'Error removing conditions. got ' + String.join(result.lstErrMessage, ', '));
        Test.stopTest();
    }
}