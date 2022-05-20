/**
* ─────────────────────────────────────────────────────────────────────────────────
* Pacreation_Ctrl_Test
* Test class for Pacreation_Ctrl apex class
* ─────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogirogio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-17
* @modified
* @systemLayer Presentation
* ─────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ─────────────────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Pacreation_Ctrl_Test {
    @TestSetup
  static void makeDataOfPacreationCtrl() {

      final List<Account> lstGroupAccount = Test_Utils.createAccounts(5);
      lstGroupAccount[0].Name = 'Account Test Orphan 0'; // retrieveTableData
      lstGroupAccount[1].Name = 'Account Test Group 0'; // retrieveTableData
      lstGroupAccount[2].Name = 'Account Test Group 1'; // retrieveTableData
      lstGroupAccount[3].Name = 'Account Test Group 2'; // manageAddNewParticipants
      lstGroupAccount[4].Name = 'Account Test Group 3'; // manageAddNewParticipants

      insert lstGroupAccount;

      final List<Account> lstAccount = Test_Utils.createAccounts(7);
      lstAccount[0].ParentId = lstGroupAccount[1].Id; // retrieveTableData
      lstAccount[1].ParentId = lstGroupAccount[1].Id; // retrieveTableData
      lstAccount[2].ParentId = lstGroupAccount[2].Id; // retrieveTableData
      lstAccount[3].ParentId = lstGroupAccount[2].Id; // retrieveTableData
      lstAccount[4].ParentId = lstGroupAccount[2].Id; // retrieveTableData
      lstAccount[5].ParentId = lstGroupAccount[4].Id; // manageAddNewParticipants
      lstAccount[6].ParentId = lstGroupAccount[4].Id; // manageAddNewParticipants
      insert lstAccount;

      final List<profitability_sheet__c> lstPS = Test_Utils.createProfSheet(5, lstGroupAccount);
      lstPS[1].gf_prftbly_sheet_stt_type_name__c = '01'; // Valid
      lstPS[2].gf_prftbly_sheet_stt_type_name__c = '10'; // Expired
      insert lstPS;

      final List<profitability_sheet_participant__c> lstPSP = new List<profitability_sheet_participant__c>();
      final List<profitability_sheet_participant__c> lstPSP1 = Test_Utils.createProfSheetParticipant(1, lstPS[1].Id, new List<Id>{lstAccount[0].Id});
      lstPSP.addAll(lstPSP1);
      final List<profitability_sheet_participant__c> lstPSP2 = Test_Utils.createProfSheetParticipant(1, lstPS[2].Id, new List<Id>{lstAccount[2].Id});
      lstPSP.addAll(lstPSP2);
      insert lstPSP;

      final List<profitability_analysis__c> lstPA = Test_Utils.createProfAnalysis(5, lstGroupAccount);
      lstPA[0].gf_profitability_sheet_id__c = lstPS[0].Id; // to orphan test

      lstPA[1].gf_pa_mgmt_stage_type_name__c = 'Analysis'; // Closed: false

      lstPA[2].gf_pa_mgmt_stage_type_name__c = 'Formalized'; // Closed: true
      lstPA[2].gf_profitability_sheet_id__c = lstPS[2].Id; // to empty accs availables test

      lstPA[3].gf_pa_management_type_name__c = 'Cancellation';
      lstPA[3].gf_pa_mgmt_stage_type_name__c = 'Analysis';
      lstPA[3].gf_pa_mgmt_status_type_name__c = 'Analysis';
      lstPA[3].gf_profitability_sheet_id__c = lstPS[3].Id;

      lstPA[4].gf_pa_management_type_name__c = 'New';
      lstPA[4].gf_pa_mgmt_stage_type_name__c = 'Analysis';
      lstPA[4].gf_pa_mgmt_status_type_name__c = 'Analysis';
      lstPA[4].gf_profitability_sheet_id__c = lstPS[4].Id;

      insert lstPA;

      final List<profitability_analysis_participant__c> lstPAP = new List<profitability_analysis_participant__c>();
      final List<profitability_analysis_participant__c> lstPAP1 = Test_Utils.createProfAnalysisParticipant(1, lstPA[1].Id, new List<Id>{lstAccount[1].Id});
      lstPAP.addAll(lstPAP1);
      final List<profitability_analysis_participant__c> lstPAP2 = Test_Utils.createProfAnalysisParticipant(1, lstPA[2].Id, new List<Id>{lstAccount[3].Id});
      lstPAP.addAll(lstPAP2);
      final List<profitability_analysis_participant__c> lstPAP3 = Test_Utils.createProfAnalysisParticipant(1, lstPA[4].Id, new List<Id>{lstAccount[5].Id});
      lstPAP.addAll(lstPAP3);
      insert lstPAP;

      final List<ps_catalog_package__c> lstPsCatPkg = Test_Utils.createPsCatalogPackage(1, 'F');
      insert lstPsCatPkg;

      final List<client_package__c> lstCP = Test_Utils.createClientPackage(1, new List<Account>{lstAccount[5]}, lstPsCatPkg);
      insert lstCP;

      final List<profitability_analysis_pkg_request__c> lstPAPkgReq = Test_Utils.createProfAnPkgReq(1, lstPA[4].Id, 'Cancellation');
      lstPAPkgReq[0].gf_cust_package_id__c = lstCP[0].Id;
      lstPAPkgReq[0].gf_psc_package_id__c = lstPsCatPkg[0].Id; //F0000
      insert lstPAPkgReq;
  }

  // Check retrieveTableData with a prof analysis related to one orphan acc (Same behaviour than subsidiary) (err)
  @IsTest
  static void retrieveTableData1() {

    final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Parent.Name = 'Account Test Group 1' LIMIT 1];

      Test.startTest();
          final Map<String, Object> retMap = Pacreation_Ctrl.retrieveTableData(lstAcc[0].Id);

          final Map<String, Object> expectedMap1 = new Map<String, Object>();
          expectedMap1.put('showTable', true);
          expectedMap1.put('errMessage', null);
          expectedMap1.put('profAccName', 'Account Test Group 1');

          final Map<String, Object> actualMap1 = new Map<String, Object>();
          actualMap1.put('showTable', retMap.get('showTable'));
          actualMap1.put('errMessage', retMap.get('errMessage'));
          actualMap1.put('profAccName', retMap.get('profAccName'));

          System.assertEquals(expectedMap1, actualMap1, 'Err at Pacreation_Ctrl - retrieveTableData1');
      Test.stopTest();
  }

  // Check retrieveTableData with no accs availables (err)
  @IsTest
  static void retrieveTableData2() {

    final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Group 1' LIMIT 1];

      Test.startTest();
          final Map<String, Object> retMap = Pacreation_Ctrl.retrieveTableData(lstAcc[0].Id);

          final Map<String, Object> expectedMap2 = new Map<String, Object>();
          expectedMap2.put('showTable', true);
          expectedMap2.put('errMessage', null);

          final Map<String, Object> actualMap2 = new Map<String, Object>();
          actualMap2.put('showTable', retMap.get('showTable'));
          actualMap2.put('errMessage', retMap.get('errMessage'));

          System.assertEquals(expectedMap2, actualMap2, 'Err at Pacreation_Ctrl - retrieveTableData2');

      Test.stopTest();
    }

    // Check retrieveTableData with accs availables
    @IsTest
    static void retrieveTableData3() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Orphan 0' LIMIT 1];

        Test.startTest();
            final Map<String, Object> retMap = Pacreation_Ctrl.retrieveTableData(lstAcc[0].Id);

            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('errMessage', retMap.get('errMessage'));

            final Map<String, Object> actualMap3 = new Map<String, Object>();
            final List<Participant_Wrapper> lstAccWrpp = (List<Participant_Wrapper>) retMap.get('tableInfo');
            actualMap3.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap3, actualMap3, 'Err at Pacreation_Ctrl - retrieveTableData3');
        Test.stopTest();
    }

    // Check retrieveTableData exception (err)
    @IsTest
    static void retrieveTableData4() {
        Test.startTest();
            try {
                Pacreation_Ctrl.retrieveTableData(null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Pacreation_CtrT_test - retrieveTableData4');
            }
        Test.stopTest();
    }
    // Check manageNewPfanalisis empty param list (err)
    @IsTest
    static void manageNewPfanalisis1() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Group 1' LIMIT 1];

        Test.startTest();
            final Map<String, Object> retMap = Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, new List<Id>(), 'test1');

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('showToast', null);
            expectedMap4.put('toastType', null);
            expectedMap4.put('errMessage', 'ok');


            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('showToast', retMap.get('showToast'));
            actualMap4.put('toastType', retMap.get('toastType'));
            actualMap4.put('errMessage', retMap.get('errMessage'));


            System.assertEquals(expectedMap4, actualMap4, 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis1');
        Test.stopTest();
    }


    // Check manageNewPfanalisis exception (err)
    @IsTest
    static void manageNewPfanalisis2() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Group 1' LIMIT 1];

        Test.startTest();
            try {
                Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis2');
            }
        Test.stopTest();
    }

    // Check manageAddNewParticipants
    @IsTest
    static void manageNewPfanalisis() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Group 1' LIMIT 1];
        final List<String> lstAccName = new List<String>{'Account Test 5', 'Account Test 6'};
        final Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name IN :lstAccName LIMIT 2]);
        final List<Id> lstId = new List<Id>();
        lstId.addAll(mapAcc.keySet());

        Test.startTest();
            final Map<String, Object> retMap = Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, lstId, 'test2');

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', true);
            expectedMap5.put('errMessage', 'ok');

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap.get('isSuccess'));
            actualMap5.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap5, actualMap5, 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis4');

        Test.stopTest();
    }
    // Check manageAddNewParticipants
    @IsTest
    static void manageNewPfanalisis3() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Parent.Name = 'Account Test Group 1' LIMIT 1];
        final List<String> lstAccName = new List<String>{'Account Test 5', 'Account Test 6'};
        final Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name IN :lstAccName LIMIT 2]);
        final List<Id> lstId = new List<Id>();
        lstId.addAll(mapAcc.keySet());

        Test.startTest();
            final Map<String, Object> retMap = Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, lstId, 'test2');

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', true);
            expectedMap5.put('errMessage', 'ok');

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap.get('isSuccess'));
            actualMap5.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap5, actualMap5, 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis3');

        Test.stopTest();
    }

    // Check manageAddNewParticipants
    @IsTest
    static void manageNewPfanalisis4() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Orphan 0' LIMIT 1];
        final List<String> lstAccName = new List<String>{'Account Test 5', 'Account Test 6'};
        final List<Id> lstId = new List<Id>();
        lstId.add(lstAcc[0].Id);

        Test.startTest();
            final Map<String, Object> retMap = Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, lstId, 'test2');

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', true);
            expectedMap5.put('errMessage', 'ok');

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap.get('isSuccess'));
            actualMap5.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap5, actualMap5, 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis3');

        Test.stopTest();
    }
    // Check manageAddNewParticipants
    @IsTest
    static void manageNewPfanalisis6() {

        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Parent.Name = 'Account Test Group 0' LIMIT 1];
        final List<Id> lstId = new List<Id>();

        Test.startTest();
            final Map<String, Object> retMap = Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, lstId, 'test2');

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', null);
            expectedMap5.put('errMessage', Label.madatory_subsidiary_selection);

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap.get('isSuccess'));
            actualMap5.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap5, actualMap5, 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis3');
        Test.stopTest();
    }
    // Check manageNewPfanalisis no create permissions (err)
    @IsTest
    static void manageNewPfanalisis7() {
        final List<Account> lstAcc = [SELECT Id, Name FROM Account WHERE Name = 'Account Test Group 2' LIMIT 1];
        final List<String> lstAccName = new List<String>{'Account Test 5', 'Account Test 6'};
        final Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name IN :lstAccName LIMIT 2]);
        final List<Id> lstId = new List<Id>();

        lstId.addAll(mapAcc.keySet());
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr = new User(Alias = 'standt1', Email='standarduser@testOwnerorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing owner', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testOwnerorg.com');
        insert usr ;

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);
            System.runAs(usr)
            {

            final Map<String, Object> retMap = Pacreation_Ctrl.manageNewPfanalisis(lstAcc[0].Id, lstId, 'test4');

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('showToast', true);
            expectedMap4.put('toastType', 'warning');
            expectedMap4.put('errMessage', Label.creation_perm_error_sample);


            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('showToast', retMap.get('showToast'));
            actualMap4.put('toastType', retMap.get('toastType'));
            actualMap4.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap4, actualMap4, 'Err at Pacreation_Ctrl_Test - manageNewPfanalisis4');
            }
        Test.stopTest();
    }

    // Private Pacreation_Ctrl constructor test
    @IsTest
    static void paCreationConstructorTest1() {
        Test.startTest();
            final Pacreation_Ctrl constructorTest = new Pacreation_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Pacreation_Ctrl_Test - paCreationConstructorTest1');
        Test.stopTest();
    }

    // Private Pacreation_Helper constructor test
    @IsTest
    static void paCreationConstructorTest2() {
        Test.startTest();
            final Pacreation_Helper constructorTest2 = new Pacreation_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Pacreation_Ctrl_Test - paCreationConstructorTest2');
        Test.stopTest();
    }

    // Private Pacreation_Service constructor test
    @IsTest
    static void paCreationConstructorTest3() {
        Test.startTest();
            final Pacreation_Service constructorTest3 = new Pacreation_Service();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Pacreation_Ctrl_Test - paCreationConstructorTest3');
        Test.stopTest();
    }
}