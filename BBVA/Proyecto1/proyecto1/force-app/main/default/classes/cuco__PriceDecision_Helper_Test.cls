/**
* ____________________________________________________________________________
* Price Decision Helper Test
* Name class: PriceDecision_Helper_Test
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-04
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@IsTest
public with sharing class PriceDecision_Helper_Test {

    @TestSetup
    static void makeDataPriceDelegationLevels() {

        // Create a user to run
        final User usuario = Test_Utils.createUser();
        Insert usuario;

        // Create parent acc
        final List<Account> lstPriceDeleAcc = Test_Utils.createAccounts(1);
        lstPriceDeleAcc[0].AccountNumber = 'B99999999';
        lstPriceDeleAcc[0].Sic = '2325';
        Insert lstPriceDeleAcc;

        // Create child accs
        final List<Account> lstPriceDeleChAcc = Test_Utils.createAccounts(2);
        lstPriceDeleChAcc[0].ParentId = lstPriceDeleAcc[0].Id;
        lstPriceDeleChAcc[0].Sic = '2325';
        lstPriceDeleChAcc[1].Sic = '2325';
        Insert lstPriceDeleChAcc;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSPriceDele = Test_Utils.createProfSheet(1, lstPriceDeleAcc[0]);
        Insert lstPSPriceDele;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAPriceDeleg = new List<profitability_analysis__c>();
        lstPAPriceDeleg.addAll(Test_Utils.createProfAnalysis(lstPriceDeleAcc[0]));
        lstPAPriceDeleg.addAll(Test_Utils.createProfAnalysis(lstPriceDeleChAcc[1]));
        for (profitability_analysis__c paPriceDelegation : lstPAPriceDeleg) {
            paPriceDelegation.gf_pa_management_type_name__c = 'New';
            paPriceDelegation.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paPriceDelegation.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paPriceDelegation.gf_profitability_sheet_id__c = lstPSPriceDele[0].Id;
            paPriceDelegation.gf_price_aprvl_process_req_id__c = '1223456';
        }
        lstPAPriceDeleg[0].gf_pa_aprvl_proc_deleg_br_id__c = '2325';
        lstPAPriceDeleg[1].Name = 'Prof Analysis Test 1';
        Insert lstPAPriceDeleg;
    }

    @IsTest
    static void priceDecisionHelperTest1() {

        final User adminUser = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = paSelector.selectByName(setNamesPA);
        //Obtain the input profitability analysis details
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA[0].Id);
        Test.startTest();
            System.runAs(adminUser) {
                final PriceDecision_Helper pdh = new PriceDecision_Helper(paWrapper,'Test','DecisionTest');
                final HttpResponse response = pdh.callWs();
                System.assertEquals(response.getStatusCode(), 200, 'Err at PriceDecision_Helper_Test - priceDelegationLevelsHelperTest1');
            }
        Test.stopTest();
    }
}