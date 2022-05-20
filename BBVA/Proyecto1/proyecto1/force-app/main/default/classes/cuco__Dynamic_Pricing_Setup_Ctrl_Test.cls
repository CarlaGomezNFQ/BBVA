/**
  * ────────────────────────────────────────────────────────────────────
  * Dynamic_Pricing_Setup_Ctrl_Test
  * Test class for Dynamic_Pricing_Setup_Ctrl apex class
  * ────────────────────────────────────────────────────────────────────
  * @author     Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-05-19
  * @modified
  * @systemLayer Presentation
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */
  @IsTest
  public with sharing class Dynamic_Pricing_Setup_Ctrl_Test {

    @TestSetup
    static void flatsSetup() {

        List<Account> acc = Test_Utils.createAccounts(1);
        insert acc;

        List<profitability_sheet__c>  profSheets= Test_Utils.createProfSheet(3, acc[0]);
        insert profSheets;

        List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(1, acc[0]);
        insert profAnalysis;

        final profitability_sheet_flat_rates__c psFlatRate = new profitability_sheet_flat_rates__c(
            cuco__gf_profitability_sheet_id__c = profSheets[0].Id
        );
        insert psFlatRate;

        final profitability_analysis_flat_rates__c paFlatRate = new profitability_analysis_flat_rates__c(
            cuco__gf_profitablity_analysis_id__c = profAnalysis[0].Id
        );
        insert paFlatRate;

        final cuco__ps_catalog_flat_rates_account__c psCatalogFlatAcc = new cuco__ps_catalog_flat_rates_account__c();
        insert psCatalogFlatAcc;

        final cuco__profitability_sheet_flat_rates_accounts__c psFlatAccount = new cuco__profitability_sheet_flat_rates_accounts__c(
            cuco__gf_ps_flat_rate_id__c = psFlatRate.Id,
            cuco__gf_psc_flat_rate_ac_svc_id__c = psCatalogFlatAcc.Id,
            cuco__gf_ps_fr_ac_use_per__c = 16
        );
        insert psFlatAccount;

        final cuco__ps_catalog_flat_rates_dp__c psCatalogdp = new cuco__ps_catalog_flat_rates_dp__c(
            Name = 'Office',
            cuco__gf_dp_item_crscls_ind_type__c = false
        );
        final cuco__ps_catalog_flat_rates_dp__c psCatalogdp2 = new cuco__ps_catalog_flat_rates_dp__c(
            Name = 'Bank',
            cuco__gf_dp_item_crscls_ind_type__c = true
        );
        insert psCatalogdp;
        insert psCatalogdp2;

        List<ps_catalog_attribute__c> attsReqFlat= Test_Utils.createPSCatAtFlat(1);
        attsReqFlat[0].cuco__gf_pscd_atrb_dp_apply_ind_type__c = true;
        insert attsReqFlat;

        final cuco__ps_catalog_flat_rates_attribute__c psCatalogAtt = new cuco__ps_catalog_flat_rates_attribute__c(
            cuco__gf_psc_attribute_id__c = attsReqFlat[0].Id
        );
        insert psCatalogAtt;

        final ps_catalog_flat_rates_dp_attribute__c psCatalogdpAtt = new ps_catalog_flat_rates_dp_attribute__c(
            cuco__gf_psc_fr_dynamic_pricing_id__c = psCatalogdp.Id,
            cuco__gf_psc_atribute_id__c = attsReqFlat[0].Id,
            cuco__gf_psc_atrb_active_dp_ind_type__c = true
        );
        insert psCatalogdpAtt;

        final cuco__profitability_sheet_flat_rates_dp__c psFlatdp = new cuco__profitability_sheet_flat_rates_dp__c(
            cuco__gf_ps_flat_rate_id__c = psFlatRate.Id,
            cuco__gf_dynamic_pricing_item_id__c = psCatalogdp.Id,
            cuco__gf_ps_fr_dp_annual_prc_amount__c = 150
        );
        insert psFlatdp;

        final cuco__profitability_analysis_flat_rates_dp__c paFlatRateDP = new cuco__profitability_analysis_flat_rates_dp__c(
            cuco__gf_pa_flat_rate_id__c = paFlatRate.Id,
            cuco__gf_fr_dynamic_pricing_item_id__c = psCatalogdp.Id
        );
        insert paFlatRateDP;

        //New ps catalog data
        final ps_catalog_flat_rates_dp_attribute__c psCatalogdpAtt2 = new ps_catalog_flat_rates_dp_attribute__c(
            cuco__gf_psc_fr_dynamic_pricing_id__c = psCatalogdp2.Id,
            cuco__gf_psc_atribute_id__c = attsReqFlat[0].Id,
            cuco__gf_psc_atrb_active_dp_ind_type__c = true
        );
        insert psCatalogdpAtt2;

        final cuco__profitability_sheet_flat_rates_dp__c psFlatdp2 = new cuco__profitability_sheet_flat_rates_dp__c(
            cuco__gf_ps_flat_rate_id__c = psFlatRate.Id,
            cuco__gf_dynamic_pricing_item_id__c = psCatalogdp2.Id,
            cuco__gf_ps_fr_dp_annual_prc_amount__c = 150
        );
        insert psFlatdp2;

        final cuco__profitability_analysis_flat_rates_dp__c paFlatRateDP2 = new cuco__profitability_analysis_flat_rates_dp__c(
            cuco__gf_pa_flat_rate_id__c = paFlatRate.Id,
            cuco__gf_fr_dynamic_pricing_item_id__c = psCatalogdp2.Id
        );
        insert paFlatRateDP2;
    }

    // Private constructor test
    @IsTest
    static void constructorFlatTest() {
        Test.startTest();
        final Dynamic_Pricing_Setup_Ctrl resFlat = new Dynamic_Pricing_Setup_Ctrl();
        System.assertEquals(resFlat, resFlat, 'private constructor of Dynamic_Pricing_Setup_Ctrl');
        Test.stopTest();
    }

    // Private constructor test 2
    @IsTest
    static void constructorFlatTest2() {
        Test.startTest();
        final Dynamic_Pricing_Setup_Helper resFlat = new Dynamic_Pricing_Setup_Helper();
        System.assertEquals(resFlat, resFlat, 'private constructor of Dynamic_Pricing_Setup_Helper');
        Test.stopTest();
    }

    // Private constructor test 3
    @IsTest
    static void constructorFlatTest3() {
        Test.startTest();
        final Dynamic_Pricing_Setup_Service resFlat = new Dynamic_Pricing_Setup_Service();
        System.assertEquals(resFlat, resFlat, 'private constructor of Dynamic_Pricing_Setup_Service');
        Test.stopTest();
    }

    @IsTest
    static void checkDPErrorTest() {
        Test.startTest();
            try {
                Dynamic_Pricing_Setup_Ctrl.getDPData(null);
            } catch(AuraHandledException e) {  //NOSONAR
                System.assertNotEquals(null, e.getMessage(), 'Err at Dynamic_Pricing_Setup_Ctrl - checkDPErrorTest');
            }
        Test.stopTest();
    }

    @IsTest
    static void checkDPTest() {

        final Set<String> paName = new Set<String>{'Prof Analysis Test 0'};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalysis = paSelector.selectByName(paName);

        final ProfitabilityAnalysisFlatRates_Selector paDPSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final Set<Id> profAnalysisSet = new Set<Id> {profAnalysis[0].Id};
        final List<profitability_analysis_flat_rates__c> flat = paDPSelector.selectByProfAnalysis(profAnalysisSet);

        Test.startTest();
        final Map<String, Object> mapReturn = Dynamic_Pricing_Setup_Ctrl.getDPData(flat[0].Id);
        System.assertEquals(mapReturn, mapReturn, 'Err at Dynamic_Pricing_Setup_Ctrl - getD wrapper');
        Test.stopTest();
    }

    @IsTest
    static void doSaveActionsErrorTest() {
        Test.startTest();
            try {
                Dynamic_Pricing_Setup_Ctrl.doSaveActions(null, null);
            } catch(AuraHandledException e) {  //NOSONAR
                System.assertNotEquals(null, e.getMessage(), 'Err at Dynamic_Pricing_Setup_Ctrl - doSaveActionsErrorTest');
            }
        Test.stopTest();
    }

    @IsTest
    static void doSaveActionsTest() {
        final Set<String> paName2 = new Set<String>{'Prof Analysis Test 0'};
        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnalysis2 = paSelector2.selectByName(paName2);

        final ProfitabilityAnalysisFlatRates_Selector paDPSelector2 = new ProfitabilityAnalysisFlatRates_Selector(true);
        final Set<Id> profAnalysisSet2 = new Set<Id> {profAnalysis2[0].Id};
        final List<profitability_analysis_flat_rates__c> flat2 = paDPSelector2.selectByProfAnalysis(profAnalysisSet2);

        final Set<String> paNameAtt = new Set<String>{'Flat_ATT_0'};
        final PsCatalogAttribute_Selector attSelector = new PsCatalogAttribute_Selector(true);
        final List<ps_catalog_attribute__c> attrib = attSelector.selectCatalogAttributeFromAttbCode(paNameAtt);

        final Set<String> paNameFlatDP = new Set<String>{'Office'};
        final PSCatalogFlatRatesDpSelector catDPSelector = new PSCatalogFlatRatesDpSelector(true);
        final List<ps_catalog_flat_rates_dp__c> catDP = catDPSelector.selectByName(paNameFlatDP);

        final String strValues = '{"lst2Insert":[{"flatId":"","flatName":"Oficina emitida","attb":[{"id":"'+attrib[0].Id+'","value":"6"}],"dynamicPricingId":"'+catDP[0].Id+'"}],"lst2Update":[{"flatId":"a091x000005mlP0AAI","flatName":"Cobro manual adeudos","attb":[{"id":"a0K1x000003ch9UEAQ","value":"5.000"},{"id":"a0K1x000003ch9VEAQ","value":"1.00"}],"dynamicPricingId":"a0R1x0000049O3VEAU"},{"flatId":"a091x000005mlOvAAI","flatName":"Conjunto","attb":[{"id":"a0K1x000003ch9SEAQ","value":"2"},{"id":"a0K1x000003ch9TEAQ","value":"1"}],"dynamicPricingId":"a0R1x0000049O3WEAU"}],"lst2Delete":[{"flatId":"a091x000005ml1zAAA","flatName":"Electrónico emitido","attb":[{"id":"a0K1x000003ch9SEAQ","value":""},{"id":"a0K1x000003ch9TEAQ","value":""}],"dynamicPricingId":"a0R1x0000049O3XEAU"}]}';
        Test.startTest();
        try {
            final Map<String, Object> mapResult1 = Dynamic_Pricing_Setup_Ctrl.doSaveActions(strValues, flat2[0].Id);
            System.assertNotEquals(mapResult1, null, 'Err 1 in doSaveActionsTest');
        } catch(AuraHandledException e) {  //NOSONAR
            System.assertNotEquals(null, e.getMessage(), 'Dynamic_Pricing_Setup_Ctrl.doSaveActions, error not captured');
        }
        Test.stopTest();
    }
}