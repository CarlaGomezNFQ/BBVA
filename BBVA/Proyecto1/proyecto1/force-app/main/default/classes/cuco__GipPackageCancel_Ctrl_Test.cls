/**
* ────────────────────────────────────────────────────────────────────
* GipPackageCancel_Ctrl_Test
* Test class for GipPackageCancel_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-05
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class GipPackageCancel_Ctrl_Test {

    @TestSetup
    static void makeDataGipCancelPkg() {

        // Create parent acc
        final List<Account> lstGipPkgCancelAcc = Test_Utils.createAccounts(1);
        lstGipPkgCancelAcc[0].AccountNumber = 'B99999999';
        insert lstGipPkgCancelAcc;

        // Create child accs
        final List<Account> lstGipPkgCancelChildAcc = Test_Utils.createAccounts(5);
        for (Account acc : lstGipPkgCancelChildAcc) {
            acc.ParentId = lstGipPkgCancelChildAcc[0].Id;
        }
        insert lstGipPkgCancelChildAcc;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgGipCancelPkg = Test_Utils.createPSCatalogPackage(5, 'G');
        insert lstPSCatPkgGipCancelPkg;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSGipCancelPkg = Test_Utils.createProfSheet(1, lstGipPkgCancelAcc[0]);
        insert lstPSGipCancelPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAGipCancelPkg = Test_Utils.createProfAnalysis(5, lstGipPkgCancelAcc[0]);
        for (profitability_analysis__c paGipCancelPkg : lstPAGipCancelPkg) {
            paGipCancelPkg.gf_pa_management_type_name__c = 'New';
            paGipCancelPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paGipCancelPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paGipCancelPkg.gf_profitability_sheet_id__c = lstPSGipCancelPkg[0].Id;
        }
        lstPAGipCancelPkg[1].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAGipCancelPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPGipCancel = new List<profitability_analysis_participant__c>();
        lstPAPGipCancel.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAGipCancelPkg[0].Id, new List<Id>{lstGipPkgCancelChildAcc[0].Id, lstGipPkgCancelChildAcc[1].Id}));
        lstPAPGipCancel.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipCancelPkg[2].Id, new List<Id>{lstGipPkgCancelChildAcc[2].Id}));
        lstPAPGipCancel.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipCancelPkg[3].Id, new List<Id>{lstGipPkgCancelChildAcc[3].Id}));
        lstPAPGipCancel.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipCancelPkg[4].Id, new List<Id>{lstGipPkgCancelChildAcc[4].Id}));
        insert lstPAPGipCancel;

        // Create client packages
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(5, lstGipPkgCancelChildAcc, lstPSCatPkgGipCancelPkg);
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPRGipCancel = new List<profitability_analysis_pkg_request__c>();
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqGipCancel1 = Test_Utils.createProfAnPkgReq(1, lstPAGipCancelPkg[0].Id, 'Extension');
        lstPAPkgReqGipCancel1[0].gf_cust_package_id__c = lstCP[0].Id;
        lstPAPkgReqGipCancel1[0].gf_psc_package_id__c = lstPSCatPkgGipCancelPkg[0].Id;
        lstPAPRGipCancel.addAll(lstPAPkgReqGipCancel1);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqGipCancel2 = Test_Utils.createProfAnPkgReq(1, lstPAGipCancelPkg[2].Id, 'New');
        lstPAPkgReqGipCancel2[0].gf_cust_package_id__c = lstCP[2].Id;
        lstPAPkgReqGipCancel2[0].participant_id__c = lstPAPGipCancel[2].Id;
        lstPAPkgReqGipCancel2[0].gf_psc_package_id__c = lstPSCatPkgGipCancelPkg[1].Id;
        lstPAPRGipCancel.addAll(lstPAPkgReqGipCancel2);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqGipCancel3 = Test_Utils.createProfAnPkgReq(1, lstPAGipCancelPkg[3].Id, 'Cancellation');
        lstPAPkgReqGipCancel3[0].gf_cust_package_id__c = lstCP[3].Id;
        lstPAPkgReqGipCancel3[0].participant_id__c = lstPAPGipCancel[3].Id;
        lstPAPkgReqGipCancel3[0].gf_psc_package_id__c = lstPSCatPkgGipCancelPkg[2].Id;
        lstPAPRGipCancel.addAll(lstPAPkgReqGipCancel3);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqGipCancel4 = Test_Utils.createProfAnPkgReq(1, lstPAGipCancelPkg[4].Id, 'Modification');
        lstPAPkgReqGipCancel4[0].gf_cust_package_id__c = lstCP[4].Id;
        lstPAPkgReqGipCancel4[0].participant_id__c = lstPAPGipCancel[4].Id;
        lstPAPkgReqGipCancel4[0].gf_psc_package_id__c = lstPSCatPkgGipCancelPkg[3].Id;
        lstPAPRGipCancel.addAll(lstPAPkgReqGipCancel4);
        insert lstPAPRGipCancel;
    }

    // Check doGipCancelChecks with pkg no related with any participant
    @IsTest
    static void doGipCancelChecks1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        final PsCatalogPackage_Selector psCatalogPkgSelector1 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg1 = psCatalogPkgSelector1.selectByPkgCode(new Set<String>{'G0001'});

        Test.startTest();

            final Map<String, Object> retGMap1 = GipPackageCancel_Ctrl.doGipCancelChecks(lstPA1[0].Id, lstPsCatPkg1[0].Id);
            final Map<String, Object> expectedGMap1 = new Map<String, Object>();
            expectedGMap1.put('hasNotParticipant', true);
            System.assertEquals(expectedGMap1, retGMap1, 'Err at GipPackageCancel_Ctrl_Test - doGipCancelChecks1');

        Test.stopTest();
    }

    // Check doGipCancelChecks with pkg related with participant
    @IsTest
    static void doGipCancelChecks2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        final PsCatalogPackage_Selector psCatalogPkgSelector2 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg2 = psCatalogPkgSelector2.selectByPkgCode(new Set<String>{'G0000'});

        Test.startTest();

            final Map<String, Object> retGMap2 = GipPackageCancel_Ctrl.doGipCancelChecks(lstPA2[0].Id, lstPsCatPkg2[0].Id);
            final Map<String, Object> expectedGMap2 = new Map<String, Object>();
            expectedGMap2.put('hasNotParticipant', false);
            System.assertEquals(expectedGMap2, retGMap2, 'Err at GipPackageCancel_Ctrl_Test - doGipCancelChecks2');

        Test.stopTest();
    }

    // Check doGipCancelChecks exception error
    @IsTest
    static void doGipCancelChecks3() {
        Test.startTest();
            try {
                GipPackageCancel_Ctrl.doGipCancelChecks(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at GipPackageCancel_Ctrl_Test - doGipCancelChecks3');
            }
        Test.stopTest();
    }

    // Check doRemoveGipCancelActions first exception (no cancel permissions)
    @IsTest
    static void doRemoveGipCancelActions1() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        Test.startTest();

            final Map<String, Object> actualGMap3 = GipPackageCancel_Ctrl.doRemoveGipCancelActions(lstPA3[0].Id, '{"type": "G"}');
            final Map<String, Object> expectedGMap3 = new Map<String, Object>();
            expectedGMap3.put('isSuccess', false);
            expectedGMap3.put('errMessage', Label.pkg_cancel_perm_error_sample);
            expectedGMap3.put('toastType', 'warning');
            System.assertEquals(expectedGMap3, actualGMap3, 'Err at GipPackageCancel_Ctrl_Test - doRemoveGipCancelActions1');

        Test.stopTest();
    }

    // Check doRemoveGipCancelActions with cancel permissions New Request test
    @IsTest
    static void doRemoveGipCancelActions2() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        final List<Package_Wrapper> lstPW4 = Packages_Service.getPackagesToShow(lstPA4[0].Id, 'GIP_PACKAGE');

        PAPackageRequest_Selector paprSelector4 = new PAPackageRequest_Selector();
        List<profitability_analysis_pkg_request__c> lstPAPRBF4 = paprSelector4.selectPkgReqByAccAndReqType(new Set<Id>{lstPW4[0].participant.id}, new List<String>{'New'});

        Test.startTest();

            final Map<String, Object> retGMap4 = GipPackageCancel_Ctrl.doRemoveGipCancelActions(lstPA4[0].Id, JSON.serialize(lstPW4[0]));

            List<profitability_analysis_pkg_request__c> lstPAPRAF4 = paprSelector4.selectPkgReqByAccAndReqType(new Set<Id>{lstPW4[0].participant.id}, new List<String>{'New'});

            final Map<String, Object> actualGMap4 = new Map<String, Object>();
            actualGMap4.put('isSuccess', retGMap4.get('isSuccess'));
            actualGMap4.put('sizeBefore', lstPAPRBF4.size());
            actualGMap4.put('sizeAfter', lstPAPRAF4.size());
            final Map<String, Object> expectedGMap4 = new Map<String, Object>();
            expectedGMap4.put('isSuccess', true);
            expectedGMap4.put('sizeBefore', 1);
            expectedGMap4.put('sizeAfter', 0);
            System.assertEquals(expectedGMap4, actualGMap4, 'Err at GipPackageCancel_Ctrl_Test - doRemoveGipCancelActions2');

        Test.stopTest();
    }

    // Check doRemoveGipCancelActions with cancel permissions Cancellation Request test
    @IsTest
    static void doRemoveGipCancelActions3() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        final List<Package_Wrapper> lstPW5 = Packages_Service.getPackagesToShow(lstPA5[0].Id, 'GIP_PACKAGE');

        PAPackageRequest_Selector paprSelector5 = new PAPackageRequest_Selector();
        List<profitability_analysis_pkg_request__c> lstPAPRBF5 = paprSelector5.selectPkgReqByAccAndReqType(new Set<Id>{lstPW5[0].participant.id}, new List<String>{'Cancellation'});

        Test.startTest();

            final Map<String, Object> retGMap5 = GipPackageCancel_Ctrl.doRemoveGipCancelActions(lstPA5[0].Id, JSON.serialize(lstPW5[0]));

            List<profitability_analysis_pkg_request__c> lstPAPRAF5 = paprSelector5.selectPkgReqByAccAndReqType(new Set<Id>{lstPW5[0].participant.id}, new List<String>{'Cancellation'});

            final Map<String, Object> actualGMap5 = new Map<String, Object>();
            actualGMap5.put('isSuccess', retGMap5.get('isSuccess'));
            actualGMap5.put('sizeBefore', lstPAPRBF5.size());
            actualGMap5.put('sizeAfter', lstPAPRAF5.size());
            final Map<String, Object> expectedGMap5 = new Map<String, Object>();
            expectedGMap5.put('isSuccess', true);
            expectedGMap5.put('sizeBefore', 1);
            expectedGMap5.put('sizeAfter', 0);
            System.assertEquals(expectedGMap5, actualGMap5, 'Err at GipPackageCancel_Ctrl_Test - doRemoveGipCancelActions3');

        Test.stopTest();
    }

    // Check doRemoveGipCancelActions with cancel permissions Modification Request test
    @IsTest
    static void doRemoveGipCancelActions4() {

        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA6 = profAnSelector6.selectByName(setNamesPA6);

        final List<Package_Wrapper> lstPW6 = Packages_Service.getPackagesToShow(lstPA6[0].Id, 'GIP_PACKAGE');

        PAPackageRequest_Selector paprSelector6 = new PAPackageRequest_Selector();
        List<profitability_analysis_pkg_request__c> lstPAPRBF6 = paprSelector6.selectPkgReqByAccAndReqType(new Set<Id>{lstPW6[0].participant.id}, new List<String>{'Modification'});

        Test.startTest();

            final Map<String, Object> retGMap6 = GipPackageCancel_Ctrl.doRemoveGipCancelActions(lstPA6[0].Id, JSON.serialize(lstPW6[0]));

            List<profitability_analysis_pkg_request__c> lstPAPRAF6 = paprSelector6.selectPkgReqByAccAndReqType(new Set<Id>{lstPW6[0].participant.id}, new List<String>{'Modification'});
            List<profitability_analysis_pkg_request__c> lstPAPRCancellation = paprSelector6.selectPkgReqByAccAndReqType(new Set<Id>{lstPW6[0].participant.id}, new List<String>{'Cancellation'});

            final Map<String, Object> actualGMap6 = new Map<String, Object>();
            actualGMap6.put('isSuccess', retGMap6.get('isSuccess'));
            actualGMap6.put('sizeBefore', lstPAPRBF6.size());
            actualGMap6.put('sizeAfter', lstPAPRAF6.size());
            actualGMap6.put('sizeCancellation', lstPAPRCancellation.size());
            final Map<String, Object> expectedGMap6 = new Map<String, Object>();
            expectedGMap6.put('isSuccess', true);
            expectedGMap6.put('sizeBefore', 1);
            expectedGMap6.put('sizeAfter', 0);
            expectedGMap6.put('sizeCancellation', 1);
            System.assertEquals(expectedGMap6, actualGMap6, 'Err at GipPackageCancel_Ctrl_Test - doRemoveGipCancelActions4');

        Test.stopTest();
    }

    // Check doRemoveGipCancelActions exception error
    @IsTest
    static void doRemoveGipCancelActionsN() {
        Test.startTest();
            try {
                GipPackageCancel_Ctrl.doRemoveGipCancelActions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at GipPackageCancel_Ctrl_Test - doRemoveGipCancelActionsN');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void gipPacakgeCancelConstructorTest() {
        Test.startTest();
            final GipPackageCancel_Ctrl constructorTest = new GipPackageCancel_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at GipPackageCancel_Ctrl_Test - gipPacakgeCancelConstructorTest');
        Test.stopTest();
    }

}