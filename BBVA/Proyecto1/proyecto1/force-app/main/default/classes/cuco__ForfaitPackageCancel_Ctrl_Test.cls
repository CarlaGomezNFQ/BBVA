/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackageCancel_Ctrl_Test
* Test class for ForfaitPackageCancel_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-28
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ForfaitPackageCancel_Ctrl_Test {

    @TestSetup
    static void makeDataForfaitCancelPkg() {

        // Create parent acc
        final List<Account> lstForfaitPkgCancelAcc = Test_Utils.createAccounts(1);
        lstForfaitPkgCancelAcc[0].AccountNumber = 'B99999999';
        insert lstForfaitPkgCancelAcc;

        // Create child accs
        final List<Account> lstForfaitPkgCancelChildAcc = Test_Utils.createAccounts(5);
        for (Account acc : lstForfaitPkgCancelChildAcc) {
            acc.ParentId = lstForfaitPkgCancelChildAcc[0].Id;
        }
        insert lstForfaitPkgCancelChildAcc;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgForfaitCancelPkg = Test_Utils.createPSCatalogPackage(5, 'F');
        insert lstPSCatPkgForfaitCancelPkg;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSForfaitCancelPkg = Test_Utils.createProfSheet(1, lstForfaitPkgCancelAcc[0]);
        insert lstPSForfaitCancelPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAForfaitCancelPkg = Test_Utils.createProfAnalysis(5, lstForfaitPkgCancelAcc[0]);
        for (profitability_analysis__c paForfaitCancelPkg : lstPAForfaitCancelPkg) {
            paForfaitCancelPkg.gf_pa_management_type_name__c = 'New';
            paForfaitCancelPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paForfaitCancelPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paForfaitCancelPkg.gf_profitability_sheet_id__c = lstPSForfaitCancelPkg[0].Id;
        }
        lstPAForfaitCancelPkg[1].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAForfaitCancelPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPForfaitCancel = new List<profitability_analysis_participant__c>();
        lstPAPForfaitCancel.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitCancelPkg[0].Id, new List<Id>{lstForfaitPkgCancelChildAcc[0].Id, lstForfaitPkgCancelChildAcc[1].Id}));
        lstPAPForfaitCancel.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitCancelPkg[2].Id, new List<Id>{lstForfaitPkgCancelChildAcc[2].Id}));
        lstPAPForfaitCancel.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitCancelPkg[3].Id, new List<Id>{lstForfaitPkgCancelChildAcc[3].Id}));
        lstPAPForfaitCancel.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitCancelPkg[4].Id, new List<Id>{lstForfaitPkgCancelChildAcc[4].Id}));
        insert lstPAPForfaitCancel;

        // Create client packages
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(5, lstForfaitPkgCancelChildAcc, lstPSCatPkgForfaitCancelPkg);
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPRForfaitCancel = new List<profitability_analysis_pkg_request__c>();
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitCancel1 = Test_Utils.createProfAnPkgReq(1, lstPAForfaitCancelPkg[0].Id, 'Extension');
        lstPAPkgReqForfaitCancel1[0].gf_cust_package_id__c = lstCP[0].Id;
        lstPAPkgReqForfaitCancel1[0].gf_psc_package_id__c = lstPSCatPkgForfaitCancelPkg[0].Id; //F0000
        lstPAPRForfaitCancel.addAll(lstPAPkgReqForfaitCancel1);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitCancel2 = Test_Utils.createProfAnPkgReq(1, lstPAForfaitCancelPkg[2].Id, 'New');
        lstPAPkgReqForfaitCancel2[0].gf_cust_package_id__c = lstCP[2].Id;
        lstPAPkgReqForfaitCancel2[0].participant_id__c = lstPAPForfaitCancel[2].Id;
        lstPAPkgReqForfaitCancel2[0].gf_psc_package_id__c = lstPSCatPkgForfaitCancelPkg[1].Id; //F0001
        lstPAPRForfaitCancel.addAll(lstPAPkgReqForfaitCancel2);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitCancel3 = Test_Utils.createProfAnPkgReq(1, lstPAForfaitCancelPkg[3].Id, 'Cancellation');
        lstPAPkgReqForfaitCancel3[0].gf_cust_package_id__c = lstCP[3].Id;
        lstPAPkgReqForfaitCancel3[0].participant_id__c = lstPAPForfaitCancel[3].Id;
        lstPAPkgReqForfaitCancel3[0].gf_psc_package_id__c = lstPSCatPkgForfaitCancelPkg[2].Id; //F0002
        lstPAPRForfaitCancel.addAll(lstPAPkgReqForfaitCancel3);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitCancel4 = Test_Utils.createProfAnPkgReq(1, lstPAForfaitCancelPkg[4].Id, 'Modification');
        lstPAPkgReqForfaitCancel4[0].gf_cust_package_id__c = lstCP[4].Id;
        lstPAPkgReqForfaitCancel4[0].participant_id__c = lstPAPForfaitCancel[4].Id;
        lstPAPkgReqForfaitCancel4[0].gf_psc_package_id__c = lstPSCatPkgForfaitCancelPkg[3].Id; //F0003
        lstPAPRForfaitCancel.addAll(lstPAPkgReqForfaitCancel4);
        insert lstPAPRForfaitCancel;

    }

    // Check doForfaitCancelChecks with pkg no related with any participant
    @IsTest
    static void doForfaitCancelChecks1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        final PsCatalogPackage_Selector psCatalogPkgSelector1 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg1 = psCatalogPkgSelector1.selectByPkgCode(new Set<String>{'F0001'});

        Test.startTest();

            final Map<String, Object> retFMap1 = ForfaitPackageCancel_Ctrl.doForfaitCancelChecks(lstPA1[0].Id, lstPsCatPkg1[0].Id);
            final Map<String, Object> expectedFMap1 = new Map<String, Object>();
            expectedFMap1.put('hasNotParticipant', true);
            System.assertEquals(expectedFMap1, retFMap1, 'Err at ForfaitPackageCancel_Ctrl_Test - doForfaitCancelChecks1');

        Test.stopTest();
    }

    // Check doForfaitCancelChecks with pkg related with participant
    @IsTest
    static void doForfaitCancelChecks2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        final PsCatalogPackage_Selector psCatalogPkgSelector2 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg2 = psCatalogPkgSelector2.selectByPkgCode(new Set<String>{'F0000'});

        Test.startTest();

            final Map<String, Object> retFMap2 = ForfaitPackageCancel_Ctrl.doForfaitCancelChecks(lstPA2[0].Id, lstPsCatPkg2[0].Id);
            final Map<String, Object> expectedFMap2 = new Map<String, Object>();
            expectedFMap2.put('hasNotParticipant', false);
            System.assertEquals(expectedFMap2, retFMap2, 'Err at ForfaitPackageCancel_Ctrl_Test - doForfaitCancelChecks2');

        Test.stopTest();
    }

    // Check doForfaitCancelChecks exception error
    @IsTest
    static void doForfaitCancelChecks3() {
        Test.startTest();
            try {
                ForfaitPackageCancel_Ctrl.doForfaitCancelChecks(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ForfaitPackageCancel_Ctrl_Test - doForfaitCancelChecks3');
            }
        Test.stopTest();
    }

    // Check doRemoveForfaitCancelActions first exception (no cancel permissions)
    @IsTest
    static void doRemoveForfaitCancelActions1() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        Test.startTest();

            final Map<String, Object> actualFMap3 = ForfaitPackageCancel_Ctrl.doRemoveForfaitCancelActions(lstPA3[0].Id, '{"type": "F"}');
            final Map<String, Object> expectedFMap3 = new Map<String, Object>();
            expectedFMap3.put('isSuccess', false);
            expectedFMap3.put('errMessage', Label.pkg_cancel_perm_error_sample);
            expectedFMap3.put('toastType', 'warning');
            System.assertEquals(expectedFMap3, actualFMap3, 'Err at ForfaitPackageCancel_Ctrl_Test - doRemoveForfaitCancelActions1');

        Test.stopTest();
    }

    // Check doRemoveForfaitCancelActions with cancel permissions New Request test
    @IsTest
    static void doRemoveForfaitCancelActions2() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        final List<Package_Wrapper> lstPW4 = Packages_Service.getPackagesToShow(lstPA4[0].Id, 'FORFAIT');

        PAPackageRequest_Selector paprSelector4 = new PAPackageRequest_Selector();
        List<profitability_analysis_pkg_request__c> lstPAPRBF4 = paprSelector4.selectPkgReqByAccAndReqType(new Set<Id>{lstPW4[0].participant.id}, new List<String>{'New'});

        Test.startTest();

            final Map<String, Object> retFMap4 = ForfaitPackageCancel_Ctrl.doRemoveForfaitCancelActions(lstPA4[0].Id, JSON.serialize(lstPW4[0]));

            List<profitability_analysis_pkg_request__c> lstPAPRAF4 = paprSelector4.selectPkgReqByAccAndReqType(new Set<Id>{lstPW4[0].participant.id}, new List<String>{'New'});

            final Map<String, Object> actualFMap4 = new Map<String, Object>();
            actualFMap4.put('isSuccess', retFMap4.get('isSuccess'));
            actualFMap4.put('sizeBefore', lstPAPRBF4.size());
            actualFMap4.put('sizeAfter', lstPAPRAF4.size());
            final Map<String, Object> expectedFMap4 = new Map<String, Object>();
            expectedFMap4.put('isSuccess', true);
            expectedFMap4.put('sizeBefore', 1);
            expectedFMap4.put('sizeAfter', 0);
            System.assertEquals(expectedFMap4, actualFMap4, 'Err at ForfaitPackageCancel_Ctrl_Test - doRemoveForfaitCancelActions2');

        Test.stopTest();
    }

    // Check doRemoveForfaitCancelActions with cancel permissions Cancellation Request test
    @IsTest
    static void doRemoveForfaitCancelActions3() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        final List<Package_Wrapper> lstPW5 = Packages_Service.getPackagesToShow(lstPA5[0].Id, 'FORFAIT');

        PAPackageRequest_Selector paprSelector5 = new PAPackageRequest_Selector();
        List<profitability_analysis_pkg_request__c> lstPAPRBF5 = paprSelector5.selectPkgReqByAccAndReqType(new Set<Id>{lstPW5[0].participant.id}, new List<String>{'Cancellation'});

        Test.startTest();

            final Map<String, Object> retFMap5 = ForfaitPackageCancel_Ctrl.doRemoveForfaitCancelActions(lstPA5[0].Id, JSON.serialize(lstPW5[0]));

            List<profitability_analysis_pkg_request__c> lstPAPRAF5 = paprSelector5.selectPkgReqByAccAndReqType(new Set<Id>{lstPW5[0].participant.id}, new List<String>{'Cancellation'});

            final Map<String, Object> actualFMap5 = new Map<String, Object>();
            actualFMap5.put('isSuccess', retFMap5.get('isSuccess'));
            actualFMap5.put('sizeBefore', lstPAPRBF5.size());
            actualFMap5.put('sizeAfter', lstPAPRAF5.size());
            final Map<String, Object> expectedFMap5 = new Map<String, Object>();
            expectedFMap5.put('isSuccess', true);
            expectedFMap5.put('sizeBefore', 1);
            expectedFMap5.put('sizeAfter', 0);
            System.assertEquals(expectedFMap5, actualFMap5, 'Err at ForfaitPackageCancel_Ctrl_Test - doRemoveForfaitCancelActions3');

        Test.stopTest();
    }

    // Check doRemoveForfaitCancelActions with cancel permissions Modification Request test
    @IsTest
    static void doRemoveForfaitCancelActions4() {

        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA6 = profAnSelector6.selectByName(setNamesPA6);

        final List<Package_Wrapper> lstPW6 = Packages_Service.getPackagesToShow(lstPA6[0].Id, 'FORFAIT');

        PAPackageRequest_Selector paprSelector6 = new PAPackageRequest_Selector();
        List<profitability_analysis_pkg_request__c> lstPAPRBF6 = paprSelector6.selectPkgReqByAccAndReqType(new Set<Id>{lstPW6[0].participant.id}, new List<String>{'Modification'});

        Test.startTest();

            final Map<String, Object> retFMap6 = ForfaitPackageCancel_Ctrl.doRemoveForfaitCancelActions(lstPA6[0].Id, JSON.serialize(lstPW6[0]));

            List<profitability_analysis_pkg_request__c> lstPAPRAF6 = paprSelector6.selectPkgReqByAccAndReqType(new Set<Id>{lstPW6[0].participant.id}, new List<String>{'Modification'});
            List<profitability_analysis_pkg_request__c> lstPAPRCancellation = paprSelector6.selectPkgReqByAccAndReqType(new Set<Id>{lstPW6[0].participant.id}, new List<String>{'Cancellation'});

            final Map<String, Object> actualFMap6 = new Map<String, Object>();
            actualFMap6.put('isSuccess', retFMap6.get('isSuccess'));
            actualFMap6.put('sizeBefore', lstPAPRBF6.size());
            actualFMap6.put('sizeAfter', lstPAPRAF6.size());
            actualFMap6.put('sizeCancellation', lstPAPRCancellation.size());
            final Map<String, Object> expectedFMap6 = new Map<String, Object>();
            expectedFMap6.put('isSuccess', true);
            expectedFMap6.put('sizeBefore', 1);
            expectedFMap6.put('sizeAfter', 0);
            expectedFMap6.put('sizeCancellation', 1);
            System.assertEquals(expectedFMap6, actualFMap6, 'Err at ForfaitPackageCancel_Ctrl_Test - doRemoveForfaitCancelActions4');

        Test.stopTest();
    }

    // Check doRemoveForfaitCancelActions exception error
    @IsTest
    static void doRemoveForfaitCancelActionsN() {
        Test.startTest();
            try {
                ForfaitPackageCancel_Ctrl.doRemoveForfaitCancelActions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ForfaitPackageCancel_Ctrl_Test - doRemoveForfaitCancelActionsN');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void forfaitPacakgeCancelConstructorTest() {
        Test.startTest();
            final ForfaitPackageCancel_Ctrl constructorTest = new ForfaitPackageCancel_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at ForfaitPackageCancel_Ctrl_Test - forfaitPacakgeCancelConstructorTest');
        Test.stopTest();
    }
}