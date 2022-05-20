/**
* ────────────────────────────────────────────────────────────────────
* GipPackageEdit_Ctrl_Test
* Test class for GipPackageEdit_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-04
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class GipPackageEdit_Ctrl_Test {

    @TestSetup
    static void makeDataGipEditPkg() {

        // Create parent acc
        final List<Account> lstGipPkgEditAcc = Test_Utils.createAccounts(1);
        lstGipPkgEditAcc[0].AccountNumber = 'B99999999';
        insert lstGipPkgEditAcc;

        // Create child accs
        final List<Account> lstGipPkgEditChildAcc = Test_Utils.createAccounts(3);
        for (Account acc : lstGipPkgEditChildAcc) {
            acc.ParentId = lstGipPkgEditChildAcc[0].Id;
        }
        insert lstGipPkgEditChildAcc;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCFGipEditPkg = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCFGipEditPkg;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCCGipEditPkg = Test_Utils.createPSCatalogConditons(4, lstPSCFGipEditPkg[0]);
        insert lstPSCCGipEditPkg;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgGipEditPkg = Test_Utils.createPSCatalogPackage(1, 'G');
        insert lstPSCatPkgGipEditPkg;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSGipEditPkg = Test_Utils.createProfSheet(3, lstGipPkgEditAcc[0]);
        insert lstPSGipEditPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAGipEditPkg = Test_Utils.createProfAnalysis(3, lstGipPkgEditAcc[0]);
        for (Integer i=0; i<lstPAGipEditPkg.size(); i++) {
            lstPAGipEditPkg[i].gf_pa_management_type_name__c = 'New';
            lstPAGipEditPkg[i].gf_pa_mgmt_stage_type_name__c = 'Analysis';
            lstPAGipEditPkg[i].gf_pa_mgmt_status_type_name__c = 'Analysis';
            lstPAGipEditPkg[i].gf_profitability_sheet_id__c = lstPSGipEditPkg[i].Id;
        }
        lstPAGipEditPkg[2].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAGipEditPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPGipEdit = new List<profitability_analysis_participant__c>();
        lstPAPGipEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipEditPkg[0].Id, new List<Id>{lstGipPkgEditChildAcc[0].Id}));
        lstPAPGipEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipEditPkg[1].Id, new List<Id>{lstGipPkgEditChildAcc[1].Id}));
        lstPAPGipEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipEditPkg[2].Id, new List<Id>{lstGipPkgEditChildAcc[2].Id}));
        insert lstPAPGipEdit;

        // Create client packages
        final List<client_package__c> lstCP = new List<client_package__c>();
        lstCP.addAll(Test_Utils.createClientPackage(1, new List<Account>{lstGipPkgEditChildAcc[0]}, lstPSCatPkgGipEditPkg));
        lstCP.addAll(Test_Utils.createClientPackage(1, new List<Account>{lstGipPkgEditChildAcc[1]}, lstPSCatPkgGipEditPkg));
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqGipEdit = Test_Utils.createProfAnPkgReq(1, lstPAGipEditPkg[1].Id, 'Modification');
        lstPAPkgReqGipEdit[0].gf_cust_package_id__c = lstCP[1].Id;
        lstPAPkgReqGipEdit[0].participant_id__c = lstPAPGipEdit[1].Id;
        lstPAPkgReqGipEdit[0].gf_pa_pkg_req_comments_desc__c = 'test comments';
        lstPAPkgReqGipEdit[0].gf_psc_package_id__c = lstPSCatPkgGipEditPkg[0].Id; //G0000
        insert lstPAPkgReqGipEdit;
    }

    // Check doPostGipEditActions first exception (no edit permissions)
    @IsTest
    static void doPostGipEditActions1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        final PAParticipant_Selector papSelector1 = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP1 = papSelector1.selectByProfAnalysis(new Set<Id>{lstPA1[0].Id});
        final Map<String, Object> formGEParams1 = new Map<String, Object>();
        formGEParams1.put('pkgDescription', 'Test Gip Edit');
        formGEParams1.put('accSelection', lstPAP1[0].participant_id__c);
        formGEParams1.put('clientRepDoc', 'Test Gip Edit');
        formGEParams1.put('clientRepName', 'Test Gip Edit');
        formGEParams1.put('comments', 'Test Gip Edit');

        Test.startTest();

            final Map<String, Object> actualMap1 = GipPackageEdit_Ctrl.doPostGipEditActions('{"type": "G"}', lstPA1[0].Id, formGEParams1);
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('isSuccess', false);
            expectedMap1.put('errMessage', Label.pkg_edit_perm_error_sample);
            expectedMap1.put('toastType', 'warning');
            System.assertEquals(expectedMap1, actualMap1, 'Err at GipPackageEdit_Ctrl - doPostGipEditActions1');

        Test.stopTest();
    }

    // Check doPostGipEditActions without pkg req
    @IsTest
    static void doPostGipEditActions2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        final List<Package_Wrapper> lstPW2 = Packages_Service.getPackagesToShow(lstPA2[0].Id, 'GIP_PACKAGE');

        final PAParticipant_Selector papSelector2 = new PAParticipant_Selector(true);
        final PAPackageRequest_Selector paprSelector2 = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP2 = papSelector2.selectByProfAnalysis(new Set<Id>{lstPA2[0].Id});
        final List<profitability_analysis_pkg_request__c> lstPAPRBf = paprSelector2.selectPkgReqByPAPAndReqType(new Set<Id>{lstPAP2[0].Id}, new Set<String>{'Modification'});
        final Map<String, Object> formGEParams2 = new Map<String, Object>();
        formGEParams2.put('pkgDescription', 'Test Gip Edit');
        formGEParams2.put('accSelection', lstPAP2[0].participant_id__c);
        formGEParams2.put('clientRepDoc', 'Test Gip Edit');
        formGEParams2.put('clientRepName', 'Test Gip Edit');
        formGEParams2.put('comments', 'Test Gip Edit');

        Test.startTest();

            final Map<String, Object> retMap2 = GipPackageEdit_Ctrl.doPostGipEditActions(JSON.serialize(lstPW2[0]), lstPA2[0].Id, formGEParams2);
            final List<profitability_analysis_pkg_request__c> lstPAPRAf = paprSelector2.selectPkgReqByPAPAndReqType(new Set<Id>{lstPAP2[0].Id}, new Set<String>{'Modification'});
            final Map<String, Object> actualMap2 = new Map<String, Object>();
            actualMap2.put('isSuccess', retMap2.get('isSuccess'));
            actualMap2.put('paprBf', lstPAPRBf.size());
            actualMap2.put('paprAf', lstPAPRAf.size());
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('isSuccess', true);
            expectedMap2.put('paprBf', 0);
            expectedMap2.put('paprAf', 1);
            System.assertEquals(expectedMap2, actualMap2, 'Err at GipPackageEdit_Ctrl - doPostGipEditActions2');

        Test.stopTest();
    }

    // Check doPostGipEditActions without pkg req
    @IsTest
    static void doPostGipEditActions3() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        final List<Package_Wrapper> lstPW3 = Packages_Service.getPackagesToShow(lstPA3[0].Id, 'GIP_PACKAGE');

        final PAParticipant_Selector papSelector3 = new PAParticipant_Selector(true);
        final PAPackageRequest_Selector paprSelector3 = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP3 = papSelector3.selectByProfAnalysis(new Set<Id>{lstPA3[0].Id});
        final List<profitability_analysis_pkg_request__c> lstPAPRBf = paprSelector3.selectPkgReqByPAPAndReqType(new Set<Id>{lstPAP3[0].Id}, new Set<String>{'Modification'});
        final Map<String, Object> formGEParams3 = new Map<String, Object>();
        formGEParams3.put('pkgDescription', 'Test Gip Edit');
        formGEParams3.put('accSelection', lstPAP3[0].participant_id__c);
        formGEParams3.put('clientRepDoc', 'Test Gip Edit');
        formGEParams3.put('clientRepName', 'Test Gip Edit');
        formGEParams3.put('comments', 'Test Gip Edit new');

        Test.startTest();

            final Map<String, Object> retMap3 = GipPackageEdit_Ctrl.doPostGipEditActions(JSON.serialize(lstPW3[0]), lstPA3[0].Id, formGEParams3);
            final List<profitability_analysis_pkg_request__c> lstPAPRAf = paprSelector3.selectPkgReqByPAPAndReqType(new Set<Id>{lstPAP3[0].Id}, new Set<String>{'Modification'});
            final Map<String, Object> actualMap3 = new Map<String, Object>();
            actualMap3.put('isSuccess', retMap3.get('isSuccess'));
            actualMap3.put('paprBf', lstPAPRBf.size());
            actualMap3.put('paprAf', lstPAPRAf.size());
            actualMap3.put('actualComments', lstPAPRAf[0].gf_pa_pkg_req_comments_desc__c);
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('isSuccess', true);
            expectedMap3.put('paprBf', 1);
            expectedMap3.put('paprAf', 1);
            expectedMap3.put('actualComments', 'Test Gip Edit new');
            System.assertEquals(expectedMap3, actualMap3, 'Err at GipPackageEdit_Ctrl - doPostGipEditActions3');

        Test.stopTest();
    }

    // Check doPostGipEditActions exception error
    @IsTest
    static void doPostGipEditActions4() {
        Test.startTest();
            try {
                GipPackageEdit_Ctrl.doPostGipEditActions(null, null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at GipPackageEdit_Ctrl - doPostGipEditActions4');
            }
        Test.stopTest();
    }

    // Check doPostGipEditActions with err on dml op
    @IsTest
    static void doPostGipEditActions5() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        final List<Package_Wrapper> lstPW5 = Packages_Service.getPackagesToShow(lstPA5[0].Id, 'GIP_PACKAGE');

        final PAParticipant_Selector papSelector5 = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP5 = papSelector5.selectByProfAnalysis(new Set<Id>{lstPA5[0].Id});
        final Map<String, Object> formGEParams5 = new Map<String, Object>();
        formGEParams5.put('pkgDescription', 'Test Gip Edit');
        formGEParams5.put('accSelection', lstPAP5[0].participant_id__c);
        formGEParams5.put('clientRepDoc', 'TestTestTestTestTestTestTestTestTest');
        formGEParams5.put('clientRepName', 'Test Gip Edit');
        formGEParams5.put('comments', 'Test Gip Edit new');

        Test.startTest();

            final Map<String, Object> retMap5 = GipPackageEdit_Ctrl.doPostGipEditActions(JSON.serialize(lstPW5[0]), lstPA5[0].Id, formGEParams5);
            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('isSuccess', retMap5.get('isSuccess'));
            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('isSuccess', false);
            System.assertEquals(expectedMap5, actualMap5, 'Err at GipPackageEdit_Ctrl - doPostGipEditActions5');

        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void gipPacakgeEditConstructorTest() {
        Test.startTest();
            final GipPackageEdit_Ctrl constructorTest = new GipPackageEdit_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at GipPackageEdit_Ctrl - gipPacakgeEditConstructorTest');
        Test.stopTest();
    }

    // Private PAPackage_Helper constructor test
    @IsTest
    static void paPackageHelperConstructorTest1() {
        Test.startTest();
            final PAPackage_Helper constructorTest1 = new PAPackage_Helper();
            System.assertEquals(constructorTest1, constructorTest1, 'Err at GipPackageEdit_Ctrl - paPackageHelperConstructorTest1');
        Test.stopTest();
    }

    // Private PAPackage_Service constructor test
    @IsTest
    static void paPackageServiceConstructorTest2() {
        Test.startTest();
            final PAPackage_Service constructorTest2 = new PAPackage_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at GipPackageEdit_Ctrl - paPackageServiceConstructorTest2');
        Test.stopTest();
    }
}