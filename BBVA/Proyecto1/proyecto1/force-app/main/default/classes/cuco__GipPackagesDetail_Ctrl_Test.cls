/**
* ────────────────────────────────────────────────────────────────────
* GipPackagesDetail_Ctrl_Test
* Test class for GipPackagesDetail_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-30
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class GipPackagesDetail_Ctrl_Test {


    @TestSetup
    static void makeDataGipPkgDetail() {

        final List<Account> lstGipPkgDetAcc = Test_Utils.createAccounts(1);
        insert lstGipPkgDetAcc;

        final List<profitability_sheet__c> lstPSGipPkgDet = Test_Utils.createProfSheet(2, lstGipPkgDetAcc[0]);
        insert lstPSGipPkgDet;

        final List<profitability_analysis__c> lstPAGipPkgDet = Test_Utils.createProfAnalysis(2, lstGipPkgDetAcc[0]);
        lstPAGipPkgDet[0].gf_pa_management_type_name__c = 'New';
        lstPAGipPkgDet[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPAGipPkgDet[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPAGipPkgDet[0].gf_profitability_sheet_id__c = lstPSGipPkgDet[0].Id;
        lstPAGipPkgDet[1].gf_pa_management_type_name__c = 'Cancellation';
        lstPAGipPkgDet[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPAGipPkgDet[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPAGipPkgDet[1].gf_profitability_sheet_id__c = lstPSGipPkgDet[1].Id;
        insert lstPAGipPkgDet;

    }

    // Check checkGipAddPermissions with permissions
    @IsTest
    static void gipPackagesDetailTest3() {
        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA3 = paSelector3.selectByName(setNamesPA3);

        Test.startTest();
            final Map<String, Object> retGMap3 = GipPackagesDetail_Ctrl.checkGipAddPermissions(lstPA3[0].Id);

            final Map<String, Object> actualGMap3 = new Map<String, Object>();
            actualGMap3.put('add', (Boolean) retGMap3.get('add'));

            final Map<String, Object> expectedGMap3 = new Map<String, Object>();
            expectedGMap3.put('add', true);

            System.assertEquals(expectedGMap3, actualGMap3, 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest3');
        Test.stopTest();
    }

    // Check checkGipAddPermissions without permissions
    @IsTest
    static void gipPackagesDetailTest4() {
        final ProfitabilityAnalysis_Selector paSelector4 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA4 = paSelector4.selectByName(setNamesPA4);

        Test.startTest();
            final Map<String, Object> retGMap4 = GipPackagesDetail_Ctrl.checkGipAddPermissions(lstPA4[0].Id);

            final Map<String, Object> actualGMap4 = new Map<String, Object>();
            actualGMap4.put('add', (Boolean) retGMap4.get('add'));
            actualGMap4.put('addMessage', (String) retGMap4.get('addMessage'));

            final Map<String, Object> expectedGMap4 = new Map<String, Object>();
            expectedGMap4.put('add', false);
            expectedGMap4.put('addMessage', Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedGMap4, actualGMap4, 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest4');
        Test.stopTest();
    }

    // Check checkGipEditPermissions with permissions
    @IsTest
    static void gipPackagesDetailTest5() {
        final ProfitabilityAnalysis_Selector paSelector5 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA5 = paSelector5.selectByName(setNamesPA5);

        Test.startTest();
            final Map<String, Object> retGMap5 = GipPackagesDetail_Ctrl.checkGipEditPermissions(lstPA5[0].Id, '{"code":"000"}');

            final Map<String, Object> actualGMap5 = new Map<String, Object>();
            actualGMap5.put('edit', (Boolean) retGMap5.get('edit'));

            final Map<String, Object> expectedGMap5 = new Map<String, Object>();
            expectedGMap5.put('edit', true);

            System.assertEquals(expectedGMap5, actualGMap5, 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest5');
        Test.stopTest();
    }

    // Check checkGipEditPermissions without permissions
    @IsTest
    static void gipPackagesDetailTest6() {
        final ProfitabilityAnalysis_Selector paSelector6 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA6 = paSelector6.selectByName(setNamesPA6);

        Test.startTest();
            final Map<String, Object> retGMap6 = GipPackagesDetail_Ctrl.checkGipEditPermissions(lstPA6[0].Id, '{"code":"000"}');

            final Map<String, Object> actualGMap6 = new Map<String, Object>();
            actualGMap6.put('edit', (Boolean) retGMap6.get('edit'));
            actualGMap6.put('editMessage', (String) retGMap6.get('editMessage'));

            final Map<String, Object> expectedGMap6 = new Map<String, Object>();
            expectedGMap6.put('edit', false);
            expectedGMap6.put('editMessage', Label.pkg_edit_perm_error_sample);

            System.assertEquals(expectedGMap6, actualGMap6, 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest6');
        Test.stopTest();
    }

    // Check checkGipEditPermissions catch err
    @IsTest
    static void gipPackagesDetailTest7() {
        Test.startTest();
            try {
                GipPackagesDetail_Ctrl.checkGipEditPermissions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest7');
            }
        Test.stopTest();
    }

    // Check checkGipCancelPermissions with permissions
    @IsTest
    static void gipPackagesDetailTest8() {
        final ProfitabilityAnalysis_Selector paSelector8 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA8 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA8 = paSelector8.selectByName(setNamesPA8);

        Test.startTest();
            final Map<String, Object> retGMap8 = GipPackagesDetail_Ctrl.checkGipCancelPermissions(lstPA8[0].Id, '{"code":"000"}');

            final Map<String, Object> actualGMap8 = new Map<String, Object>();
            actualGMap8.put('cancel', (Boolean) retGMap8.get('cancel'));

            final Map<String, Object> expectedGMap8 = new Map<String, Object>();
            expectedGMap8.put('cancel', true);

            System.assertEquals(expectedGMap8, actualGMap8, 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest8');
        Test.stopTest();
    }

    // Check checkGipCancelPermissions without permissions
    @IsTest
    static void gipPackagesDetailTest9() {
        final ProfitabilityAnalysis_Selector paSelector9 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA9 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA9 = paSelector9.selectByName(setNamesPA9);

        Test.startTest();
            final Map<String, Object> retGMap9 = GipPackagesDetail_Ctrl.checkGipCancelPermissions(lstPA9[0].Id, '{"code":"000"}');

            final Map<String, Object> actualGMap9 = new Map<String, Object>();
            actualGMap9.put('cancel', (Boolean) retGMap9.get('cancel'));
            actualGMap9.put('cancelMessage', (String) retGMap9.get('cancelMessage'));

            final Map<String, Object> expectedGMap9 = new Map<String, Object>();
            expectedGMap9.put('cancel', false);
            expectedGMap9.put('cancelMessage', Label.pkg_cancel_perm_error_sample);

            System.assertEquals(expectedGMap9, actualGMap9, 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest9');
        Test.stopTest();
    }

    // Check checkGipEditPermissions catch err
    @IsTest
    static void gipPackagesDetailTest10() {
        Test.startTest();
            try {
                GipPackagesDetail_Ctrl.checkGipCancelPermissions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackagesDetail_Ctrl_Test - gipPackagesDetailTest10');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void gipPackagesDetailCtrlConstructorTest11() {
        Test.startTest();
            final GipPackagesDetail_Ctrl constructorTest11 = new GipPackagesDetail_Ctrl();
            System.assertEquals(constructorTest11, constructorTest11, 'Err at GipPackagesDetail_Ctrl_Test - gipPackagesDetailCtrlConstructorTest11');
        Test.stopTest();
    }
}