/**
* ────────────────────────────────────────────────────────────────────
* GipPackageAdd_Ctrl_Test
* Test class for GipPackageAdd_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-01
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class GipPackageAdd_Ctrl_Test {

    @TestSetup
    static void makeDataGipAddPkg() {

        // Create parent acc
        final List<Account> lstGipPkgAddAcc = Test_Utils.createAccounts(1);
        lstGipPkgAddAcc[0].AccountNumber = 'B99999999';
        insert lstGipPkgAddAcc;

        // Create child accs
        final List<Account> lstGipPkgAddChildAcc = Test_Utils.createAccounts(5);
        for (Account acc : lstGipPkgAddChildAcc) {
            acc.ParentId = lstGipPkgAddAcc[0].Id;
        }
        insert lstGipPkgAddChildAcc;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgGipAddPkg = Test_Utils.createPSCatalogPackage(1, 'G');
        insert lstPSCatPkgGipAddPkg;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSGipAddPkg = Test_Utils.createProfSheet(1, lstGipPkgAddAcc[0]);
        insert lstPSGipAddPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAGipAddPkg = Test_Utils.createProfAnalysis(5, lstGipPkgAddAcc[0]);
        for (profitability_analysis__c paGipAddPkg : lstPAGipAddPkg) {
            paGipAddPkg.gf_pa_management_type_name__c = 'New';
            paGipAddPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paGipAddPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paGipAddPkg.gf_profitability_sheet_id__c = lstPSGipAddPkg[0].Id;
        }
        lstPAGipAddPkg[0].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAGipAddPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPGipAdd = new List<profitability_analysis_participant__c>();
        lstPAPGipAdd.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAGipAddPkg[1].Id, new List<Id>{lstGipPkgAddChildAcc[0].Id, lstGipPkgAddChildAcc[1].Id}));
        lstPAPGipAdd.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipAddPkg[2].Id, new List<Id>{lstGipPkgAddChildAcc[2].Id}));
        lstPAPGipAdd.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipAddPkg[3].Id, new List<Id>{lstGipPkgAddChildAcc[3].Id}));
        lstPAPGipAdd.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAGipAddPkg[4].Id, new List<Id>{lstGipPkgAddChildAcc[4].Id}));
        insert lstPAPGipAdd;

        // Create client packages
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(1, new List<Account>{lstGipPkgAddChildAcc[2]}, new List<ps_catalog_package__c>{lstPSCatPkgGipAddPkg[0]});
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqGipAddPkg = Test_Utils.createProfAnPkgReq(1, lstPAGipAddPkg[3].Id, 'New');
        lstPAPkgReqGipAddPkg[0].participant_id__c = lstPAPGipAdd[3].Id;
        lstPAPkgReqGipAddPkg[0].gf_psc_package_id__c = lstPSCatPkgGipAddPkg[0].Id;
        insert lstPAPkgReqGipAddPkg;

    }

    // Check retrieveGipAddData
    @IsTest
    static void retrieveGipAddData1() {

        final ProfitabilityAnalysis_Selector profGAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setGNamesPA31 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA1 = profGAnSelector1.selectByName(setGNamesPA31);

        Test.startTest();

            final Map<String, Object> retMap1 = GipPackageAdd_Ctrl.retrieveGipAddData(lstPA1[0].Id);

            final Map<String, Object> actualGMap1 = new Map<String, Object>();
            actualGMap1.put('lstPWSize', ((List<Participant_Wrapper>) retMap1.get('lstPW')).size());

            final Map<String, Object> expectedGMap1 = new Map<String, Object>();
            expectedGMap1.put('lstPWSize', 2);
            System.assertEquals(expectedGMap1, actualGMap1, 'Err at GipPackageAdd_Ctrl - retrieveGipAddData1');

        Test.stopTest();
    }

    // Check addNewGipPkg exception no add permissions (add mode)
    @IsTest
    static void addNewGipPkg1() {

        final ProfitabilityAnalysis_Selector profGAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final PsCatalogPackage_Selector psGCatPkgSelector2 = new PsCatalogPackage_Selector(true);
        final Set<String> setGNamesPA32 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = profGAnSelector2.selectByName(setGNamesPA32);
        final List<ps_catalog_package__c> lstPsCatPkg2 = psGCatPkgSelector2.selectByPkgCode(new Set<String>{'G0000'});
        final Map<String, Object> formGParams2 = new Map<String, Object>();
        formGParams2.put('accSelection', null);
        formGParams2.put('bankRepDoc', 'TestGip');
        formGParams2.put('bankRepName', 'TestGip');
        formGParams2.put('clientRepDoc', 'TestGip');
        formGParams2.put('clientRepName', 'TestGip');
        formGParams2.put('comments', 'TestGip');
        formGParams2.put('pkgSelection', lstPsCatPkg2[0].Id);
        formGParams2.put('signingLocation', 'TestGip');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> actualGMap2 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA2[0].Id, formGParams2, mode);

            final Map<String, Object> expectedGMap2 = new Map<String, Object>();
            expectedGMap2.put('isSuccess', false);
            expectedGMap2.put('toastType', 'warning');
            expectedGMap2.put('errMessage', Label.gip_pkg_add_error + ' ' + Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedGMap2, actualGMap2, 'Err at GipPackageAdd_Ctrl_Test - addNewGipPkg1');

        Test.stopTest();
    }

    // Check addNewGipPkg with participant with GIP package on client package with valid status
    @IsTest
    static void addNewGipPkg2() {

        final ProfitabilityAnalysis_Selector profGAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papGSelector3 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psGCatPkgSelector3 = new PsCatalogPackage_Selector(true);
        final Set<String> setGNamesPA33 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA3 = profGAnSelector3.selectByName(setGNamesPA33);
        final List<profitability_analysis_participant__c> lstPAP3 = papGSelector3.selectByProfAnalysis(new Set<Id>{lstPA3[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg3 = psGCatPkgSelector3.selectByPkgCode(new Set<String>{'G0000'});
        final Map<String, Object> formGParams3 = new Map<String, Object>();
        formGParams3.put('accSelection', lstPAP3[0].participant_id__c);
        formGParams3.put('bankRepDoc', 'TestGip');
        formGParams3.put('bankRepName', 'TestGip');
        formGParams3.put('clientRepDoc', 'TestGip');
        formGParams3.put('clientRepName', 'TestGip');
        formGParams3.put('comments', 'TestGip');
        formGParams3.put('pkgSelection', lstPsCatPkg3[0].Id);
        formGParams3.put('signingLocation', 'TestGip');

        Test.startTest();

            final Map<String, Object> actualGMap3 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA3[0].Id, formGParams3, 'add');

            final Map<String, Object> expectedGMap3 = new Map<String, Object>();
            expectedGMap3.put('isSuccess', false);
            expectedGMap3.put('toastType', 'warning');
            expectedGMap3.put('errMessage', Label.gip_pkg_add_error + ' ' + Label.pkg_not_valid_participant);
            System.assertEquals(expectedGMap3, actualGMap3, 'Err at GipPackageAdd_Ctrl_Test - addNewGipPkg2');

        Test.stopTest();
    }

    // Check addNewGipPkg with participant with prof analysis pkg req for this participant with request type new (add mode)
    @IsTest
    static void addNewGipPkg3() {

        final ProfitabilityAnalysis_Selector profGAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papGSelector4 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psGCatPkgSelector4 = new PsCatalogPackage_Selector(true);
        final Set<String> setGNamesPA34 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA4 = profGAnSelector4.selectByName(setGNamesPA34);
        final List<profitability_analysis_participant__c> lstPAP4 = papGSelector4.selectByProfAnalysis(new Set<Id>{lstPA4[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg4 = psGCatPkgSelector4.selectByPkgCode(new Set<String>{'G0000'});
        final Map<String, Object> formGParams4 = new Map<String, Object>();
        formGParams4.put('accSelection', lstPAP4[0].participant_id__c);
        formGParams4.put('bankRepDoc', 'TestGip');
        formGParams4.put('bankRepName', 'TestGip');
        formGParams4.put('clientRepDoc', 'TestGip');
        formGParams4.put('clientRepName', 'TestGip');
        formGParams4.put('comments', 'TestGip');
        formGParams4.put('pkgSelection', lstPsCatPkg4[0].Id);
        formGParams4.put('signingLocation', 'TestGip');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> actualGMap4 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA4[0].Id, formGParams4, mode);

            final Map<String, Object> expectedGMap4 = new Map<String, Object>();
            expectedGMap4.put('isSuccess', false);
            expectedGMap4.put('toastType', 'warning');
            expectedGMap4.put('errMessage', Label.gip_pkg_add_error + ' ' + Label.pkg_not_valid_participant);
            System.assertEquals(expectedGMap4, actualGMap4, 'Err at GipPackageAdd_Ctrl_Test - addNewGipPkg3');

        Test.stopTest();
    }

    // Check addNewGipPkg without err with add mode
    @IsTest
    static void addNewGipPkg4() {

        final ProfitabilityAnalysis_Selector profGAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papGSelector5 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psGCatPkgSelector5 = new PsCatalogPackage_Selector(true);
        final Set<String> setGNamesPA35 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA5 = profGAnSelector5.selectByName(setGNamesPA35);
        final List<profitability_analysis_participant__c> lstPAP5 = papGSelector5.selectByProfAnalysis(new Set<Id>{lstPA5[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg5 = psGCatPkgSelector5.selectByPkgCode(new Set<String>{'G0000'});
        final Map<String, Object> formGParams5 = new Map<String, Object>();
        formGParams5.put('accSelection', lstPAP5[0].participant_id__c);
        formGParams5.put('bankRepDoc', 'TestGip');
        formGParams5.put('bankRepName', 'TestGip');
        formGParams5.put('clientRepDoc', 'TestGip');
        formGParams5.put('clientRepName', 'TestGip');
        formGParams5.put('comments', 'TestGip');
        formGParams5.put('pkgSelection', lstPsCatPkg5[0].Id);
        formGParams5.put('signingLocation', 'TestGip');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> retMap5 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA5[0].Id, formGParams5, mode);

            final PAPackageRequest_Selector paprSelector5 = new PAPackageRequest_Selector();
            final List<profitability_analysis_pkg_request__c> lstPAPR5 = paprSelector5.selectPkgReqByAcc(new Set<Id>{lstPAP5[0].Id});
            final Map<String, Object> actualGMap5 = new Map<String, Object>();
            actualGMap5.put('isSuccess', (Boolean) retMap5.get('isSuccess'));
            actualGMap5.put('paprSize', lstPAPR5.size());

            final Map<String, Object> expectedGMap5 = new Map<String, Object>();
            expectedGMap5.put('isSuccess', true);
            expectedGMap5.put('paprSize', 1);
            System.assertEquals(expectedGMap5, actualGMap5, 'Err at GipPackageAdd_Ctrl_Test - addNewGipPkg4');

        Test.stopTest();
    }

    // Check addNewGipPkg without err with edit mode
    @IsTest
    static void addNewGipPkg5() {

        final ProfitabilityAnalysis_Selector profGAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papGSelector6 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psGCatPkgSelector6 = new PsCatalogPackage_Selector(true);
        final Set<String> setGNamesPA36 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA6 = profGAnSelector6.selectByName(setGNamesPA36);
        final List<profitability_analysis_participant__c> lstPAP6 = papGSelector6.selectByProfAnalysis(new Set<Id>{lstPA6[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg6 = psGCatPkgSelector6.selectByPkgCode(new Set<String>{'G0000'});
        final Map<String, Object> formGParams6 = new Map<String, Object>();
        formGParams6.put('accSelection', lstPAP6[0].participant_id__c);
        formGParams6.put('bankRepDoc', 'TestGip');
        formGParams6.put('bankRepName', 'TestGip');
        formGParams6.put('clientRepDoc', 'TestGip');
        formGParams6.put('clientRepName', 'TestGip');
        formGParams6.put('comments', 'TestGip');
        formGParams6.put('pkgSelection', lstPsCatPkg6[0].Id);
        formGParams6.put('signingLocation', 'TestGip');

        Test.startTest();

            final Map<String, Object> retMapAdd6 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA6[0].Id, formGParams6, 'add');
            formGParams6.put('comments', 'Test2');
            final Map<String, Object> retMapEdit6 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA6[0].Id, formGParams6, 'edit');

            PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector(true);
            List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByAcc(new Set<Id>{lstPAP6[0].Id});
            final Map<String, Object> actualGMap6 = new Map<String, Object>();
            actualGMap6.put('isSuccess1', (Boolean) retMapAdd6.get('isSuccess'));
            actualGMap6.put('isSuccess2', (Boolean) retMapEdit6.get('isSuccess'));
            actualGMap6.put('paprSize', lstPAPR.size());
            actualGMap6.put('commentsValue', lstPAPR[0].gf_pa_pkg_req_comments_desc__c);

            final Map<String, Object> expectedGMap6 = new Map<String, Object>();
            expectedGMap6.put('isSuccess1', true);
            expectedGMap6.put('isSuccess2', true);
            expectedGMap6.put('paprSize', 1);
            expectedGMap6.put('commentsValue', 'Test2');
            System.assertEquals(expectedGMap6, actualGMap6, 'Err at GipPackageAdd_Ctrl_Test - addNewGipPkg5');

        Test.stopTest();
    }

    // Check addNewGipPkg exception no add permissions (edit mode)
    @IsTest
    static void addNewGipPkg6() {

        final ProfitabilityAnalysis_Selector profGAnSelector7 = new ProfitabilityAnalysis_Selector(true);
        final PsCatalogPackage_Selector psGCatPkgSelector7 = new PsCatalogPackage_Selector(true);
        final Set<String> setGNamesPA37 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA7 = profGAnSelector7.selectByName(setGNamesPA37);
        final List<ps_catalog_package__c> lstPsCatPkg7 = psGCatPkgSelector7.selectByPkgCode(new Set<String>{'G0000'});
        final Map<String, Object> formGParams7 = new Map<String, Object>();
        formGParams7.put('accSelection', null);
        formGParams7.put('bankRepDoc', 'TestGip');
        formGParams7.put('bankRepName', 'TestGip');
        formGParams7.put('clientRepDoc', 'TestGip');
        formGParams7.put('clientRepName', 'TestGip');
        formGParams7.put('comments', 'TestGip');
        formGParams7.put('pkgSelection', lstPsCatPkg7[0].Id);
        formGParams7.put('signingLocation', 'TestGip');
        final String mode = 'edit';

        Test.startTest();

            final Map<String, Object> actualGMap7 = GipPackageAdd_Ctrl.addNewGipPkg(lstPA7[0].Id, formGParams7, mode);

            final Map<String, Object> expectedGMap7 = new Map<String, Object>();
            expectedGMap7.put('isSuccess', false);
            expectedGMap7.put('toastType', 'warning');
            expectedGMap7.put('errMessage', Label.gip_pkg_edit_error + ' ' + Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedGMap7, actualGMap7, 'Err at GipPackageAdd_Ctrl_Test - addNewGipPkg6');

        Test.stopTest();
    }

    // Private GipPackageAdd_Ctrl constructor test
    @IsTest
    static void gipPackageAddConstructorTest() {
        Test.startTest();
            final GipPackageAdd_Ctrl constructorTest = new GipPackageAdd_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at GipPackageAdd_Ctrl_Test - gipPackageAddConstructorTest');
        Test.stopTest();
    }

    // Private PackagesGip_Helper constructor test
    @IsTest
    static void packagesGipHelperConstructorTest() {
        Test.startTest();
            final PackagesGip_Helper constructorTest2 = new PackagesGip_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at GipPackageAdd_Ctrl_Test - packagesGipHelperConstructorTest');
        Test.stopTest();
    }
}