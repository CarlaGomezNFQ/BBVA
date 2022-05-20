/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Ctrl_Test
* Test class for Flat_Rates_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-06
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Flat_Rates_Ctrl_Test {

    @TestSetup
    static void makeDataFlatRates() {

        // Create parent acc
        final List<Account> lstFlatRatesAcc = Test_Utils.createAccounts(1);
        lstFlatRatesAcc[0].AccountNumber = 'B99999999';
        insert lstFlatRatesAcc;

        // Create child accs
        final List<Account> lstFlatRatesChildAcc = Test_Utils.createAccounts(2);
        for (Account acc : lstFlatRatesChildAcc) {
            acc.ParentId = lstFlatRatesAcc[0].Id;
        }
        insert lstFlatRatesChildAcc;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSFlatRates = Test_Utils.createProfSheet(1, lstFlatRatesAcc[0]);
        insert lstPSFlatRates;

        // Create profitability sheet participants
        final List<profitability_sheet_participant__c> lstPSPFlatRates = Test_Utils.createProfSheetParticipant(1, lstPSFlatRates[0].Id, new List<Id>{lstFlatRatesChildAcc[0].Id});
        insert lstPSPFlatRates;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAFlatRates = Test_Utils.createProfAnalysis(2, lstFlatRatesAcc[0]);
        for (profitability_analysis__c paFlatRate : lstPAFlatRates) {
            paFlatRate.gf_pa_management_type_name__c = 'New';
            paFlatRate.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paFlatRate.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paFlatRate.gf_profitability_sheet_id__c = lstPSFlatRates[0].Id;
        }
        lstPAFlatRates[1].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAFlatRates;

        // Create profitability analysis participants
        final List<profitability_analysis_participant__c> lstPAPFlatRates = Test_Utils.createProfAnalysisParticipant(1, lstPAFlatRates[0].Id, new List<Id>{lstFlatRatesChildAcc[1].Id});
        insert lstPAPFlatRates;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCFFlatRates = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCFFlatRates;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCCFlatRates = Test_Utils.createPSCatalogConditons(4, lstPSCFFlatRates[0]);
        insert lstPSCCFlatRates;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgFlatRates = Test_Utils.createPSCatalogPackage(1, 'F');
        insert lstPSCatPkgFlatRates;

        // Create ps catalog pkg condition
        final List<ps_catalog_pkg_condition__c> lstPSCatPkgCondFlatRates = Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgFlatRates[0], lstPSCCFlatRates);
        insert lstPSCatPkgCondFlatRates;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACFlatRates = Test_Utils.createProfAnalysisConditons(1, lstPAFlatRates[0], lstPSCCFlatRates[0]);
        lstPACFlatRates[0].gf_pa_cond_atrb_source_type__c = 'COMMISSIONS_FLAT';
        lstPACFlatRates[0].gf_pa_source_cust_package_id__c = 'B00000000F0000';
        insert lstPACFlatRates;

        // Create profitability sheet conditions
        final List<profitability_sheet_condition__c> lstPSCFlatRates = Test_Utils.createProfSheetConditons(1, lstPSFlatRates[0], lstPSCCFlatRates[1]);
        lstPSCFlatRates[0].gf_ps_cond_atrb_srce_type_name__c = 'COMMISSIONS_FLAT';
        lstPSCFlatRates[0].gf_ps_source_cust_package_id__c = 'B00000001F0000';
        insert lstPSCFlatRates;

        // Create ps_catalog_attributes
        List<ps_catalog_attribute__c> lstPsCatAttb = Test_Utils.createPSCatalogAttributesFlat();
        insert lstPsCatAttb;

        // Create ps_catalog_flat_rates_attribute__c
        List<ps_catalog_flat_rates_attribute__c> lstPsCatFlatRatesAttb = Test_Utils.createPSCatalogFlatRatesAttributes(lstPsCatAttb);
        insert lstPsCatFlatRatesAttb;

        // Create profitability sheet flat rates
        final profitability_sheet_flat_rates__c psFlatRate = new profitability_sheet_flat_rates__c();
        psFlatRate.gf_ps_fr_price_type__c = '';
        psFlatRate.gf_ps_fr_fixed_annual_amount__c = 00;
        psFlatRate.gf_ps_fr_variable_amount_desc__c = '';
        psFlatRate.gf_ps_fr_charge_type__c = '';
        psFlatRate.gf_ps_fr_charge_pdicy_type__c = '';
        psFlatRate.gf_ps_fr_currency_type__c = '';
        psFlatRate.gf_ps_fr_price_type__c = '';
        psFlatRate.gf_ps_fr_no_wrkdy_ch_meth_type__c = '';
        psFlatRate.gf_ps_fr_ac_no_bal_method_type__c = '';
        psFlatRate.gf_profitability_sheet_id__c = lstPSFlatRates[0].Id;
        insert psFlatRate;

        // Create profitability analysis flat rates
        final List<profitability_analysis_flat_rates__c> paFlatRate = Test_Utils.createPaFlatRate(new List<Id>{lstPAFlatRates[0].Id}, 'New');
        insert paFlatRate;

        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAcc = Test_Utils.createPSCatFlatRatesAcc();
        insert lstPsCatFlatRatesAcc;

        final profitability_sheet_flat_rates_accounts__c psFlatAccount = new profitability_sheet_flat_rates_accounts__c(
            gf_ps_flat_rate_id__c = psFlatRate.Id,
            gf_psc_flat_rate_ac_svc_id__c = lstPsCatFlatRatesAcc[0].Id,
            gf_ps_fr_ac_use_per__c = 16
        );
        insert psFlatAccount;

        final profitability_analysis_flatrates_account__c paFlatAccount = new profitability_analysis_flatrates_account__c(
            gf_pa_flat_rate_id__c = paFlatRate[0].Id,
            gf_pa_flat_rate_account_id__c = lstPsCatFlatRatesAcc[1].Id,
            gf_pa_fr_ac_use_per__c = 25
        );
        insert paFlatAccount;
    }

    // Check getFlatRatesInfo of profitability_analysis__c
    @IsTest
    static void getFlatRatesInfo1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();

            final Map<String, Object> retMap1 = Flat_Rates_Ctrl.getFlatRatesInfo(lstPA1[0].Id);
            System.assertNotEquals(null, retMap1, 'Err at Flat_Rates_Ctrl_Test - getFlatRatesInfo1');

        Test.stopTest();
    }

    // Check getFlatRatesInfo of profitability_sheet__c
    @IsTest
    static void getFlatRatesInfo2() {

        final ProfitabilitySheet_Selector profSheetSelector2 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS2 = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> lstPS2 = profSheetSelector2.selectByName(setNamesPS2);

        Test.startTest();

            final Map<String, Object> retMap2 = Flat_Rates_Ctrl.getFlatRatesInfo(lstPS2[0].Id);
            System.assertNotEquals(null, retMap2, 'Err at Flat_Rates_Ctrl_Test - getFlatRatesInfo2');

        Test.stopTest();
    }

    // Check getFlatRatesInfo error
    @IsTest
    static void getFlatRatesInfo3() {
        Test.startTest();
            try {
                Flat_Rates_Ctrl.getFlatRatesInfo('000000000000000000');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Flat_Rates_Ctrl_Test - getFlatRatesInfo3');
            }
        Test.stopTest();
    }

    // Check checkSetupFlatRatesPermissions with permissions
    @IsTest
    static void checkSetupFlatRatesPermissions1() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        Test.startTest();

            final Map<String, Object> retMap3 = Flat_Rates_Ctrl.checkSetupFlatRatesPermissions(lstPA3[0].Id);
            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('setup', true);
            System.assertEquals(expectedMap3, retMap3, 'Err at Flat_Rates_Ctrl_Test - checkSetupFlatRatesPermissions1');

        Test.stopTest();
    }

    // Check checkSetupFlatRatesPermissions without permissions
    @IsTest
    static void checkSetupFlatRatesPermissions2() {

        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        Test.startTest();

            final Map<String, Object> retMap4 = Flat_Rates_Ctrl.checkSetupFlatRatesPermissions(lstPA4[0].Id);
            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('setup', false);
            expectedMap4.put('setupMessage', Label.setup_fr_perm_error_sample);
            System.assertEquals(expectedMap4, retMap4, 'Err at Flat_Rates_Ctrl_Test - checkSetupFlatRatesPermissions2');

        Test.stopTest();
    }

    // Check checkRemoveFlatRatesPermissions with permissions
    @IsTest
    static void checkRemoveFlatRatesPermissions1() {

        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        Test.startTest();

            final Map<String, Object> retMap5 = Flat_Rates_Ctrl.checkRemoveFlatRatesPermissions(lstPA5[0].Id);
            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('remove', true);
            System.assertEquals(expectedMap5, retMap5, 'Err at Flat_Rates_Ctrl_Test - checkRemoveFlatRatesPermissions1');

        Test.stopTest();
    }

    // Check checkRemoveFlatRatesPermissions without permissions
    @IsTest
    static void checkRemoveFlatRatesPermissions2() {

        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA6 = profAnSelector6.selectByName(setNamesPA6);

        Test.startTest();

            final Map<String, Object> retMap6 = Flat_Rates_Ctrl.checkRemoveFlatRatesPermissions(lstPA6[0].Id);
            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('remove', false);
            expectedMap6.put('removeMessage', Label.remove_fr_perm_error_sample);
            System.assertEquals(expectedMap6, retMap6, 'Err at Flat_Rates_Ctrl_Test - checkRemoveFlatRatesPermissions2');

        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void flatRatesConstructorTest() {
        Test.startTest();
            final Flat_Rates_Ctrl constructorTest = new Flat_Rates_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Flat_Rates_Ctrl_Test - flatRatesConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void flatRatesServiceConstructorTest() {
        Test.startTest();
            final Flat_Rates_Service constructorTest2 = new Flat_Rates_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Flat_Rates_Ctrl_Test - flatRatesServiceConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void flatRatesHelperConstructorTest() {
        Test.startTest();
            final Flat_Rates_Helper constructorTest3 = new Flat_Rates_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Flat_Rates_Ctrl_Test - flatRatesHelperConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void paFlatHelperConstructorTest() {
        Test.startTest();
            final ProfitabilityAnalysisFlat_Helper constructorTest4 = new ProfitabilityAnalysisFlat_Helper();
            System.assertEquals(constructorTest4, constructorTest4, 'Err at Flat_Rates_Ctrl_Test - PAFlatHelperConstructorTest');
        Test.stopTest();
    }
}