/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Remove_Ctrl_Test
* Test class for Flat_Rates_Remove_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-14
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Flat_Rates_Remove_Ctrl_Test {

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
        insert lstPACFlatRates;

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

    // Check requestData of profitability_analysis_flat_rates__c
    @IsTest
    static void requestDataTest() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byPaIdWithFields(new Set<Id>{lstPA1[0].Id});

        Test.startTest();
            final Map<String, Object> retMap1 = Flat_Rates_Remove_Ctrl.requestData(lstProfAnalFlatRates[0].Id);
            System.assertEquals(lstProfAnalFlatRates[0].Id, ((profitability_analysis_flat_rates__c) retMap1.get('returnedFlatRate')).Id, 'Error Flat_Rates_Remove_Ctrl_Test.requestDataTest(), paFlatRate id not returned');
        Test.stopTest();
    }

    // Check getFlatRatesInfo of profitability_analysis__c
    @IsTest
    static void persistDataTestNew() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byPaIdWithFields(new Set<Id>{lstPA1[0].Id});

        Test.startTest();
            final Map<String, Object> retMap1 = Flat_Rates_Remove_Ctrl.persistData(lstProfAnalFlatRates[0]);
            System.assertEquals(true, (Boolean) retMap1.get('isSuccess'), 'Error Flat_Rates_Remove_Ctrl_Test.persistDataTestNew(), isSuccess = false');
        Test.stopTest();
    }

    @IsTest
    static void persistDataTestMod() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byPaIdWithFields(new Set<Id>{lstPA1[0].Id});
        for (profitability_analysis_flat_rates__c pafr : lstProfAnalFlatRates) {
            pafr.cuco__gf_pa_fr_request_type__c = 'Modification';
        }
        update lstProfAnalFlatRates;

        Test.startTest();
            final Map<String, Object> retMap1 = Flat_Rates_Remove_Ctrl.persistData(lstProfAnalFlatRates[0]);
            System.assertEquals(true, (Boolean) retMap1.get('isSuccess'), 'Error Flat_Rates_Remove_Ctrl_Test.persistDataTestMod(), isSuccess = false');
        Test.stopTest();
    }

    @IsTest
    static void persistDataTestCan() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byPaIdWithFields(new Set<Id>{lstPA1[0].Id});
        for (profitability_analysis_flat_rates__c pafr : lstProfAnalFlatRates) {
            pafr.cuco__gf_pa_fr_request_type__c = 'Cancellation';
        }
        update lstProfAnalFlatRates;

        Test.startTest();
            final Map<String, Object> retMap1 = Flat_Rates_Remove_Ctrl.persistData(lstProfAnalFlatRates[0]);
            System.assertEquals(true, (Boolean) retMap1.get('isSuccess'), 'Error Flat_Rates_Remove_Ctrl_Test.persistDataTestCan(), isSuccess = false');
        Test.stopTest();
    }

    @IsTest
    static void persistDataTestEmp() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.byPaIdWithFields(new Set<Id>{lstPA1[0].Id});
        for (profitability_analysis_flat_rates__c pafr : lstProfAnalFlatRates) {
            pafr.cuco__gf_pa_fr_request_type__c = '';
        }
        update lstProfAnalFlatRates;

        Test.startTest();
            final Map<String, Object> retMap1 = Flat_Rates_Remove_Ctrl.persistData(lstProfAnalFlatRates[0]);
            System.assertEquals(true, (Boolean) retMap1.get('isSuccess'), 'Error Flat_Rates_Remove_Ctrl_Test.persistDataTestEmp(), isSuccess = false');
        Test.stopTest();
    }

    // Private Flat_Rates_Remove_Ctrl constructor test
    @IsTest
    static void flatRatesRemoveConstructorTest1() {
        Test.startTest();
            final Flat_Rates_Remove_Ctrl constructorTest = new Flat_Rates_Remove_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Flat_Rates_Remove_Ctrl_Test - flatRatesRemoveConstructorTest1');
        Test.stopTest();
    }

    // Private Flat_Rates_Remove_Service constructor test
    @IsTest
    static void flatRatesRemoveConstructorTest2() {
        Test.startTest();
            final Flat_Rates_Remove_Service constructorTest2 = new Flat_Rates_Remove_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Flat_Rates_Remove_Ctrl_Test - flatRatesRemoveConstructorTest2');
        Test.stopTest();
    }

    // Private Flat_Rates_Remove_Helper constructor test
    @IsTest
    static void flatRatesRemoveConstructorTest3() {
        Test.startTest();
            final Flat_Rates_Remove_Helper constructorTest3 = new Flat_Rates_Remove_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at Flat_Rates_Remove_Ctrl_Test - flatRatesRemoveConstructorTest3');
        Test.stopTest();
    }
}