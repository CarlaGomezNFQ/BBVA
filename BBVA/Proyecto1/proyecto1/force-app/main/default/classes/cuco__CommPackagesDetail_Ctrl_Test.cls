/**
* ────────────────────────────────────────────────────────────────────
* CommPackagesDetail_Ctrl_Test
* Test class for CommPackagesDetail_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-26
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class CommPackagesDetail_Ctrl_Test {

    @TestSetup
    static void makeDataCommPkgDetail() {

        final List<Account> lstCommPkgDetAcc = Test_Utils.createAccounts(1);
        insert lstCommPkgDetAcc;

        final List<profitability_sheet__c> lstPSCommPkgDet = Test_Utils.createProfSheet(2, lstCommPkgDetAcc[0]);
        insert lstPSCommPkgDet;

        final List<profitability_analysis__c> lstPACommPkgDet = Test_Utils.createProfAnalysis(2, lstCommPkgDetAcc[0]);
        lstPACommPkgDet[0].gf_pa_management_type_name__c = 'New';
        lstPACommPkgDet[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPACommPkgDet[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPACommPkgDet[0].gf_profitability_sheet_id__c = lstPSCommPkgDet[0].Id;
        lstPACommPkgDet[1].gf_pa_management_type_name__c = 'Cancellation';
        lstPACommPkgDet[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPACommPkgDet[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPACommPkgDet[1].gf_profitability_sheet_id__c = lstPSCommPkgDet[1].Id;
        insert lstPACommPkgDet;
    }

    // Test method to check can edit methods with positive result of Permissions Sample
    @IsTest
    static void commPackagesDetailTest1() {
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = paSelector.selectByName(setNamesPA);

        Test.startTest();
            final Map<String, Object> retCMapCheckEdit = CommPackagesDetail_Ctrl.checkCommEditPermissions(lstPA[0].Id, '{"code":"000"}');

            final Map<String, Object> actualCMap = new Map<String, Object>();
            actualCMap.put('editPermission', retCMapCheckEdit.get('edit'));

            final Map<String, Object> expectedCMap = new Map<String, Object>();
            expectedCMap.put('editPermission', true);

            System.assertEquals(expectedCMap, actualCMap, 'Err at CommPackagesDetail_Ctrl_Test - commPackagesDetailTest1');
        Test.stopTest();
    }

    // Test method to check can edit methods with negative result of Permissions Sample
    @IsTest
    static void commPackagesDetailTest2() {
        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = paSelector2.selectByName(setNamesPA2);

        Test.startTest();
            final Map<String, Object> retCMapCheckEdit2 = CommPackagesDetail_Ctrl.checkCommEditPermissions(lstPA2[0].Id, '{"code":"001"}');

            final Map<String, Object> actualCMap2 = new Map<String, Object>();
            actualCMap2.put('editPermission', retCMapCheckEdit2.get('edit'));
            actualCMap2.put('editMsg', retCMapCheckEdit2.get('editMessage'));

            final Map<String, Object> expectedCMap2 = new Map<String, Object>();
            expectedCMap2.put('editPermission', false);
            expectedCMap2.put('editMsg', Label.pkg_edit_perm_error_sample);

            System.assertEquals(expectedCMap2, actualCMap2, 'Err at CommPackagesDetail_Ctrl_Test - commPackagesDetailTest2');
        Test.stopTest();
    }

    // Check auraexecption err at commPackagesDetail
    @IsTest
    static void commPackagesDetailTest3() {
        Test.startTest();
            try {
                CommPackagesDetail_Ctrl.checkCommEditPermissions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackagesDetail_Ctrl_Test - commPackagesDetailTest3');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void commPackagesDetailCtrlConstructorTest() {
        Test.startTest();
            final CommPackagesDetail_Ctrl constructorTest = new CommPackagesDetail_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackagesDetail_Ctrl_Test - commPackagesDetailCtrlConstructorTest');
        Test.stopTest();
    }
}