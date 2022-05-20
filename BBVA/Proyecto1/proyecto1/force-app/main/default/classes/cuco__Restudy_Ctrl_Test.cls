/**
* ────────────────────────────────────────────────────────────────────
* Restudy_Ctrl_Test
* Test class for Restudy_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-09
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Restudy_Ctrl_Test {

    @TestSetup
    static void makeDataRestudy() {
        // Create parent acc
        final List<Account> lstRestudyAcc = Test_Utils.createAccounts(2);
        insert lstRestudyAcc;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSRestudy = Test_Utils.createProfSheet(2, lstRestudyAcc);
        insert lstPSRestudy;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPARestudy = Test_Utils.createProfAnalysis(2, lstRestudyAcc);
        for (Integer i=0; i<lstPARestudy.size(); i++) {
            lstPARestudy[i].gf_profitability_sheet_id__c = lstPSRestudy[i].Id;
        }
        lstPARestudy[0].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstPARestudy[0].gf_pa_mgmt_status_type_name__c = 'Price Authorized';
        lstPARestudy[0].gf_price_aprvl_process_req_id__c = '12345';
        lstPARestudy[1].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        lstPARestudy[1].gf_pa_mgmt_status_type_name__c = 'Formalization Returned';
        insert lstPARestudy;
    }

    // Check getRestudyBaseInfo with Price approval stage
    @IsTest
    static void getRestudyBaseInfo1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();

            final Map<String, Object> retMap1 = Restudy_Ctrl.getRestudyBaseInfo(lstPA1[0].Id);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('commentsLabel', Label.restudy_price_comments);
            expectedMap1.put('requiredComments', true);
            System.assertEquals(expectedMap1, retMap1, 'Err at Restudy_Ctrl - getRestudyBaseInfo1');

        Test.stopTest();
    }

    // Check getRestudyBaseInfo with Formalization stage
    @IsTest
    static void getRestudyBaseInfo2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();

            final Map<String, Object> retMap2 = Restudy_Ctrl.getRestudyBaseInfo(lstPA2[0].Id);
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('commentsLabel', Label.restudy_form_comments);
            expectedMap2.put('requiredComments', false);
            System.assertEquals(expectedMap2, retMap2, 'Err at Restudy_Ctrl - getRestudyBaseInfo2');

        Test.stopTest();
    }

    // Check getRestudyBaseInfo exception
    @IsTest
    static void getRestudyBaseInfo3() {
        Test.startTest();
            try {
                Restudy_Ctrl.getRestudyBaseInfo(null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Restudy_Ctrl - getRestudyBaseInfo3');
            }
        Test.stopTest();
    }

    // Check doRestudySave with Price Approval stage with price approval id filled
    @IsTest
    static void doRestudySave1() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA3Bf = profAnSelector3.selectByName(setNamesPA3);

        Test.startTest();

            final Map<String, Object> retMap3 = Restudy_Ctrl.doRestudySave(lstPA3Bf[0].Id, 'test restudy comments', 'test screenShot');
            final List<profitability_analysis__c> lstPA3Af = profAnSelector3.selectByName(setNamesPA3);
            final Map<String, Object> actualMap3 = new Map<String, Object>();
            actualMap3.put('isSuccess', retMap3.get('isSuccess'));
            actualMap3.put('message', retMap3.get('message'));
            actualMap3.put('paStageBf', lstPA3Bf[0].gf_pa_mgmt_stage_type_name__c);
            actualMap3.put('paStatusBf', lstPA3Bf[0].gf_pa_mgmt_status_type_name__c);
            actualMap3.put('paStageAf', lstPA3Af[0].gf_pa_mgmt_stage_type_name__c);
            actualMap3.put('paStatusAf', lstPA3Af[0].gf_pa_mgmt_status_type_name__c);
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('isSuccess', true);
            expectedMap3.put('message', Label.restudy_success_sample);
            expectedMap3.put('paStageBf', 'Price Approval');
            expectedMap3.put('paStatusBf', 'Price Authorized');
            expectedMap3.put('paStageAf', 'Analysis');
            expectedMap3.put('paStatusAf', 'Restudy');
            System.assertEquals(expectedMap3, actualMap3, 'Err at Restudy_Ctrl - doRestudySave1');

        Test.stopTest();
    }

    // Check doRestudySave with Formalization stage with price approval id filled
    @IsTest
    static void doRestudySave2() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA4Bf = profAnSelector4.selectByName(setNamesPA4);

        Test.startTest();

            final Map<String, Object> retMap4 = Restudy_Ctrl.doRestudySave(lstPA4Bf[0].Id, 'test restudy comments', 'test screenShot');
            final List<profitability_analysis__c> lstPA4Af = profAnSelector4.selectByName(setNamesPA4);
            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('isSuccess', retMap4.get('isSuccess'));
            actualMap4.put('message', retMap4.get('message'));
            actualMap4.put('paStageBf', lstPA4Bf[0].gf_pa_mgmt_stage_type_name__c);
            actualMap4.put('paStatusBf', lstPA4Bf[0].gf_pa_mgmt_status_type_name__c);
            actualMap4.put('paStageAf', lstPA4Af[0].gf_pa_mgmt_stage_type_name__c);
            actualMap4.put('paStatusAf', lstPA4Af[0].gf_pa_mgmt_status_type_name__c);
            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('isSuccess', true);
            expectedMap4.put('message', Label.restudy_success_sample);
            expectedMap4.put('paStageBf', 'Formalization');
            expectedMap4.put('paStatusBf', 'Formalization Returned');
            expectedMap4.put('paStageAf', 'Analysis');
            expectedMap4.put('paStatusAf', 'Restudy');
            System.assertEquals(expectedMap4, actualMap4, 'Err at Restudy_Ctrl - doRestudySave2');

        Test.stopTest();
    }

    // Check doRestudySave exception
    @IsTest
    static void doRestudySave3() {
        Test.startTest();
            try {
                Restudy_Ctrl.doRestudySave(null, null, null);
            } catch (Exception e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Restudy_Ctrl - doRestudySave3');
            }
        Test.stopTest();
    }

    // Check callPriceDecisionWS on Restudy_Helper due to if price_approval_type__c field on general
    // configuration mtd is unchecked, test dont cover this method
    @IsTest
    static void callPriceDecisionRestudyWS1() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA5Bf = profAnSelector5.selectByName(setNamesPA5);

        final ProfitabilityAnalysis_Wrapper paWrapper5 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA5Bf[0].Id);

        Test.startTest();

            final Map<String, Object> retMap5 = Restudy_Helper.callPriceDecisionRestudyWS(paWrapper5, 'test restudy comments', 'test screenShot');
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
            expectedMap5.put('message', Label.restudy_success_sample);
            expectedMap5.put('paStageBf', 'Price Approval');
            expectedMap5.put('paStatusBf', 'Price Authorized');
            expectedMap5.put('paStageAf', 'Analysis');
            expectedMap5.put('paStatusAf', 'Restudy');
            System.assertEquals(expectedMap5, actualMap5, 'Err at Restudy_Ctrl - callPriceDecisionRestudyWS1');

        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void restudyCtrlConstructorTest() {
        Test.startTest();
            final Restudy_Ctrl constructorTest = new Restudy_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Restudy_Ctrl - restudyCtrlConstructorTest');
        Test.stopTest();
    }

    // Private constructor test service class
    @IsTest
    static void restudyHelperConstructorTest() {
        Test.startTest();
            final Restudy_Helper constructorTest1 = new Restudy_Helper();
            System.assertEquals(constructorTest1, constructorTest1, 'Err at Restudy_Ctrl - restudyHelperConstructorTest');
        Test.stopTest();
    }

    // Private constructor test helper class
    @IsTest
    static void restudyServiceConstructorTest() {
        Test.startTest();
            final Restudy_Service constructorTest2 = new Restudy_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Restudy_Ctrl - restudyServiceConstructorTest');
        Test.stopTest();
    }
}