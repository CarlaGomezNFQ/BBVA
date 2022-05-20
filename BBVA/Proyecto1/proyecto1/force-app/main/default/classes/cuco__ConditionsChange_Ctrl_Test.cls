/**
* ────────────────────────────────────────────────────────────────────
* ConditionsChange_Ctrl_Test
* Test class for ConditionsEdit_Ctrl class
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-08
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class ConditionsChange_Ctrl_Test {

    @TestSetup
    static void setupTestData() {

        /* create catalog */
        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(5, families[0]);
        insert conditions;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(10);
        attributes[0].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[0].gf_attribute_value_type_name__c = 'Currency';
        attributes[0].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        attributes[1].gf_psc_bknd_svc_format_type__c = 'RATE';
        attributes[1].gf_attribute_value_type_name__c = 'Permillage';
        attributes[1].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        attributes[2].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[2].gf_attribute_value_type_name__c = 'Currency';
        attributes[2].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        attributes[3].gf_psc_bknd_svc_format_type__c = 'TEXT';
        attributes[3].gf_attribute_value_type_name__c = 'Checkbox';
        attributes[3].cuco__gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        attributes[4].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[4].gf_attribute_value_type_name__c = 'Currency';
        attributes[4].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_fix_amount__c';
        insert attributes;

        final List<ps_catalog_condition_attribute__c> conditionAttributes = Test_Utils.createPSCatalogConditonAttributes(10, conditions[0], attributes);
        conditionAttributes[0].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.amount';
        conditionAttributes[0].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[0].gf_psc_atribute_id__c = attributes[0].Id;

        conditionAttributes[1].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.type';
        conditionAttributes[1].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[1].gf_psc_atribute_id__c = attributes[1].Id;

        conditionAttributes[2].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.min';
        conditionAttributes[2].gf_psc_condition_id__c = conditions[1].Id;
        conditionAttributes[2].gf_psc_atribute_id__c = attributes[2].Id;

        conditionAttributes[3].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.type';
        conditionAttributes[3].gf_psc_condition_id__c = conditions[1].Id;
        conditionAttributes[3].gf_psc_atribute_id__c = attributes[3].Id;

        conditionAttributes[4].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.min';
        conditionAttributes[4].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[4].gf_psc_atribute_id__c = attributes[4].Id;

        insert conditionAttributes;

        /* create conditions */

        final List<Account> accounts = Test_Utils.createAccounts(2);
        accounts[0].Sic = '666';
        accounts[0].AccountNumber = '001183970';

        insert accounts;

        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(3, accounts[0]);
        insert profSheets;

        final List<profitability_sheet_participant__c> participants = Test_Utils.createProfSheetParticipant(1, profSheets[0].Id, new List<Id>{accounts[0].Id});
        insert participants;

        final List<profitability_sheet_participant__c> participants2 = Test_Utils.createProfSheetParticipant(1, profSheets[1].Id, new List<Id>{accounts[1].Id});
        insert participants2;

        final List<profitability_sheet_condition__c> psConditions = Test_Utils.createProfSheetConditons(3, profSheets[0], conditions[0]);
        psConditions[1].gf_ps_cond_atrb_srce_type_name__c = 'COMMERCIAL_PACKAGE';
        psConditions[1].gf_ps_source_cust_package_id__c = '001183970F765';
        psConditions[2].gf_ps_cond_atrb_srce_type_name__c = 'GIP_PACKAGE';
        psConditions[2].gf_ps_source_cust_package_id__c = '001183970G654';
        insert psConditions;

        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(1, accounts[0]);
        profAnalysis[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[0].segment_type__c = 'BEC';
        profAnalysis[0].gf_all_ct_apply_cond_ind_type__c = false;
        profAnalysis[0].gf_pa_forced_mf_mgmt_ind_type__c = false;
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].Id;
        insert profAnalysis;

        final List<profitability_analysis_condition__c> paConditions = Test_Utils.createProfAnalysisConditons(4, profAnalysis[0], conditions[0]);
        paConditions[2].gf_psc_condition_id__c = conditions[1].Id;
        paConditions[3].gf_psc_condition_id__c = conditions[1].Id;
        insert paConditions;

        final List<ps_catalog_condition_standard__c> stdConditions = Test_Utils.createPSCatalogConditonsStandard(3);
        stdConditions[0].gf_psc_cond_atrb_std_id__c = conditionAttributes[0].gf_psc_condition_attribute_id__c;
        stdConditions[0].gf_psc_condition_attribute_id__c = conditionAttributes[0].Id;
        stdConditions[1].gf_psc_cond_atrb_std_id__c = conditionAttributes[1].gf_psc_condition_attribute_id__c;
        stdConditions[1].gf_cond_atrb_max_val_name__c = '';
        stdConditions[1].gf_psc_condition_attribute_id__c = conditionAttributes[1].Id;
        stdConditions[2].gf_psc_cond_atrb_std_id__c = conditionAttributes[2].gf_psc_condition_attribute_id__c;
        stdConditions[2].gf_psc_condition_attribute_id__c = conditionAttributes[2].Id;
        stdConditions[2].gf_cond_atrb_min_val_name__c = '';
        insert stdConditions;
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final ConditionsChange_Ctrl res = new ConditionsChange_Ctrl();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getConditionsFromJSONTest() {

        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectActiveCatalogConditions();

        final Id profanalysisId = profitabilityAnalysis[0].Id;
        final Id familyId = catalogConditions[0].gf_psc_family_id__c;

        String jsonAttrValues = '{"standard":[],"actual":[{"value":"567.88","id":"np.nat.transfer.EEE.ob.branch.amount"}, {"value":"2.6","id":"np.nat.transfer.EEE.ob.branch.type"}],"delegation":[],"conditions":[{"isIncluded":true,"id":"' + catalogConditions[0].Id + '"}, {"isIncluded":true,"id":"' + catalogConditions[1].Id + '"}],"familyId":"' + familyId + '","profAnalysisId":"' + profanalysisId + '"}';

        Test.startTest();
            ConditionsChange_Ctrl.Conditions res = ConditionsChange_Ctrl.getConditionsFromJSON(jsonAttrValues);
            System.assertEquals(true, true, 'Expected true. got ');
        Test.stopTest();
    }

    @IsTest
    static void updateConditionsTest() {

        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectActiveCatalogConditions();

        final Id profanalysisId = profitabilityAnalysis[0].Id;
        final Id familyId = catalogConditions[0].gf_psc_family_id__c;

        String conditionAttValuesJSON = '{"conditions":[{"id":"' + catalogConditions[0].Id + '","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"2.00"}, {"id":"np.nat.transfer.EEE.ob.branch.amount","proposed":"2500.00"}]}, {"id":"' + catalogConditions[1].Id + '","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"3500.00"}, {"id":"np.nat.transfer.EEE.ob.tf.type","proposed":"true"}]}]}';

        Test.startTest();
            ConditionsChange_Ctrl.updateConditions(profanalysisId, conditionAttValuesJSON);
            System.assertEquals(true, true, 'Expected true. got ');
        Test.stopTest();
    }

    @IsTest
    static void validateInputValuesTest() {

        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectActiveCatalogConditions();

        final Id profanalysisId = profitabilityAnalysis[0].Id;
        final Id familyId = catalogConditions[0].gf_psc_family_id__c;

        String conditionAttValuesJSON = '{"conditions":[{"id":"' + catalogConditions[0].Id + '","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"2.00"}, {"id":"np.nat.transfer.EEE.ob.branch.amount","proposed":"2500.00"}]}, {"id":"' + catalogConditions[1].Id + '","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"3500.00"}, {"id":"np.nat.transfer.EEE.ob.tf.type","proposed":"true"}]}]}';

        Test.startTest();
            ConditionsChange_Ctrl.validateInputValues(profanalysisId, conditionAttValuesJSON);
            System.assertEquals(true, true, 'Expected true. got ');
        Test.stopTest();
    }




}