/**
* ────────────────────────────────────────────────────────────────────
* Analysis_ctrl_Test
* Test class for Analysis_ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author     Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-05
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Analysis_ctrl_Test {

    @TestSetup
    static void makeDataOfAnalysisCtrl() {

        /* create catalog */

        final List<ps_catalog_family__c> families = Test_Utils.createPSCatalogFamilies(1);
        insert families;

        final List<ps_catalog_attribute__c> attributes = Test_Utils.createPSCatalogAttributes(1);
        insert attributes;

        final List<ps_catalog_condition__c> conditions = Test_Utils.createPSCatalogConditons(1, families[0]);
        insert conditions;

        final List<ps_catalog_condition_attribute__c> conditionAttributes = Test_Utils.createPSCatalogConditonAttributes(attributes.size(), conditions[0], attributes);
        insert conditionAttributes;

        /* create conditions */

        final List<Account> accounts = Test_Utils.createAccounts(1);
        insert accounts;

        final List<profitability_sheet__c> profSheets = Test_Utils.createProfSheet(1, accounts[0]);
        insert profSheets;

        final List<profitability_analysis__c> profAnalysis = Test_Utils.createProfAnalysis(1, accounts[0]);
        profAnalysis[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysis[0].gf_profitability_sheet_id__c = profSheets[0].Id;

        insert profAnalysis;

        final List<profitability_analysis_condition__c> paConditions = Test_Utils.createProfAnalysisConditons(1, profAnalysis[0], conditions[0]);
        insert paConditions;

        final List<profitability_sheet_condition__c> psConditions = Test_Utils.createProfSheetConditons(1, profSheets[0], conditions[0]);
        insert psConditions;
    }

    @IsTest
    static void checkManageAnalysis() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String> {'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);
        Test.startTest();
        final Map<String, Object> retMapManAnalysis = Analysis_ctrl.getAnalysisPermissions(profitabilityAnalysis[0].Id);
        final Map<String, Object> expectedMapManAnalysis = new Map<String, Object>();
        expectedMapManAnalysis.put('profAnalys', profitabilityAnalysis[0]);
        expectedMapManAnalysis.put('manage', false);
        expectedMapManAnalysis.put('manageMessage', Label.manage_analysis_perm_error_sample);
        System.assertEquals(expectedMapManAnalysis.get('manage'), retMapManAnalysis.get('manage'), 'Expected ' + expectedMapManAnalysis.get('manage')+'. got ' + retMapManAnalysis.get('manage'));
        System.assertEquals(expectedMapManAnalysis.get('manageMessage'), retMapManAnalysis.get('manageMessage'), 'Expected ' + expectedMapManAnalysis.get('manageMessage')+'. got ' + retMapManAnalysis.get('manageMessage'));
        Test.stopTest();
    }
    @IsTest
    static void checkUpdateComments() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(false);
        final Set<String> paNames = new Set<String> {'Prof Analysis Test 0'};
        final List<profitability_analysis__c> profitabilityAnalysis = paSelector.selectByName(paNames);
        Test.startTest();
        Utils.DML_Wrapper wrapper = Analysis_ctrl.updatePAAnalysis(profitabilityAnalysis);
        Utils.DML_Wrapper expected = new Utils.DML_Wrapper(true, new List<String>());
        System.assertEquals(expected.isSuccess, wrapper.isSuccess, 'Expected ' + expected.isSuccess + '. got ' + wrapper.isSuccess);
        Test.stopTest();
    }
    @IsTest
    static void checkUpdateCommentsException() {
        Test.startTest();
        try{
            Utils.DML_Wrapper wrapper = Analysis_ctrl.updatePAAnalysis(null);
            Utils.DML_Wrapper expected = new Utils.DML_Wrapper(false, new List<String>());
            System.assertEquals(expected.isSuccess, wrapper.isSuccess, 'Expected ' + expected.isSuccess + '. got ' + wrapper.isSuccess);
        }catch (Exception e) { //NOSONAR
            System.debug('Exception '+ e);//NOSONAR
        }
        Test.stopTest();
    }

    // Check getAnalysisPermissions exception error
    @IsTest
    static void checkGetAnalysisPermissionsErr() {
        Test.startTest();
            try {
                Analysis_ctrl.getAnalysisPermissions('000000000000000000');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Analysis_ctrl_Test - checkGetAnalysisPermissionsErr');
            }
        Test.stopTest();
    }

    // Check checkManagePAPermissionsErr exception error
    @IsTest
    static void checkManagePAPermissionsErr() {
        Test.startTest();
            try {
                Analysis_ctrl.checkManagePAPermissions('000000000000000000');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Analysis_ctrl_Test - checkManagePAPermissionsErr');
            }
        Test.stopTest();
    }

    // Private Analysis_ctrl constructor test
    @IsTest
    static void analysisCtrlConstructorTest1() {
        Test.startTest();
            final Analysis_ctrl constructorTest = new Analysis_ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Analysis_ctrl_Test - analysisCtrlConstructorTest1');
        Test.stopTest();
    }
}