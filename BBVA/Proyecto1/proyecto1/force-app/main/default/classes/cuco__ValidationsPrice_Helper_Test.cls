/**
* ────────────────────────────────────────────────────────────────────
* ValidationsPrice_Helper_Test
* Test class for ValidationsPrice_Helper class
* ────────────────────────────────────────────────────────────────────* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-17
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ValidationsPrice_Helper_Test {

    @TestSetup
    static void setupTestData() {
        final Date today = date.today();
        final List<Account> accountList = Test_Utils.createAccounts(1);
        insert accountList;
        final List<profitability_sheet__c> profSheetList = Test_Utils.createProfSheet(accountList[0]);
        insert profSheetList;
        final List<profitability_analysis__c> profAnalysisList = Test_Utils.createProfAnalysis(3, accountList[0]);
        profAnalysisList[0].cuco__gf_pa_management_type_name__c = 'New';
        profAnalysisList[0].cuco__gf_pa_price_negotiated_date__c = today - 40;
        profAnalysisList[1].cuco__gf_pa_management_type_name__c = 'New';
        profAnalysisList[1].cuco__gf_pa_price_negotiated_date__c = today - 10;
        profAnalysisList[2].cuco__gf_pa_management_type_name__c = 'Cancellation';
        profAnalysisList[2].cuco__gf_pa_price_negotiated_date__c = today - 40;
        insert profAnalysisList;
    }

    @IsTest
    static void checkNegValidityTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysis_Wrapper paWrapper1 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA1[0].Id);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        List<String> returnList = new List<String>();
        Test.startTest();
            returnList = ValidationsPrice_Helper.checkNegValidity(paWrapper1, genConfig);
            System.assertEquals(returnList[0], Label.error_price_app_validity, 'Error at ValidationsPrice_Helper_Test - checkNegValidityTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkNegValidityTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);
        final ProfitabilityAnalysis_Wrapper paWrapper2 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA2[0].Id);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        List<String> returnList = new List<String>();
        Test.startTest();
            returnList = ValidationsPrice_Helper.checkNegValidity(paWrapper2, genConfig);
            System.assertEquals(returnList.size(), 0, 'Error at ValidationsPrice_Helper_Test - checkNegValidityTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkNegValidityTest3() {
        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);
        final ProfitabilityAnalysis_Wrapper paWrapper3 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA3[0].Id);
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        List<String> returnList = new List<String>();
        Test.startTest();
            returnList = ValidationsPrice_Helper.checkNegValidity(paWrapper3, genConfig);
            System.assertEquals(returnList.size(), 0, 'Error at ValidationsPrice_Helper_Test - checkNegValidityTest3');
        Test.stopTest();
    }

    @IsTest
    static void validationsPriceConstructorTest() {
        Test.startTest();
            final ValidationsPrice_Helper constructorTest = new ValidationsPrice_Helper();
            System.assertEquals(constructorTest, constructorTest, 'Error at ValidationsPrice_Helper_Test - validationsPriceConstructorTest');
        Test.stopTest();
    }
}