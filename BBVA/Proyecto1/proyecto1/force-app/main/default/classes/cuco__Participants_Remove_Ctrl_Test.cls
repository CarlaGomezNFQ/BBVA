/**
* ────────────────────────────────────────────────────────────────────
* Participants_Remove_Ctrl_Test
* Test class for Participants_Remove_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-01
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Participants_Remove_Ctrl_Test {

    @TestSetup
    static void makeDataOfParticipantsRemoveCtrl() {

        // Create parent accounts
        final List<Account> lstGroupAccs = Test_Utils.createAccounts(7);
        insert lstGroupAccs;

        // Create child accounts
        final List<Account> lstChildAccs = Test_Utils.createAccounts(8);
        lstChildAccs[0].ParentId = lstGroupAccs[0].Id;
        lstChildAccs[1].ParentId = lstGroupAccs[1].Id;
        lstChildAccs[2].ParentId = lstGroupAccs[2].Id;
        lstChildAccs[3].ParentId = lstGroupAccs[3].Id;
        lstChildAccs[4].ParentId = lstGroupAccs[4].Id;
        lstChildAccs[5].ParentId = lstGroupAccs[5].Id;
        lstChildAccs[6].ParentId = lstGroupAccs[6].Id;
        lstChildAccs[7].ParentId = lstGroupAccs[6].Id;
        insert lstChildAccs;

        // Create profitability sheets
        final List<profitability_sheet__c> lstPS = Test_Utils.createProfSheet(7, lstGroupAccs);
        lstPS[0].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[1].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[2].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[3].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[4].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[5].gf_prftbly_sheet_stt_type_name__c = '01';
        lstPS[6].gf_prftbly_sheet_stt_type_name__c = '01';
        insert lstPS;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAPartR = Test_Utils.createProfAnalysis(7, lstGroupAccs);
        for (Integer i=0; i<lstPAPartR.size(); i++) {
            lstPAPartR[i].gf_pa_management_type_name__c = 'New';
            lstPAPartR[i].gf_pa_mgmt_stage_type_name__c = 'Analysis';
            lstPAPartR[i].gf_pa_mgmt_status_type_name__c = 'Analysis';
            lstPAPartR[i].gf_profitability_sheet_id__c = lstPS[i].Id;
        }
        lstPAPartR[2].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAPartR;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAP = new List<profitability_analysis_participant__c>();
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAPartR[0].Id, new List<Id>{lstChildAccs[0].Id}));
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAPartR[1].Id, new List<Id>{lstChildAccs[1].Id}));
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAPartR[2].Id, new List<Id>{lstChildAccs[2].Id}));
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAPartR[3].Id, new List<Id>{lstChildAccs[3].Id}));
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAPartR[4].Id, new List<Id>{lstChildAccs[4].Id}));
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPAPartR[5].Id, new List<Id>{lstChildAccs[5].Id}));
        lstPAP.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAPartR[6].Id, new List<Id>{lstChildAccs[6].Id, lstChildAccs[7].Id}));
        insert lstPAP;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCF = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCF;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCC = Test_Utils.createPSCatalogConditons(4, lstPSCF[0]);
        insert lstPSCC;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPAC = new List<profitability_analysis_condition__c>();
        final List<profitability_analysis_condition__c> lstPAC1 = Test_Utils.createProfAnalysisConditons(1, lstPAPartR[0], lstPSCC[0]);
        lstPAC1[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPAC1[0].gf_pa_source_cust_package_id__c = 'B00000000F0000';
        lstPAC.addAll(lstPAC1);
        final List<profitability_analysis_condition__c> lstPAC2 = Test_Utils.createProfAnalysisConditons(1, lstPAPartR[3], lstPSCC[1]);
        lstPAC2[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPAC2[0].gf_pa_source_cust_package_id__c = 'B00000003F0001';
        lstPAC.addAll(lstPAC2);
        final List<profitability_analysis_condition__c> lstPAC3 = Test_Utils.createProfAnalysisConditons(1, lstPAPartR[4], lstPSCC[2]);
        lstPAC3[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPAC3[0].gf_pa_source_cust_package_id__c = 'B00000004F0002';
        lstPAC.addAll(lstPAC3);
        final List<profitability_analysis_condition__c> lstPAC4 = Test_Utils.createProfAnalysisConditons(1, lstPAPartR[6], lstPSCC[3]);
        lstPAC4[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPAC4[0].gf_pa_source_cust_package_id__c = 'B00000007F0003';
        lstPAC.addAll(lstPAC4);
        insert lstPAC;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPsCatPkg = Test_Utils.createPsCatalogPackage(5, 'F');
        insert lstPsCatPkg;

        // Create client packages
        final List<client_package__c> lstCP = Test_Utils.createClientPackage(5, new List<Account>{lstChildAccs[0], lstChildAccs[3], lstChildAccs[4], lstChildAccs[5], lstChildAccs[7]}, lstPsCatPkg);
        insert lstCP;

        // Create profitability analysis pkg request
        final List<profitability_analysis_pkg_request__c> lstPAPkgReq = new List<profitability_analysis_pkg_request__c>();
        final List<profitability_analysis_pkg_request__c> lstPAPkgReq1 = Test_Utils.createProfAnPkgReq(1, lstPAPartR[0].Id, 'New');
        lstPAPkgReq1[0].participant_id__c = lstPAP[0].Id;
        lstPAPkgReq1[0].gf_cust_package_id__c = lstCP[0].Id;
        lstPAPkgReq1[0].gf_psc_package_id__c = lstPsCatPkg[0].Id; //F0000
        lstPAPkgReq.addAll(lstPAPkgReq1);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReq2 = Test_Utils.createProfAnPkgReq(1, lstPAPartR[3].Id, 'Extension');
        lstPAPkgReq2[0].participant_id__c = lstPAP[3].Id;
        lstPAPkgReq2[0].gf_cust_package_id__c = lstCP[1].Id;
        lstPAPkgReq2[0].gf_pa_pkg_ext_req_st_type_name__c = 'Add';
        lstPAPkgReq2[0].gf_psc_package_id__c = lstPsCatPkg[1].Id; //F0001
        lstPAPkgReq.addAll(lstPAPkgReq2);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReq3 = Test_Utils.createProfAnPkgReq(2, lstPAPartR[5].Id, 'New');
        lstPAPkgReq3[0].participant_id__c = lstPAP[5].Id;
        lstPAPkgReq3[0].gf_cust_package_id__c = lstCP[3].Id;
        lstPAPkgReq3[0].gf_psc_package_id__c = lstPsCatPkg[2].Id; //F0002
        lstPAPkgReq3[1].participant_id__c = lstPAP[5].Id;
        lstPAPkgReq3[1].gf_cust_package_id__c = lstCP[3].Id;
        lstPAPkgReq3[1].gf_pa_pkg_request_type_name__c = 'Extension';
        lstPAPkgReq3[1].gf_psc_package_id__c = lstPsCatPkg[3].Id; //F0003
        lstPAPkgReq.addAll(lstPAPkgReq3);
        final List<profitability_analysis_pkg_request__c> lstPAPkgReq4 = Test_Utils.createProfAnPkgReq(1, lstPAPartR[0].Id, 'New');
        lstPAPkgReq4[0].participant_id__c = lstPAP[7].Id;
        lstPAPkgReq4[0].gf_cust_package_id__c = lstCP[4].Id;
        lstPAPkgReq4[0].gf_psc_package_id__c = lstPsCatPkg[4].Id; //F0004
        lstPAPkgReq.addAll(lstPAPkgReq4);
        insert lstPAPkgReq;
    }

    // doPreviousChecks with all (With a ReqPkg, ExtPkg, and a GIP/Forfait pkg in Valid status)
    @IsTest
    static void doPreviousChecks1() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});

        final PsCatalogPackage_Selector psCatPkgSelector = new PsCatalogPackage_Selector(true);
        final List<ps_catalog_package__c> lstCatPkg = psCatPkgSelector.selectByPkgCode(new Set<String>{'F0000'});

        Test.startTest();

            final Map<String, Object> actualMap1 = Participants_Remove_Ctrl.doPreviousChecks(lstPAP[0].Id);

            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('papName', lstPAP[0].participant_id__r.Name);
            expectedMap1.put('profAnalysisId', lstPA[0].Id);
            expectedMap1.put('stage', 1);
            expectedMap1.put('hasReqPkg', true);
            expectedMap1.put('hasExtPkg', true);
            expectedMap1.put('extPkgName', lstCatPkg[0].gf_psc_package_name__c);

            System.assertEquals(expectedMap1, actualMap1, 'Err at Participants_Remove_Ctrl_Test - doPreviousChecks1');

        Test.stopTest();

    }

    // doPreviousChecks without all (Without a ReqPkg, ExtPkg, and a GIP/Forfait pkg in Valid status)
    @IsTest
    static void doPreviousChecks2() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});

        Test.startTest();

            final Map<String, Object> actualMap2 = Participants_Remove_Ctrl.doPreviousChecks(lstPAP[0].Id);

            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('papName', lstPAP[0].participant_id__r.Name);
            expectedMap2.put('profAnalysisId', lstPA[0].Id);
            expectedMap2.put('stage', 2);
            expectedMap2.put('hasReqPkg', false);
            expectedMap2.put('hasExtPkg', false);

            System.assertEquals(expectedMap2, actualMap2, 'Err at Participants_Remove_Ctrl_Test - doPreviousChecks2');

        Test.stopTest();

    }

    // doPreviousChecks err
    @IsTest
    static void doPreviousChecks3() {

        Test.startTest();

            try {
                Participants_Remove_Ctrl.doPreviousChecks(null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Participants_Remove_Ctrl_Test - doPreviousChecks3');
            }

        Test.stopTest();

    }

    // doRemoveActions without remove permissions
    @IsTest
    static void doRemoveActions1() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});

        Test.startTest();

            final Map<String, Object> retMap = Participants_Remove_Ctrl.doRemoveActions(lstPAP[0].Id, null);

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('showToast', true);
            expectedMap4.put('toastType', 'warning');
            expectedMap4.put('errMessage', Label.remove_subs_perm_error_sample);


            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('showToast', retMap.get('showToast'));
            actualMap4.put('toastType', retMap.get('toastType'));
            actualMap4.put('errMessage', retMap.get('errMessage'));

            System.assertEquals(expectedMap4, actualMap4, 'Err at Participants_Remove_Ctrl_Test - doRemoveActions1');

        Test.stopTest();

    }

    // doRemoveActions with remove permissions and an extended package and with pkg req with ext req type = 'Extension' -> Test to dextend pkg and delete pkg req

    @IsTest
    static void doRemoveActions2() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});

        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
        final List<profitability_analysis_condition__c> lstPACBf = pacSelector.selectByProfitabilityAnalysisIdAndSourceClientPkg(new Set<String>{'B00000003F0001'});

        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c>  lstPAPRBf = pkgReqSelector.selectPkgReqByAcc(new Set<Id>{lstPAP[0].Id});

        Test.startTest();

            final Map<String, Object> retMap = Participants_Remove_Ctrl.doRemoveActions(lstPAP[0].Id, null);

            final List<profitability_analysis_participant__c> lstPAPAf = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});
            final List<profitability_analysis_condition__c> lstPACAf = pacSelector.selectByProfitabilityAnalysisIdAndSourceClientPkg(new Set<String>{'B00000003F0001'});
            final List<profitability_analysis_pkg_request__c>  lstPAPRAf = pkgReqSelector.selectPkgReqByAcc(new Set<Id>{lstPAP[0].Id});


            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('retMap', new Map<String, Object>());
            expectedMap5.put('lstPAPBf', 1);    // Number of Profitability Analysis Participants before calling method
            expectedMap5.put('lstPACBf', 1);    // Number of Profitability Analysis Condition before calling method
            expectedMap5.put('lstPAPRBf', 1);   // Number of Profitability Analysis Pkg Request before calling method
            expectedMap5.put('lstPAPAf', 0);    // Number of Profitability Analysis Participants after calling method
            expectedMap5.put('lstPACAf', 0);    // Number of Profitability Analysis Condition after calling method
            expectedMap5.put('lstPAPRAf', 0);   // Number of Profitability Analysis Pkg Request after calling method

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('retMap', retMap);
            actualMap5.put('lstPAPBf', lstPAP.size());
            actualMap5.put('lstPACBf', lstPACBf.size());
            actualMap5.put('lstPAPRBf', lstPAPRBf.size());
            actualMap5.put('lstPAPAf', lstPAPAf.size());
            actualMap5.put('lstPACAf', lstPACAf.size());
            actualMap5.put('lstPAPRAf', lstPAPRAf.size());

            System.assertEquals(expectedMap5, actualMap5, 'Err at Participants_Remove_Ctrl_Test - doRemoveActions2');

        Test.stopTest();

    }

    // doRemoveActions with remove permissions and an extended package and with pkg req without ext req type = 'Extension' -> Test to dextend pkg and create new pkg req

    @IsTest
    static void doRemoveActions3() {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 4'};
        final List<profitability_analysis__c> lstPA = profAnSelector.selectByName(setNamesPA);

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});

        final ClientPackage_Selector cpSelector = new ClientPackage_Selector(true);
        final List<client_package__c> lstCP = cpSelector.selectPkgByAccIdAndStatus(new Set<Id>{lstPAP[0].participant_id__c}, new List<String>{'Valid'});

        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
        final List<profitability_analysis_condition__c> lstPACBf = pacSelector.selectByProfitabilityAnalysisIdAndSourceClientPkg(new Set<String>{'B00000004F0002'});

        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c>  lstPAPRBf = pkgReqSelector.selectPkgReqByReqType(new Set<Id>{lstCP[0].Id}, lstPAP[0].gf_profitablity_analysis_id__c, new List<String>{'Extension'});

        Test.startTest();

            final Map<String, Object> retMap = Participants_Remove_Ctrl.doRemoveActions(lstPAP[0].Id, null);

            final List<profitability_analysis_participant__c> lstPAPAf = papSelector.selectByProfAnalysis(new Set<Id>{lstPA[0].Id});
            final List<profitability_analysis_condition__c> lstPACAf = pacSelector.selectByProfitabilityAnalysisIdAndSourceClientPkg(new Set<String>{'B00000004F0002'});
            final List<profitability_analysis_pkg_request__c>  lstPAPRAf = pkgReqSelector.selectPkgReqByReqType(new Set<Id>{lstCP[0].Id}, lstPAP[0].gf_profitablity_analysis_id__c, new List<String>{'Extension'});

            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('retMap', new Map<String, Object>());
            expectedMap6.put('lstPAPBf', 1);    // Number of Profitability Analysis Participants before calling method
            expectedMap6.put('lstPACBf', 1);    // Number of Profitability Analysis Condition before calling method
            expectedMap6.put('lstPAPRBf', 0);   // Number of Profitability Analysis Pkg Request before calling method
            expectedMap6.put('lstPAPAf', 0);    // Number of Profitability Analysis Participants after calling method
            expectedMap6.put('lstPACAf', 0);    // Number of Profitability Analysis Condition after calling method
            expectedMap6.put('lstPAPRAf', 1);   // Number of Profitability Analysis Pkg Request after calling method

            final Map<String, Object> actualMap6 = new Map<String, Object>();
            actualMap6.put('retMap', retMap);
            actualMap6.put('lstPAPBf', lstPAP.size());
            actualMap6.put('lstPACBf', lstPACBf.size());
            actualMap6.put('lstPAPRBf', lstPAPRBf.size());
            actualMap6.put('lstPAPAf', lstPAPAf.size());
            actualMap6.put('lstPACAf', lstPACAf.size());
            actualMap6.put('lstPAPRAf', lstPAPRAf.size());

            System.assertEquals(expectedMap6, actualMap6, 'Err at Participants_Remove_Ctrl_Test - doRemoveActions3');

        Test.stopTest();


    }

    // doRemoveActions with remove permissions and two Pkg Req (One modification, one New) and first stage selected 'permanently' -> Test to delete pkg req and new pkg
    @IsTest
    static void doRemoveActions4() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        final PAParticipant_Selector papSelector4 = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP4 = papSelector4.selectByProfAnalysis(new Set<Id>{lstPA4[0].Id});

        final ClientPackage_Selector cpSelector4 = new ClientPackage_Selector(true);
        final List<client_package__c> lstCP4 = cpSelector4.selectPkgByAccIdAndStatus(new Set<Id>{lstPAP4[0].participant_id__c}, new List<String>{'Valid'});

        final PAPackageRequest_Selector pkgReqSelector4 = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c>  lstPAPRNewExtBf4 = pkgReqSelector4.selectPkgReqByReqType(new Set<Id>{lstCP4[0].Id}, lstPA4[0].Id, new List<String>{'New','Extension'});
        final List<profitability_analysis_pkg_request__c>  lstPAPRCanBf4 = pkgReqSelector4.selectPkgReqByReqType(new Set<Id>{lstCP4[0].Id}, lstPA4[0].Id, new List<String>{'Cancellation'});

        Test.startTest();

            final Map<String, Object> retMap4 = Participants_Remove_Ctrl.doRemoveActions(lstPAP4[0].Id, 'permanently');

            final List<profitability_analysis_participant__c> lstPAPAf4 = papSelector4.selectByProfAnalysis(new Set<Id>{lstPA4[0].Id});
            final List<profitability_analysis_pkg_request__c>  lstPAPRNewExtAf4 = pkgReqSelector4.selectPkgReqByReqType(new Set<Id>{lstCP4[0].Id}, lstPA4[0].Id, new List<String>{'New','Extension'});
            final List<profitability_analysis_pkg_request__c>  lstPAPRCanAf4 = pkgReqSelector4.selectPkgReqByReqType(new Set<Id>{lstCP4[0].Id}, lstPA4[0].Id, new List<String>{'Cancellation'});

            final Map<String, Object> expectedMap7 = new Map<String, Object>();
            expectedMap7.put('retMap', new Map<String, Object>());
            expectedMap7.put('lstPAPBf', 1);            // Number of Profitability Analysis Participants before calling method
            expectedMap7.put('lstPAPRNewExtBf', 2);     // Number of Profitability Analysis Pkg Request with type 'New' or 'Extension' before calling method
            expectedMap7.put('lstPAPRCanBf', 0);        // Number of Profitability Analysis Pkg Request with type 'Cancellation' before calling method
            expectedMap7.put('lstPAPAf', 0);            // Number of Profitability Analysis Participants after calling method
            expectedMap7.put('lstPAPRNewExtAf', 0);     // Number of Profitability Analysis Pkg Request with type 'New' or 'Extension' after calling method
            expectedMap7.put('lstPAPRCanAf', 1);        // Number of Profitability Analysis Pkg Request with type 'Cancellation' after calling method

            final Map<String, Object> actualMap7 = new Map<String, Object>();
            actualMap7.put('retMap', retMap4);
            actualMap7.put('lstPAPBf', lstPAP4.size());
            actualMap7.put('lstPAPRNewExtBf', lstPAPRNewExtBf4.size());
            actualMap7.put('lstPAPRCanBf', lstPAPRCanBf4.size());
            actualMap7.put('lstPAPAf', lstPAPAf4.size());
            actualMap7.put('lstPAPRNewExtAf', lstPAPRNewExtAf4.size());
            actualMap7.put('lstPAPRCanAf', lstPAPRCanAf4.size());

            System.assertEquals(expectedMap7, actualMap7, 'Err at Participants_Remove_Ctrl_Test - doRemoveActions4');

        Test.stopTest();

    }

    // doRemoveActions with remove permissions and two Pkg Req (One modification, one New) and first stage selected 'temporarily' -> Test to delete pkg req
    @IsTest
    static void doRemoveActions5() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 5'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        final PAParticipant_Selector papSelector5 = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP5 = papSelector5.selectByProfAnalysis(new Set<Id>{lstPA5[0].Id});

        final ClientPackage_Selector cpSelector5 = new ClientPackage_Selector(true);
        final List<client_package__c> lstCP5 = cpSelector5.selectPkgByAccIdAndStatus(new Set<Id>{lstPAP5[0].participant_id__c}, new List<String>{'Valid'});

        final PAPackageRequest_Selector pkgReqSelector5 = new PAPackageRequest_Selector(true);
        final List<profitability_analysis_pkg_request__c>  lstPAPRNewExtBf5 = pkgReqSelector5.selectPkgReqByReqType(new Set<Id>{lstCP5[0].Id}, lstPA5[0].Id, new List<String>{'New','Extension'});
        final List<profitability_analysis_pkg_request__c>  lstPAPRCanBf5 = pkgReqSelector5.selectPkgReqByReqType(new Set<Id>{lstCP5[0].Id}, lstPA5[0].Id, new List<String>{'Cancellation'});

        Test.startTest();

            final Map<String, Object> retMap5 = Participants_Remove_Ctrl.doRemoveActions(lstPAP5[0].Id, 'temporarily');

            final List<profitability_analysis_participant__c> lstPAPAf5 = papSelector5.selectByProfAnalysis(new Set<Id>{lstPA5[0].Id});
            final List<profitability_analysis_pkg_request__c>  lstPAPRNewExtAf5 = pkgReqSelector5.selectPkgReqByReqType(new Set<Id>{lstCP5[0].Id}, lstPA5[0].Id, new List<String>{'New','Extension'});
            final List<profitability_analysis_pkg_request__c>  lstPAPRCanAf5 = pkgReqSelector5.selectPkgReqByReqType(new Set<Id>{lstCP5[0].Id}, lstPA5[0].Id, new List<String>{'Cancellation'});

            final Map<String, Object> expectedMap8 = new Map<String, Object>();
            expectedMap8.put('retMap', new Map<String, Object>());
            expectedMap8.put('lstPAPBf', 1);            // Number of Profitability Analysis Participants before calling method
            expectedMap8.put('lstPAPRNewExtBf', 2);     // Number of Profitability Analysis Pkg Request with type 'New' or 'Extension' before calling method
            expectedMap8.put('lstPAPRCanBf', 0);        // Number of Profitability Analysis Pkg Request with type 'Cancellation' before calling method
            expectedMap8.put('lstPAPAf', 0);            // Number of Profitability Analysis Participants after calling method
            expectedMap8.put('lstPAPRNewExtAf', 0);     // Number of Profitability Analysis Pkg Request with type 'New' or 'Extension' after calling method
            expectedMap8.put('lstPAPRCanAf', 0);        // Number of Profitability Analysis Pkg Request with type 'Cancellation' after calling method

            final Map<String, Object> actualMap8 = new Map<String, Object>();
            actualMap8.put('retMap', retMap5);
            actualMap8.put('lstPAPBf', lstPAP5.size());
            actualMap8.put('lstPAPRNewExtBf', lstPAPRNewExtBf5.size());
            actualMap8.put('lstPAPRCanBf', lstPAPRCanBf5.size());
            actualMap8.put('lstPAPAf', lstPAPAf5.size());
            actualMap8.put('lstPAPRNewExtAf', lstPAPRNewExtAf5.size());
            actualMap8.put('lstPAPRCanAf', lstPAPRCanAf5.size());

            System.assertEquals(expectedMap8, actualMap8, 'Err at Participants_Remove_Ctrl_Test - doRemoveActions5');

        Test.stopTest();

    }

    // doPreviousChecks err
    @IsTest
    static void doRemoveActions7() {
        Test.startTest();
            try {
                Participants_Remove_Ctrl.doRemoveActions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Participants_Remove_Ctrl_Test - doPreviousChecks7');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void participantsRemoveCtrlConstructorTest() {
        Test.startTest();
            final Participants_Remove_Ctrl constructorTest = new Participants_Remove_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Participants_Remove_Ctrl_Test - participantsRemoveCtrlConstructorTest');
        Test.stopTest();
    }

    // Private Participants_Service constructor test
    @IsTest
    static void participantsRemoveCtrlConstructorTest2() {
        Test.startTest();
            final Participants_Service constructorTest2 = new Participants_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Participants_Remove_Ctrl_Test - participantsRemoveCtrlConstructorTest2');
        Test.stopTest();
    }

    // Private Participants_Helper constructor test
    @IsTest
    static void participantsRemoveCtrlConstructorTest3() {
        Test.startTest();
            final Participants_Helper constructorTest3 = new Participants_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Participants_Remove_Ctrl_Test - participantsRemoveCtrlConstructorTest3');
        Test.stopTest();
    }
}