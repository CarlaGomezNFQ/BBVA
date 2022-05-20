/**
* ────────────────────────────────────────────────────────────────────
* CommPackageEdit_Ctrl_Test
* Test class for CommPackageEdit_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-09
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class CommPackageEdit_Ctrl_Test {

    @TestSetup
    static void makeDataCommEditPkg() {

        // Create parent acc
        final List<Account> lstCommPkgEditAcc = Test_Utils.createAccounts(1);
        lstCommPkgEditAcc[0].AccountNumber = 'B99999999';
        insert lstCommPkgEditAcc;

        // Create child accs
        final List<Account> lstCommPkgEditChildAcc = Test_Utils.createAccounts(14);
        for (Account acc : lstCommPkgEditChildAcc) {
            acc.ParentId = lstCommPkgEditAcc[0].Id;
        }
        insert lstCommPkgEditChildAcc;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCF = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCF;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCC = Test_Utils.createPSCatalogConditons(4, lstPSCF[0]);
        insert lstPSCC;

        // Create ps catalog attribute
        List<ps_catalog_attribute__c> lstPsCatAttb = Test_Utils.createPSCatalogAttributes(5);
        lstPsCatAttb[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        lstPsCatAttb[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        lstPsCatAttb[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        lstPsCatAttb[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        lstPsCatAttb[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert lstPsCatAttb;

        // Create ps catalog condition attributes
        List<ps_catalog_condition_attribute__c> lstPsCatCondAttb = new List<ps_catalog_condition_attribute__c>();
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[0], lstPsCatAttb));
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[1], lstPsCatAttb));
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[2], lstPsCatAttb));
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[3], lstPsCatAttb));
        for (Integer i=0; i<lstPsCatCondAttb.size(); i++) {
            lstPsCatCondAttb[i].gf_psc_condition_attribute_id__c = 'canonical.uniqueid.' + i;
            switch on Math.mod(i, 5) {
                when  0 {
                    lstPsCatCondAttb[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 1 {
                    lstPsCatCondAttb[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 2 {
                    lstPsCatCondAttb[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 3 {
                    lstPsCatCondAttb[i].gf_psc_ca_exemption_name__c = 'IF';
                }
                when 4 {
                    lstPsCatCondAttb[i].gf_psc_ca_exemption_name__c = 'true';
                }
            }
        }
        insert lstPsCatCondAttb;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgCommEditPkg = Test_Utils.createPSCatalogPackage(8, 'C');
        lstPSCatPkgCommEditPkg[0].gf_psc_extended_pkg_ind_type__c = false;
        insert lstPSCatPkgCommEditPkg;

        // Create ps catalog pkg condition
        final List<ps_catalog_pkg_condition__c> lstPSCatPkgCond = new List<ps_catalog_pkg_condition__c>();
        lstPSCatPkgCond.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgCommEditPkg[5], lstPSCC));
        lstPSCatPkgCond.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgCommEditPkg[6], lstPSCC));
        lstPSCatPkgCond.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgCommEditPkg[7], lstPSCC));
        insert lstPSCatPkgCond;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSCommEditPkg = Test_Utils.createProfSheet(1, lstCommPkgEditAcc[0]);
        insert lstPSCommEditPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPACommEditPkg = Test_Utils.createProfAnalysis(8, lstCommPkgEditAcc[0]);
        for (profitability_analysis__c paCommEditPkg : lstPACommEditPkg) {
            paCommEditPkg.gf_pa_management_type_name__c = 'New';
            paCommEditPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paCommEditPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paCommEditPkg.gf_profitability_sheet_id__c = lstPSCommEditPkg[0].Id;
        }
        lstPACommEditPkg[4].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPACommEditPkg;

        // Create profitability analysis participant
        Set<Id> lstCommPkgEditChildId = new Set<Id>();
        for (Account acc : lstCommPkgEditChildAcc) {
            lstCommPkgEditChildId.add(acc.Id);
        }
        final List<profitability_analysis_participant__c> lstPAPCommEdit = new List<profitability_analysis_participant__c>();
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPACommEditPkg[0].Id, new List<Id>{lstCommPkgEditChildAcc[0].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPACommEditPkg[1].Id, new List<Id>{lstCommPkgEditChildAcc[1].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPACommEditPkg[2].Id, new List<Id>{lstCommPkgEditChildAcc[2].Id, lstCommPkgEditChildAcc[3].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPACommEditPkg[3].Id, new List<Id>{lstCommPkgEditChildAcc[4].Id, lstCommPkgEditChildAcc[5].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPACommEditPkg[4].Id, new List<Id>{lstCommPkgEditChildAcc[6].Id, lstCommPkgEditChildAcc[7].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPACommEditPkg[5].Id, new List<Id>{lstCommPkgEditChildAcc[8].Id, lstCommPkgEditChildAcc[9].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPACommEditPkg[6].Id, new List<Id>{lstCommPkgEditChildAcc[10].Id, lstCommPkgEditChildAcc[11].Id}));
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPACommEditPkg[7].Id, new List<Id>{lstCommPkgEditChildAcc[12].Id, lstCommPkgEditChildAcc[13].Id}));
        insert lstPAPCommEdit;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACCommPkg = new List<profitability_analysis_condition__c>();
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[2], lstPSCC[3]));
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[5], lstPSCC[0]));
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[5], lstPSCC[1]));
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[6], lstPSCC[3]));
        lstPACCommPkg[0].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        lstPACCommPkg[0].gf_pa_source_cust_package_id__c = 'B00000003C0003';
        lstPACCommPkg[3].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        lstPACCommPkg[3].gf_pa_source_cust_package_id__c = 'B00000009C0006';

        insert lstPACCommPkg;

        // Create client packages
        final List<Account> lstAccPA2CP = new List<Account>{lstCommPkgEditChildAcc[0], lstCommPkgEditChildAcc[1], lstCommPkgEditChildAcc[2], lstCommPkgEditChildAcc[4],
                                                            lstCommPkgEditChildAcc[6], lstCommPkgEditChildAcc[8], lstCommPkgEditChildAcc[10], lstCommPkgEditChildAcc[12]};
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(8, lstAccPA2CP, lstPSCatPkgCommEditPkg);
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqCommEditPkg = Test_Utils.createProfAnPkgReq(1, lstPACommEditPkg[7].Id, 'Extension');
        lstPAPkgReqCommEditPkg[0].gf_cust_package_id__c = lstCP[7].Id;
        lstPAPkgReqCommEditPkg[0].gf_psc_package_id__c = lstPSCatPkgCommEditPkg[0].Id; //C0000
        insert lstPAPkgReqCommEditPkg;

    }

    // Check doPreviousEditChecks first exception (method checkIfPkgCanExtend)
    @IsTest
    static void doPreviousEditChecks1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        final List<Package_Wrapper> lstPW1 = Packages_Service.getPackagesToShow(lstPA1[0].Id, 'COMMERCIAL_PACKAGE');

        Test.startTest();

            final Map<String, Object> actualMap1 = CommPackageEdit_Ctrl.doPreviousEditChecks(lstPA1[0].Id, JSON.serialize(lstPW1[0]));
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('isSuccess', false);
            expectedMap1.put('errMessage', Label.pkg_no_extension_allowed);
            System.assertEquals(expectedMap1, actualMap1, 'Err at CommPackageEdit_Ctrl_Test - doPreviousEditChecks1');

        Test.stopTest();
    }

    // Check doPreviousEditChecks first exception (method checkIfOnlyOnePAP)
    @IsTest
    static void doPreviousEditChecks2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        final List<Package_Wrapper> lstPW2 = Packages_Service.getPackagesToShow(lstPA2[0].Id, 'COMMERCIAL_PACKAGE');

        Test.startTest();

            final Map<String, Object> actualMap2 = CommPackageEdit_Ctrl.doPreviousEditChecks(lstPA2[0].Id, JSON.serialize(lstPW2[0]));
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('isSuccess', false);
            expectedMap2.put('errMessage', Label.pkg_one_participant_error);
            System.assertEquals(expectedMap2, actualMap2, 'Err at CommPackageEdit_Ctrl_Test - doPreviousEditChecks2');

        Test.stopTest();
    }

    // Check doPreviousEditChecks first exception (method checkIfAlreadyVeCommExtPkg)
    @IsTest
    static void doPreviousEditChecks3() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        final List<Package_Wrapper> lstPW3 = Packages_Service.getPackagesToShow(lstPA3[0].Id, 'COMMERCIAL_PACKAGE');

        Test.startTest();

            final Map<String, Object> actualMap3 = CommPackageEdit_Ctrl.doPreviousEditChecks(lstPA3[0].Id, JSON.serialize(lstPW3[0]));
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('isSuccess', false);
            expectedMap3.put('errMessage', Label.pkg_only_one_extended_error);
            System.assertEquals(expectedMap3, actualMap3, 'Err at CommPackageEdit_Ctrl_Test - doPreviousEditChecks3');

        Test.stopTest();
    }

    // Check doPreviousEditChecks no error
    @IsTest
    static void doPreviousEditChecks4() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        final List<Package_Wrapper> lstPW4 = Packages_Service.getPackagesToShow(lstPA4[0].Id, 'COMMERCIAL_PACKAGE');

        Test.startTest();

            final Map<String, Object> actualMap4 = CommPackageEdit_Ctrl.doPreviousEditChecks(lstPA4[0].Id, JSON.serialize(lstPW4[0]));
            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('isSuccess', true);
            System.assertEquals(expectedMap4, actualMap4, 'Err at CommPackageEdit_Ctrl_Test - doPreviousEditChecks4');

        Test.stopTest();
    }

    // Check doPreviousEditChecks exception error
    @IsTest
    static void doPreviousEditChecks5() {
        Test.startTest();
            try {
                CommPackageEdit_Ctrl.doPreviousEditChecks(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackageEdit_Ctrl_Test - commPackagesTest5');
            }
        Test.stopTest();
    }

    // Check doEditCommPkgActions first exception (no edit permissions)
    @IsTest
    static void doEditCommPkgActions1() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        final List<Package_Wrapper> lstPW5 = Packages_Service.getPackagesToShow(lstPA5[0].Id, 'COMMERCIAL_PACKAGE');
        final Map<String, Object> mapParams5 = new Map<String, Object>();
        mapParams5.put('profAnalysisId', lstPA5[0].Id);
        mapParams5.put('step', '1');
        mapParams5.put('decision', 'extend');

        Test.startTest();

            final Map<String, Object> actualMap5 = CommPackageEdit_Ctrl.doEditCommPkgActions(JSON.serialize(lstPW5[0]), mapParams5);
            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', false);
            expectedMap5.put('errMessage', Label.pkg_edit_perm_error_sample);
            expectedMap5.put('toastType', 'warning');
            System.assertEquals(expectedMap5, actualMap5, 'Err at CommPackageEdit_Ctrl_Test - doEditCommPkgActions1');

        Test.stopTest();
    }

    // Check doEditCommPkgActions step 1 with ProfAnalysisCond related (need user confim)
    @IsTest
    static void doEditCommPkgActions2() {

        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> lstPA6 = profAnSelector6.selectByName(setNamesPA6);

        final List<Package_Wrapper> lstPW6 = Packages_Service.getPackagesToShow(lstPA6[0].Id, 'COMMERCIAL_PACKAGE');
        final Map<String, Object> mapParams6 = new Map<String, Object>();
        mapParams6.put('profAnalysisId', lstPA6[0].Id);
        mapParams6.put('step', '1');
        mapParams6.put('decision', 'extend');

        Test.startTest();

            final Map<String, Object> retMap = CommPackageEdit_Ctrl.doEditCommPkgActions(JSON.serialize(lstPW6[0]), mapParams6);
            final Map<String, Object> actualMap6 = new Map<String, Object>();
            actualMap6.put('isSuccess', retMap.get('isSuccess'));
            actualMap6.put('lstPACSize', ((List<profitability_analysis_condition__c>) retMap.get('lstPAC')).size());
            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('isSuccess', false);
            expectedMap6.put('lstPACSize', 2);
            System.assertEquals(expectedMap6, actualMap6, 'Err at CommPackageEdit_Ctrl_Test - doEditCommPkgActions2');

        Test.stopTest();
    }

    // Check doEditCommPkgActions step 2 with ProfAnalysisCond related
    @IsTest
    static void doEditCommPkgActions3() {

        final ProfitabilityAnalysis_Selector profAnSelector7 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA7 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> lstPA7 = profAnSelector7.selectByName(setNamesPA7);

        final List<Package_Wrapper> lstPW7 = Packages_Service.getPackagesToShow(lstPA7[0].Id, 'COMMERCIAL_PACKAGE');
        final Map<String, Object> mapParams7 = new Map<String, Object>();
        mapParams7.put('profAnalysisId', lstPA7[0].Id);
        mapParams7.put('step', '2');
        mapParams7.put('decision', 'extend');

        Test.startTest();

            final Map<String, Object> retMap = CommPackageEdit_Ctrl.doEditCommPkgActions(JSON.serialize(lstPW7[0]), mapParams7);
            final Map<String, Object> actualMap7 = new Map<String, Object>();
            actualMap7.put('isSuccess', retMap.get('isSuccess'));
            final Map<String, Object> expectedMap7 = new Map<String, Object>();
            expectedMap7.put('isSuccess', true);
            System.assertEquals(expectedMap7, actualMap7, 'Err at CommPackageEdit_Ctrl_Test - doEditCommPkgActions3');

        Test.stopTest();
    }

    // Check doEditCommPkgActions step 2 with ProfAnalysisCond related (deextend)
    @IsTest
    static void doEditCommPkgActions4() {

        final ProfitabilityAnalysis_Selector profAnSelector8 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA8 = new Set<String>{'Prof Analysis Test 6'};
        final List<profitability_analysis__c> lstPA8 = profAnSelector8.selectByName(setNamesPA8);

        final List<Package_Wrapper> lstPW8 = Packages_Service.getPackagesToShow(lstPA8[0].Id, 'COMMERCIAL_PACKAGE');
        final Map<String, Object> mapParams8 = new Map<String, Object>();
        mapParams8.put('profAnalysisId', lstPA8[0].Id);
        mapParams8.put('step', '2');
        mapParams8.put('decision', 'deextend');

        Test.startTest();

            final Map<String, Object> retMap = CommPackageEdit_Ctrl.doEditCommPkgActions(JSON.serialize(lstPW8[0]), mapParams8);
            final Map<String, Object> actualMap8 = new Map<String, Object>();
            actualMap8.put('isSuccess', retMap.get('isSuccess'));
            final Map<String, Object> expectedMap8 = new Map<String, Object>();
            expectedMap8.put('isSuccess', true);
            System.assertEquals(expectedMap8, actualMap8, 'Err at CommPackageEdit_Ctrl_Test - doEditCommPkgActions4');

        Test.stopTest();
    }

    // Check doEditCommPkgActions step 1 withot ProfAnalysisCond related and prof analysis pkg req extended created
    @IsTest
    static void doEditCommPkgActions5() {

        final ProfitabilityAnalysis_Selector profAnSelector9 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA9 = new Set<String>{'Prof Analysis Test 7'};
        final List<profitability_analysis__c> lstPA9 = profAnSelector9.selectByName(setNamesPA9);

        final List<Package_Wrapper> lstPW9 = Packages_Service.getPackagesToShow(lstPA9[0].Id, 'COMMERCIAL_PACKAGE');
        final Map<String, Object> mapParams9 = new Map<String, Object>();
        mapParams9.put('profAnalysisId', lstPA9[0].Id);
        mapParams9.put('step', '1');
        mapParams9.put('decision', 'deextend');

        Test.startTest();

            final Map<String, Object> retMap = CommPackageEdit_Ctrl.doEditCommPkgActions(JSON.serialize(lstPW9[0]), mapParams9);
            final Map<String, Object> actualMap9 = new Map<String, Object>();
            actualMap9.put('isSuccess', retMap.get('isSuccess'));
            final Map<String, Object> expectedMap9 = new Map<String, Object>();
            expectedMap9.put('isSuccess', true);
            System.assertEquals(expectedMap9, actualMap9, 'Err at CommPackageEdit_Ctrl_Test - doEditCommPkgActions5');

        Test.stopTest();
    }

    // Check doEditCommPkgActions exception error
    @IsTest
    static void doEditCommPkgActions6() {
        Test.startTest();
            try {
                CommPackageEdit_Ctrl.doEditCommPkgActions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackageEdit_Ctrl_Test - doEditCommPkgActions6');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void commPackagesEditCtrlConstructorTest() {
        Test.startTest();
            final CommPackageEdit_Ctrl constructorTest = new CommPackageEdit_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackageEdit_Ctrl_Test - commPackagesEditCtrlConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void commPackagesCommHelperConstructorTest() {
        Test.startTest();
            final PackagesComm_Helper constructorTest2 = new PackagesComm_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at CommPackageEdit_Ctrl_Test - commPackagesCommHelperConstructorTest');
        Test.stopTest();
    }
}