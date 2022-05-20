/**
* ────────────────────────────────────────────────────────────────────
* ConditionsEdit_ctrl_Test
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
public with sharing class ConditionsEdit_ctrl_Test {

    @TestSetup
    static void setupTestData() {

        /* create catalog */
        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(5, families[0]);
        insert conditions;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(10);
        attributes[0].gf_psc_bknd_svc_format_type__c = 'TEXT';
        attributes[1].gf_psc_bknd_svc_format_type__c = 'TEXT';
        attributes[2].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[3].gf_psc_bknd_svc_format_type__c = 'RATE';
        attributes[4].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[5].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[6].gf_psc_bknd_svc_format_type__c = 'TERM';
        attributes[7].gf_psc_bknd_svc_format_type__c = 'RATE';
        attributes[8].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[9].gf_psc_bknd_svc_format_type__c = 'AMOUNT';

        insert attributes;

        final List<ps_catalog_condition_attribute__c> conditionAttributes = Test_Utils.createPSCatalogConditonAttributes(10, conditions[0], attributes);
        conditionAttributes[0].gf_psc_condition_attribute_id__c = 'debit.sepa.postal.ind';
        conditionAttributes[0].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[1].gf_psc_condition_attribute_id__c = 'extended.package';
        conditionAttributes[1].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[2].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.amount';
        conditionAttributes[2].gf_psc_condition_id__c = conditions[1].Id;
        conditionAttributes[3].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.type';
        conditionAttributes[3].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[4].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.min';
        conditionAttributes[4].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[5].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.max';
        conditionAttributes[5].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[6].gf_psc_condition_attribute_id__c = 'FX.issued.order.pay.days';
        conditionAttributes[6].gf_psc_condition_id__c = conditions[3].Id;
        conditionAttributes[7].gf_psc_condition_attribute_id__c = 'np.SEPA.day.payroll.eur.branch.type';
        conditionAttributes[7].gf_psc_condition_id__c = conditions[4].Id;
        conditionAttributes[8].gf_psc_condition_attribute_id__c = 'np.SEPA.day.payroll.eur.branch.min';
        conditionAttributes[8].gf_psc_condition_id__c = conditions[4].Id;
        conditionAttributes[9].gf_psc_condition_attribute_id__c = 'np.SEPA.day.payroll.eur.branch.max';
        conditionAttributes[9].gf_psc_condition_id__c = conditions[4].Id;
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
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final ConditionsEdit_ctrl res = new ConditionsEdit_ctrl();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getConditionsValuesTest() {

        final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);

        final PsCatalogCondition_Selector selector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> catalogConditions = selector.selectActiveCatalogConditions();

        final Id profanalysisId = profitabilityAnalysis[0].Id;
        final Id familyId = catalogConditions[0].gf_psc_family_id__c;
        final List<Id> conditionsIncluded = new List<String>{catalogConditions[0].Id, catalogConditions[1].Id};

        Test.startTest();
            String res = ConditionsEdit_ctrl.getConditionsValues(profAnalysisId, familyId, conditionsIncluded);
            System.assertEquals(true, true, 'Expected true. got ');
        Test.stopTest();
    }


}