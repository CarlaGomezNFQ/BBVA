/**
* ────────────────────────────────────────────────────────────────────
* BackendIntegration_Test
* Test classes for Backend Integration Helper
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-06
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class BackendIntegration_Test {

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
        insert accounts;

        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(1, accounts[0]);
        insert profSheets;

        final List<profitability_sheet_participant__c> participants = Test_Utils.createProfSheetParticipant(1, profSheets[0].Id, new List<Id>{accounts[0].Id});
        insert participants;
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final BackendIntegration_Helper res = new BackendIntegration_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void generateRequest1() {
        Test.startTest();
            final GetProposalConditionsNotebook_Helper instance = new GetProposalConditionsNotebook_Helper('12345');
            final String res = instance.generateRequest();
            System.assertEquals(res, res, 'Generate request');
        Test.stopTest();
    }

    @IsTest
    static void generateRequest2() {
        Test.startTest();
            final ListProposalNotebookConditions_Helper instance = new ListProposalNotebookConditions_Helper('12345', Date.today());
            final String res = instance.generateRequest();
            System.assertEquals(res, res, 'Generate request');
        Test.stopTest();
    }

    @IsTest
    static void getProfSheetFullDetails1() {
        Test.startTest();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final Set<String> psNames = new Set<String>{'Prof sheet Test 0'};
            final List<profitability_sheet__c> profSheets = profSheetSelector.selectByName(psNames);
            final Map<String,Object> res = ProfitabilitySheet_Service.getProfSheetFullDetails(profSheets[0].Id);
            System.assertEquals(res.get('success'), true, 'Error in ProfitabilitySheet_Service.getProfSheetFullDetails Expected map.success = true. got: ' + res.get('success') );
        Test.stopTest();
    }

}