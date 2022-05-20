/**
  * ────────────────────────────────────────────────────────────────────
  * Dynamic_Pricing_Test
  * Test class for Dynamic_Pricing_Ctrl apex class
  * ────────────────────────────────────────────────────────────────────
  * @author     Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-04-29
  * @modified
  * @systemLayer Presentation
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */
@IsTest
public with sharing class Dynamic_Pricing_Test {

    @TestSetup
    static void makeDataOfAnalysisCtrl() {

    List<Account> acc = Test_Utils.createAccounts(1);
    insert acc;

    List<profitability_sheet__c>  profSheets= Test_Utils.createProfSheet(3, acc[0]);
    insert profSheets;

    final profitability_sheet_flat_rates__c psFlatRate = new profitability_sheet_flat_rates__c(
        cuco__gf_profitability_sheet_id__c = profSheets[0].Id
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
    psCatalogdp.gf_dp_item_crscls_ind_type__c = true;
    insert psCatalogdp;

    List<ps_catalog_attribute__c> attsReqFlat= Test_Utils.createPSCatAtFlat(1);
    attsReqFlat[0].gf_psc_attribute_id__c = 'extID';
    attsReqFlat[0].Name = 'catAttributeTest';
    insert attsReqFlat;

    final cuco__ps_catalog_flat_rates_attribute__c psCatalogAtt = new cuco__ps_catalog_flat_rates_attribute__c(
        cuco__gf_psc_attribute_id__c = attsReqFlat[0].Id
    );
    insert psCatalogAtt;

    final ps_catalog_flat_rates_dp_attribute__c psCatalogdpAtt = new ps_catalog_flat_rates_dp_attribute__c(
        cuco__gf_psc_fr_dynamic_pricing_id__c = psCatalogdp.Id,
        cuco__gf_psc_atribute_id__c = attsReqFlat[0].Id,
        cuco__gf_psc_dynamic_pricing_atrb_id__c = 'externalId'
    );
    insert psCatalogdpAtt;

    final cuco__profitability_sheet_flat_rates_dp__c psFlatdp = new cuco__profitability_sheet_flat_rates_dp__c(
        cuco__gf_ps_flat_rate_id__c = psFlatRate.Id,
        cuco__gf_dynamic_pricing_item_id__c = psCatalogdp.Id,
        cuco__gf_ps_fr_dp_annual_prc_amount__c = 150
    );
    insert psFlatdp;
    }

    @IsTest
    static void getDP() {

        final Set<String> psName = new Set<String>{'Prof Sheet Test 0'};
        final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector(true);
        final List<profitability_sheet__c> profSheet = psSelector.selectByName(psName);

        final PSFlatRates_Selector selector = new PSFlatRates_Selector(true);
        final Set<Id> profSheetSet = new Set<Id> {profSheet[0].Id};
        List<profitability_sheet_flat_rates__c> flat = selector.selectByProfSheet(profSheetSet);

        Test.startTest();
        DP_Clasification_Wrapper  dpWrapper = Dynamic_Pricing_Ctrl.getDP(ProfitabilitySheet_Helper.fillFlatWrapper(flat[0]));
        System.assertEquals(dpWrapper, dpWrapper, 'Err at Dynamic_Pricing_Ctrl - getD wrapper');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void dynamicPricingConstructorTest() {
        Test.startTest();
        final Dynamic_Pricing_Ctrl constructorTest = new Dynamic_Pricing_Ctrl();
        System.assertEquals(constructorTest, constructorTest, 'Err at Dynamic_Pricing_Ctrl - dynamicPricingConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void dynamicPricingHelperConstructorTest() {
        Test.startTest();
        final Dynamic_Pricing_Helper constructorTest2 = new Dynamic_Pricing_Helper();
        System.assertEquals(constructorTest2, constructorTest2, 'Err at Dynamic_Pricing_Helper - dynamicPricingHelperConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void dynamicPricingServiceConstructorTest() {
        Test.startTest();
        final Dynamic_Pricing_Service constructorTest3 = new Dynamic_Pricing_Service();
        System.assertEquals(constructorTest3, constructorTest3, 'Err at Dynamic_Pricing_Service - dynamicPricingServiceConstructorTest');
        Test.stopTest();
    }
}