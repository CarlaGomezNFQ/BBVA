/**
* ────────────────────────────────────────────────────────────────────
* Participants_Add_Ctrl_Test
* Test class for Participants_Add_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-17
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Participants_Add_Ctrl_Test {

  @TestSetup
  static void makeDataOfParticipantsAddCtrl() {

      final List<Account> lstGroupAccPartA = Test_Utils.createAccounts(5);
      lstGroupAccPartA[0].Name = 'Account Test Orphan 0'; // retrieveTableData
      lstGroupAccPartA[1].Name = 'Account Test Group 0'; // retrieveTableData
      lstGroupAccPartA[2].Name = 'Account Test Group 1'; // retrieveTableData
      lstGroupAccPartA[3].Name = 'Account Test Group 2'; // manageAddNewParticipants
      lstGroupAccPartA[4].Name = 'Account Test Group 3'; // manageAddNewParticipants

      insert lstGroupAccPartA;

      final List<Account> lstAccPartA = Test_Utils.createAccounts(7);
      lstAccPartA[0].ParentId = lstGroupAccPartA[1].Id; // retrieveTableData
      lstAccPartA[1].ParentId = lstGroupAccPartA[1].Id; // retrieveTableData
      lstAccPartA[2].ParentId = lstGroupAccPartA[2].Id; // retrieveTableData
      lstAccPartA[3].ParentId = lstGroupAccPartA[2].Id; // retrieveTableData
      lstAccPartA[4].ParentId = lstGroupAccPartA[2].Id; // retrieveTableData
      lstAccPartA[5].ParentId = lstGroupAccPartA[4].Id; // manageAddNewParticipants
      lstAccPartA[6].ParentId = lstGroupAccPartA[4].Id; // manageAddNewParticipants
      insert lstAccPartA;

      final List<profitability_sheet__c> lstPSPAdd = Test_Utils.createProfSheet(5, lstGroupAccPartA);
      lstPSPAdd[1].gf_prftbly_sheet_stt_type_name__c = '01'; // Valid
      lstPSPAdd[2].gf_prftbly_sheet_stt_type_name__c = '10'; // Expired
      insert lstPSPAdd;

      final List<profitability_sheet_participant__c> lstPSP = new List<profitability_sheet_participant__c>();
      final List<profitability_sheet_participant__c> lstPSP1 = Test_Utils.createProfSheetParticipant(1, lstPSPAdd[1].Id, new List<Id>{lstAccPartA[0].Id});
      lstPSP.addAll(lstPSP1);
      final List<profitability_sheet_participant__c> lstPSP2 = Test_Utils.createProfSheetParticipant(1, lstPSPAdd[2].Id, new List<Id>{lstAccPartA[2].Id});
      lstPSP.addAll(lstPSP2);
      insert lstPSP;

      final List<profitability_analysis__c> lstPAPartAdd = Test_Utils.createProfAnalysis(5, lstGroupAccPartA);
      lstPAPartAdd[0].gf_profitability_sheet_id__c = lstPSPAdd[0].Id; // to orphan test

      lstPAPartAdd[1].gf_pa_mgmt_stage_type_name__c = 'Analysis'; // Closed: false

      lstPAPartAdd[2].gf_pa_mgmt_stage_type_name__c = 'Formalized'; // Closed: true
      lstPAPartAdd[2].gf_profitability_sheet_id__c = lstPSPAdd[2].Id; // to empty accs availables test

      lstPAPartAdd[3].gf_pa_management_type_name__c = 'Cancellation';
      lstPAPartAdd[3].gf_pa_mgmt_stage_type_name__c = 'Analysis';
      lstPAPartAdd[3].gf_pa_mgmt_status_type_name__c = 'Analysis';
      lstPAPartAdd[3].gf_profitability_sheet_id__c = lstPSPAdd[3].Id;

      lstPAPartAdd[4].gf_pa_management_type_name__c = 'New';
      lstPAPartAdd[4].gf_pa_mgmt_stage_type_name__c = 'Analysis';
      lstPAPartAdd[4].gf_pa_mgmt_status_type_name__c = 'Analysis';
      lstPAPartAdd[4].gf_profitability_sheet_id__c = lstPSPAdd[4].Id;

      insert lstPAPartAdd;

      final List<profitability_analysis_participant__c> lstPAP = new List<profitability_analysis_participant__c>();
      final List<profitability_analysis_participant__c> lstPAP1 = Test_Utils.createProfAnalysisParticipant(1, lstPAPartAdd[1].Id, new List<Id>{lstAccPartA[1].Id});
      lstPAP.addAll(lstPAP1);
      final List<profitability_analysis_participant__c> lstPAP2 = Test_Utils.createProfAnalysisParticipant(1, lstPAPartAdd[2].Id, new List<Id>{lstAccPartA[3].Id});
      lstPAP.addAll(lstPAP2);
      final List<profitability_analysis_participant__c> lstPAP3 = Test_Utils.createProfAnalysisParticipant(1, lstPAPartAdd[4].Id, new List<Id>{lstAccPartA[5].Id});
      lstPAP.addAll(lstPAP3);
      insert lstPAP;

      final List<ps_catalog_package__c> lstPsCatPkg = Test_Utils.createPsCatalogPackage(1, 'F');
      insert lstPsCatPkg;

      final List<client_package__c> lstCP = Test_Utils.createClientPackage(1, new List<Account>{lstAccPartA[5]}, lstPsCatPkg);
      insert lstCP;

      final List<profitability_analysis_pkg_request__c> lstPAPkgReq = Test_Utils.createProfAnPkgReq(1, lstPAPartAdd[4].Id, 'Cancellation');
      lstPAPkgReq[0].gf_cust_package_id__c = lstCP[0].Id;
      lstPAPkgReq[0].gf_psc_package_id__c = lstPsCatPkg[0].Id; //F0000
      insert lstPAPkgReq;
  }

  // Check retrieveTableData with a prof analysis related to one orphan acc (Same behaviour than subsidiary) (err)
  @IsTest
  static void retrieveTableData1() {

      final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
      final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
      final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

      Test.startTest();
          final Map<String, Object> retMap = Participants_Add_Ctrl.retrieveTableData(lstPA[0].Id);

          final Map<String, Object> expectedMap1 = new Map<String, Object>();
          expectedMap1.put('showTable', false);
          expectedMap1.put('errMessage', Label.not_allow_add_participants);
          expectedMap1.put('profAccName', lstPA[0].participant_id__r.Name);

          final Map<String, Object> actualMap1 = new Map<String, Object>();
          actualMap1.put('showTable', retMap.get('showTable'));
          actualMap1.put('errMessage', retMap.get('errMessage'));
          actualMap1.put('profAccName', retMap.get('profAccName'));

          System.assertEquals(expectedMap1, actualMap1, 'Err at Participants_Add_Ctrl_Test - retrieveTableData1');

      Test.stopTest();
  }

  // Check retrieveTableData with no accs availables (err)
  @IsTest
  static void retrieveTableData2() {

      final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
      final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 1'};
      final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

      Test.startTest();
          final Map<String, Object> retMap = Participants_Add_Ctrl.retrieveTableData(lstPA[0].Id);

          final Map<String, Object> expectedMap2 = new Map<String, Object>();
          expectedMap2.put('showTable', false);
          expectedMap2.put('errMessage', Label.not_available_group_ps);

          final Map<String, Object> actualMap2 = new Map<String, Object>();
          actualMap2.put('showTable', retMap.get('showTable'));
          actualMap2.put('errMessage', retMap.get('errMessage'));

          System.assertEquals(expectedMap2, actualMap2, 'Err at Participants_Add_Ctrl_Test - retrieveTableData2');

      Test.stopTest();
    }

    // Check retrieveTableData with accs availables
    @IsTest
    static void retrieveTableData3() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Add_Ctrl.retrieveTableData(lstPA[0].Id);

            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('showTable', true);
            expectedMap3.put('lstWrapperSize', 3);

            final Map<String, Object> actualMap3 = new Map<String, Object>();
            final List<Participant_Wrapper> lstAccWrpp = (List<Participant_Wrapper>) retMap.get('tableInfo');
            actualMap3.put('showTable', retMap.get('showTable'));
            actualMap3.put('lstWrapperSize', lstAccWrpp.size());

            System.assertEquals(expectedMap3, actualMap3, 'Err at Participants_Add_Ctrl_Test - retrieveTableData3');

        Test.stopTest();
    }

    // Check retrieveTableData exception (err)
    @IsTest
    static void retrieveTableData4() {
        Test.startTest();
            try {
                Participants_Add_Ctrl.retrieveTableData(null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Participants_Add_Ctrl_Test - retrieveTableData4');
            }
        Test.stopTest();
    }

    // Check manageAddNewParticipants no add permissions (err)
    @IsTest
    static void manageAddNewParticipants1() {
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Add_Ctrl.manageNewParticipants(lstPA[0].Id, null);

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('showToast', true);
            expectedMap4.put('toastType', 'warning');
            expectedMap4.put('errMessage', Label.add_subs_perm_error_sample);


            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('showToast', retMap.get('showToast'));
            actualMap4.put('toastType', retMap.get('toastType'));
            actualMap4.put('errMessage', retMap.get('errMessage'));


            System.assertEquals(expectedMap4, actualMap4, 'Err at Participants_Add_Ctrl_Test - manageAddNewParticipants1');

        Test.stopTest();
    }

    // Check manageAddNewParticipants empty param list (err)
    @IsTest
    static void manageAddNewParticipants2() {
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retMap = Participants_Add_Ctrl.manageNewParticipants(lstPA[0].Id, new List<Id>());

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('showEmptyErr', true);
            expectedMap5.put('errMessage', Label.madatory_subsidiary_selection);


            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('showEmptyErr', retMap.get('showEmptyErr'));
            actualMap5.put('errMessage', retMap.get('errMessage'));


            System.assertEquals(expectedMap5, actualMap5, 'Err at Participants_Add_Ctrl_Test - manageAddNewParticipants2');

        Test.stopTest();
    }

    // Check manageAddNewParticipants exception (err)
    @IsTest
    static void manageAddNewParticipants3() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        Test.startTest();
            try {
                Participants_Add_Ctrl.manageNewParticipants(lstPA[0].Id, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Participants_Add_Ctrl_Test - manageAddNewParticipants3');
            }
        Test.stopTest();
    }

    // Check manageAddNewParticipants
    @IsTest
    static void manageAddNewParticipants4() {
        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final List<String> lstAccName = new List<String>{'Account Test 5', 'Account Test 6'};
        final Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name IN :lstAccName LIMIT 2]);
        final List<Id> lstId = new List<Id>();
        lstId.addAll(mapAcc.keySet());

        Test.startTest();
            final Map<String, Object> retMap = Participants_Add_Ctrl.manageNewParticipants(lstPA[0].Id, lstId);

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', true);
            expectedMap5.put('errMessage', new List<String>());

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap.get('isSuccess'));
            actualMap5.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap5, actualMap5, 'Err at Participants_Add_Ctrl_Test - manageAddNewParticipants4');

        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void participantsAddCtrlConstructorTest() {
        Test.startTest();
            final Participants_Add_Ctrl constructorTest = new Participants_Add_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Participants_Add_Ctrl_Test - participantsAddCtrlConstructorTest');
        Test.stopTest();
    }
}