/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackageEdit_Ctrl_Test
* Test class for ForfaitPackageEdit_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-26
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ForfaitPackageEdit_Ctrl_Test {

    @TestSetup
    static void makeDataForfaitEditPkg() {

        // Create parent acc
        final List<Account> lstForfaitPkgEditAcc = Test_Utils.createAccounts(1);
        lstForfaitPkgEditAcc[0].AccountNumber = 'B99999999';
        insert lstForfaitPkgEditAcc;

        // Create child accs
        final List<Account> lstForfaitPkgEditChildAcc = Test_Utils.createAccounts(14);
        for (Account acc : lstForfaitPkgEditChildAcc) {
            acc.ParentId = lstForfaitPkgEditChildAcc[0].Id;
        }
        insert lstForfaitPkgEditChildAcc;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCFForfaitEditPkg = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCFForfaitEditPkg;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCCForfaitEditPkg = Test_Utils.createPSCatalogConditons(4, lstPSCFForfaitEditPkg[0]);
        insert lstPSCCForfaitEditPkg;

        // Create ps catalog attribute
        final List<ps_catalog_attribute__c> lstPsCatAttbForfaitEditPkg = Test_Utils.createPSCatalogAttributes(5);
        lstPsCatAttbForfaitEditPkg[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        lstPsCatAttbForfaitEditPkg[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        lstPsCatAttbForfaitEditPkg[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        lstPsCatAttbForfaitEditPkg[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        lstPsCatAttbForfaitEditPkg[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert lstPsCatAttbForfaitEditPkg;

        // Create ps catalog condition attributes
        final List<ps_catalog_condition_attribute__c> lstPsCatCondAttbForfaitEditPkg = new List<ps_catalog_condition_attribute__c>();
        lstPsCatCondAttbForfaitEditPkg.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCForfaitEditPkg[0], lstPsCatAttbForfaitEditPkg));
        lstPsCatCondAttbForfaitEditPkg.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCForfaitEditPkg[1], lstPsCatAttbForfaitEditPkg));
        lstPsCatCondAttbForfaitEditPkg.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCForfaitEditPkg[2], lstPsCatAttbForfaitEditPkg));
        lstPsCatCondAttbForfaitEditPkg.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCForfaitEditPkg[3], lstPsCatAttbForfaitEditPkg));
        for (Integer i=0; i<lstPsCatCondAttbForfaitEditPkg.size(); i++) {
            lstPsCatCondAttbForfaitEditPkg[i].gf_psc_condition_attribute_id__c = 'canonical.uniqueid.' + i;
            switch on Math.mod(i, 5) {
                when  0 {
                    lstPsCatCondAttbForfaitEditPkg[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 1 {
                    lstPsCatCondAttbForfaitEditPkg[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 2 {
                    lstPsCatCondAttbForfaitEditPkg[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 3 {
                    lstPsCatCondAttbForfaitEditPkg[i].gf_psc_ca_exemption_name__c = 'IF';
                }
                when 4 {
                    lstPsCatCondAttbForfaitEditPkg[i].gf_psc_ca_exemption_name__c = 'true';
                }
            }
        }
        insert lstPsCatCondAttbForfaitEditPkg;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgForfaitEditPkg = Test_Utils.createPSCatalogPackage(8, 'F');
        lstPSCatPkgForfaitEditPkg[0].gf_psc_extended_pkg_ind_type__c = false;
        insert lstPSCatPkgForfaitEditPkg;

        // Create ps catalog pkg condition
        final List<ps_catalog_pkg_condition__c> lstPSCatPkgCondForfaitEditPkg = new List<ps_catalog_pkg_condition__c>();
        lstPSCatPkgCondForfaitEditPkg.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgForfaitEditPkg[5], lstPSCCForfaitEditPkg));
        lstPSCatPkgCondForfaitEditPkg.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgForfaitEditPkg[6], lstPSCCForfaitEditPkg));
        lstPSCatPkgCondForfaitEditPkg.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgForfaitEditPkg[7], lstPSCCForfaitEditPkg));
        insert lstPSCatPkgCondForfaitEditPkg;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSForfaitEditPkg = Test_Utils.createProfSheet(1, lstForfaitPkgEditAcc[0]);
        insert lstPSForfaitEditPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAForfaitEditPkg = Test_Utils.createProfAnalysis(8, lstForfaitPkgEditAcc[0]);
        for (profitability_analysis__c paForfaitEditPkg : lstPAForfaitEditPkg) {
            paForfaitEditPkg.gf_pa_management_type_name__c = 'New';
            paForfaitEditPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paForfaitEditPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paForfaitEditPkg.gf_profitability_sheet_id__c = lstPSForfaitEditPkg[0].Id;
        }
        lstPAForfaitEditPkg[4].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAForfaitEditPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPForfaitEdit = new List<profitability_analysis_participant__c>();
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitEditPkg[0].Id, new List<Id>{lstForfaitPkgEditChildAcc[0].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAForfaitEditPkg[1].Id, new List<Id>{lstForfaitPkgEditChildAcc[1].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitEditPkg[2].Id, new List<Id>{lstForfaitPkgEditChildAcc[2].Id, lstForfaitPkgEditChildAcc[3].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitEditPkg[3].Id, new List<Id>{lstForfaitPkgEditChildAcc[4].Id, lstForfaitPkgEditChildAcc[5].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitEditPkg[4].Id, new List<Id>{lstForfaitPkgEditChildAcc[6].Id, lstForfaitPkgEditChildAcc[7].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitEditPkg[5].Id, new List<Id>{lstForfaitPkgEditChildAcc[8].Id, lstForfaitPkgEditChildAcc[9].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitEditPkg[6].Id, new List<Id>{lstForfaitPkgEditChildAcc[10].Id, lstForfaitPkgEditChildAcc[11].Id}));
        lstPAPForfaitEdit.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAForfaitEditPkg[7].Id, new List<Id>{lstForfaitPkgEditChildAcc[12].Id, lstForfaitPkgEditChildAcc[13].Id}));
        insert lstPAPForfaitEdit;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACForfaitEditPkg = new List<profitability_analysis_condition__c>();
        lstPACForfaitEditPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAForfaitEditPkg[2], lstPSCCForfaitEditPkg[3]));
        lstPACForfaitEditPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAForfaitEditPkg[5], lstPSCCForfaitEditPkg[0]));
        lstPACForfaitEditPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAForfaitEditPkg[5], lstPSCCForfaitEditPkg[1]));
        lstPACForfaitEditPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAForfaitEditPkg[6], lstPSCCForfaitEditPkg[3]));
        lstPACForfaitEditPkg[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPACForfaitEditPkg[0].gf_pa_source_cust_package_id__c = 'B00000003F0003';
        lstPACForfaitEditPkg[3].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPACForfaitEditPkg[3].gf_pa_source_cust_package_id__c = 'B00000009F0006';

        insert lstPACForfaitEditPkg;

        // Create client packages
        final List<Account> lstAccPA2CP = new List<Account>{lstForfaitPkgEditChildAcc[0], lstForfaitPkgEditChildAcc[1], lstForfaitPkgEditChildAcc[2], lstForfaitPkgEditChildAcc[4],
                                                            lstForfaitPkgEditChildAcc[6], lstForfaitPkgEditChildAcc[8], lstForfaitPkgEditChildAcc[10], lstForfaitPkgEditChildAcc[12]};
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(8, lstAccPA2CP, lstPSCatPkgForfaitEditPkg);
        insert lstCP;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPRForfaitEdit = new List<profitability_analysis_pkg_request__c>();
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitEditPkg = Test_Utils.createProfAnPkgReq(1, lstPAForfaitEditPkg[7].Id, 'Extension');
        lstPAPkgReqForfaitEditPkg[0].gf_cust_package_id__c = lstCP[7].Id;
        lstPAPkgReqForfaitEditPkg[0].gf_psc_package_id__c = lstPSCatPkgForfaitEditPkg[0].Id; //F0000
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqForfaitEditPkg2 = Test_Utils.createProfAnPkgReq(1, lstPAForfaitEditPkg[6].Id, 'Modification');
        lstPAPkgReqForfaitEditPkg2[0].gf_cust_package_id__c = lstCP[6].Id;
        lstPAPkgReqForfaitEditPkg2[0].gf_psc_package_id__c = lstPSCatPkgForfaitEditPkg[1].Id; //F0001
        lstPAPRForfaitEdit.addAll(lstPAPkgReqForfaitEditPkg2);
        insert lstPAPRForfaitEdit;

    }

    // Check doInitialActionsForfaitEdit first exception (cannot extended pkg)
    @IsTest
    static void doInitialActionsForfaitEdit1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        final PsCatalogPackage_Selector psCatalogPkgSelector1 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg1 = psCatalogPkgSelector1.selectByPkgCode(new Set<String>{'F0000'});

        Test.startTest();

            final Map<String, Object> retMap1 = ForfaitPackageEdit_Ctrl.doInitialActionsForfaitEdit(lstPA1[0].Id, lstPsCatPkg1[0].Id, false);
            final Map<String, Object> actualMap1 = new Map<String, Object>();
            actualMap1.put('showExtendedSection', retMap1.get('showExtendedSection'));
            actualMap1.put('hasPeriodicity', (((List<Utils.Picklist_Wrapper>) retMap1.get('lstChargePeriodicity')).size() > 0));
            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('showExtendedSection', false);
            expectedMap1.put('hasPeriodicity', true);
            System.assertEquals(expectedMap1, actualMap1, 'Err at ForfaitPackageEdit_Ctrl_Test - doInitialActionsForfaitEdit1');

        Test.stopTest();
    }

    // Check doInitialActionsForfaitEdit first exception (more than one prof analysis participant on the current profitability analysis)
    @IsTest
    static void doInitialActionsForfaitEdit2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        final PsCatalogPackage_Selector psCatalogPkgSelector2 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg2 = psCatalogPkgSelector2.selectByPkgCode(new Set<String>{'F0001'});

        Test.startTest();

            final Map<String, Object> retMap2 = ForfaitPackageEdit_Ctrl.doInitialActionsForfaitEdit(lstPA2[0].Id, lstPsCatPkg2[0].Id, false);
            final Map<String, Object> actualMap2 = new Map<String, Object>();
            actualMap2.put('showExtendedSection', retMap2.get('showExtendedSection'));
            actualMap2.put('hasPeriodicity', (((List<Utils.Picklist_Wrapper>) retMap2.get('lstChargePeriodicity')).size() > 0));
            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('showExtendedSection', false);
            expectedMap2.put('hasPeriodicity', true);
            System.assertEquals(expectedMap2, actualMap2, 'Err at ForfaitPackageEdit_Ctrl_Test - doInitialActionsForfaitEdit2');

        Test.stopTest();
    }

    // Check doInitialActionsForfaitEdit first exception (already have one extended pkg)
    @IsTest
    static void doInitialActionsForfaitEdit3() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        final PsCatalogPackage_Selector psCatalogPkgSelector3 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg3 = psCatalogPkgSelector3.selectByPkgCode(new Set<String>{'F0001'});

        Test.startTest();

            final Map<String, Object> retMap3 = ForfaitPackageEdit_Ctrl.doInitialActionsForfaitEdit(lstPA3[0].Id, lstPsCatPkg3[0].Id, false);
            final Map<String, Object> actualMap3 = new Map<String, Object>();
            actualMap3.put('showExtendedSection', retMap3.get('showExtendedSection'));
            actualMap3.put('hasPeriodicity', (((List<Utils.Picklist_Wrapper>) retMap3.get('lstChargePeriodicity')).size() > 0));
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('showExtendedSection', false);
            expectedMap3.put('hasPeriodicity', true);
            System.assertEquals(expectedMap3, actualMap3, 'Err at ForfaitPackageEdit_Ctrl_Test - doInitialActionsForfaitEdit3');

        Test.stopTest();
    }

    // Check doInitialActionsForfaitEdit no error without isExtended marked on wrapper
    @IsTest
    static void doInitialActionsForfaitEdit4() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        final PsCatalogPackage_Selector psCatalogPkgSelector4 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg4 = psCatalogPkgSelector4.selectByPkgCode(new Set<String>{'F0001'});

        Test.startTest();

            final Map<String, Object> retMap4 = ForfaitPackageEdit_Ctrl.doInitialActionsForfaitEdit(lstPA4[0].Id, lstPsCatPkg4[0].Id, false);
            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('showExtendedSection', retMap4.get('showExtendedSection'));
            actualMap4.put('hasPeriodicity', ((List<Utils.Picklist_Wrapper>) retMap4.get('lstChargePeriodicity')).size() > 0);
            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('showExtendedSection', true);
            expectedMap4.put('hasPeriodicity', true);
            System.assertEquals(expectedMap4, actualMap4, 'Err at ForfaitPackageEdit_Ctrl_Test - doInitialActionsForfaitEdit4');

        Test.stopTest();
    }

    // Check doInitialActionsForfaitEdit no error with isExtended marked on wrapper
    @IsTest
    static void doInitialActionsForfaitEdit5() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        final PsCatalogPackage_Selector psCatalogPkgSelector5 = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg5 = psCatalogPkgSelector5.selectByPkgCode(new Set<String>{'F0001'});

        Test.startTest();

            final Map<String, Object> retMap5 = ForfaitPackageEdit_Ctrl.doInitialActionsForfaitEdit(lstPA5[0].Id, lstPsCatPkg5[0].Id, true);
            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('showExtendedSection', retMap5.get('showExtendedSection'));
            actualMap5.put('hasPeriodicity', ((List<Utils.Picklist_Wrapper>) retMap5.get('lstChargePeriodicity')).size() > 0);
            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('showExtendedSection', true);
            expectedMap5.put('hasPeriodicity', true);
            System.assertEquals(expectedMap5, actualMap5, 'Err at ForfaitPackageEdit_Ctrl_Test - doInitialActionsForfaitEdit5');

        Test.stopTest();
    }

    // Check doInitialActionsForfaitEdit exception error
    @IsTest
    static void doInitialActionsForfaitEdit6() {
        Test.startTest();
            try {
                ForfaitPackageEdit_Ctrl.doInitialActionsForfaitEdit(null, null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ForfaitPackageEdit_Ctrl_Test - doInitialActionsForfaitEdit6');
            }
        Test.stopTest();
    }


    // Check doPostForfaitEditActions first exception (no edit permissions)
    @IsTest
    static void doPostForfaitEditActions1() {

        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA6 = profAnSelector6.selectByName(setNamesPA6);

        final List<Package_Wrapper> lstPW6 = Packages_Service.getPackagesToShow(lstPA6[0].Id, 'FORFAIT');
        final Map<String, Object> mapParams6 = new Map<String, Object>();
        mapParams6.put('profAnalysisId', lstPA6[0].Id);
        mapParams6.put('step', '1');
        mapParams6.put('decision', 'extend');
        mapParams6.put('makeExtensionActions', true);

        final PAParticipant_Selector papSelector6 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psCatPkgSelector6 = new PsCatalogPackage_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP6 = papSelector6.selectByProfAnalysis(new Set<Id>{lstPA6[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg6 = psCatPkgSelector6.selectByPkgCode(new Set<String>{'F0001'});
        final Map<String, Object> formParams6 = new Map<String, Object>();
        formParams6.put('accSelection', lstPAP6[0].participant_id__c);
        formParams6.put('chargeAmount', '300000');
        formParams6.put('chargePeriodicity', 'D');
        formParams6.put('clientRepDoc', 'Test');
        formParams6.put('clientRepName', 'Test');
        formParams6.put('comments', 'Test');
        formParams6.put('pkgSelection', lstPsCatPkg6[0].Id);

        Test.startTest();

            final Map<String, Object> actualMap6 = ForfaitPackageEdit_Ctrl.doPostForfaitEditActions(JSON.serialize(lstPW6[0]), mapParams6, formParams6);
            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('isSuccess', false);
            expectedMap6.put('errMessage', Label.pkg_edit_perm_error_sample);
            expectedMap6.put('toastType', 'warning');
            System.assertEquals(expectedMap6, actualMap6, 'Err at ForfaitPackageEdit_Ctrl_Test - doPostForfaitEditActions1');

        Test.stopTest();
    }

    // Check doPostForfaitEditActions step 1 with ProfAnalysisCond related (need user confim)
    @IsTest
    static void doPostForfaitEditActions2() {

        final ProfitabilityAnalysis_Selector profAnSelector7 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA7 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> lstPA7 = profAnSelector7.selectByName(setNamesPA7);

        final List<Package_Wrapper> lstPW7 = Packages_Service.getPackagesToShow(lstPA7[0].Id, 'FORFAIT');
        final Map<String, Object> mapParams7 = new Map<String, Object>();
        mapParams7.put('profAnalysisId', lstPA7[0].Id);
        mapParams7.put('step', '1');
        mapParams7.put('decision', 'extend');
        mapParams7.put('makeExtensionActions', true);

        final PAParticipant_Selector papSelector7 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psCatPkgSelector7 = new PsCatalogPackage_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP7 = papSelector7.selectByProfAnalysis(new Set<Id>{lstPA7[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg7 = psCatPkgSelector7.selectByPkgCode(new Set<String>{'F0001'});
        final Map<String, Object> formParams7 = new Map<String, Object>();
        formParams7.put('accSelection', lstPAP7[0].participant_id__c);
        formParams7.put('chargeAmount', '300000');
        formParams7.put('chargePeriodicity', 'D');
        formParams7.put('clientRepDoc', 'Test');
        formParams7.put('clientRepName', 'Test');
        formParams7.put('comments', 'Test');
        formParams7.put('pkgSelection', lstPsCatPkg7[0].Id);

        Test.startTest();

            final Map<String, Object> retMap = ForfaitPackageEdit_Ctrl.doPostForfaitEditActions(JSON.serialize(lstPW7[0]), mapParams7, formParams7);
            final Map<String, Object> actualMap7 = new Map<String, Object>();
            actualMap7.put('isSuccess', retMap.get('isSuccess'));
            actualMap7.put('lstPACSize', ((List<profitability_analysis_condition__c>) retMap.get('lstPAC')).size());
            final Map<String, Object> expectedMap7 = new Map<String, Object>();
            expectedMap7.put('isSuccess', false);
            expectedMap7.put('lstPACSize', 2);
            System.assertEquals(expectedMap7, actualMap7, 'Err at ForfaitPackageEdit_Ctrl_Test - doPostForfaitEditActions2');

        Test.stopTest();
    }

    // Check doPostForfaitEditActions step 2 with ProfAnalysisCond related
    @IsTest
    static void doPostForfaitEditActions3() {

        final ProfitabilityAnalysis_Selector profAnSelector8 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA8 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> lstPA8 = profAnSelector8.selectByName(setNamesPA8);

        final List<Package_Wrapper> lstPW8 = Packages_Service.getPackagesToShow(lstPA8[0].Id, 'FORFAIT');
        final Map<String, Object> mapParams8 = new Map<String, Object>();
        mapParams8.put('profAnalysisId', lstPA8[0].Id);
        mapParams8.put('step', '2');
        mapParams8.put('decision', 'extend');
        mapParams8.put('makeExtensionActions', true);

        final PAParticipant_Selector papSelector8 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psCatPkgSelector8 = new PsCatalogPackage_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP8 = papSelector8.selectByProfAnalysis(new Set<Id>{lstPA8[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg8 = psCatPkgSelector8.selectByPkgCode(new Set<String>{'F0001'});
        final Map<String, Object> formParams8 = new Map<String, Object>();
        formParams8.put('accSelection', lstPAP8[0].participant_id__c);
        formParams8.put('chargeAmount', '300000');
        formParams8.put('chargePeriodicity', 'D');
        formParams8.put('clientRepDoc', 'Test');
        formParams8.put('clientRepName', 'Test');
        formParams8.put('comments', 'Test');
        formParams8.put('pkgSelection', lstPsCatPkg8[0].Id);

        Test.startTest();

            final Map<String, Object> retMap = ForfaitPackageEdit_Ctrl.doPostForfaitEditActions(JSON.serialize(lstPW8[0]), mapParams8, formParams8);
            final Map<String, Object> actualMap8 = new Map<String, Object>();
            actualMap8.put('isSuccess', retMap.get('isSuccess'));
            final Map<String, Object> expectedMap8 = new Map<String, Object>();
            expectedMap8.put('isSuccess', true);
            System.assertEquals(expectedMap8, actualMap8, 'Err at ForfaitPackageEdit_Ctrl_Test - doPostForfaitEditActions3');

        Test.stopTest();
    }

    // Check doPostForfaitEditActions step 2 with ProfAnalysisCond related (deextend)
    @IsTest
    static void doPostForfaitEditActions4() {

        final ProfitabilityAnalysis_Selector profAnSelector9 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA9 = new Set<String>{'Prof Analysis Test 6'};
        final List<profitability_analysis__c> lstPA9 = profAnSelector9.selectByName(setNamesPA9);

        final List<Package_Wrapper> lstPW9 = Packages_Service.getPackagesToShow(lstPA9[0].Id, 'FORFAIT');
        final Map<String, Object> mapParams9 = new Map<String, Object>();
        mapParams9.put('profAnalysisId', lstPA9[0].Id);
        mapParams9.put('step', '2');
        mapParams9.put('decision', 'deextend');
        mapParams9.put('makeExtensionActions', true);

        final PAParticipant_Selector papSelector9 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psCatPkgSelector9 = new PsCatalogPackage_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP9 = papSelector9.selectByProfAnalysis(new Set<Id>{lstPA9[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg9 = psCatPkgSelector9.selectByPkgCode(new Set<String>{'F0001'});
        final Map<String, Object> formParams9 = new Map<String, Object>();
        formParams9.put('accSelection', lstPAP9[0].participant_id__c);
        formParams9.put('chargeAmount', '300000');
        formParams9.put('chargePeriodicity', 'D');
        formParams9.put('clientRepDoc', 'Test');
        formParams9.put('clientRepName', 'Test');
        formParams9.put('comments', 'Test');
        formParams9.put('pkgSelection', lstPsCatPkg9[0].Id);

        Test.startTest();

            final Map<String, Object> retMap = ForfaitPackageEdit_Ctrl.doPostForfaitEditActions(JSON.serialize(lstPW9[0]), mapParams9, formParams9);
            final Map<String, Object> actualMap9 = new Map<String, Object>();
            actualMap9.put('isSuccess', retMap.get('isSuccess'));
            final Map<String, Object> expectedMap9 = new Map<String, Object>();
            expectedMap9.put('isSuccess', true);
            System.assertEquals(expectedMap9, actualMap9, 'Err at ForfaitPackageEdit_Ctrl_Test - doPostForfaitEditActions4');

        Test.stopTest();
    }

    // Check doPostForfaitEditActions step 1 withot ProfAnalysisCond related and prof analysis pkg req extended created
    @IsTest
    static void doPostForfaitEditActions5() {

        final ProfitabilityAnalysis_Selector profAnSelector10 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA10 = new Set<String>{'Prof Analysis Test 7'};
        final List<profitability_analysis__c> lstPA10 = profAnSelector10.selectByName(setNamesPA10);

        final List<Package_Wrapper> lstPW10 = Packages_Service.getPackagesToShow(lstPA10[0].Id, 'FORFAIT');
        final Map<String, Object> mapParams10 = new Map<String, Object>();
        mapParams10.put('profAnalysisId', lstPA10[0].Id);
        mapParams10.put('step', '1');
        mapParams10.put('decision', 'deextend');
        mapParams10.put('makeExtensionActions', true);

        final PAParticipant_Selector papSelector10 = new PAParticipant_Selector(true);
        final PsCatalogPackage_Selector psCatPkgSelector10 = new PsCatalogPackage_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP10 = papSelector10.selectByProfAnalysis(new Set<Id>{lstPA10[0].Id});
        final List<ps_catalog_package__c> lstPsCatPkg10 = psCatPkgSelector10.selectByPkgCode(new Set<String>{'F0006'});
        final Map<String, Object> formParams10 = new Map<String, Object>();
        formParams10.put('accSelection', lstPAP10[0].participant_id__c);
        formParams10.put('chargeAmount', '300000');
        formParams10.put('chargePeriodicity', 'D');
        formParams10.put('clientRepDoc', 'Test');
        formParams10.put('clientRepName', 'Test');
        formParams10.put('comments', 'Test2');
        formParams10.put('pkgSelection', lstPsCatPkg10[0].Id);

        Test.startTest();

            final Map<String, Object> retMap = ForfaitPackageEdit_Ctrl.doPostForfaitEditActions(JSON.serialize(lstPW10[0]), mapParams10, formParams10);
            final Map<String, Object> actualMap10 = new Map<String, Object>();
            actualMap10.put('isSuccess', retMap.get('isSuccess'));
            final Map<String, Object> expectedMap10 = new Map<String, Object>();
            expectedMap10.put('isSuccess', true);
            System.assertEquals(expectedMap10, actualMap10, 'Err at ForfaitPackageEdit_Ctrl_Test - doPostForfaitEditActions5');

        Test.stopTest();
    }

    // Check doPostForfaitEditActions exception error
    @IsTest
    static void doPostForfaitEditActions6() {
        Test.startTest();
            try {
                ForfaitPackageEdit_Ctrl.doPostForfaitEditActions(null, null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ForfaitPackageEdit_Ctrl_Test - doPostForfaitEditActions6');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void forfaitPacakgeEditConstructorTest() {
        Test.startTest();
            final ForfaitPackageEdit_Ctrl constructorTest = new ForfaitPackageEdit_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at ForfaitPackageEdit_Ctrl_Test - forfaitPacakgeEditConstructorTest');
        Test.stopTest();
    }

    // Private constructor test PackageExtended_Helper
    @IsTest
    static void packageExtendedHelperConstructorTest() {
        Test.startTest();
            final PackageExtended_Helper constructorTest2 = new PackageExtended_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at ForfaitPackageEdit_Ctrl_Test - packageExtendedHelperConstructorTest');
        Test.stopTest();
    }
}