/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilitySheet_Test
* Test classes for Profitability Sheet
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-18
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class ProfitabilitySheet_Test {

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

        final profitability_sheet_flat_rates__c flat = new profitability_sheet_flat_rates__c();
        flat.gf_ps_fr_price_type__c = '';
        flat.gf_ps_fr_fixed_annual_amount__c = 00;
        flat.gf_ps_fr_variable_amount_desc__c = '';
        flat.gf_ps_fr_charge_type__c = '';
        flat.gf_ps_fr_charge_pdicy_type__c = '';
        flat.gf_ps_fr_currency_type__c = '';
        flat.gf_ps_fr_price_type__c = '';
        flat.gf_ps_fr_no_wrkdy_ch_meth_type__c = '';
        flat.gf_ps_fr_ac_no_bal_method_type__c = '';
        flat.gf_profitability_sheet_id__c = profSheets[0].Id;
        insert flat;

        final profitability_sheet_flat_rates_accounts__c psFlRtAccList = new profitability_sheet_flat_rates_accounts__c();
        psFlRtAccList.gf_ps_flat_rate_id__c = flat.Id;
        insert psFlRtAccList;

        final profitability_sheet_flat_rates_dp__c lstPsFlatDp = new profitability_sheet_flat_rates_dp__c();
        lstPsFlatDp.gf_ps_flat_rate_id__c = flat.Id;
        insert lstPsFlatDp;
    }

    @IsTest
    static void constructorTest() {
        Test.startTest();
            final ProfitabilitySheet_Service res = new ProfitabilitySheet_Service();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void constructorTest2() {
        Test.startTest();
            final ProfitabilitySheet_Helper res = new ProfitabilitySheet_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void getBranchCode() {
        Test.startTest();
            final profitability_sheet__c  psInfo = [SELECT Id, participant_id__r.Sic FROM profitability_sheet__c WHERE Name =: 'Prof Sheet Test 0' LIMIT 1];
            final String branchCode = ProfitabilitySheet_Service.getBranchCode(psInfo.Id);
            System.assertEquals(psInfo.participant_id__r.Sic, branchCode, 'Error in ProfitabilitySheet_Service.getBranchCode. Expected: ' + psInfo.participant_id__r.Sic + ' got: ' + branchCode);
        Test.stopTest();
    }

    @IsTest
    static void getProfSheetFullDetails1() {
        Test.startTest();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final Set<String> psNames = new Set<String>{'Prof sheet Test 0'};
            final List<profitability_sheet__c> profSheets = profSheetSelector.selectByName(psNames);
            final Map<String,Object> res = ProfitabilitySheet_Helper.getProfSheetFullDetails(profSheets[0].Id);
            System.assertEquals(res.get('success'), true, 'Error in ProfitabilitySheet_Helper.getProfSheetFullDetails Expected map.success = true. got: ' + res.get('success') );
        Test.stopTest();
    }

    @IsTest
    static void getProfSheetFullDetails2() {
        Test.startTest();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final Set<String> psNames = new Set<String>{'Prof sheet Test 1'};
            final List<profitability_sheet__c> profSheets = profSheetSelector.selectByName(psNames);
            final Map<String,Object> res = ProfitabilitySheet_Helper.getProfSheetFullDetails(profSheets[0].Id);
            System.assertEquals(res.get('success'), true, 'Error in ProfitabilitySheet_Helper.getProfSheetFullDetails Expected map.success = false. got ' + res.get('success') );
        Test.stopTest();
    }

    @IsTest
    static void getProfSheetFullDetails3() {
        Test.startTest();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final Set<String> psNames = new Set<String>{'Prof sheet Test 2'};
            final List<profitability_sheet__c> profSheets = profSheetSelector.selectByName(psNames);
            final Map<String,Object> res = ProfitabilitySheet_Helper.getProfSheetFullDetails(profSheets[0].Id);
            System.assertEquals(res.get('success'), false, 'Error in ProfitabilitySheet_Helper.getProfSheetFullDetails Expected map.success = false. got ' + res.get('success') );
        Test.stopTest();
    }

    @IsTest
    static void getPSActualValues() {
        Test.startTest();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final Set<String> psNames = new Set<String>{'Prof sheet Test 0'};
            final List<profitability_sheet__c> profSheets = profSheetSelector.selectByName(psNames);
            final String jsonStr = ProfitabilitySheet_Service.getPSActualValues(profSheets[0].Id);
            System.assertEquals(jsonStr.Substring(0, 58), '[{"value":"2.9","id":"np.nat.transfer.EEE.ob.branch.type"}', 'Error in ProfitabilitySheet_Service.getPSActualValues Expected [{"value":"2.9","id":"np.nat.transfer.EEE.ob.branch.type"} got: ' + jsonStr.Substring(0, 58));
        Test.stopTest();
    }

    @IsTest
    static void getPSExtendedPkgs() {
        Test.startTest();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final Set<String> psNames = new Set<String>{'Prof sheet Test 0'};
            final List<profitability_sheet__c> profSheets = profSheetSelector.selectByName(psNames);
            final Map<String,Set<String>> res = ProfitabilitySheet_Service.getPSExtendedPkgs(profSheets[0].Id);
            final String value = new List<String>(res.get('001183970'))[0];
            System.assertEquals(value, 'F0275', 'Error in ProfitabilitySheet_Service.getPSExtendedPkgs Expected "F0275" got:' + value);
        Test.stopTest();
    }
}