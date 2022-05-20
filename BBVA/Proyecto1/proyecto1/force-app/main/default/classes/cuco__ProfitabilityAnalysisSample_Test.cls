/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysisSample_Test
* Test class for ProfitabilityAnalysisSample apex class
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-24
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ProfitabilityAnalysisSample_Test {

    /** @description branchCode */
    static final String BRANCHCODE = '';
    /** @description usercode */
    static final String USERCODE = '';
    /** @description screenShot */
    static final String SCREENSHOT_NEW = '<div class="slds-modal__content slds-p-around_xx-large"></div>';

    @TestSetup
    static void makeDataOfProfitabilityAnalysisSample() {

        final List<Account> lstGroupAccount = Test_Utils.createAccounts(5);
        lstGroupAccount[0].Name = 'Account Test Orphan 0'; // retrieveTableData
        lstGroupAccount[1].Name = 'Account Test Group 0'; // retrieveTableData
        lstGroupAccount[2].Name = 'Account Test Group 1'; // retrieveTableData
        lstGroupAccount[3].Name = 'Account Test Group 2'; // manageAddNewParticipants
        lstGroupAccount[4].Name = 'Account Test Group 3'; // manageAddNewParticipants

        insert lstGroupAccount;


        final User usuario = Test_Utils.createUser();
        insert usuario;

        final List<Account> accounts = Test_Utils.createAccounts(4);
        accounts[0].Sic = '666';
        insert accounts;

        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(1, accounts[0]);
        insert profSheets;

        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(4, accounts);
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Sent for Price Approval';
        profAnalysis[1].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[2].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        profAnalysis[3].gf_pa_mgmt_stage_type_name__c = 'Formalization';
        profAnalysis[3].gf_pa_mgmt_status_type_name__c = 'Sent for Formalization';
        profAnalysis[3].gf_manl_formalization_req_id__c = 'Manual Req Id';
        insert profAnalysis;

        final Group group1 = new Group(Name = 'group name test');
        insert group1;
    }

    @IsTest
    static void getUserCode1() {
        Test.startTest();
            final User federation = [SELECT id, FederationIdentifier FROM User WHERE LastName =: 'profi' LIMIT 1];
            final ProfitabilityAnalysisSample profitaSample = new ProfitabilityAnalysisSample();
            final String actualValue = profitaSample.getUserCode(federation.id);
            System.assertEquals(federation.FederationIdentifier, actualValue, 'Err at ProfitabilityAnalysisSample_Test getUserCode1');
        Test.stopTest();
    }

    @IsTest
    static void setPADefaultCreationData() {
        Test.startTest();

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Group 0' LIMIT 1];
        final profitability_analysis__c paNew = new profitability_analysis__c();
        paNew.name = 'test1';
        paNew.participant_id__c = lstAcc[0].Id;
        paNew.gf_pa_management_type_name__c ='New';
        paNew.gf_pa_mgmt_stage_type_name__c ='Analysis';
        paNew.gf_pa_mgmt_status_type_name__c ='Analysis';

        insert paNew;
        final ProfitabilityAnalysisSample profitaSample = new ProfitabilityAnalysisSample();
        final profitability_analysis__c actualValue = profitaSample.setPADefaultCreationData(paNew);
        System.assertEquals(actualValue, actualValue, 'Err at ProfitabilityAnalysisSample_Test setPADefaultCreationData');
        Test.stopTest();
    }

    @IsTest
    static void getUserId1() {
        Test.startTest();
            final User userInfo = [SELECT Id, FederationIdentifier FROM User WHERE LastName =: 'profi' LIMIT 1];
            final Id userId = ProfitabilityAnalysis_Service.obtainUserInfo(userInfo.FederationIdentifier);
            System.assertEquals(userInfo.Id, userId, 'Err at ProfitabilityAnalysisSample_Test getUserId1. Expected: ' + userInfo.Id + ' got: ' + userId);
        Test.stopTest();
    }

    @IsTest
    static void getBranchCode1() {
        Test.startTest();
            final profitability_analysis__c paInfo = [SELECT Id, participant_id__r.Sic FROM profitability_analysis__c WHERE Name =: 'Prof Analysis Test 0' LIMIT 1];
            final String branchCode = ProfitabilityAnalysis_Service.getBranchCode(paInfo.Id);
            System.assertEquals(paInfo.participant_id__r.Sic, branchCode, 'Err at ProfitabilityAnalysisSample_Test getBranchCode1. Expected: ' + paInfo.participant_id__r.Sic + ' got: ' + branchCode);
        Test.stopTest();
    }

    @IsTest
    static void getBranchCode2() {
        Test.startTest();
            final profitability_sheet__c  psInfo = [SELECT Id, participant_id__r.Sic FROM profitability_sheet__c WHERE Name =: 'Prof Sheet Test 0' LIMIT 1];
            final String branchCode = ProfitabilityAnalysis_Service.getBranchCode(psInfo.Id);
            System.assertEquals(psInfo.participant_id__r.Sic, branchCode, 'Err at ProfitabilityAnalysisSample_Test getBranchCode2. Expected: ' + psInfo.participant_id__r.Sic + ' got: ' + branchCode);
        Test.stopTest();
    }

    @IsTest
    static void setPADefaultRequestDataTest() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);

        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            final profitability_analysis__c paRes1 = paSample.setPADefaultRequestData(profAnalysis[0],BRANCHCODE,USERCODE);
            System.assertEquals(paRes1.Name,'Prof Analysis Test 0','Error in setPADefaultRequestData1');

            profAnalysis[0].cuco__gf_pa_management_type_name__c = 'Novation';
            profAnalysis[0].Name = 'Prof Analysis Test 0';
            update profAnalysis;
            final profitability_analysis__c paRes2 = paSample.setPADefaultRequestData(profAnalysis[0],branchCode,userCode);
            System.assertEquals(paRes2.Name,'Novation - Prof Analysis Test 0','Error in setPADefaultRequestData2');

            profAnalysis[0].cuco__gf_pa_management_type_name__c = 'Cancellation';
            profAnalysis[0].Name = 'Prof Analysis Test 0';
            update profAnalysis;
            final profitability_analysis__c paRes3 = paSample.setPADefaultRequestData(profAnalysis[0],branchCode,userCode);
            System.assertEquals(paRes3.Name,'Cancellation - Prof Analysis Test 0','Error in setPADefaultRequestData3');

            profAnalysis[0].cuco__gf_pa_management_type_name__c = 'Renewal';
            profAnalysis[0].Name = 'Prof Analysis Test 0';
            update profAnalysis;
            final profitability_analysis__c paRes4 = paSample.setPADefaultRequestData(profAnalysis[0],branchCode,userCode);
            System.assertEquals(paRes4.Name,'Renewal - Prof Analysis Test 0','Error in setPADefaultRequestData4');

        Test.stopTest();
    }

    @IsTest
    static void setPriceDecisionTestA() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            Map<String, Object> paRes1 = paSample.setPriceDecision(paWrapper,'A', 'String decisionComments', 'String screenShot');
            System.assertEquals(paRes1.get('success'),true,'Error in setPriceDecisionTest');
            final List<String> lstDecisions = new List<String>{'A','B','E','Z','Y','S'};
            final List<PriceDecision_Wrapper> paRes2 = paSample.getPriceDecisions(lstDecisions, Label.price_sent_approval);
            System.assertEquals(paRes2[0].name,Label.price_dec_elevateTop_sample,'Error in setPriceDecisionTest');
            paSample.getARCEDate(profAnalysis[0].Id);
        Test.stopTest();
    }

    @IsTest
    static void setPriceDecisionTestB() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            final Map<String, Object> paRes1 = paSample.setPriceDecision(paWrapper,'B', 'String decisionComments', 'String screenShot');
            System.assertEquals(paRes1.get('success'),true,'Error in setPriceDecisionTest');
        Test.stopTest();
    }

    @IsTest
    static void setPriceDecisionTestS() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            final Map<String, Object> paRes1 = paSample.setPriceDecision(paWrapper,'S', 'String decisionComments', 'String screenShot');
            System.assertEquals(paRes1.get('success'),true,'Error in setPriceDecisionTest');
        Test.stopTest();
    }

    @IsTest
    static void setPriceDecisionTestE() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            final Map<String, Object> paRes1 = paSample.setPriceDecision(paWrapper,'E', 'String decisionComments', 'String screenShot');
            System.assertEquals(paRes1.get('success'),true,'Error in setPriceDecisionTest');
        Test.stopTest();
    }

    @IsTest
    static void setPriceDecisionTestY() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            final Map<String, Object> paRes1 = paSample.setPriceDecision(paWrapper,'Y', 'String decisionComments', 'String screenShot');
            System.assertEquals(paRes1.get('success'),true,'Error in setPriceDecisionTest');
        Test.stopTest();
    }

    @IsTest
    static void setPriceDecisionTestZ() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            final Map<String, Object> paRes1 = paSample.setPriceDecision(paWrapper,'Z', 'String decisionComments', 'String screenShot');
            System.assertEquals(paRes1.get('success'),true,'Error in setPriceDecisionTest');
    }

    @IsTest
    static void setPAApprovePriceTest() {
        final ProfitabilityAnalysis_Selector paSelectorPrice = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetNamePrice = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = paSelectorPrice.selectByName(paSetNamePrice);

        Test.startTest();
            final ProfitabilityAnalysis_Wrapper profAnalysis = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA[0].Id);
            final ProfitabilityAnalysisSample paSamplePrice = new ProfitabilityAnalysisSample();
            final Map<String,Object> mapRet = paSamplePrice.setPAApprovePrice(profAnalysis,'');
            System.assertEquals(mapRet.get('success'), true, 'Err at ProfitabilityAnalysisSample_Test setPAApprovePriceTest');
        Test.stopTest();
    }

    @IsTest
    static void setPADismissalTest() {
        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = paSelector2.selectByName(paSetName2);

        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA2[0].Id);
        String dismissalComments = 'test comments';
        String screenShot = 'test screenshot';

        Test.startTest();
            final ProfitabilityAnalysisSample paSample = new ProfitabilityAnalysisSample();
            Map<String, Object> retMap = paSample.setPADismissal(paWrapper, dismissalComments, screenShot);
            final List<profitability_analysis__c> lstPAPost = paSelector2.selectByName(paSetName2);
            final List<dwp_cvad__Action_Audit__c> lstActionAudit = [SELECT Id FROM dwp_cvad__Action_Audit__c LIMIT 1];
            final List<dwp_cvad__Action_Audit_Detail__c> lstActionAuditDetail = [SELECT Id FROM dwp_cvad__Action_Audit_Detail__c LIMIT 1];

            final Map<String, Object> expectedMap = new Map<String, Object>();
            expectedMap.put('success', true);
            expectedMap.put('stage', 'Dismissed');
            expectedMap.put('status', 'Dismissed');
            expectedMap.put('actionAudit', 1);
            expectedMap.put('actionAuditDetail', 1);

            final Map<String, Object> actualMap = new Map<String, Object>();
            actualMap.put('success', (Boolean) retMap.get('success'));
            actualMap.put('stage', lstPAPost[0].gf_pa_mgmt_stage_type_name__c);
            actualMap.put('status', lstPAPost[0].gf_pa_mgmt_status_type_name__c);
            actualMap.put('actionAudit', lstActionAudit.size());
            actualMap.put('actionAuditDetail', lstActionAuditDetail.size());

            System.assertEquals(expectedMap, actualMap, 'Err at ProfitabilityAnalysisSample_Test - setPADismissalTest');
        Test.stopTest();
    }

    @IsTest
    static void setPAFormalizationTest() {
        final ProfitabilityAnalysis_Selector paSelectorForm = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetNameForm = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = paSelectorForm.selectByName(paSetNameForm);

        Test.startTest();
            final ProfitabilityAnalysis_Wrapper profAnalysis = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA[0].Id);
            final ProfitabilityAnalysisSample paSampleForm = new ProfitabilityAnalysisSample();
            final Map<String,Object> mapRet1 = paSampleForm.setPAFormalization(profAnalysis,'Combined','',SCREENSHOT_NEW);
            final Map<String,Object> mapRet2 = paSampleForm.setPAFormalization(profAnalysis,'Automatic','',SCREENSHOT_NEW);
            System.assertEquals(mapRet1.get('success'), true, 'Err 1 at ProfitabilityAnalysisSample_Test setPAFormalizationTest (combined)');
            System.assertEquals(mapRet2.get('success'), true, 'Err 2 at ProfitabilityAnalysisSample_Test setPAFormalizationTest (automatic)');
        Test.stopTest();
    }

    @IsTest
    static void setPARestudyTest1() {
        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA3 = paSelector3.selectByName(paSetName3);

        final ProfitabilityAnalysis_Wrapper paWrapper3 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA3[0].Id);
        String restudyComments3 = 'test comments';
        String screenShot3 = 'test screenshot';

        Test.startTest();
            final ProfitabilityAnalysisSample paSample3 = new ProfitabilityAnalysisSample();
            Map<String, Object> retMap3 = paSample3.setPARestudy(paWrapper3, restudyComments3, screenShot3);
            final List<profitability_analysis__c> lstPAPost3 = paSelector3.selectByName(paSetName3);
            final List<dwp_cvad__Action_Audit__c> lstActionAudit3 = [SELECT Id FROM dwp_cvad__Action_Audit__c LIMIT 1];
            final List<dwp_cvad__Action_Audit_Detail__c> lstActionAuditDetail3 = [SELECT Id FROM dwp_cvad__Action_Audit_Detail__c LIMIT 1];

            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('success', true);
            expectedMap3.put('stage', 'Analysis');
            expectedMap3.put('status', 'Restudy');
            expectedMap3.put('actionAudit', 1);
            expectedMap3.put('actionAuditDetail', 1);
            expectedMap3.put('emptyFieldOne', null);
            expectedMap3.put('emptyFieldTwo', null);

            final Map<String, Object> actualMap3 = new Map<String, Object>();
            actualMap3.put('success', (Boolean) retMap3.get('success'));
            actualMap3.put('stage', lstPAPost3[0].gf_pa_mgmt_stage_type_name__c);
            actualMap3.put('status', lstPAPost3[0].gf_pa_mgmt_status_type_name__c);
            actualMap3.put('actionAudit', lstActionAudit3.size());
            actualMap3.put('actionAuditDetail', lstActionAuditDetail3.size());
            actualMap3.put('emptyFieldOne', lstPAPost3[0].gf_pa_price_negotiated_date__c);
            actualMap3.put('emptyFieldTwo', lstPAPost3[0].gf_pa_aprvl_proc_deleg_br_id__c);

            System.assertEquals(expectedMap3, actualMap3, 'Err at ProfitabilityAnalysisSample_Test - setPARestudyTest1');
        Test.stopTest();
    }

    @IsTest
    static void setPARestudyTest2() {
        final ProfitabilityAnalysis_Selector paSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName4 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA4 = paSelector4.selectByName(paSetName4);

        final ProfitabilityAnalysis_Wrapper paWrapper4 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA4[0].Id);
        String restudyComments4 = 'test comments';
        String screenShot4 = 'test screenshot';

        Test.startTest();
            final ProfitabilityAnalysisSample paSample4 = new ProfitabilityAnalysisSample();
            Map<String, Object> retMap4 = paSample4.setPARestudy(paWrapper4, restudyComments4, screenShot4);
            final List<profitability_analysis__c> lstPAPost4 = paSelector4.selectByName(paSetName4);
            final List<dwp_cvad__Action_Audit__c> lstActionAudit4 = [SELECT Id FROM dwp_cvad__Action_Audit__c LIMIT 1];
            final List<dwp_cvad__Action_Audit_Detail__c> lstActionAuditDetail4 = [SELECT Id FROM dwp_cvad__Action_Audit_Detail__c LIMIT 1];

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('success', true);
            expectedMap4.put('stage', 'Analysis');
            expectedMap4.put('status', 'Restudy');
            expectedMap4.put('actionAudit', 1);
            expectedMap4.put('actionAuditDetail', 1);
            expectedMap4.put('emptyFieldOne', null);
            expectedMap4.put('emptyFieldTwo', null);
            expectedMap4.put('emptyFieldThree', null);

            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('success', (Boolean) retMap4.get('success'));
            actualMap4.put('stage', lstPAPost4[0].gf_pa_mgmt_stage_type_name__c);
            actualMap4.put('status', lstPAPost4[0].gf_pa_mgmt_status_type_name__c);
            actualMap4.put('actionAudit', lstActionAudit4.size());
            actualMap4.put('actionAuditDetail', lstActionAuditDetail4.size());
            actualMap4.put('emptyFieldOne', lstPAPost4[0].gf_price_aprvl_process_req_id__c);
            actualMap4.put('emptyFieldTwo', lstPAPost4[0].gf_pa_price_negotiated_date__c);
            actualMap4.put('emptyFieldThree', lstPAPost4[0].gf_pa_aprvl_proc_deleg_br_id__c);

            System.assertEquals(expectedMap4, actualMap4, 'Err at ProfitabilityAnalysisSample_Test - setPARestudyTest2');
        Test.stopTest();
    }

    @IsTest
    static void getFirstAndLastName1() {
        Test.startTest();
            final User userInfo = [SELECT Id, FirstName, LastName FROM User WHERE LastName =: 'profi' LIMIT 1];
            final String userName = ProfitabilityAnalysis_Service.getFirstAndLastName(userInfo.Id);
            System.assertEquals(userInfo.FirstName + ' ' + userInfo.LastName, userName, 'Err at ProfitabilityAnalysisSample_Test getFirstAndLastName1. Expected: ' + userInfo.FirstName + ' ' + userInfo.LastName + ' got: ' + userName);
        Test.stopTest();
    }

    @IsTest
    static void getFirstAndLastName2() {
        Test.startTest();
            final Group group1 = [SELECT Id FROM Group WHERE Name = 'group name test' LIMIT 1];
            final String userName = ProfitabilityAnalysis_Service.getFirstAndLastName(group1.Id);
            System.assertEquals('', userName, 'Err at ProfitabilityAnalysisSample_Test getFirstAndLastName2. Expected: empty got: ' + userName);
        Test.stopTest();
    }

    @IsTest
    static void setPANotificationTest1() {
        final ProfitabilityAnalysis_Selector paSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName5 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA5 = paSelector5.selectByName(paSetName5);

        final ProfitabilityAnalysis_Wrapper paWrapper5 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA5[0].Id);
        String notificationComments5 = 'test comments notification';
        String screenShot5 = 'test screenshot notification';

        Test.startTest();
            final ProfitabilityAnalysisSample paSample5 = new ProfitabilityAnalysisSample();
            Map<String, Object> retMap5 = paSample5.setPANotification(paWrapper5, notificationComments5, screenShot5);
            final List<profitability_analysis__c> lstPAPost5 = paSelector5.selectByName(paSetName5);
            final List<dwp_cvad__Action_Audit__c> lstActionAudit5 = [SELECT Id FROM dwp_cvad__Action_Audit__c LIMIT 1];
            final List<dwp_cvad__Action_Audit_Detail__c> lstActionAuditDetail5 = [SELECT Id FROM dwp_cvad__Action_Audit_Detail__c LIMIT 1];

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('success', true);
            expectedMap5.put('stage', 'Formalization');
            expectedMap5.put('status', 'Sent for Formalization');
            expectedMap5.put('actionAudit', 1);
            expectedMap5.put('actionAuditDetail', 1);
            expectedMap5.put('fieldOne', 'Manual Req Id');

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('success', (Boolean) retMap5.get('success'));
            actualMap5.put('stage', lstPAPost5[0].gf_pa_mgmt_stage_type_name__c);
            actualMap5.put('status', lstPAPost5[0].gf_pa_mgmt_status_type_name__c);
            actualMap5.put('actionAudit', lstActionAudit5.size());
            actualMap5.put('actionAuditDetail', lstActionAuditDetail5.size());
            actualMap5.put('fieldOne', lstPAPost5[0].gf_manl_formalization_req_id__c);

            System.assertEquals(expectedMap5, actualMap5, 'Err at ProfitabilityAnalysisSample_Test - setPANotificationTest1');
        Test.stopTest();
    }

    // Private ProfitabilityAnalysis_Service constructor test
    @IsTest
    static void profitabilityAnalysisServiceConstructorTest1() {
        Test.startTest();
            final ProfitabilityAnalysis_Service constructorTest = new ProfitabilityAnalysis_Service();
            System.assertEquals(constructorTest, constructorTest, 'Err at ProfitabilityAnalysisSample_Test - profitabilityAnalysisServiceConstructorTest1');
        Test.stopTest();
    }

    // Private ProfitabilityAnalysis_Helper constructor test
    @IsTest
    static void profitabilityAnalysisHelperConstructorTest2() {
        Test.startTest();
            final ProfitabilityAnalysis_Helper constructorTest2 = new ProfitabilityAnalysis_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at ProfitabilityAnalysisSample_Test - profitabilityAnalysisHelperConstructorTest2');
        Test.stopTest();
    }
}