/**
* ────────────────────────────────────────────────────────────────────
* Alert_Ctrl_Test
* Test class for Alert_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-04
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Alert_Ctrl_Test {

    @TestSetup
    static void makeDataOfPAAlertCtrl() {

        final List<Account> lstAcc = Test_Utils.createAccounts(1);
        insert lstAcc;

        final List<profitability_sheet__c> lstPS = Test_Utils.createProfSheet(6, lstAcc[0]);
        insert lstPS;

        final List<profitability_analysis__c> lstPA = Test_Utils.createProfAnalysis(6, lstAcc[0]);
        // Prof Analysis 1: Renewal with Closed Stage Type false
        lstPA[0].gf_pa_management_type_name__c = 'Renewal';
        lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[0].gf_profitability_sheet_id__c = lstPS[0].Id;

        // Prof Analysis 2: Cancellation with Closed Stage Type false
        lstPA[1].gf_pa_management_type_name__c = 'Cancellation';
        lstPA[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[1].gf_profitability_sheet_id__c = lstPS[1].Id;

        // Prof Analysis 3: Novation with Closed Stage Type false
        lstPA[2].gf_pa_management_type_name__c = 'Novation';
        lstPA[2].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[2].gf_profitability_sheet_id__c = lstPS[2].Id;

        // Prof Analysis 4: New with Closed Stage Type false
        lstPA[3].gf_pa_management_type_name__c = 'New';
        lstPA[3].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[3].gf_auto_formalization_req_id__c = '00003';

        // Prof Analysis 5: Renewal with Closed Stage Type true (Without gf_pa_mgmt_stage_type_name__c filled, for default label test purpose)
        lstPA[4].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[4].gf_profitability_sheet_id__c = lstPS[4].Id;

        // Prof Analysis 6: New with Closed Stage Type true
        lstPA[5].gf_pa_management_type_name__c = 'New';
        lstPA[5].gf_pa_mgmt_stage_type_name__c = 'Formalized';
        lstPA[5].gf_profitability_sheet_id__c = lstPS[5].Id;

        insert lstPA;
    }

    @IsTest
    static void checkAnalysisInProgressTest1() {
        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 0'};
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};

        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = true;
        expectedWrapper.textToShow = Label.renewal_alert_msg;
        expectedWrapper.recordIdToNavigate = lstPA[0].Id;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(lstPS[0].Id);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkAnalysisInProgressTest2() {
        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 1'};
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 1'};

        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = true;
        expectedWrapper.textToShow = Label.cancellation_alert_msg;
        expectedWrapper.recordIdToNavigate = lstPA[0].Id;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(lstPS[0].Id);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkAnalysisInProgressTest3() {
        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 2'};
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 2'};

        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = true;
        expectedWrapper.textToShow = Label.novation_alert_msg;
        expectedWrapper.recordIdToNavigate = lstPA[0].Id;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(lstPS[0].Id);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest3');
        Test.stopTest();
    }

    @IsTest
    static void checkAnalysisInProgressTest4() {
        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 3'};
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 3'};

        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = true;
        expectedWrapper.textToShow = Label.new_alert_msg;
        expectedWrapper.recordIdToNavigate = lstPA[0].Id;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(lstPS[0].Id);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest4');
        Test.stopTest();
    }

    @IsTest
    static void checkAnalysisInProgressTest5() {
        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 4'};
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 4'};

        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = true;
        expectedWrapper.textToShow = Label.default_alert_msg;
        expectedWrapper.recordIdToNavigate = lstPA[0].Id;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(lstPS[0].Id);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest5');
        Test.stopTest();
    }

    @IsTest
    static void checkAnalysisInProgressTest6() {
        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 5'};

        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = false;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(lstPS[0].Id);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest6');
        Test.stopTest();
    }

    @IsTest
    static void checkAnalysisInProgressTest7() {

        final Alert_Ctrl.Alert_Wrapper expectedWrapper = new Alert_Ctrl.Alert_Wrapper();
        expectedWrapper.showBanner = false;

        Test.startTest();
            final Alert_Ctrl.Alert_Wrapper actualWrapper = Alert_Ctrl.checkAnalysisInProgress(null);
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at Alert_Ctrl_Test checkAnalysisInProgressTest7');
        Test.stopTest();

    }

    // Private constructor test
    @IsTest
    static void alertCtrlConstructorTest() {
        Test.startTest();
            final Alert_Ctrl constructorTest = new Alert_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Alert_Ctrl_Test - alertCtrlConstructorTest');
        Test.stopTest();
    }
}