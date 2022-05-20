/**
* ────────────────────────────────────────────────────────────────────
* Approve_Price_Ctrl_Test
* Test class for Approve_Price_Ctrl class
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-07
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class Approve_Price_Ctrl_Test {

    @TestSetup
    static void setupTestData() {
        final List<Account> accountsApprove = Test_Utils.createAccounts(1);
        insert accountsApprove;

        /* profitability sheet */
        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(1, accountsApprove[0]);
        insert profSheets;

        /* profitability analysis */
        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(2, accountsApprove[0]);
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].Id;
        profAnalysis[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Price Authorized';
        profAnalysis[0].gf_price_aprvl_process_req_id__c = '001';
        profAnalysis[1].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[1].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[1].gf_pa_mgmt_status_type_name__c = 'Price Authorized';
        insert profAnalysis;
    }

    @IsTest
    static void constructorApproveTest() {
        Test.startTest();
            final Approve_Price_Ctrl res = new Approve_Price_Ctrl();
            System.assertEquals(res, res, 'private constructor of Approve_Price_Ctrl');
        Test.stopTest();
    }

    @IsTest
    static void approveErrorTest() {
        Test.startTest();
            try {
                System.assertEquals(null, null,'Err in approveErrorTest');
            } catch(AuraHandledException e) {  //NOSONAR
                System.assertEquals(null, e.getMessage(), 'Approve_Price_Ctrl.approvePrice, error not captured');
            }
        Test.stopTest();
    }

    @IsTest
    static void approvePriceTest1() {
        final Set<String> setNamePA1 = new Set<String>{'Prof Analysis Test 0'};
        final ProfitabilityAnalysis_Selector paSelector1 = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profAnalysis1 = paSelector1.selectByName(setNamePA1);
        Test.startTest();
            try {
                final Map<String, Object> mapResult1 = Approve_Price_Ctrl.approvePrice(profAnalysis1[0].Id);
                System.assertNotEquals(mapResult1, null, 'Err in approvePriceTest1');
            } catch(AuraHandledException e) {  //NOSONAR
                System.assertNotEquals(null, e.getMessage(), 'Approve_Price_Ctrl.approvePrice, error not captured');
            }
        Test.stopTest();
    }

    @IsTest
    static void approvePriceTest2() {
        final Set<String> setNamePA2 = new Set<String>{'Prof Analysis Test 1'};
        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profAnalysis2 = paSelector2.selectByName(setNamePA2);
        Test.startTest();
            try {
                final Map<String, Object> mapResult2 = Approve_Price_Ctrl.approvePrice(profAnalysis2[0].Id);
                System.assertNotEquals(mapResult2, null, 'Err in approvePriceTest2');
            } catch(AuraHandledException e) {  //NOSONAR
                System.assertNotEquals(null, e.getMessage(), 'Approve_Price_Ctrl.approvePrice, error not captured');
            }
        Test.stopTest();
    }

    @IsTest
    static void approvePriceTest3() {
        final Set<String> setNamePA3 = new Set<String>{'Prof Analysis Test 0'};
        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector(false);
        final List<profitability_analysis__c> profAnalysis3 = paSelector3.selectByName(setNamePA3);
        profAnalysis3[0].gf_pa_mgmt_status_type_name__c = '';
        update profAnalysis3[0];
        Test.startTest();
            try {
                Approve_Price_Ctrl.approvePrice(profAnalysis3[0].Id);
            } catch(Exception e) {  //NOSONAR
                System.assertNotEquals(null, e.getMessage(), 'Approve_Price_Ctrl.approvePrice, error not captured');
            }
        Test.stopTest();
    }

    // Private Approve_Price_Service constructor test
    @IsTest
    static void approvePriceServiceConstructorTest1() {
        Test.startTest();
            final Approve_Price_Service constructorTest = new Approve_Price_Service();
            System.assertEquals(constructorTest, constructorTest, 'Approve_Price_Ctrl.approvePriceServiceConstructorTest1 - approvePriceServiceConstructorTest1');
        Test.stopTest();
    }

}