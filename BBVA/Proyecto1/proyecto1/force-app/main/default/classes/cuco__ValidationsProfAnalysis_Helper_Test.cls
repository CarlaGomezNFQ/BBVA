/**
* ────────────────────────────────────────────────────────────────────────────────────
* ValidationsProfAnalysis_Helper_Test
* Test class for ValidationsProfAnalysis_Helper apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.Mastrogiorigo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-19
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ValidationsProfAnalysis_Helper_Test {

    @TestSetup
    static void makeDataOfProfitabilityAnalysisSample() {

        final List<Account> lstGroupAccount = Test_Utils.createAccounts(5);
        lstGroupAccount[0].Name = 'Account Test Orphan 0'; // retrieveTableData
        lstGroupAccount[1].Name = 'Account Test Group 0'; // retrieveTableData
        lstGroupAccount[2].Name = 'Account Test Subsidiary 0'; // retrieveTableData
        lstGroupAccount[3].Name = 'Account Test Group 1'; // manageAddNewParticipants
        lstGroupAccount[4].Name = 'Account Test Group 2'; // manageAddNewParticipants
        insert lstGroupAccount;

        final User usuario = Test_Utils.createUser();
        insert usuario;

        final List<Account> accounts = Test_Utils.createAccounts(5);
        accounts[0].Sic = '1597';
        accounts[0].ParentId = lstGroupAccount[1].Id;
        accounts[1].ParentId = lstGroupAccount[1].Id;
        accounts[2].ParentId = lstGroupAccount[2].Id;
        accounts[3].ParentId = lstGroupAccount[2].Id;
        accounts[4].ParentId = lstGroupAccount[2].Id;
        insert accounts;

        final List<Account> lstAccs2PS = new List<Account>{lstGroupAccount[1], accounts[2], lstGroupAccount[3], lstGroupAccount[4], lstGroupAccount[0]};
        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(5, lstAccs2PS);
        profSheets[0].gf_prftbly_sheet_start_date__c = date.today().addDays(- integer.valueof(200));
        profSheets[0].gf_prftbly_sheet_end_date__c= date.today().addDays(- integer.valueof(190));
        insert profSheets;

        final List<profitability_sheet_participant__c> lstPSPPart = Test_Utils.createProfSheetParticipant(2, profSheets[0].Id, new List<Id>{accounts[0].Id, accounts[1].Id});
        insert lstPSPPart;

        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(5, lstAccs2PS);
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Sent for Price Approval';
        profAnalysis[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].id;

        profAnalysis[1].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[1].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[1].gf_profitability_sheet_id__c = profSheets[1].id;

        profAnalysis[2].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[2].gf_pa_mgmt_stage_type_name__c = 'Price Approval';
        profAnalysis[2].gf_profitability_sheet_id__c = profSheets[2].id;

        profAnalysis[3].gf_pa_management_type_name__c = 'New';
        profAnalysis[3].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[3].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[3].gf_profitability_sheet_id__c = profSheets[3].Id;

        profAnalysis[4].gf_pa_management_type_name__c = 'New';
        profAnalysis[4].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[4].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[4].gf_profitability_sheet_id__c = profSheets[4].Id;
        insert profAnalysis;

        final List<profitability_analysis_participant__c> lstPAP = Test_Utils.createProfAnalysisParticipant(2, profAnalysis[0].Id, new List<Id>{accounts[0].Id, accounts[1].Id});
        insert lstPAP;
    }

    @IsTest
    static void validationsProfAnalysisTest() {

        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> paSetName = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paSetName);

        final ProfitabilitySheet_Selector profShSelector = new ProfitabilitySheet_Selector(true);
        final ProfitabilityAnalysis_Wrapper wrapperToReturn = new ProfitabilityAnalysis_Wrapper();
        final List<Profitability_sheet__c> profShList = profShSelector.selectById(new Set<Id>{profAnalysis[0].gf_profitability_sheet_id__c});
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysis[0].Id);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        wrapperToReturn.id = profAnalysis[0].Id;
        wrapperToReturn.name = profAnalysis[0].Name;
        wrapperToReturn.typology = profAnalysis[0].gf_pa_management_type_name__c;
        wrapperToReturn.stage = profAnalysis[0].gf_pa_mgmt_stage_type_name__c;
        wrapperToReturn.status = profAnalysis[0].gf_pa_mgmt_status_type_name__c;
        wrapperToReturn.mainParticipant = null;

        if (profShList != null && !profShList.isEmpty()) {
            wrapperToReturn.code = profShList[0].cuco__gf_profitability_sheet_id__c;
            if (profAnalysis[0].gf_pa_management_type_name__c == 'Novation' || profAnalysis[0].gf_pa_management_type_name__c == 'Renewal') {
                wrapperToReturn.originStartDate = profShList[0].gf_prftbly_sheet_start_date__c;
                wrapperToReturn.originEndDate = profShList[0].gf_prftbly_sheet_end_date__c;
            }
        }
        Test.startTest();
            List<String> lcheckBranch = ValidationsProfAnalysis_Helper.checkBranch(wrapperToReturn);
            System.assert(true,Label.error_missing_branch);
            List<String> lcheckSegment = ValidationsProfAnalysis_Helper.checkSegment(wrapperToReturn, genConfig);
            System.assert(true,Label.error_non_valid_segment);
            List<String> lcheckMainParticipant = ValidationsProfAnalysis_Helper.checkMainParticipant(wrapperToReturn);
            System.assert(true,Label.error_missing_main_participant);
            List<String> lcheckRenewalMargin = ValidationsProfAnalysis_Helper.checkRenewalMargin(paWrapper, genConfig);
            System.assert(true, Label.error_renewal_margin);
            List<String> lcheckBackendLastDate = ValidationsProfAnalysis_Helper.checkBackendLastDate(wrapperToReturn);
            System.assert(true, Label.error_backend_date);
        Test.stopTest();
    }

    @IsTest
    static void checkParticipantTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        Test.startTest();
            final List<String> retList = ValidationsProfAnalysis_Helper.checkParticipant(paWrapper, genConfig);
            System.assertEquals(0, retList.size(), 'Err at ValidationsProfAnalysis_Helper_Test - checkParticipantTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkParticipantTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        paWrapper.participantsList[0].accountid = paWrapper.mainParticipant.accountid;
        Test.startTest();
            List<String> retList = ValidationsProfAnalysis_Helper.checkParticipant(paWrapper, genConfig);
            System.assertEquals(1, retList.size(), 'Err at ValidationsProfAnalysis_Helper_Test - checkParticipantTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkParticipantTest3() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        paWrapper.participantsList.clear();
        Test.startTest();
            List<String> retList = ValidationsProfAnalysis_Helper.checkParticipant(paWrapper, genConfig);
            System.assertEquals(1, retList.size(), 'Err at ValidationsProfAnalysis_Helper_Test - checkParticipantTest3');
        Test.stopTest();
    }

    @IsTest
    static void checkParticipantTest4() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 4'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        paWrapper.participantsList = new List<ProfitabilityAnalysis_Wrapper.Participants>{new ProfitabilityAnalysis_Wrapper.Participants()};
        paWrapper.participantsList[0].accountid = paWrapper.id;
        Test.startTest();
            final List<String> retList = ValidationsProfAnalysis_Helper.checkParticipant(paWrapper, genConfig);
            System.assertEquals(1, retList.size(), 'Err at ValidationsProfAnalysis_Helper_Test - checkParticipantTest4');
        Test.stopTest();
    }

    @IsTest
    static void checkParticipantTest5() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 1'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        Test.startTest();
            final List<String> retList = ValidationsProfAnalysis_Helper.checkParticipant(paWrapper, genConfig);
            System.assertEquals(1, retList.size(), 'Err at ValidationsProfAnalysis_Helper_Test - checkParticipantTest5');
        Test.stopTest();
    }
}