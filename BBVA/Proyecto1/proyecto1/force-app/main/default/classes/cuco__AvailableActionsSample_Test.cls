/**
* ────────────────────────────────────────────────────────────────────────────────────
* AvailableActionsSample_Test
* Test class for AvailableActionsSample apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.Mastrogiorigo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-09
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
@IsTest
public class AvailableActionsSample_Test {

    @TestSetup
    static void makeDataAvailableActions() {

        final List<Account> lstAvailableActionsAcc = Test_Utils.createAccounts(1);
        insert lstAvailableActionsAcc;

        final List<profitability_sheet__c> lstAvailableActionsPS = Test_Utils.createProfSheet(1, lstAvailableActionsAcc[0]);
        insert lstAvailableActionsPS;

        final List<profitability_analysis__c> lstAvailableActionsPA = Test_Utils.createProfAnalysis(14, lstAvailableActionsAcc[0]);
        for (profitability_analysis__c profAn : lstAvailableActionsPA) {
            profAn.gf_profitability_sheet_id__c = lstAvailableActionsPS[0].Id;
        }
        // PA_Dismiss_Sample
        lstAvailableActionsPA[0].gf_pa_management_type_name__c = 'Cancellation';
        lstAvailableActionsPA[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstAvailableActionsPA[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstAvailableActionsPA[1].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstAvailableActionsPA[1].gf_pa_mgmt_status_type_name__c = 'Restudy';
        lstAvailableActionsPA[2].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[2].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstAvailableActionsPA[2].gf_pa_mgmt_status_type_name__c = 'Restudy';
        lstAvailableActionsPA[2].gf_auto_formalization_req_id__c = 'Test';

        // PA_Price_Approval_Sample
        lstAvailableActionsPA[3].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[3].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstAvailableActionsPA[3].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstAvailableActionsPA[4].gf_pa_management_type_name__c = 'Cancellation';
        lstAvailableActionsPA[4].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstAvailableActionsPA[4].gf_pa_mgmt_status_type_name__c = 'Analysis';

        // PA_Approve_Price_Sample
        lstAvailableActionsPA[5].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[5].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstAvailableActionsPA[5].gf_pa_mgmt_status_type_name__c = 'Price Authorized';
        lstAvailableActionsPA[6].gf_pa_management_type_name__c = 'Cancellation';
        lstAvailableActionsPA[6].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstAvailableActionsPA[6].gf_pa_mgmt_status_type_name__c = 'Price Authorized';

        // PA_Restudy_Sample
        lstAvailableActionsPA[7].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[7].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        lstAvailableActionsPA[7].gf_pa_mgmt_status_type_name__c = 'Formalization Returned';
        lstAvailableActionsPA[8].gf_pa_management_type_name__c = 'Cancellation';
        lstAvailableActionsPA[8].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        lstAvailableActionsPA[8].gf_pa_mgmt_status_type_name__c = 'Formalization Returned';

        // PA_Formalization_Sample
        lstAvailableActionsPA[9].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[9].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstAvailableActionsPA[9].gf_pa_mgmt_status_type_name__c = 'Price Approved';
        lstAvailableActionsPA[10].gf_pa_management_type_name__c = 'Cancellation';
        lstAvailableActionsPA[10].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstAvailableActionsPA[10].gf_pa_mgmt_status_type_name__c = 'Price Approved';
        lstAvailableActionsPA[13].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[13].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstAvailableActionsPA[13].gf_pa_mgmt_status_type_name__c = 'Price Authorized';

        // PA_Notification_Sample
        lstAvailableActionsPA[11].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[11].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        lstAvailableActionsPA[11].gf_pa_mgmt_status_type_name__c = 'Sent for Formalization';
        lstAvailableActionsPA[12].gf_pa_management_type_name__c = 'Novation';
        lstAvailableActionsPA[12].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        lstAvailableActionsPA[12].gf_pa_mgmt_status_type_name__c = 'Price Approved';

        insert lstAvailableActionsPA;
    }

    // PA_Dismiss_Sample test 1
    @IsTest
    static void availableActionsSampleTest1() {

        final ProfitabilityAnalysis_Selector paSelector1 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis1 = paSelector1.selectByName(paNames1);

        Test.startTest();
            final Map<String,Object> actualMap1 = AvailableActionsSample.checkAvailableAction('PA_Dismiss', profitabilityAnalysis1[0].Id);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('success', true);
            System.assertEquals(expectedMap1, actualMap1, 'Err at AvailableActionsSample_Test - availableActionsSampleTest1');
        Test.stopTest();
    }

    // PA_Dismiss_Sample test 2
    @IsTest
    static void availableActionsSampleTest2() {

        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> profitabilityAnalysis2 = paSelector2.selectByName(paNames2);

        Test.startTest();
            final Map<String,Object> actualMap2 = AvailableActionsSample.checkAvailableAction('PA_Dismiss', profitabilityAnalysis2[0].Id);
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('success', true);
            System.assertEquals(expectedMap2, actualMap2, 'Err at AvailableActionsSample_Test - availableActionsSampleTest2');
        Test.stopTest();
    }

    // PA_Dismiss_Sample test 3
    @IsTest
    static void availableActionsSampleTest3() {

        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames3 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> profitabilityAnalysis3 = paSelector3.selectByName(paNames3);

        Test.startTest();
            final Map<String,Object> actualMap3 = AvailableActionsSample.checkAvailableAction('PA_Dismiss', profitabilityAnalysis3[0].Id);
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('success', false);
            expectedMap3.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap3, actualMap3, 'Err at AvailableActionsSample_Test - availableActionsSampleTest3');
        Test.stopTest();
    }

    // PA_Price_Approval_Sample test 1
    @IsTest
    static void availableActionsSampleTest4() {

        final ProfitabilityAnalysis_Selector paSelector4 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames4 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> profitabilityAnalysis4 = paSelector4.selectByName(paNames4);

        Test.startTest();
            final Map<String,Object> actualMap4 = AvailableActionsSample.checkAvailableAction('PA_Price_Approval', profitabilityAnalysis4[0].Id);
            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('success', true);
            System.assertEquals(expectedMap4, actualMap4, 'Err at AvailableActionsSample_Test - availableActionsSampleTest4');
        Test.stopTest();
    }

    // PA_Price_Approval_Sample test 2
    @IsTest
    static void availableActionsSampleTest5() {

        final ProfitabilityAnalysis_Selector paSelector5 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames5 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> profitabilityAnalysis5 = paSelector5.selectByName(paNames5);

        Test.startTest();
            final Map<String,Object> actualMap5 = AvailableActionsSample.checkAvailableAction('PA_Price_Approval', profitabilityAnalysis5[0].Id);
            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('success', false);
            expectedMap5.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap5, actualMap5, 'Err at AvailableActionsSample_Test - availableActionsSampleTest5');
        Test.stopTest();
    }

    // PA_Approve_Price_Sample test 1
    @IsTest
    static void availableActionsSampleTest6() {

        final ProfitabilityAnalysis_Selector paSelector6 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames6 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> profitabilityAnalysis6 = paSelector6.selectByName(paNames6);

        Test.startTest();
            final Map<String,Object> actualMap6 = AvailableActionsSample.checkAvailableAction('PA_Approve_Price', profitabilityAnalysis6[0].Id);
            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('success', true);
            System.assertEquals(expectedMap6, actualMap6, 'Err at AvailableActionsSample_Test - availableActionsSampleTest6');
        Test.stopTest();
    }

    // PA_Approve_Price_Sample test 2
    @IsTest
    static void availableActionsSampleTest7() {

        final ProfitabilityAnalysis_Selector paSelector7 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames7 = new Set<String>{'Prof Analysis Test 6'};
        final List<profitability_analysis__c> profitabilityAnalysis7 = paSelector7.selectByName(paNames7);

        Test.startTest();
            final Map<String,Object> actualMap7 = AvailableActionsSample.checkAvailableAction('PA_Approve_Price', profitabilityAnalysis7[0].Id);
            final Map<String, Object> expectedMap7 = new Map<String, Object>();
            expectedMap7.put('success', false);
            expectedMap7.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap7, actualMap7, 'Err at AvailableActionsSample_Test - availableActionsSampleTest7');
        Test.stopTest();
    }

    // PA_Restudy_Sample test 1
    @IsTest
    static void availableActionsSampleTest8() {

        final ProfitabilityAnalysis_Selector paSelector8 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames8 = new Set<String>{'Prof Analysis Test 7'};
        final List<profitability_analysis__c> profitabilityAnalysis8 = paSelector8.selectByName(paNames8);

        Test.startTest();
            final Map<String,Object> actualMap8 = AvailableActionsSample.checkAvailableAction('PA_Restudy', profitabilityAnalysis8[0].Id);
            final Map<String, Object> expectedMap8 = new Map<String, Object>();
            expectedMap8.put('success', true);
            System.assertEquals(expectedMap8, actualMap8, 'Err at AvailableActionsSample_Test - availableActionsSampleTest8');
        Test.stopTest();
    }

    // PA_Restudy_Sample test 2
    @IsTest
    static void availableActionsSampleTest9() {

        final ProfitabilityAnalysis_Selector paSelector9 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames9 = new Set<String>{'Prof Analysis Test 8'};
        final List<profitability_analysis__c> profitabilityAnalysis9 = paSelector9.selectByName(paNames9);

        Test.startTest();
            final Map<String,Object> actualMap9 = AvailableActionsSample.checkAvailableAction('PA_Restudy', profitabilityAnalysis9[0].Id);
            final Map<String, Object> expectedMap9 = new Map<String, Object>();
            expectedMap9.put('success', false);
            expectedMap9.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap9, actualMap9, 'Err at AvailableActionsSample_Test - availableActionsSampleTest9');
        Test.stopTest();
    }

    // PA_Formalization_Sample test 1
    @IsTest
    static void availableActionsSampleTest10() {

        final ProfitabilityAnalysis_Selector paSelector10 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames10 = new Set<String>{'Prof Analysis Test 9'};
        final List<profitability_analysis__c> profitabilityAnalysis10 = paSelector10.selectByName(paNames10);

        Test.startTest();
            final Map<String,Object> actualMap10 = AvailableActionsSample.checkAvailableAction('PA_Formalization', profitabilityAnalysis10[0].Id);
            final Map<String, Object> expectedMap10 = new Map<String, Object>();
            expectedMap10.put('success', true);
            System.assertEquals(expectedMap10, actualMap10, 'Err at AvailableActionsSample_Test - availableActionsSampleTest10');
        Test.stopTest();
    }

    // PA_Formalization_Sample test 2
    @IsTest
    static void availableActionsSampleTest11() {

        final ProfitabilityAnalysis_Selector paSelector11 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames11 = new Set<String>{'Prof Analysis Test 10'};
        final List<profitability_analysis__c> profitabilityAnalysis11 = paSelector11.selectByName(paNames11);

        Test.startTest();
            final Map<String,Object> actualMap11 = AvailableActionsSample.checkAvailableAction('PA_Formalization', profitabilityAnalysis11[0].Id);
            final Map<String, Object> expectedMap11 = new Map<String, Object>();
            expectedMap11.put('success', false);
            expectedMap11.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap11, actualMap11, 'Err at AvailableActionsSample_Test - availableActionsSampleTest11');
        Test.stopTest();
    }

    // PA_Notification_Sample test 1
    @IsTest
    static void availableActionsSampleTest12() {

        final ProfitabilityAnalysis_Selector paSelector12 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames12 = new Set<String>{'Prof Analysis Test 11'};
        final List<profitability_analysis__c> profitabilityAnalysis12 = paSelector12.selectByName(paNames12);

        Test.startTest();
            final Map<String,Object> actualMap12 = AvailableActionsSample.checkAvailableAction('PA_Notification', profitabilityAnalysis12[0].Id);
            final Map<String, Object> expectedMap12 = new Map<String, Object>();
            expectedMap12.put('success', true);
            System.assertEquals(expectedMap12, actualMap12, 'Err at AvailableActionsSample_Test - availableActionsSampleTest12');
        Test.stopTest();
    }

    // PA_Notification_Sample test 2
    @IsTest
    static void availableActionsSampleTest13() {

        final ProfitabilityAnalysis_Selector paSelector13 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames13 = new Set<String>{'Prof Analysis Test 12'};
        final List<profitability_analysis__c> profitabilityAnalysis13 = paSelector13.selectByName(paNames13);

        Test.startTest();
            final Map<String,Object> actualMap13 = AvailableActionsSample.checkAvailableAction('PA_Notification', profitabilityAnalysis13[0].Id);
            final Map<String, Object> expectedMap13 = new Map<String, Object>();
            expectedMap13.put('success', false);
            expectedMap13.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap13, actualMap13, 'Err at AvailableActionsSample_Test - availableActionsSampleTest13');
        Test.stopTest();
    }

    // PA_Formalization_Sample test 2
    @IsTest
    static void availableActionsSampleTest14() {

        final ProfitabilityAnalysis_Selector paSelector14 = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames14 = new Set<String>{'Prof Analysis Test 13'};
        final List<profitability_analysis__c> profitabilityAnalysis14 = paSelector14.selectByName(paNames14);

        Test.startTest();
            final Map<String,Object> actualMap14 = AvailableActionsSample.checkAvailableAction('PA_Formalization', profitabilityAnalysis14[0].Id);
            final Map<String, Object> expectedMap14 = new Map<String, Object>();
            expectedMap14.put('success', false);
            expectedMap14.put('message', Label.action_not_available_sample);
            System.assertEquals(expectedMap14, actualMap14, 'Err at AvailableActionsSample_Test - availableActionsSampleTest14');
        Test.stopTest();
    }
}