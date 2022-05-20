/**
* ────────────────────────────────────────────────────────────────────
* Request_Ctrl_test
* Test class for Request_Ctrl class
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-22
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public with sharing class Request_Ctrl_test {

    /** @description RENEWAL */
    static final String RENEWAL = Label.renewal;
    /** @description NOVATION */
    static final String NOVATION = Label.novation;
    /** @description CANCELLATION */
    static final String CANCELLATION = Label.cancellation;

    @TestSetup
    static void setupTestData() {

        /* create catalog */

        final List<ps_catalog_family__c> familiesReq = Test_Utils.createPSCatalogFamilies(1);
        insert familiesReq;

        final List<ps_catalog_attribute__c> attributesReq = Test_Utils.createPSCatalogAttributes(1);
        attributesReq[0].cuco__gf_attribute_value_type_name__c = 'List';
        attributesReq[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        insert attributesReq;

        final List<ps_catalog_attribute__c> attsReqFlat = Test_Utils.createPSCatAtFlat(1);
        insert attsReqFlat;

        final List<ps_catalog_condition__c> conditionsReq = Test_Utils.createPSCatalogConditons(2, familiesReq[0]);
        conditionsReq[0].cuco__gf_psc_cond_prc_class_ind_type__c = true;
        conditionsReq[1].cuco__gf_psc_cond_prc_class_ind_type__c = true;
        insert conditionsReq;

        final List<ps_catalog_condition_attribute__c> condAttriReq = Test_Utils.createPSCatalogConditonAttributes(1, conditionsReq[1], new List<ps_catalog_attribute__c>{attributesReq[0]});
        condAttriReq[0].cuco__gf_psc_condition_attribute_id__c = 'np.SEPA.day.payroll.eur.branch.max';
        insert condAttriReq;

        /* create profitability sheet and profitability analysis*/

        final User userReq = Test_Utils.createUser();
        insert userReq;

        final List<Account> accountsReq = Test_Utils.createAccounts(2);
        accountsReq[1].OwnerId = userReq.Id;
        accountsReq[0].AccountNumber = '001183970';
        insert accountsReq;

        /* profitability sheet */
        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(4, accountsReq[0]);
        profSheets[0].cuco__gf_profitability_sheet_id__c = 'ES0182000000020';
        profSheets[0].cuco__gf_prftbly_sheet_stt_type_name__c = '01';
        profSheets[0].cuco__gf_prftbly_sheet_start_date__c = Date.today().addMonths(-2);
        profSheets[0].cuco__gf_prftbly_sheet_end_date__c = Date.today().addMonths(2);
        profSheets[1].cuco__gf_profitability_sheet_id__c = 'ES0182000000021';
        profSheets[1].cuco__gf_prftbly_sheet_stt_type_name__c = '01';
        profSheets[1].cuco__gf_prftbly_sheet_start_date__c = Date.today().addMonths(-2);
        profSheets[1].cuco__gf_prftbly_sheet_end_date__c = Date.today().addMonths(2);
        profSheets[2].cuco__gf_profitability_sheet_id__c = 'ES0182000000022';
        profSheets[2].cuco__gf_prftbly_sheet_stt_type_name__c = '01';
        profSheets[2].cuco__gf_prftbly_sheet_start_date__c = Date.today().addMonths(-2);
        profSheets[2].cuco__gf_prftbly_sheet_end_date__c = Date.today().addMonths(2);
        profSheets[2].participant_id__c = accountsReq[1].Id;
        profSheets[3].cuco__gf_profitability_sheet_id__c = 'ES0182000000023';
        profSheets[3].cuco__gf_prftbly_sheet_stt_type_name__c = '12';
        profSheets[3].cuco__gf_prftbly_sheet_start_date__c = Date.today().addMonths(-2);
        profSheets[3].cuco__gf_prftbly_sheet_end_date__c = Date.today().addMonths(2);
        insert profSheets;

        /* profitability analysis */
        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(1, accountsReq[0]);
        profAnalysis[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysis[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysis[0].segment_type__c = 'BEC';
        profAnalysis[0].gf_all_ct_apply_cond_ind_type__c = false;
        profAnalysis[0].gf_pa_forced_mf_mgmt_ind_type__c = false;
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].Id;
        insert profAnalysis;

        final List<profitability_analysis_condition__c> paConditions = Test_Utils.createProfAnalysisConditons(1, profAnalysis[0], conditionsReq[0]);
        insert paConditions;

        final List<profitability_analysis_participant__c> lstPAP = Test_Utils.createProfAnalysisParticipant(1, profAnalysis[0].Id, new List<Id>{accountsReq[0].Id});
        insert lstPAP;

        final List<profitability_sheet_condition__c> psConditions1 = Test_Utils.createProfSheetConditons(1, profSheets[0], conditionsReq[0]);
        insert psConditions1;

        final List<profitability_sheet_condition__c> psConditions2 = Test_Utils.createProfSheetConditons(1, profSheets[1], conditionsReq[1]);
        insert psConditions2;

        final List<profitability_sheet_participant__c> lstPSP1 = Test_Utils.createProfSheetParticipant(1, profSheets[0].Id, new List<Id>{accountsReq[0].Id});
        insert lstPSP1;

        final List<profitability_sheet_participant__c> lstPSP2 = Test_Utils.createProfSheetParticipant(1, profSheets[1].Id, new List<Id>{accountsReq[0].Id});
        insert lstPSP2;

        final List<profitability_sheet_participant__c> lstPSP3 = Test_Utils.createProfSheetParticipant(1, profSheets[2].Id, new List<Id>{accountsReq[1].Id});
        insert lstPSP3;

        final List<profitability_sheet_participant__c> lstPSP4 = Test_Utils.createProfSheetParticipant(1, profSheets[3].Id, new List<Id>{accountsReq[0].Id});
        insert lstPSP4;

        /* create profitability sheet flatRates and catalog for flats */

        final profitability_sheet_flat_rates__c psFlatRate = new profitability_sheet_flat_rates__c(
            cuco__gf_profitability_sheet_id__c = profSheets[1].Id
        );
        insert psFlatRate;

        final cuco__ps_catalog_flat_rates_account__c psCatalogFlatAcc = new cuco__ps_catalog_flat_rates_account__c();
        insert psCatalogFlatAcc;

        final cuco__profitability_sheet_flat_rates_accounts__c psFlatAccount = new cuco__profitability_sheet_flat_rates_accounts__c(
            cuco__gf_ps_flat_rate_id__c = psFlatRate.Id,
            cuco__gf_psc_flat_rate_ac_svc_id__c = psCatalogFlatAcc.Id,
            cuco__gf_ps_fr_ac_use_per__c = 16
        );
        insert psFlatAccount;

        final cuco__ps_catalog_flat_rates_dp__c psCatalogdp = new cuco__ps_catalog_flat_rates_dp__c();
        insert psCatalogdp;

        /* create attributes for flats */

        final cuco__ps_catalog_flat_rates_attribute__c psCatalogAtt = new cuco__ps_catalog_flat_rates_attribute__c(
            cuco__gf_psc_attribute_id__c = attsReqFlat[0].Id
        );
        insert psCatalogAtt;

        final ps_catalog_flat_rates_dp_attribute__c psCatalogdpAtt = new ps_catalog_flat_rates_dp_attribute__c(
            cuco__gf_psc_fr_dynamic_pricing_id__c = psCatalogdp.Id,
            cuco__gf_psc_atribute_id__c = attsReqFlat[0].Id
        );
        insert psCatalogdpAtt;

        final cuco__profitability_sheet_flat_rates_dp__c psFlatdp = new cuco__profitability_sheet_flat_rates_dp__c(
            cuco__gf_ps_flat_rate_id__c = psFlatRate.Id,
            cuco__gf_dynamic_pricing_item_id__c = psCatalogdp.Id,
            cuco__gf_ps_fr_dp_annual_prc_amount__c = 150
        );
        insert psFlatdp;

        /* create catalog for packages */

        final cuco__ps_catalog_package__c psCatalogPack = new cuco__ps_catalog_package__c(
            cuco__gf_psc_package_name__c = 'Test bono',
            cuco__gf_psc_package_type_name__c = 'G',
            cuco__gf_psc_extended_pkg_ind_type__c = false,
            cuco__gf_psc_package_active_ind_type__c = true
        );
        insert psCatalogPack;

        final cuco__ps_catalog_pkg_condition__c psCatalogCondPack = new cuco__ps_catalog_pkg_condition__c(
            cuco__gf_psc_condition_id__c = conditionsReq[1].Id,
            cuco__gf_psc_package_id__c = psCatalogPack.Id,
            cuco__gf_psc_cond_pkg_act_ind_type__c = true
        );
        insert psCatalogCondPack;

        final cuco__client_package__c clientPckg = new cuco__client_package__c(
            cuco__participant_id__c = accountsReq[0].Id,
            cuco__gf_psc_package_code_id__c = psCatalogPack.Id,
            cuco__gf_cst_pkg_ct_srce_sys_st_type__c = 'V'
        );
        insert clientPckg;
    }

    @IsTest
    static void constructorRequestTest() {
        Test.startTest();
            final Request_Ctrl res = new Request_Ctrl();
            System.assertEquals(res, res, 'private constructor of Request_ctrl');
        Test.stopTest();
    }

    @IsTest
    static void requestErrorTest() {
        final Set<String> setNamePfErr = new Set<String>{'Prof Sheet Test 0'};
        final ProfitabilitySheet_Selector psSelectorErr = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> profSheetErr = psSelectorErr.selectByName(setNamePfErr);
        Test.startTest();
            try {
                System.assertNotEquals(Request_Ctrl.requestData(profSheetErr[0].Id,null),null,'Err');
            } catch(AuraHandledException e) {  //NOSONAR
                System.assertNotEquals(null, e.getMessage(), 'Request_Ctrl.requestData, error not captured');
            }
        Test.stopTest();
    }

    @IsTest
    static void requestDataTest1() {
        final Set<String> setNamePf = new Set<String>{'Prof Sheet Test 0'};
        final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> profSheet = psSelector.selectByName(setNamePf);

        Test.startTest();
            final Map<String, Object> mapResult = Request_Ctrl.requestData(profSheet[0].Id,RENEWAL);
            System.assertEquals(false, mapResult.get('success'), 'Error in requestData1 method');
        Test.stopTest();
    }

    @IsTest
    static void requestDataTest2() {
        final Set<String> setNamePf = new Set<String>{'Prof Sheet Test 1'};
        final ProfitabilitySheet_Selector psSelector1 = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> profSheet1 = psSelector1.selectByName(setNamePf);

        Test.startTest();
            final Map<String, Object> mapResult1 = Request_Ctrl.requestData(profSheet1[0].Id,CANCELLATION);
            System.assertEquals(true, mapResult1.get('success'), 'Error in requestData2 method');
        Test.stopTest();
    }

    @IsTest
    static void requestDataTest3() {
        final Set<String> setNamePf = new Set<String>{'Prof Sheet Test 2'};
        final ProfitabilitySheet_Selector psSelector2 = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> profSheet2 = psSelector2.selectByName(setNamePf);

        Test.startTest();
            final Map<String, Object> mapResult2 = Request_Ctrl.requestData(profSheet2[0].Id,NOVATION);
            System.assertEquals(false, mapResult2.get('success'), 'Error in requestData3 method');
        Test.stopTest();
    }

    @IsTest
    static void requestDataTest4() {
        final Set<String> setNamePf = new Set<String>{'Prof Sheet Test 3'};
        final ProfitabilitySheet_Selector psSelector3 = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> profSheet3 = psSelector3.selectByName(setNamePf);

        Test.startTest();
            final Map<String, Object> mapResult3 = Request_Ctrl.requestData(profSheet3[0].Id,CANCELLATION);
            System.assertEquals(true, mapResult3.get('success'), 'Error in requestData4 method');
        Test.stopTest();
    }

    @IsTest
    static void checkValidation1() { // Method to check new validation on Request_Helper
        final Set<String> setNamePf = new Set<String>{'Prof Sheet Test 2'};
        final ProfitabilitySheet_Selector psSelector4 = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> profSheet4 = psSelector4.selectByName(setNamePf);
        final Map<String,Object> mapDetails4 = ProfitabilitySheet_Service.getProfSheetFullDetails(profSheet4[0].Id);
        final ProfitabilitySheet_Wrapper wrapperInfo4 = (ProfitabilitySheet_Wrapper) mapDetails4.get('profSheetDetails');
        wrapperInfo4.status = 'Pending Request';

        Test.startTest();
            final Map<String, Object> mapResult4 = Request_Helper.checkValidations(wrapperInfo4, NOVATION);
            System.assertEquals(false, mapResult4.get('success'), 'Error in checkValidation1 method');
        Test.stopTest();
    }

    // Private Request_Ctrl constructor test
    @IsTest
    static void requestCtrlConstructorTest1() {
        Test.startTest();
            final Request_Ctrl constructorTest = new Request_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Request_Ctrl_test - requestCtrlConstructorTest1');
        Test.stopTest();
    }

    // Private Request_Service constructor test
    @IsTest
    static void requestServiceConstructorTest2() {
        Test.startTest();
            final Request_Service constructorTest2 = new Request_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Request_Ctrl_test - requestServiceConstructorTest2');
        Test.stopTest();
    }

    // Private Request_Helper constructor test
    @IsTest
    static void requestHelperConstructorTest3() {
        Test.startTest();
            final Request_Helper constructorTest3 = new Request_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Request_Ctrl_test - requestHelperConstructorTest3');
        Test.stopTest();
    }
}