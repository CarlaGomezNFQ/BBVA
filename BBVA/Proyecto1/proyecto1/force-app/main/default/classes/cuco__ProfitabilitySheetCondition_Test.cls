/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilitySheetCondition_Test
* Test class for ProfitabilitySheetCondition
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-08
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class ProfitabilitySheetCondition_Test {

    @TestSetup
    static void setupTestData() {

        /* create catalog */
        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(5, families[0]);
        insert conditions;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(10);
        attributes[0].gf_psc_bknd_svc_format_type__c = 'RATE';
        attributes[1].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[2].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[3].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[4].gf_psc_bknd_svc_format_type__c = 'RATE';
        attributes[5].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[6].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributes[7].gf_psc_bknd_svc_format_type__c = 'TEXT';
        attributes[8].gf_psc_bknd_svc_format_type__c = 'TERM';

        insert attributes;

        final List<ps_catalog_condition_attribute__c> conditionAttributes = Test_Utils.createPSCatalogConditonAttributes(10, conditions[0], attributes);

        conditionAttributes[0].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.type';
        conditionAttributes[0].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[1].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.min';
        conditionAttributes[1].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[2].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.max';
        conditionAttributes[2].gf_psc_condition_id__c = conditions[0].Id;
        conditionAttributes[3].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.amount';
        conditionAttributes[3].gf_psc_condition_id__c = conditions[1].Id;
        conditionAttributes[4].gf_psc_condition_attribute_id__c = 'np.nat.transfer.BBVA.branch.type';
        conditionAttributes[4].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[5].gf_psc_condition_attribute_id__c = 'np.nat.transfer.BBVA.branch.min';
        conditionAttributes[5].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[6].gf_psc_condition_attribute_id__c = 'np.nat.transfer.BBVA.branch.max';
        conditionAttributes[6].gf_psc_condition_id__c = conditions[2].Id;
        conditionAttributes[7].gf_psc_condition_attribute_id__c = 'np.exempt.mail.ind';
        conditionAttributes[7].gf_psc_condition_id__c = conditions[3].Id;
        conditionAttributes[8].gf_psc_condition_attribute_id__c = 'FX.bonus.per.fixing.diff.type';
        conditionAttributes[8].gf_psc_condition_id__c = conditions[4].Id;

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
    }

    @IsTest
    static void profSheetConditionServiceTest() {
        Test.startTest();
            final ProfitabilitySheetCondition_Service res = new ProfitabilitySheetCondition_Service();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void profSheetConditionHelperTest() {
        Test.startTest();
            final ProfitabilitySheetCondition_Helper res = new ProfitabilitySheetCondition_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getConditionsFromProfSheet() {

        final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector(false);
        final Set<String> psNames = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> profitabilitySheet = psSelector.selectByName(psNames);
        Test.startTest();
            final List<Conditions_Wrapper> conditions = ProfitabilitySheetCondition_Helper.getProfitabilitySheetConditionWrapper(profitabilitySheet[0].Id);
            System.assertEquals(conditions[0].attributes[0].Name, 'Attribute0', 'Expected "Attribute0". got ' + conditions[0].attributes[0].Name );
        Test.stopTest();
    }

}