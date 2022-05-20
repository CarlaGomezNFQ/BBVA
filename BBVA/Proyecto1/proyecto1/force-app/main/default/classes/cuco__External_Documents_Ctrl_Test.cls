/**
* ────────────────────────────────────────────────────────────────────
* External_Documents_Ctrl_Test
* Test class for External_Documents_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-09
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class External_Documents_Ctrl_Test {

    @TestSetup
    static void setupTestData() {

        // Create parent acc
        final List<Account> extDocsAccList = Test_Utils.createAccounts(1);
        extDocsAccList[0].AccountNumber = 'B99999999';
        insert extDocsAccList;

        // Create profitability sheet
        final List<profitability_sheet__c> profSheetList = Test_Utils.createProfSheet(1, extDocsAccList[0]);
        insert profSheetList;

        // Create profitability analysis
        final List<profitability_analysis__c> profAnList = Test_Utils.createProfAnalysis(3, extDocsAccList[0]);
        insert profAnList;

        // Create profitability analysis external documents
        final List<profitability_analysis_external_document__c> extDocList1 = Test_Utils.createPAExternalDoc(4, profAnList[0].Id);
        insert extDocList1;

        final List<profitability_analysis_external_document__c> extDocList2 = Test_Utils.createPAExternalDoc(1, profAnList[1].Id);
        insert extDocList2;
    }

    // Private constructor test
    @IsTest
    static void extDocConstructorTest() {
        Test.startTest();
            final External_Documents_Ctrl constructorTest = new External_Documents_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at External_Documents_Ctrl_Test - extDocConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void extDocServiceConstructorTest() {
        Test.startTest();
            final External_Documents_Service constructorTest2 = new External_Documents_Service();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at External_Documents_Ctrl_Test - extDocServiceConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void extDocHelperConstructorTest() {
        Test.startTest();
            final External_Documents_Helper constructorTest3 = new External_Documents_Helper();
            System.assertEquals(constructorTest3, constructorTest3, 'Err at External_Documents_Ctrl_Test - extDocHelperConstructorTest');
        Test.stopTest();
    }

    // Check getExternalDocumentInfo of profitability_analysis__c with external documents
    @IsTest
    static void getExternalDocumentInfo1Test() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();

            final List<ExternalDocument_Wrapper> ExtDocWrList = External_Documents_Ctrl.getExternalDocumentInfo(lstPA1[0].Id);
            System.assertEquals(4, ExtDocWrList.size(), 'Err at External_Documents_Ctrl_Test - getExternalDocumentInfo1Test');

        Test.stopTest();
    }

    // Check getExternalDocumentInfo of profitability_analysis__c without external documents
    @IsTest
    static void getExternalDocumentInfo2Test() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();

            final List<ExternalDocument_Wrapper> ExtDocWrList = External_Documents_Ctrl.getExternalDocumentInfo(lstPA2[0].Id);
            System.assertEquals(0, ExtDocWrList.size(), 'Err at External_Documents_Ctrl_Test - getExternalDocumentInfo2Test');

        Test.stopTest();
    }

    // Check getPicassoWSResponse success
    @IsTest
    static void getPicassoWSResponse1Test() {

        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);
        final PAExternalDocument_Selector paExtDocSelector = new PAExternalDocument_Selector(true);
        final Set<Id> paIdSet = new Set<Id>{lstPA3[0].Id};
        final List<profitability_analysis_external_document__c> paExtDocList = paExtDocSelector.selectByProfAnalysis(paIdSet);

        Test.startTest();

                String extDocOperId = paExtDocList[0].gf_external_operation_id__c;
                String extDocId = paExtDocList[0].gf_document_id__c;
                final Map<String, Object> retMap = External_Documents_Ctrl.getPicassoWSResponse(extDocOperId, extDocId);
                final Map<String, Object> actualMap = new Map<String, Object>();
                actualMap.put('isSuccess', retMap.get('isSuccess'));
                final Map<String, Object> expectedMap = new Map<String, Object>();
                expectedMap.put('isSuccess', true);
                System.assertEquals(expectedMap, actualMap, 'Err at External_Documents_Ctrl_Test - getPicassoWSResponse1Test');

        Test.stopTest();
    }
}