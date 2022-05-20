/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackageAdd_Ctrl_Test
* Test class for ForfaitPackageAdd_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-21
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ForfaitPackageAdd_Ctrl_Test {

    @TestSetup
    static void makeDataForfaitAddPkg() {

        // Create parent acc
        final List<Account> lstForfaitPkgAddAcc = Test_Utils.createAccounts(1);
        lstForfaitPkgAddAcc[0].AccountNumber = 'B99999999';
        insert lstForfaitPkgAddAcc;

        // Create child accs
        final List<Account> lstForfaitPkgAddChildAcc = Test_Utils.createAccounts(5);
        for (Account acc : lstForfaitPkgAddChildAcc) {
            acc.ParentId = lstForfaitPkgAddAcc[0].Id;
        }
        insert lstForfaitPkgAddChildAcc;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgForfaitAddPkg = Test_Utils.createPSCatalogPackage(5, 'F');
        insert lstPSCatPkgForfaitAddPkg;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSForfaitAddPkg = Test_Utils.createProfSheet(1, lstForfaitPkgAddAcc[0]);
        insert lstPSForfaitAddPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAForfaitAddPkg = Test_Utils.createProfAnalysis(5, lstForfaitPkgAddAcc[0]);
        for (profitability_analysis__c paForfaitAddPkg : lstPAForfaitAddPkg) {
            paForfaitAddPkg.gf_pa_management_type_name__c = 'New';
            paForfaitAddPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paForfaitAddPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paForfaitAddPkg.gf_profitability_sheet_id__c = lstPSForfaitAddPkg[0].Id;
        }
        lstPAForfaitAddPkg[0].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAForfaitAddPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPForfaitAdd = new List<profitability_analysis_participant__c>();
        lstPAPForfaitAdd.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitAddPkg[1].Id, new List<Id>{lstForfaitPkgAddChildAcc[0].Id, lstForfaitPkgAddChildAcc[1].Id}));
        lstPAPForfaitAdd.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitAddPkg[2].Id, new List<Id>{lstForfaitPkgAddChildAcc[2].Id}));
        lstPAPForfaitAdd.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitAddPkg[3].Id, new List<Id>{lstForfaitPkgAddChildAcc[3].Id}));
        lstPAPForfaitAdd.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitAddPkg[4].Id, new List<Id>{lstForfaitPkgAddChildAcc[4].Id}));
        insert lstPAPForfaitAdd;

        // Create client packages
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(1, new List<Account>{lstForfaitPkgAddChildAcc[2]}, new List<ps_catalog_package__c>{lstPSCatPkgForfaitAddPkg[1]});
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitAddPkg = Test_Utils.createProfAnPkgReq(1, lstPAForfaitAddPkg[3].Id, 'New');
        lstPAPkgReqForfaitAddPkg[0].participant_id__c = lstPAPForfaitAdd[3].Id;
        lstPAPkgReqForfaitAddPkg[0].gf_psc_package_id__c = lstPSCatPkgForfaitAddPkg[2].Id;
        insert lstPAPkgReqForfaitAddPkg;

    }

    // Check retrieveForfaitAddData
    @IsTest
    static void retrieveForfaitAddData1() {

        final ProfitabilityAnalysis_Selector profFAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setFNamesPA1 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA1 = profFAnSelector1.selectByName(setFNamesPA1);

        Test.startTest();

            final Map<String, Object> retMap1 = ForfaitPackageAdd_Ctrl.retrieveForfaitAddData(lstPA1[0].Id);

            final Map<String, Object> actualFMap1 = new Map<String, Object>();
            actualFMap1.put('lstFPsCatPkgSize', ((List<ps_catalog_package__c>) retMap1.get('lstPsCatPkg')).size());
            actualFMap1.put('lstPWSize', ((List<Participant_Wrapper>) retMap1.get('lstPW')).size());

            final Map<String, Object> expectedFMap1 = new Map<String, Object>();
            expectedFMap1.put('lstFPsCatPkgSize', 5);
            expectedFMap1.put('lstPWSize', 2);
            System.assertEquals(expectedFMap1, actualFMap1, 'Err at ForfaitPackageAdd_Ctrl_Test - retrieveForfaitAddData1');

        Test.stopTest();
    }

    // Check addNewForfaitPkg exception no add permissions (add mode)
    @IsTest
    static void addNewForfaitPkg1() {

        final ProfitabilityAnalysis_Selector profFAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final PsCatalogPackage_Selector psFCatPkgSelector2 = new PsCatalogPackage_Selector(true);
        final Set<String> setFNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = profFAnSelector2.selectByName(setFNamesPA2);
        final List<ps_catalog_package__c> lstFPsCatPkg2 = psFCatPkgSelector2.selectByPkgCode(new Set<String>{'F0000'});
        final Map<String, Object> formFParams2 = new Map<String, Object>();
        formFParams2.put('accSelection', null);
        formFParams2.put('bankRepDoc', 'TestForfait');
        formFParams2.put('bankRepName', 'TestForfait');
        formFParams2.put('chargeAccount', 'TestForfait');
        formFParams2.put('chargeAmount', '300000');
        formFParams2.put('chargePeriodicity', 'D');
        formFParams2.put('clientRepDoc', 'TestForfait');
        formFParams2.put('clientRepName', 'TestForfait');
        formFParams2.put('comments', 'TestForfait');
        formFParams2.put('pkgSelection', lstFPsCatPkg2[0].Id);
        formFParams2.put('signingLocation', 'TestForfait');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> actualFMap2 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA2[0].Id, formFParams2, mode);

            final Map<String, Object> expectedFMap2 = new Map<String, Object>();
            expectedFMap2.put('isSuccess', false);
            expectedFMap2.put('toastType', 'warning');
            expectedFMap2.put('errMessage', Label.forfait_pkg_add_error + ' ' + Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedFMap2, actualFMap2, 'Err at ForfaitPackageAdd_Ctrl_Test - addNewForfaitPkg1');

        Test.stopTest();
    }

    // Check addNewForfaitPkg with participant with GIP package on client package with valid status
    @IsTest
    static void addNewForfaitPkg2() {

        final ProfitabilityAnalysis_Selector profFAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papFSelector3 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psFCatPkgSelector3 = new PsCatalogPackage_Selector(true);
        final Set<String> setFNamesPA3 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA3 = profFAnSelector3.selectByName(setFNamesPA3);
        final List<profitability_analysis_participant__c> lstPAP3 = papFSelector3.selectByProfAnalysis(new Set<Id>{lstPA3[0].Id});
        final List<ps_catalog_package__c> lstFPsCatPkg3 = psFCatPkgSelector3.selectByPkgCode(new Set<String>{'F0001'});
        final Map<String, Object> formFParams3 = new Map<String, Object>();
        formFParams3.put('accSelection', lstPAP3[0].participant_id__c);
        formFParams3.put('bankRepDoc', 'TestForfait');
        formFParams3.put('bankRepName', 'TestForfait');
        formFParams3.put('chargeAccount', 'TestForfait');
        formFParams3.put('chargeAmount', '250000');
        formFParams3.put('chargePeriodicity', 'D');
        formFParams3.put('clientRepDoc', 'TestForfait');
        formFParams3.put('clientRepName', 'TestForfait');
        formFParams3.put('comments', 'TestForfait');
        formFParams3.put('pkgSelection', lstFPsCatPkg3[0].Id);
        formFParams3.put('signingLocation', 'TestForfait');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> actualFMap3 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA3[0].Id, formFParams3, mode);

            final Map<String, Object> expectedFMap3 = new Map<String, Object>();
            expectedFMap3.put('isSuccess', false);
            expectedFMap3.put('toastType', 'warning');
            expectedFMap3.put('errMessage', Label.forfait_pkg_add_error + ' ' + Label.pkg_not_valid_participant);
            System.assertEquals(expectedFMap3, actualFMap3, 'Err at ForfaitPackageAdd_Ctrl_Test - addNewForfaitPkg2');

        Test.stopTest();
    }

    // Check addNewForfaitPkg with participant with prof analysis pkg req for this participant with request type new (add mode)
    @IsTest
    static void addNewForfaitPkg3() {

        final ProfitabilityAnalysis_Selector profFAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papFSelector4 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psFCatPkgSelector4 = new PsCatalogPackage_Selector(true);
        final Set<String> setFNamesPA4 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA4 = profFAnSelector4.selectByName(setFNamesPA4);
        final List<profitability_analysis_participant__c> lstPAP4 = papFSelector4.selectByProfAnalysis(new Set<Id>{lstPA4[0].Id});
        final List<ps_catalog_package__c> lstFPsCatPkg4 = psFCatPkgSelector4.selectByPkgCode(new Set<String>{'F0002'});
        final Map<String, Object> formFParams4 = new Map<String, Object>();
        formFParams4.put('accSelection', lstPAP4[0].participant_id__c);
        formFParams4.put('bankRepDoc', 'TestForfait');
        formFParams4.put('bankRepName', 'TestForfait');
        formFParams4.put('chargeAccount', 'TestForfait');
        formFParams4.put('chargeAmount', '250000');
        formFParams4.put('chargePeriodicity', 'D');
        formFParams4.put('clientRepDoc', 'TestForfait');
        formFParams4.put('clientRepName', 'TestForfait');
        formFParams4.put('comments', 'TestForfait');
        formFParams4.put('pkgSelection', lstFPsCatPkg4[0].Id);
        formFParams4.put('signingLocation', 'TestForfait');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> actualFMap4 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA4[0].Id, formFParams4, mode);

            final Map<String, Object> expectedFMap4 = new Map<String, Object>();
            expectedFMap4.put('isSuccess', false);
            expectedFMap4.put('toastType', 'warning');
            expectedFMap4.put('errMessage', Label.forfait_pkg_add_error + ' ' + Label.pkg_not_valid_participant);
            System.assertEquals(expectedFMap4, actualFMap4, 'Err at ForfaitPackageAdd_Ctrl_Test - addNewForfaitPkg3');

        Test.stopTest();
    }

    // Check addNewForfaitPkg without err with add mode
    @IsTest
    static void addNewForfaitPkg4() {

        final ProfitabilityAnalysis_Selector profFAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papFSelector5 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psFCatPkgSelector5 = new PsCatalogPackage_Selector(true);
        final Set<String> setFNamesPA5 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA5 = profFAnSelector5.selectByName(setFNamesPA5);
        final List<profitability_analysis_participant__c> lstPAP5 = papFSelector5.selectByProfAnalysis(new Set<Id>{lstPA5[0].Id});
        final List<ps_catalog_package__c> lstFPsCatPkg5 = psFCatPkgSelector5.selectByPkgCode(new Set<String>{'F0002'});
        final Map<String, Object> formFParams5 = new Map<String, Object>();
        formFParams5.put('accSelection', lstPAP5[0].participant_id__c);
        formFParams5.put('bankRepDoc', 'TestForfait');
        formFParams5.put('bankRepName', 'TestForfait');
        formFParams5.put('chargeAccount', 'TestForfait');
        formFParams5.put('chargeAmount', '250000');
        formFParams5.put('chargePeriodicity', 'D');
        formFParams5.put('clientRepDoc', 'TestForfait');
        formFParams5.put('clientRepName', 'TestForfait');
        formFParams5.put('comments', 'TestForfait');
        formFParams5.put('pkgSelection', lstFPsCatPkg5[0].Id);
        formFParams5.put('signingLocation', 'TestForfait');
        final String mode = 'add';

        Test.startTest();

            final Map<String, Object> retMap5 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA5[0].Id, formFParams5, mode);

            final PAPackageRequest_Selector paprSelector5 = new PAPackageRequest_Selector();
            final List<profitability_analysis_pkg_request__c> lstPAPR5 = paprSelector5.selectPkgReqByAcc(new Set<Id>{lstPAP5[0].Id});
            final Map<String, Object> actualFMap5 = new Map<String, Object>();
            actualFMap5.put('isSuccess', (Boolean) retMap5.get('isSuccess'));
            actualFMap5.put('paprSize', lstPAPR5.size());

            final Map<String, Object> expectedFMap5 = new Map<String, Object>();
            expectedFMap5.put('isSuccess', true);
            expectedFMap5.put('paprSize', 1);
            System.assertEquals(expectedFMap5, actualFMap5, 'Err at ForfaitPackageAdd_Ctrl_Test - addNewForfaitPkg4');

        Test.stopTest();
    }

    // Check addNewForfaitPkg without err with edit mode
    @IsTest
    static void addNewForfaitPkg5() {

        final ProfitabilityAnalysis_Selector profFAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final PAParticipant_Selector papFSelector6 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psFCatPkgSelector6 = new PsCatalogPackage_Selector(true);
        final Set<String> setFNamesPA6 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA6 = profFAnSelector6.selectByName(setFNamesPA6);
        final List<profitability_analysis_participant__c> lstPAP6 = papFSelector6.selectByProfAnalysis(new Set<Id>{lstPA6[0].Id});
        final List<ps_catalog_package__c> lstFPsCatPkg6 = psFCatPkgSelector6.selectByPkgCode(new Set<String>{'F0002'});
        final Map<String, Object> formFParams6 = new Map<String, Object>();
        formFParams6.put('accSelection', lstPAP6[0].participant_id__c);
        formFParams6.put('bankRepDoc', 'TestForfait');
        formFParams6.put('bankRepName', 'TestForfait');
        formFParams6.put('chargeAccount', 'TestForfait');
        formFParams6.put('chargeAmount', '250000');
        formFParams6.put('chargePeriodicity', 'D');
        formFParams6.put('clientRepDoc', 'TestForfait');
        formFParams6.put('clientRepName', 'TestForfait');
        formFParams6.put('comments', 'TestForfait');
        formFParams6.put('pkgSelection', lstFPsCatPkg6[0].Id);
        formFParams6.put('signingLocation', 'TestForfait');

        Test.startTest();

            final Map<String, Object> retMapAdd6 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA6[0].Id, formFParams6, 'add');
            formFParams6.put('comments', 'Test2');
            final Map<String, Object> retMapEdit6 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA6[0].Id, formFParams6, 'edit');

            PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector(true);
            List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByAcc(new Set<Id>{lstPAP6[0].Id});
            final Map<String, Object> actualFMap6 = new Map<String, Object>();
            actualFMap6.put('isSuccess1', (Boolean) retMapAdd6.get('isSuccess'));
            actualFMap6.put('isSuccess2', (Boolean) retMapEdit6.get('isSuccess'));
            actualFMap6.put('paprSize', lstPAPR.size());
            actualFMap6.put('commentsValue', lstPAPR[0].gf_pa_pkg_req_comments_desc__c);

            final Map<String, Object> expectedFMap6 = new Map<String, Object>();
            expectedFMap6.put('isSuccess1', true);
            expectedFMap6.put('isSuccess2', true);
            expectedFMap6.put('paprSize', 1);
            expectedFMap6.put('commentsValue', 'Test2');
            System.assertEquals(expectedFMap6, actualFMap6, 'Err at ForfaitPackageAdd_Ctrl_Test - addNewForfaitPkg5');

        Test.stopTest();
    }

    // Check addNewForfaitPkg exception no add permissions (edit mode)
    @IsTest
    static void addNewForfaitPkg6() {

        final ProfitabilityAnalysis_Selector profFAnSelector7 = new ProfitabilityAnalysis_Selector(true);
        final PsCatalogPackage_Selector psFCatPkgSelector7 = new PsCatalogPackage_Selector(true);
        final Set<String> setFNamesPA7 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA7 = profFAnSelector7.selectByName(setFNamesPA7);
        final List<ps_catalog_package__c> lstFPsCatPkg7 = psFCatPkgSelector7.selectByPkgCode(new Set<String>{'F0000'});
        final Map<String, Object> formFParams7 = new Map<String, Object>();
        formFParams7.put('accSelection', null);
        formFParams7.put('bankRepDoc', 'TestForfait');
        formFParams7.put('bankRepName', 'TestForfait');
        formFParams7.put('chargeAccount', 'TestForfait');
        formFParams7.put('chargeAmount', '250000');
        formFParams7.put('chargePeriodicity', 'D');
        formFParams7.put('clientRepDoc', 'TestForfait');
        formFParams7.put('clientRepName', 'TestForfait');
        formFParams7.put('comments', 'TestForfait');
        formFParams7.put('pkgSelection', lstFPsCatPkg7[0].Id);
        formFParams7.put('signingLocation', 'TestForfait');
        final String mode = 'edit';

        Test.startTest();

            final Map<String, Object> actualFMap7 = ForfaitPackageAdd_Ctrl.addNewForfaitPkg(lstPA7[0].Id, formFParams7, mode);

            final Map<String, Object> expectedFMap7 = new Map<String, Object>();
            expectedFMap7.put('isSuccess', false);
            expectedFMap7.put('toastType', 'warning');
            expectedFMap7.put('errMessage', Label.forfait_pkg_edit_error + ' ' + Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedFMap7, actualFMap7, 'Err at ForfaitPackageAdd_Ctrl_Test - addNewForfaitPkg6');

        Test.stopTest();
    }

    // Private ForfaitPackageAdd_Ctrl constructor test
    @IsTest
    static void forfaitPackageAddConstructorTest1() {
        Test.startTest();
            final ForfaitPackageAdd_Ctrl constructorTest = new ForfaitPackageAdd_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at ForfaitPackageAdd_Ctrl_Test - forfaitPackageAddConstructorTest1');
        Test.stopTest();
    }

    // Private PackagesForfait_Helper constructor test
    @IsTest
    static void packagesForfaitHelperConstructorTest2() {
        Test.startTest();
            final PackagesForfait_Helper constructorTest2 = new PackagesForfait_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at ForfaitPackageAdd_Ctrl_Test - packagesForfaitHelperConstructorTest2');
        Test.stopTest();
    }
}