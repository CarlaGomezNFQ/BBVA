/**
* ────────────────────────────────────────────────────────────────────
* ValidationsFlat_Helper_Test
* Test class for ValidationsFlat_Helper class
* ────────────────────────────────────────────────────────────────────* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-18
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ValidationsFlat_Helper_Test {
    @TestSetup
    static void setupTestData() {
        final List<Account> accountList = Test_Utils.createAccounts(1);
        insert accountList;
        final List<profitability_sheet__c> profSheetList = Test_Utils.createProfSheet(1,accountList[0]);
        insert profSheetList;
        final List<profitability_analysis__c> profAnalysisList = Test_Utils.createProfAnalysis(3, accountList[0]);
        profAnalysisList[0].gf_pa_management_type_name__c = 'New';
        profAnalysisList[1].gf_pa_management_type_name__c = 'Novation';
        profAnalysisList[1].gf_profitability_sheet_id__c = profSheetList[0].Id;
        profAnalysisList[2].gf_pa_management_type_name__c = 'New';
        insert profAnalysisList;
        final List<Id> proAnalysisId = new List<Id>{profAnalysisList[0].id};
        final List<profitability_analysis_flat_rates__c> paFlatRatesList = Test_Utils.createPaFlatRate(proAnalysisId, 'New');
        paFlatRatesList[0].gf_pa_fr_price_type__c = 'IF';
        paFlatRatesList[0].gf_pa_fr_charge_type__c = '1';
        paFlatRatesList[0].gf_pa_fr_charge_pdicy_type__c = '1';
        paFlatRatesList[0].gf_pa_fr_currency_type__c = 'EUR';
        paFlatRatesList[0].gf_pa_fr_charge_date_type__c = '1';
        paFlatRatesList[0].gf_pa_fr_pv_wrkdy_ch_meth_type__c = 'A';
        paFlatRatesList[0].gf_pa_fr_ac_no_bal_method_type__c = 'C';
        paFlatRatesList[0].gf_pa_fr_ac_comments_desc__c ='Account Comments';
        paFlatRatesList[0].gf_pa_fr_invoice_comments_desc__c = 'Invoice Comments';
        insert paFlatRatesList;
        final List<Id> proAnalysisId2 = new List<Id>{profAnalysisList[1].id};
        final List<profitability_analysis_flat_rates__c> paFlatRatesList2 = Test_Utils.createPaFlatRate(proAnalysisId2, 'Modification');
        paFlatRatesList2[0].gf_pa_fr_price_type__c = 'EF';
        paFlatRatesList2[0].gf_pa_fr_charge_type__c = '1';
        paFlatRatesList2[0].gf_pa_fr_charge_pdicy_type__c = '1';
        paFlatRatesList2[0].gf_pa_fr_currency_type__c = 'EUR';
        paFlatRatesList2[0].gf_pa_fr_charge_date_type__c = '1';
        paFlatRatesList2[0].gf_pa_fr_pv_wrkdy_ch_meth_type__c = 'A';
        paFlatRatesList2[0].gf_pa_fr_ac_no_bal_method_type__c = 'C';
        paFlatRatesList2[0].gf_pa_fr_ac_comments_desc__c ='Account Comments';
        paFlatRatesList2[0].gf_pa_fr_invoice_comments_desc__c = 'Invoice Comments';
        paFlatRatesList2[0].gf_pa_fr_variable_amount_desc__c = 'variable Amount specifications';
        insert paFlatRatesList2;

        // Create ps_catalog_flat_rates_account__c
        final List<ps_catalog_flat_rates_account__c> lstPsCatFRAcc = Test_Utils.createPSCatFlatRatesAcc();
        insert lstPsCatFRAcc;
        // Create profitability_analysis_flatrates_account__c
        final List<profitability_analysis_flatrates_account__c> lstPaFRAccs = Test_Utils.createPAFlatRatesAccounts(new List<profitability_analysis_flat_rates__c>{paFlatRatesList2[0]}, new List<ps_catalog_flat_rates_account__c>{lstPsCatFRAcc[0]}, new List<Decimal>{22,50});
        insert lstPaFRAccs;
        // Create ps_catalog_attribute__c
        final List<ps_catalog_attribute__c> psCatAttrList = Test_Utils.createPSCatalogAttributesFlat();
        insert psCatAttrList;
        // Create ps_catalog_flat_rates_attribute__c
        final List<ps_catalog_flat_rates_attribute__c> psCatFRAttList = Test_Utils.createPSCatalogFlatRatesAttributes(psCatAttrList);
        insert psCatFRAttList;
    }

    @IsTest
    static void checkMandatoryInfoTest1() {
        final ProfitabilityAnalysis_Selector paSelectMIT1 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPaMIT1 = paSelectMIT1.selectByName(new Set<String>{'Prof Analysis Test 0'});
        final ProfitabilityAnalysis_Wrapper paWrapMIT1 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPaMIT1[0].Id);
        List<String> returnList = new List<String>();
        Test.startTest();
            returnList = ValidationsFlat_Helper.checkMandatoryInfo(paWrapMIT1);
            System.assertEquals(1, returnList.size(), 'ValidationsFlat_Helper_Test - checkMandatoryInfoTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkMandatoryInfoTest2() {
        final ProfitabilityAnalysis_Selector paSelectMIT2 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPaMIT2 = paSelectMIT2.selectByName(new Set<String>{'Prof Analysis Test 1'});
        final ProfitabilityAnalysis_Wrapper paWrapMIT2 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPaMIT2[0].Id);
        List<String> returnList = new List<String>();
        Test.startTest();
            returnList = ValidationsFlat_Helper.checkMandatoryInfo(paWrapMIT2);
            System.assertEquals(0, returnList.size(), 'ValidationsFlat_Helper_Test - checkMandatoryInfoTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkMandatoryInfoTest3() {
        final ProfitabilityAnalysis_Selector paSelectMIT2 = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPaMIT2 = paSelectMIT2.selectByName(new Set<String>{'Prof Analysis Test 1'});
        final ProfitabilityAnalysis_Wrapper paWrapMIT2 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPaMIT2[0].Id);
        paWrapMIT2.flatRate.flatRateAccountsList.clear();
        List<String> returnList = new List<String>();
        Test.startTest();
            returnList = ValidationsFlat_Helper.checkMandatoryInfo(paWrapMIT2);
            System.assertEquals(1, returnList.size(), 'ValidationsFlat_Helper_Test - checkMandatoryInfoTest3');
        Test.stopTest();
    }

    @IsTest
    static void validationsFlatConstructorTest() {
        Test.startTest();
            final ValidationsFlat_Helper constructorTest = new ValidationsFlat_Helper();
            System.assertEquals(constructorTest, constructorTest, 'Error at ValidationsFlat_Helper_Test - validationsFlatConstructorTest');
        Test.stopTest();
    }
}