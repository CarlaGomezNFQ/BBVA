/**
* ────────────────────────────────────────────────────────────────────
* ValidationsPackages_Helper_Test
* Test class for ValidationsPackages_Helper apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fco Javier Berenguer <franciscojavier.berenguer.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-17
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ValidationsPackages_Helper_Test {

    @TestSetup
    static void makeDataValidationPackages() {
        // Create parent account
        final List<Account> parentAccounts = Test_Utils.createAccounts(1);
        parentAccounts[0].AccountNumber = 'B99999999';
        insert parentAccounts;

        // Create child accounts
        final List<Account> childAccounts = Test_Utils.createAccounts(12);
        for (Account acc : childAccounts) {
            acc.ParentId = parentAccounts[0].Id;
        }
        insert childAccounts;

        // Split child accs for sheet and analysis participant records
        final List<Id> childIdsPSP = new List<Id>();
        final List<Account> childAccsPSP = new List<Account>();
        final List<Id> childIdsPAP = new List<Id>();
        final List<Account> childAccsPAP = new List<Account>();

        // First 4 records to psp, rest (8) to pap
        for (Integer i = 0; i < childAccounts.size(); i++) {
            if (i < 4) {
                childIdsPSP.add(childAccounts[i].Id);
                childAccsPSP.add(childAccounts[i]);
            } else {
                childIdsPAP.add(childAccounts[i].Id);
                childAccsPAP.add(childAccounts[i]);
            }
        }

        // Create ps catalog package
        final List<ps_catalog_package__c> psCatalogPackage = new List<ps_catalog_package__c>();
        psCatalogPackage.addAll(Test_Utils.createPSCatalogPackage(8, 'F'));
        psCatalogPackage.addAll(Test_Utils.createPSCatalogPackage(6, 'C'));
        psCatalogPackage.addAll(Test_Utils.createPSCatalogPackage(4, 'G'));
        insert psCatalogPackage;

        // Create ps catalog family
        final List<ps_catalog_family__c> psCatalogFamily = Test_Utils.createPSCatalogFamilies(1);
        insert psCatalogFamily;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> psCatalogCondition = Test_Utils.createPSCatalogConditons(2, psCatalogFamily[0]);
        insert psCatalogCondition;

        // Create ps catalog attribute
        List<ps_catalog_attribute__c> psCatalogAttribute = Test_Utils.createPSCatalogAttributes(5);
        psCatalogAttribute[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        psCatalogAttribute[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        psCatalogAttribute[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        psCatalogAttribute[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        psCatalogAttribute[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert psCatalogAttribute;

        // Create ps catalog condition attributes
        List<ps_catalog_condition_attribute__c> psCatCondAttribute = new List<ps_catalog_condition_attribute__c>();
        psCatCondAttribute.addAll(Test_Utils.createPSCatalogConditonAttributes(5, psCatalogCondition[0], psCatalogAttribute));
        psCatCondAttribute.addAll(Test_Utils.createPSCatalogConditonAttributes(5, psCatalogCondition[1], psCatalogAttribute));
        for (Integer i = 0; i < psCatCondAttribute.size(); i++) {
            psCatCondAttribute[i].gf_psc_condition_attribute_id__c = 'canonical.uniqueid.' + i;
            switch on Math.mod(i, 5) {
                when  0 {
                    psCatCondAttribute[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 1 {
                    psCatCondAttribute[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 2 {
                    psCatCondAttribute[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 3 {
                    psCatCondAttribute[i].gf_psc_ca_exemption_name__c = 'EF';
                }
                when 4 {
                    psCatCondAttribute[i].gf_psc_ca_exemption_name__c = 'true';
                }
            }
        }
        insert psCatCondAttribute;

        // Create profitability sheet
        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(2, parentAccounts[0]);
        insert profSheets;

        // Create profitability sheet participant
        final List<profitability_sheet_participant__c> psParticipant = Test_Utils.createProfSheetParticipant(4, profSheets[0].Id, childIdsPSP);
        insert psParticipant;

        // Create profitability sheet condition
        final List<profitability_sheet_condition__c> psCondition = Test_Utils.createProfSheetConditons(3, profSheets[0], psCatalogCondition[0]);
        psCondition[0].gf_ps_cond_atrb_srce_type_name__c = 'FORFAIT';
        psCondition[0].gf_ps_source_cust_package_id__c = 'B00000009F0004';
        psCondition[1].gf_ps_cond_atrb_srce_type_name__c = 'FORFAIT';
        psCondition[1].gf_ps_source_cust_package_id__c = 'B00000010F0005';
        psCondition[2].gf_ps_cond_atrb_srce_type_name__c = 'COMMERCIAL_PACKAGE';
        psCondition[2].gf_ps_source_cust_package_id__c = 'B00000011C0003';
        insert psCondition;

        // Create profitability analysis
        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(2, parentAccounts[0]);
        profAnalysis[0].gf_pa_management_type_name__c = 'New';
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].Id;
        profAnalysis[1].gf_pa_management_type_name__c = 'Cancellation';
        profAnalysis[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[1].gf_profitability_sheet_id__c = profSheets[1].Id;
        insert profAnalysis;

        // Create profitability analysis 0 participant
        final List<profitability_analysis_participant__c> paParticipants = Test_Utils.createProfAnalysisParticipant(6, profAnalysis[0].Id, childIdsPAP);
        insert paParticipants;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> paConditions = Test_Utils.createProfAnalysisConditons(5, profAnalysis[0], psCatalogCondition[1]);
        paConditions[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        paConditions[0].gf_pa_source_cust_package_id__c = 'B00000021F0006';
        paConditions[1].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        paConditions[1].gf_pa_source_cust_package_id__c = 'B00000022F010';
        paConditions[2].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        paConditions[2].gf_pa_source_cust_package_id__c = 'B00000023F011';
        paConditions[3].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        paConditions[3].gf_pa_source_cust_package_id__c = 'B00000024C0008';
        paConditions[4].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        paConditions[4].gf_pa_source_cust_package_id__c = 'B00000025C0009';
        insert paConditions;

        // Create profitability analysis 1 participant
        final List<profitability_analysis_participant__c> pa1Participants = Test_Utils.createProfAnalysisParticipant(1, profAnalysis[1].Id, childIdsPAP);
        insert pa1Participants;

        // Create profitability analysis 1 condition
        final List<profitability_analysis_condition__c> pa1Conditions = Test_Utils.createProfAnalysisConditons(1, profAnalysis[1], psCatalogCondition[1]);
        pa1Conditions[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        pa1Conditions[0].gf_pa_source_cust_package_id__c = 'B00000021F0006';
        insert pa1Conditions;

        // Create client packages
        final List<client_package__c> clientPackages = new List<client_package__c>();
        final List<Account> accPAClientPackages = new List<Account>{childAccsPAP[0], childAccsPAP[1], childAccsPAP[2], childAccsPAP[3], childAccsPAP[4],
            childAccsPAP[5], childAccsPAP[6], childAccsPAP[7]};
        final List<ps_catalog_package__c> psCatPAClientPackages = new List<ps_catalog_package__c>{psCatalogPackage[4], psCatalogPackage[5], psCatalogPackage[6], psCatalogPackage[7],
            psCatalogPackage[11], psCatalogPackage[12], psCatalogPackage[13],
            psCatalogPackage[16], psCatalogPackage[17]};
        final List<client_package__c> clientPackagesFromPA = Test_Utils.createClientPackage(8,  accPAClientPackages, psCatPAClientPackages);
        clientPackagesFromPA[6].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';
        clientPackagesFromPA[7].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';

        clientPackages.addAll(clientPackagesFromPA);

        final List<ps_catalog_package__c> psCatPSClientPackages = new List<ps_catalog_package__c>{psCatalogPackage[0], psCatalogPackage[1], psCatalogPackage[2], psCatalogPackage[3],
            psCatalogPackage[8], psCatalogPackage[9], psCatalogPackage[10],
            psCatalogPackage[14], psCatalogPackage[15]};
        final List<client_package__c> clientPackagesFromPS = Test_Utils.createClientPackage(4, childAccsPSP, psCatalogPackage);
        clientPackagesFromPS[2].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';
        clientPackagesFromPS[3].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';
        clientPackages.addAll(clientPackagesFromPS);
        insert clientPackages;

        // Create profitability analysis pkg request
        final List<profitability_analysis_pkg_request__c> paPackageRequest = Test_Utils.createProfAnPkgReq(5, profAnalysis[0].Id, 'New');
        paPackageRequest[0].participant_id__c = paParticipants[1].Id;
        paPackageRequest[0].gf_psc_package_id__c = psCatalogPackage[6].Id; //F0010
        paPackageRequest[0].gf_pa_pkg_charge_pdicy_type__c = 'D';
        paPackageRequest[0].gf_pa_pkg_request_type_name__c = 'New';
        paPackageRequest[1].participant_id__c = paParticipants[2].Id;
        paPackageRequest[1].gf_psc_package_id__c = psCatalogPackage[7].Id; //C010
        paPackageRequest[1].gf_pa_pkg_charge_pdicy_type__c = 'S';
        paPackageRequest[1].gf_pa_pkg_request_type_name__c = 'Modification';
        paPackageRequest[2].participant_id__c = paParticipants[3].Id;
        paPackageRequest[2].gf_psc_package_id__c = psCatalogPackage[12].Id; //C011
        paPackageRequest[2].gf_pa_pkg_charge_pdicy_type__c = 'Q';
        paPackageRequest[2].gf_pa_pkg_request_type_name__c = 'Extension';
        paPackageRequest[2].gf_pa_pkg_ext_req_st_type_name__c = 'Add';
        paPackageRequest[3].participant_id__c = paParticipants[4].Id;
        paPackageRequest[3].gf_psc_package_id__c = psCatalogPackage[13].Id; //G0005
        paPackageRequest[3].gf_pa_pkg_charge_pdicy_type__c = 'M';
        paPackageRequest[3].gf_pa_pkg_request_type_name__c = 'Extension';
        paPackageRequest[3].gf_pa_pkg_ext_req_st_type_name__c = 'Remove';
        paPackageRequest[4].participant_id__c = paParticipants[5].Id;
        paPackageRequest[4].gf_psc_package_id__c = psCatalogPackage[17].Id; //G0006
        paPackageRequest[4].gf_pa_pkg_charge_pdicy_type__c = 'T';
        paPackageRequest[4].gf_pa_pkg_request_type_name__c = 'Cancellation';
        insert paPackageRequest;
    }

    @IsTest
    static void checkNumExtendedPkgsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        Test.startTest();
            final List<String> retList = ValidationsPackages_Helper.checkNumExtendedPkgs(paWrapper);
            System.assertEquals(1, retList.size(), 'Err at ValidationsPackages_Helper_Test - checkNumExtendedPkgsTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkNumParticipantsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 1'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        Test.startTest();
            final List<String> retList = ValidationsPackages_Helper.checkNumParticipants(paWrapper);
            System.assertEquals(1, retList.size(), 'Err at ValidationsPackages_Helper_Test - checkNumParticipantsTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkExtendedPkgsStatusTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        Test.startTest();
            final List<String> retList = ValidationsPackages_Helper.checkExtendedPkgsStatus(paWrapper);
            System.assertEquals(0, retList.size(), 'Err at ValidationsPackages_Helper_Test - checkExtendedPkgsStatusTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkExtendedPkgsStatusTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
        paWrapper.packages.commPackageList[2].isExtended = true;
        paWrapper.packages.commPackageList[2].status.id = 'Cancelled';
        paWrapper.packages.commPackageList[2].status.id = 'Cancelled';
        paWrapper.packages.forfaitPackageList[2].isExtended = true;
        paWrapper.packages.forfaitPackageList[2].status.id = 'Cancelled';
        paWrapper.packages.forfaitPackageList[2].status.id = 'Cancelled';
        Test.startTest();
            final List<String> retList = ValidationsPackages_Helper.checkExtendedPkgsStatus(paWrapper);
            System.assertEquals(2, retList.size(), 'Err at ValidationsPackages_Helper_Test - checkExtendedPkgsStatusTest1');
        Test.stopTest();
    }

    @IsTest
    static void validationsPackagesConstructorTest() {
        Test.startTest();
            final ValidationsPackages_Helper constructorTest = new ValidationsPackages_Helper();
            System.assertEquals(constructorTest, constructorTest, 'Error at ValidationsPackages_Helper_Test - validationsPackagesConstructorTest');
        Test.stopTest();
    }
}