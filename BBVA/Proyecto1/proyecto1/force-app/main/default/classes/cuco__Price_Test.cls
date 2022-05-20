/**
* ────────────────────────────────────────────────────────────────────
* Price test
* Test class for Price_Service and Price_Helper
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-13
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class Price_Test {

    @TestSetup
    static void setupTestData() {

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
    }

    @IsTest
    static void priceService() {
        Test.startTest();
            final Price_Service res = new Price_Service();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void priceHelper() {
        Test.startTest();
            final Price_Helper res = new Price_Helper();
            System.assertEquals(res, res, 'private constructor');
        Test.stopTest();
    }

    @IsTest
    static void delegatedValuesTest() {
        Test.startTest();
            final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
            final Set<String> paNames = new Set<String>{'Prof Analysis Test 0'};
            final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);
            final String res = Price_Service.getDelegatedValues(profitabilityAnalysis[0].Id);
            System.assertEquals(res.subString(0,1), '[', 'returned invalid JSON');
        Test.stopTest();
    }

}