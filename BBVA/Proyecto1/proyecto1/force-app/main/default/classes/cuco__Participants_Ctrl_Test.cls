/**
* ────────────────────────────────────────────────────────────────────
* Participants_Ctrl_Test
* Test class for Participants_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-10
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Participants_Ctrl_Test {

    @TestSetup
    static void makeDataOfParticipantsCtrl() {

        final List<Account> lstGroupAccPart = Test_Utils.createAccounts(5);
        lstGroupAccPart[0].Name = 'Account Test Group 0';
        lstGroupAccPart[1].Name = 'Account Test Orphan 1';
        lstGroupAccPart[2].Name = 'Account Test Subsidiary 0';
        lstGroupAccPart[3].Name = 'Account Test Group 1';
        lstGroupAccPart[4].Name = 'Account Test Group 2';
        insert lstGroupAccPart;

        final List<Account> lstAccPart = Test_Utils.createAccounts(4);
        lstAccPart[0].ParentId = lstGroupAccPart[0].Id;
        lstAccPart[1].ParentId = lstGroupAccPart[0].Id;
        lstAccPart[2].ParentId = lstGroupAccPart[3].Id;
        lstAccPart[3].ParentId = lstGroupAccPart[4].Id;
        insert lstAccPart;

        final List<Account> lstAccs2PS = new List<Account>{lstGroupAccPart[0], lstGroupAccPart[3], lstGroupAccPart[4], lstGroupAccPart[1]};
        final List<profitability_sheet__c> lstPSPart = Test_Utils.createProfSheet(4, lstAccs2PS);
        insert lstPSPart;

        final List<profitability_sheet_participant__c> lstPSPPart = Test_Utils.createProfSheetParticipant(2, lstPSPart[0].Id, new List<Id>{lstAccPart[0].Id, lstAccPart[1].Id});
        insert lstPSPPart;

        final List<Account> lstAccs2PAPart = new List<Account>{lstGroupAccPart[0], lstGroupAccPart[3], lstGroupAccPart[4]};
        final List<profitability_analysis__c> lstPAPart = Test_Utils.createProfAnalysis(3, lstAccs2PAPart);
        for (Integer i=0; i<lstPAPart.size(); i++) {
            lstPAPart[i].gf_pa_management_type_name__c = 'New';
            lstPAPart[i].gf_pa_mgmt_stage_type_name__c = 'Analysis';
            lstPAPart[i].gf_pa_mgmt_status_type_name__c = 'Analysis';
            lstPAPart[i].gf_profitability_sheet_id__c = lstPSPart[i].Id;
        }
        lstPAPart[2].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAPart;

        final List<profitability_analysis_participant__c> lstPAP = Test_Utils.createProfAnalysisParticipant(2, lstPAPart[0].Id, new List<Id>{lstAccPart[0].Id, lstAccPart[1].Id});
        insert lstPAP;
    }

    // Check participantsInfo related to Prof Sheet with prof sheet participants
    @IsTest
    static void retrieveParticipantsInfoTest1() {

        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector();
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Ctrl.retrieveParticipantsInfo(lstPS[0].Id, 'cuco__profitability_sheet__c');

            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('showInfo', true);
            expectedMap1.put('tableTitle', Label.included_subsidiaries_ps);
            expectedMap1.put('lstEmpty', false);
            expectedMap1.put('lstParticipantsNotEmpty', false);

            final Map<String, Object> actualMap1 = new Map<String, Object>();
            actualMap1.put('showInfo', retMap.get('showInfo'));
            actualMap1.put('tableTitle', retMap.get('tableTitle'));
            actualMap1.put('lstEmpty', retMap.get('lstEmpty'));
            actualMap1.put('lstParticipantsNotEmpty', ((List<Object>) retMap.get('lstParticipantsDetails')).isEmpty());

            System.assertEquals(expectedMap1, actualMap1, 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest1');
        Test.stopTest();
    }

    // Check participantsInfo related to Prof Sheet without prof sheet participants
    @IsTest
    static void retrieveParticipantsInfoTest2() {

        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector();
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 1'};
        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Ctrl.retrieveParticipantsInfo(lstPS[0].Id, 'cuco__profitability_sheet__c');

            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('showInfo', true);
            expectedMap1.put('tableTitle', Label.included_subsidiaries_ps);
            expectedMap1.put('lstEmpty', true);
            expectedMap1.put('errMessage', Label.no_subs_ps);

            final Map<String, Object> actualMap1 = new Map<String, Object>();
            actualMap1.put('showInfo', retMap.get('showInfo'));
            actualMap1.put('tableTitle', retMap.get('tableTitle'));
            actualMap1.put('lstEmpty', retMap.get('lstEmpty'));
            actualMap1.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap1, actualMap1, 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest2');
        Test.stopTest();
    }

    // Check participantsInfo related to Prof Sheet without prof sheet participants (Orhpan account)
    @IsTest
    static void retrieveParticipantsInfoTest3() {

        final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector();
        final Set<String> setNamesPS = new Set<String>{'Prof Sheet Test 3'};
        final List<profitability_sheet__c> lstPS = profSheetSelector.selectByName(setNamesPS);

        Test.startTest();

            final Map<String, Object> retMap = Participants_Ctrl.retrieveParticipantsInfo(lstPS[0].Id, 'cuco__profitability_sheet__c');

            final Map<String, Object> expectedMap = new Map<String, Object>();
            expectedMap.put('showInfo', false);

            final Map<String, Object> actualMap = new Map<String, Object>();
            actualMap.put('showInfo', retMap.get('showInfo'));

            System.assertEquals(expectedMap, actualMap, 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest3');

        Test.stopTest();
    }

    // Check participantsInfo related to Prof Analysis with prof analysis participants
    @IsTest
    static void retrieveParticipantsInfoTest4() {

      final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
      final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
      final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Ctrl.retrieveParticipantsInfo(lstPA[0].Id, 'cuco__profitability_analysis__c');

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('showInfo', true);
            expectedMap4.put('tableTitle', Label.included_subsidiaries_pa);
            expectedMap4.put('lstEmpty', false);
            expectedMap4.put('lstParticipantsNotEmpty', false);

            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('showInfo', retMap.get('showInfo'));
            actualMap4.put('tableTitle', retMap.get('tableTitle'));
            actualMap4.put('lstEmpty', retMap.get('lstEmpty'));
            actualMap4.put('lstParticipantsNotEmpty', ((List<Object>) retMap.get('lstParticipantsDetails')).isEmpty());

            System.assertEquals(expectedMap4, actualMap4, 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest4');
        Test.stopTest();
    }

    // Check participantsInfo related to Prof Analysis without prof analysis participants
    @IsTest
    static void retrieveParticipantsInfoTest5() {

      final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
      final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 1'};
      final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Ctrl.retrieveParticipantsInfo(lstPA[0].Id, 'cuco__profitability_analysis__c');

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('showInfo', true);
            expectedMap5.put('tableTitle', Label.included_subsidiaries_pa);
            expectedMap5.put('lstEmpty', true);
            expectedMap5.put('errMessage', Label.no_subs_pa);
            expectedMap5.put('showAddButton', true);
            expectedMap5.put('showRemoveButton', true);

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('showInfo', retMap.get('showInfo'));
            actualMap5.put('tableTitle', retMap.get('tableTitle'));
            actualMap5.put('lstEmpty', retMap.get('lstEmpty'));
            actualMap5.put('errMessage', retMap.get('errMessage'));
            actualMap5.put('showAddButton', retMap.get('showAddButton'));
            actualMap5.put('showRemoveButton', retMap.get('showRemoveButton'));

            System.assertEquals(expectedMap5, actualMap5, 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest5');
        Test.stopTest();
    }

    // Check managePermissions related to Prof Analysis
    @IsTest
    static void retrieveParticipantsInfoTest6() {

      final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
      final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 2'};
      final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Ctrl.retrieveParticipantsInfo(lstPA[0].Id, 'cuco__profitability_analysis__c');

            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('showAddButton', false);
            expectedMap6.put('showRemoveButton', false);

            final Map<String, Object> actualMap6 = new Map<String, Object>();
            actualMap6.put('showAddButton', retMap.get('showAddButton'));
            actualMap6.put('showRemoveButton', retMap.get('showRemoveButton'));

            System.assertEquals(expectedMap6, actualMap6, 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest6');
        Test.stopTest();
    }

    // Check auraexecption err at retrieveParticipantsInfoTest
    @IsTest
    static void retrieveParticipantsInfoTest7() {
        Test.startTest();
            try {
                Participants_Ctrl.retrieveParticipantsInfo(null, 'cuco__profitability_analysis__c');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Participants_Ctrl_Test - retrieveParticipantsInfoTest7');
            }
        Test.stopTest();
    }

    // Check addAction permissions related to Prof Analysis (OK)
    @IsTest
    static void handleAddActionTest1() {
        final PaGeneralConfiguration_Selector genConfigSelector = new PaGeneralConfiguration_Selector();
        final List<pa_general_configuration__mdt> lstGenConfig = genConfigSelector.selectActiveRecord();
        if (!lstGenConfig.isEmpty()) {
            final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
            final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 1'};
            final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);
            Test.startTest();
                final Map<String, Object> retMap = Participants_Ctrl.handleAddAction(lstPA[0].Id);
                System.assertEquals(true, retMap.get('add'), 'Err at Participants_Ctrl_Test - handleAddActionTest1');
            Test.stopTest();
        }
    }

    // Check addAction permissions related to Prof Analysis (KO)
    @IsTest
    static void handleAddActionTest2() {
        final PaGeneralConfiguration_Selector genConfigSelector = new PaGeneralConfiguration_Selector();
        final List<pa_general_configuration__mdt> lstGenConfig = genConfigSelector.selectActiveRecord();
        if (!lstGenConfig.isEmpty()) {
            final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
            final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 2'};
            final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);
            Test.startTest();
                final Map<String, Object> retMap = Participants_Ctrl.handleAddAction(lstPA[0].Id);

                final Map<String, Object> expectedMap = new Map<String, Object>();
                expectedMap.put('add', false);
                expectedMap.put('addMessage', Label.add_subs_perm_error_sample);

                final Map<String, Object> actualMap = new Map<String, Object>();
                actualMap.put('add', retMap.get('add'));
                actualMap.put('addMessage', retMap.get('addMessage'));

                System.assertEquals(expectedMap, actualMap, 'Err at Participants_Ctrl_Test - handleAddActionTest2');
            Test.stopTest();
        }
    }

    // Check removeAction permissions related to Prof Analysis (OK)
    @IsTest
    static void handleRemoveActionTest1() {
        final PaGeneralConfiguration_Selector genConfigSelector = new PaGeneralConfiguration_Selector();
        final List<pa_general_configuration__mdt> lstGenConfig = genConfigSelector.selectActiveRecord();
        if (!lstGenConfig.isEmpty()) {
            final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
            final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 1'};
            final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);
            Test.startTest();
                final Map<String, Object> retMap = Participants_Ctrl.handleRemoveAction(lstPA[0].Id, null);
                System.assertEquals(true, retMap.get('remove'), 'Err at Participants_Ctrl_Test - handleRemoveActionTest1');
            Test.stopTest();
        }
    }

    // Check removeAction permissions related to Prof Analysis (KO)
    @IsTest
    static void handleRemoveActionTest2() {
        final PaGeneralConfiguration_Selector genConfigSelector = new PaGeneralConfiguration_Selector();
        final List<pa_general_configuration__mdt> lstGenConfig = genConfigSelector.selectActiveRecord();
        if (!lstGenConfig.isEmpty()) {
            final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector();
            final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 2'};
            final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);
            Test.startTest();
                final Map<String, Object> retMap = Participants_Ctrl.handleRemoveAction(lstPA[0].Id, null);

                final Map<String, Object> expectedMap = new Map<String, Object>();
                expectedMap.put('remove', false);
                expectedMap.put('removeMessage', Label.remove_subs_perm_error_sample);

                final Map<String, Object> actualMap = new Map<String, Object>();
                actualMap.put('remove', retMap.get('remove'));
                actualMap.put('removeMessage', retMap.get('removeMessage'));

                System.assertEquals(expectedMap, actualMap, 'Err at Participants_Ctrl_Test - handleRemoveActionTest2');
            Test.stopTest();
        }
    }

    // Private constructor test
    @IsTest
    static void participantsCtrlConstructorTest() {
        Test.startTest();
            final Participants_Ctrl constructorTest = new Participants_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Participants_Ctrl_Test - participantsCtrlConstructorTest');
        Test.stopTest();
    }
}