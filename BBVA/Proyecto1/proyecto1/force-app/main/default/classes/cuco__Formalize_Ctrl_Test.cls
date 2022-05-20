/**
* ────────────────────────────────────────────────────────────────────
* Formalize_Ctrl_Test
* Test class for Formalize_Ctrl class
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-13
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/


@IsTest
public with sharing class Formalize_Ctrl_Test {

    /** @description screenShot */
    static final String SCREENSHOT = '<div class="slds-modal__content slds-p-around_xx-large"></div>';
    /** @description PA Formalization */
    static final String FORMALIZATION = 'PA_Formalization';

    @TestSetup
    static void setupTestData() {
        final List<Account> accountsForm = Test_Utils.createAccounts(1);
        insert accountsForm;

        /* profitability sheet */
        final List<profitability_sheet__c> profSheetsForm = Test_Utils.createProfSheet(1, accountsForm[0]);
        insert profSheetsForm;

        /* profitability analysis */
        final List<profitability_analysis__c> profAnalysisForm = Test_Utils.createProfAnalysis(4, accountsForm[0]);
        profAnalysisForm[0].gf_profitability_sheet_id__c = profSheetsForm[0].Id;
        profAnalysisForm[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysisForm[0].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysisForm[0].gf_pa_mgmt_status_type_name__c = 'Price Approved';
        profAnalysisForm[1].gf_pa_management_type_name__c = 'New';
        profAnalysisForm[1].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysisForm[1].gf_pa_mgmt_status_type_name__c = 'Price Approved';
        profAnalysisForm[1].gf_pa_cond_appl_eff_date__c = Date.today();
        profAnalysisForm[1].gf_pa_cond_appl_expiry_date__c = Date.today().addDays(20);
        profAnalysisForm[1].gf_all_ct_apply_cond_ind_type__c = true;
        profAnalysisForm[2].gf_pa_management_type_name__c = 'Cancellation';
        profAnalysisForm[2].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysisForm[2].gf_pa_mgmt_status_type_name__c = 'Price Approved';
        profAnalysisForm[2].gf_pa_cond_appl_eff_date__c = Date.today().addDays(1);
        profAnalysisForm[2].gf_pa_cond_appl_expiry_date__c = Date.today().addDays(22);
        profAnalysisForm[2].gf_all_ct_apply_cond_ind_type__c = true;
        profAnalysisForm[2].gf_price_aprvl_process_req_id__c = '001';
        profAnalysisForm[3].gf_pa_management_type_name__c = 'Novation';
        profAnalysisForm[3].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysisForm[3].gf_pa_mgmt_status_type_name__c = 'Price Approved';
        profAnalysisForm[3].gf_price_aprvl_process_req_id__c = '002';
        insert profAnalysisForm;
    }

    @IsTest
    static void constructorFormTest() {
        Test.startTest();
        final Formalize_Ctrl resForm = new Formalize_Ctrl();
        System.assertEquals(resForm, resForm, 'private constructor of Formalize_Ctrl');
        Test.stopTest();
    }

    @IsTest
    static void formErrorTest() {
        Test.startTest();
        try {
            System.assertEquals(null, Formalize_Ctrl.formalize(null),'Err in formErrorTest');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Formalize_Ctrl, error not captured 1');
        }
        Test.stopTest();
    }

    @IsTest
    static void callServiceErrorTest() {
        Test.startTest();
        try {
            System.assertEquals(null, Formalize_Ctrl.callService(null,null,null,'',''),'Err in callServiceErrorTest');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Formalize_Ctrl, error not captured 2');
        }
        Test.stopTest();
    }

    @IsTest
    static void formalizeTest() {
        final Set<String> setNamePA1 = new Set<String>{'Prof Analysis Test 0'};
        final ProfitabilityAnalysis_Selector paSelector1 = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profAnalysis1 = paSelector1.selectByName(setNamePA1);
        Test.startTest();
        try {
            final Map<String, Object> mapResult1 = Formalize_Ctrl.formalize(profAnalysis1[0].Id);
            System.assertNotEquals(mapResult1, null, 'Err in formalizeTest');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertNotEquals(null, e.getMessage(), 'Formalize_Ctrl.formalize, error not captured');
        }
        Test.stopTest();
    }

    @IsTest
    static void callServiceTest1() {
        final Set<String> setNamePA2 = new Set<String>{'Prof Analysis Test 1'};
        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalysis2 = paSelector2.selectByName(setNamePA2);
        Test.startTest();
        try {
            final Map<String, Object> mapResult2 =  Formalize_Ctrl.callService(profAnalysis2[0].Id, profAnalysis2[0].gf_pa_cond_appl_eff_date__c, profAnalysis2[0].gf_pa_cond_appl_expiry_date__c,'', SCREENSHOT);
            System.assertNotEquals(mapResult2, null, 'Err in callServiceTest1');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertNotEquals(null, e.getMessage(), 'Formalize_Ctrl.callService, error not captured');
        }
        Test.stopTest();
    }

    @IsTest
    static void callServiceTest2() {
        final Set<String> setNamePA3 = new Set<String>{'Prof Analysis Test 2'};
        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalysis3 = paSelector3.selectByName(setNamePA3);
        Test.startTest();
        try {
            final Map<String, Object> mapResult3 =  Formalize_Ctrl.callService(profAnalysis3[0].Id, profAnalysis3[0].gf_pa_cond_appl_eff_date__c, profAnalysis3[0].gf_pa_cond_appl_expiry_date__c,'', SCREENSHOT);
            System.assertNotEquals(mapResult3, null, 'Err in callServiceTest2');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertNotEquals(null, e.getMessage(), 'Formalize_Ctrl.callService, error not captured');
        }
        Test.stopTest();
    }

    @IsTest
    static void callServiceTest3() {
        final Set<String> setNamePA4 = new Set<String>{'Prof Analysis Test 0'};
        final ProfitabilityAnalysis_Selector paSelector4 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalysis4 = paSelector4.selectByName(setNamePA4);
        Test.startTest();
        try {
            final Map<String, Object> mapResult4 =  Formalize_Ctrl.callService(profAnalysis4[0].Id, profAnalysis4[0].gf_pa_cond_appl_eff_date__c, profAnalysis4[0].gf_pa_cond_appl_expiry_date__c,'comment', SCREENSHOT);
            System.assertNotEquals(mapResult4, null, 'Err in callServiceTest3');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertNotEquals(null, e.getMessage(), 'Formalize_Ctrl.callService, error not captured');
        }
        Test.stopTest();
    }

    @IsTest
    static void callServiceTest4() {
        final Set<String> paName = new Set<String>{'Prof Analysis Test 3'};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paName);
        Test.startTest();
        try {
            final Map<String, Object> mapResult =  Formalize_Ctrl.callService(profAnalysis[0].Id, profAnalysis[0].gf_pa_cond_appl_eff_date__c, profAnalysis[0].gf_pa_cond_appl_expiry_date__c,'', SCREENSHOT);
            System.assertNotEquals(mapResult, null, 'Err in callServiceTest4');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertNotEquals(null, e.getMessage(), 'Formalize_Ctrl.callService, error not captured');
        }
        Test.stopTest();
    }

    // Private Formalize_Service constructor test
    @IsTest
    static void formalizeServiceConstructorTest1() {
        Test.startTest();
            final Formalize_Service constructorTest = new Formalize_Service();
            System.assertEquals(constructorTest, constructorTest, 'Err at Formalize_Ctrl_Test - formalizeServiceConstructorTest1');
        Test.stopTest();
    }
}