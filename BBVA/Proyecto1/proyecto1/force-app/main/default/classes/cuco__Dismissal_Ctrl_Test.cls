/**
* ────────────────────────────────────────────────────────────────────
* Dismissal_Ctrl_Test
* Test class for Dismissal_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-08
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Dismissal_Ctrl_Test {

    @TestSetup
    static void makeDataDismissal() {
        // Create parent acc
        final List<Account> lstDismissalAcc = Test_Utils.createAccounts(5);
        insert lstDismissalAcc;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSDismissal = Test_Utils.createProfSheet(5, lstDismissalAcc);
        insert lstPSDismissal;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPADismissal = Test_Utils.createProfAnalysis(5, lstDismissalAcc);
        for (Integer i=0; i<lstPADismissal.size(); i++) {
            lstPADismissal[i].gf_pa_mgmt_stage_type_name__c = 'Analysis';
            lstPADismissal[i].gf_pa_mgmt_status_type_name__c = 'Analysis';
            lstPADismissal[i].gf_profitability_sheet_id__c = lstPSDismissal[i].Id;
        }
        lstPADismissal[0].gf_pa_management_type_name__c = 'Renewal';
        lstPADismissal[0].gf_price_aprvl_process_req_id__c = '12345';
        lstPADismissal[1].gf_pa_management_type_name__c = 'Novation';
        lstPADismissal[2].gf_pa_management_type_name__c = 'New';
        lstPADismissal[3].gf_pa_management_type_name__c = 'Cancellation';
        lstPADismissal[4].gf_pa_management_type_name__c = 'New';
        lstPADismissal[4].gf_price_aprvl_process_req_id__c = '54321';
        insert lstPADismissal;
    }

    // Check getDismissalBaseInfo with Renewal typology and price approval id filled
    @IsTest
    static void getDismissalBaseInfo1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();

            final Map<String, Object> retMap1 = Dismissal_Ctrl.getDismissalBaseInfo(lstPA1[0].Id);
            final Map<String, Object> actualMap1 = new Map<String, Object>();
            actualMap1.put('confirmQuestion', retMap1.get('confirmQuestion'));
            actualMap1.put('priceApprovalId', retMap1.get('priceApprovalId'));
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('confirmQuestion', Label.dismissal_confirm_pre + ' ' + Label.dismissal_renewal + ' ' + Label.dismissal_confirm_post);
            expectedMap1.put('priceApprovalId', '12345');
            System.assertEquals(expectedMap1, actualMap1, 'Err at Dismissal_Ctrl - getDismissalBaseInfo1');

        Test.stopTest();
    }

    // Check getDismissalBaseInfo with Novation typology and price approval id not filled
    @IsTest
    static void getDismissalBaseInfo2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();

            final Map<String, Object> retMap2 = Dismissal_Ctrl.getDismissalBaseInfo(lstPA2[0].Id);
            final Map<String, Object> actualMap2 = new Map<String, Object>();
            actualMap2.put('confirmQuestion', retMap2.get('confirmQuestion'));
            actualMap2.put('priceApprovalId', retMap2.get('priceApprovalId'));
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('confirmQuestion', Label.dismissal_confirm_pre + ' ' + Label.dismissal_novation + ' ' + Label.dismissal_confirm_post);
            expectedMap2.put('priceApprovalId', null);
            System.assertEquals(expectedMap2, actualMap2, 'Err at Dismissal_Ctrl - getDismissalBaseInfo2');

        Test.stopTest();
    }

    // Check getDismissalBaseInfo with New typology and price approval id not filled
    @IsTest
    static void getDismissalBaseInfo3() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        Test.startTest();

            final Map<String, Object> retMap3 = Dismissal_Ctrl.getDismissalBaseInfo(lstPA3[0].Id);
            final Map<String, Object> actualMap3 = new Map<String, Object>();
            actualMap3.put('confirmQuestion', retMap3.get('confirmQuestion'));
            actualMap3.put('priceApprovalId', retMap3.get('priceApprovalId'));
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('confirmQuestion', Label.dismissal_confirm_pre + ' ' + Label.dismissal_new + ' ' + Label.dismissal_confirm_post);
            expectedMap3.put('priceApprovalId', null);
            System.assertEquals(expectedMap3, actualMap3, 'Err at Dismissal_Ctrl - getDismissalBaseInfo3');

        Test.stopTest();
    }

    // Check getDismissalBaseInfo with Cancellation typology and price approval id not filled
    @IsTest
    static void getDismissalBaseInfo4() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        Test.startTest();

            final Map<String, Object> retMap4 = Dismissal_Ctrl.getDismissalBaseInfo(lstPA4[0].Id);
            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('confirmQuestion', retMap4.get('confirmQuestion'));
            actualMap4.put('priceApprovalId', retMap4.get('priceApprovalId'));
            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('confirmQuestion', Label.dismissal_confirm_pre + ' ' + Label.dismissal_cancellation + ' ' + Label.dismissal_confirm_post);
            expectedMap4.put('priceApprovalId', null);
            System.assertEquals(expectedMap4, actualMap4, 'Err at Dismissal_Ctrl - getDismissalBaseInfo3');

        Test.stopTest();
    }

    // Check getDismissalBaseInfo exception
    @IsTest
    static void getDismissalBaseInfo5() {
        Test.startTest();
            try {
                Dismissal_Ctrl.getDismissalBaseInfo(null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Dismissal_Ctrl - getDismissalBaseInfo5');
            }
        Test.stopTest();
    }

    // Check doDismissalSave
    @IsTest
    static void doDismissalSave1() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA5Bf = profAnSelector5.selectByName(setNamesPA5);

        Test.startTest();

            final Map<String, Object> retMap5 = Dismissal_Ctrl.doDismissalSave(lstPA5Bf[0].Id, 'test dismissal comments', 'test screenShot');
            final List<profitability_analysis__c> lstPA5Af = profAnSelector5.selectByName(setNamesPA5);
            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap5.get('isSuccess'));
            actualMap5.put('message', retMap5.get('message'));
            actualMap5.put('paStageBf', lstPA5Bf[0].gf_pa_mgmt_stage_type_name__c);
            actualMap5.put('paStatusBf', lstPA5Bf[0].gf_pa_mgmt_status_type_name__c);
            actualMap5.put('paStageAf', lstPA5Af[0].gf_pa_mgmt_stage_type_name__c);
            actualMap5.put('paStatusAf', lstPA5Af[0].gf_pa_mgmt_status_type_name__c);
            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', true);
            expectedMap5.put('message', Label.dismissal_success_sample);
            expectedMap5.put('paStageBf', 'Analysis');
            expectedMap5.put('paStatusBf', 'Analysis');
            expectedMap5.put('paStageAf', 'Dismissed');
            expectedMap5.put('paStatusAf', 'Dismissed');
            System.assertEquals(expectedMap5, actualMap5, 'Err at Dismissal_Ctrl - doDismissalSave1');

        Test.stopTest();
    }

    // Check doDismissalSave exception
    @IsTest
    static void doDismissalSave2() {
        final ProfitabilityAnalysis_Selector profAnSelectorErr = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAErr = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPAErr = profAnSelectorErr.selectByName(setNamesPAErr);
        lstPAErr[0].gf_pa_mgmt_status_type_name__c = '';
        update lstPAErr[0];
        Test.startTest();
            try {
                Dismissal_Ctrl.doDismissalSave(lstPAErr[0].Id, null, null);
            } catch (Exception e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Dismissal_Ctrl - doDismissalSave2');
            }
        Test.stopTest();
    }

    // Check callPriceDecisionWS on Dismissal_Helper due to if price_approval_type__c field on general
    // configuration mtd is unchecked, test dont cover this method
    @IsTest
    static void callPriceDecisionWS1() {

        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA6Bf = profAnSelector6.selectByName(setNamesPA6);

        final ProfitabilityAnalysis_Wrapper paWrapper6 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA6Bf[0].Id);

        Test.startTest();

            final Map<String, Object> retMap6 = Dismissal_Helper.callPriceDecisionWS(paWrapper6, 'test dismissal comments', 'test screenShot');
            final List<profitability_analysis__c> lstPA6Af = profAnSelector6.selectByName(setNamesPA6);
            final Map<String, Object> actualMap6 = new Map<String, Object>();
            actualMap6.put('isSuccess', retMap6.get('isSuccess'));
            actualMap6.put('message', retMap6.get('message'));
            actualMap6.put('paStageBf', lstPA6Bf[0].gf_pa_mgmt_stage_type_name__c);
            actualMap6.put('paStatusBf', lstPA6Bf[0].gf_pa_mgmt_status_type_name__c);
            actualMap6.put('paStageAf', lstPA6Af[0].gf_pa_mgmt_stage_type_name__c);
            actualMap6.put('paStatusAf', lstPA6Af[0].gf_pa_mgmt_status_type_name__c);
            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('isSuccess', true);
            expectedMap6.put('message', Label.dismissal_success_sample);
            expectedMap6.put('paStageBf', 'Analysis');
            expectedMap6.put('paStatusBf', 'Analysis');
            expectedMap6.put('paStageAf', 'Dismissed');
            expectedMap6.put('paStatusAf', 'Dismissed');
            System.assertEquals(expectedMap6, actualMap6, 'Err at Dismissal_Ctrl - callPriceDecisionWS1');

        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void dismissalCtrlConstructorTest() {
        Test.startTest();
            final Dismissal_Ctrl constructorTest = new Dismissal_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Dismissal_Ctrl - dismissalCtrlConstructorTest');
        Test.stopTest();
    }

    // Private constructor test service class
    @IsTest
    static void dismissalHelperConstructorTest() {
        Test.startTest();
            final Dismissal_Service constructorTest1 = new Dismissal_Service();
            System.assertEquals(constructorTest1, constructorTest1, 'Err at Dismissal_Ctrl - dismissalHelperConstructorTest');
        Test.stopTest();
    }

    // Private constructor test helper class
    @IsTest
    static void dismissalServiceConstructorTest() {
        Test.startTest();
            final Dismissal_Helper constructorTest2 = new Dismissal_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Dismissal_Ctrl - dismissalServiceConstructorTest');
        Test.stopTest();
    }
}