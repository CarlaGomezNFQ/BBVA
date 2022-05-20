/**
* ────────────────────────────────────────────────────────────────────
* PriceDelegationLevels_Helper_Test
* Test class for PriceDelegationLevels_Helper apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-13
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class PriceDelegationLevels_Helper_Test {

    @TestSetup
    static void makeDataPriceDelegationLevels() {

        // Create a user to run
        final User usuario = Test_Utils.createUser();
        insert usuario;

        // Create parent acc
        final List<Account> lstPriceDelegationAcc = Test_Utils.createAccounts(1);
        lstPriceDelegationAcc[0].AccountNumber = 'B99999999';
        lstPriceDelegationAcc[0].Sic = '2325';
        insert lstPriceDelegationAcc;

        // Create child accs
        final List<Account> lstPriceDelegationChildAcc = Test_Utils.createAccounts(2);
        lstPriceDelegationChildAcc[0].ParentId = lstPriceDelegationAcc[0].Id;
        lstPriceDelegationChildAcc[0].Sic = '2325';
        lstPriceDelegationChildAcc[1].Sic = '2325';
        insert lstPriceDelegationChildAcc;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSPriceDelegation = Test_Utils.createProfSheet(1, lstPriceDelegationAcc[0]);
        insert lstPSPriceDelegation;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAPriceDelegation = new List<profitability_analysis__c>();
        lstPAPriceDelegation.addAll(Test_Utils.createProfAnalysis(lstPriceDelegationAcc[0]));
        lstPAPriceDelegation.addAll(Test_Utils.createProfAnalysis(lstPriceDelegationChildAcc[1]));
        for (profitability_analysis__c paPriceDelegation : lstPAPriceDelegation) {
            paPriceDelegation.gf_pa_management_type_name__c = 'New';
            paPriceDelegation.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paPriceDelegation.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paPriceDelegation.gf_profitability_sheet_id__c = lstPSPriceDelegation[0].Id;
        }
        lstPAPriceDelegation[0].gf_pa_aprvl_proc_deleg_br_id__c = '2325';
        lstPAPriceDelegation[1].Name = 'Prof Analysis Test 1';
        insert lstPAPriceDelegation;
    }

    @IsTest
    static void priceDelegationLevelsHelperTest1() {

        final User adminUser = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = paSelector.selectByName(setNamesPA);

        Test.startTest();
            System.runAs(adminUser) {
                final PriceDelegationLevels_Helper pdlHelper = new PriceDelegationLevels_Helper(lstPA[0].Id);
                final HttpResponse response = pdlHelper.callWs();
                System.assertEquals(201, response.getStatusCode(), 'Err at PriceDelegationLevels_Helper_Test - priceDelegationLevelsHelperTest1');
            }
        Test.stopTest();
    }

    @IsTest
    static void priceDelegationLevelsHelperTest2() {

        final User adminUser2 = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = paSelector2.selectByName(setNamesPA2);

        Test.startTest();
            System.runAs(adminUser2) {
                final PriceDelegationLevels_Helper pdlHelper2 = new PriceDelegationLevels_Helper(lstPA2[0].Id);
                final HttpResponse response2 = pdlHelper2.callWs();
                System.assertEquals(201, response2.getStatusCode(), 'Err at PriceDelegationLevels_Helper_Test - priceDelegationLevelsHelperTest2');
            }
        Test.stopTest();
    }
}