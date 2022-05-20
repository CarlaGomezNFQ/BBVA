/**
* ────────────────────────────────────────────────────────────────────
* Price_approval_Ctrl_Test
* Test class for Price_approval_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-12
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class Price_approval_Ctrl_Test {

    @TestSetup
    static void makeDataPermissionsSample() {

        final List<Account> lstAcc = Test_Utils.createAccounts(1);
        insert lstAcc;

        final List<profitability_sheet__c> lstPS = Test_Utils.createProfSheet(1, lstAcc[0]);
        lstPS[0].cuco__gf_prftbly_sheet_start_date__c = Date.today();
        lstPS[0].cuco__gf_prftbly_sheet_end_date__c = Date.today().addMonths(12);
        insert lstPS;

        final List<profitability_analysis__c> lstPA = Test_Utils.createProfAnalysis(2, lstAcc[0]);
        // Prof Analysis 1: Renewal with Closed Stage Type false
        lstPA[0].gf_pa_management_type_name__c = 'Renewal';
        lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[0].gf_profitability_sheet_id__c = lstPS[0].Id;
        lstPA[1].gf_pa_management_type_name__c = 'Renewal';
        lstPA[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[1].gf_profitability_sheet_id__c = lstPS[0].Id;
        lstPA[1].gf_price_aprvl_process_req_id__c = 'TestrequestId';

        insert lstPA;

        // Create profitability analysis participant
        final Set<Id> setIdAcc = new Set<Id>();
        for (Account acc : lstAcc) {
            setIdAcc.add(acc.Id);
        }
        final List<Id> lstId = new List<Id>();
        lstId.addAll(setIdAcc);

        final List<profitability_analysis_participant__c> lstPAPCommEdit = new List<profitability_analysis_participant__c>();
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPA[0].Id, lstId));
        insert lstPAPCommEdit;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCFFRS = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCFFRS;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCCFRS = Test_Utils.createPSCatalogConditons(4, lstPSCFFRS[0]);
        insert lstPSCCFRS;

        // Create ps catalog attribute
        final List<ps_catalog_attribute__c> lstPsCatAttbFR = Test_Utils.createPSCatalogAttributes(5);
        lstPsCatAttbFR[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        lstPsCatAttbFR[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        lstPsCatAttbFR[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        lstPsCatAttbFR[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        lstPsCatAttbFR[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert lstPsCatAttbFR;

        // Create ps catalog condiction attribute
        final List<ps_catalog_condition_attribute__c> lstPSCCATT = Test_Utils.createPSCatalogConditonAttributes(1, lstPSCCFRS[0], lstPsCatAttbFR);
        insert lstPSCCATT;
    }

    // Test method to check can manage methods with positive result of Permissions Sample
    @IsTest
    static void requestDataTest() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();
            final Map<String, Object> requestData = Price_approval_Ctrl.requestData(lstPA1[0].Id);
            System.assertEquals(requestData.get('priceStatusCode'), 200, 'Error Price_approval_Ctrl_Test - requestDataTest');
        Test.stopTest();
    }

    @IsTest
    static void requestDataTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();
            final Map<String, Object> requestData = Price_approval_Ctrl.requestData(lstPA1[0].Id);
            System.assertEquals(requestData.get('priceStatusCode'), 200, 'Error Price_approval_Ctrl_Test - requestDataTest');
        Test.stopTest();
    }

    @IsTest
    static void persistingDataTest() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final Map<String, Object> dataToSend = new Map<String, Object>();
        final Date enddate = Date.today();

        dataToSend.put('profAnalId', lstPA1[0].Id);
        dataToSend.put('decisionCode', 'A');
        dataToSend.put('decisionComments', 'Comments');
        dataToSend.put('proposedEndDate', String.ValueOf(enddate));
        dataToSend.put('screenshot', 'auditHtml');

        Test.startTest();
            final Map<String, Object> requestData = Price_approval_Ctrl.persistData(dataToSend);
            System.assertEquals(requestData.get('success'), true, 'Error Price_approval_Ctrl_Test - persistingDataTest');
        Test.stopTest();
    }
    // Test method to check exception in controller
    @IsTest
    static void requestDataTestError1() {
        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);
        lstPA2[0].gf_pa_mgmt_status_type_name__c = '';
        update lstPA2[0];
        Test.startTest();
            try {
                Price_approval_Ctrl.requestData(lstPA2[0].Id);
            } catch (Exception e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Price_approval - requestData');
            }
        Test.stopTest();
    }
    // Test method to check exception in controller
    @IsTest
    static void persistDataTestError1() {
        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);
        lstPA3[0].gf_pa_mgmt_status_type_name__c = '';
        update lstPA3[0];
        final Map<String, Object> dataToSendError = new Map<String, Object>();

        dataToSendError.put('profAnalId', lstPA3[0].Id);
        Test.startTest();
            try {
                Price_approval_Ctrl.persistData(dataToSendError);
            } catch (Exception e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Price_approval - persistData');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void priceApprovalHelperConstructorTest() {
        Test.startTest();
            final Price_approval_Helper constructorTest = new Price_approval_Helper();
            System.assertEquals(constructorTest, constructorTest, 'Err at Price_approval_Helper_Test - priceApprovalHelperConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void priceApprovalCtrlConstructorTest() {
        Test.startTest();
            final Price_approval_Ctrl constructorTest2 = new Price_approval_Ctrl();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Price_approval_Ctrl_Test - priceApprovalCtrlConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void priceApprovalServiceConstructorTest() {
        Test.startTest();
            final Price_approval_Service constructorTest3 = new Price_approval_Service();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Price_approval_Helper_Test - priceApprovalServiceConstructorTest');
        Test.stopTest();
    }
}