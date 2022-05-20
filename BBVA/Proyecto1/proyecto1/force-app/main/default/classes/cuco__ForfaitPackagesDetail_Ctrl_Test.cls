/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackagesDetail_Ctrl_Test
* Test class for ForfaitPackagesDetail_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-15
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ForfaitPackagesDetail_Ctrl_Test {

    @TestSetup
    static void makeDataForfaitPkgDetail() {

        final List<Account> lstForfaitPkgDetAcc = Test_Utils.createAccounts(1);
        insert lstForfaitPkgDetAcc;

        final List<profitability_sheet__c> lstPSForfaitPkgDet = Test_Utils.createProfSheet(2, lstForfaitPkgDetAcc[0]);
        insert lstPSForfaitPkgDet;

        final List<profitability_analysis__c> lstPAForfaitPkgDet = Test_Utils.createProfAnalysis(2, lstForfaitPkgDetAcc[0]);
        lstPAForfaitPkgDet[0].gf_pa_management_type_name__c = 'New';
        lstPAForfaitPkgDet[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPAForfaitPkgDet[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPAForfaitPkgDet[0].gf_profitability_sheet_id__c = lstPSForfaitPkgDet[0].Id;
        lstPAForfaitPkgDet[1].gf_pa_management_type_name__c = 'Cancellation';
        lstPAForfaitPkgDet[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPAForfaitPkgDet[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPAForfaitPkgDet[1].gf_profitability_sheet_id__c = lstPSForfaitPkgDet[1].Id;
        insert lstPAForfaitPkgDet;

    }

    // Check checkForfaitAddPermissions with permissions
    @IsTest
    static void forfaitPackagesDetailTest3() {
        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA3 = paSelector3.selectByName(setNamesPA3);

        Test.startTest();
            final Map<String, Object> retFMap3 = ForfaitPackagesDetail_Ctrl.checkForfaitAddPermissions(lstPA3[0].Id);

            final Map<String, Object> actualFMap3 = new Map<String, Object>();
            actualFMap3.put('add', (Boolean) retFMap3.get('add'));

            final Map<String, Object> expectedFMap3 = new Map<String, Object>();
            expectedFMap3.put('add', true);

            System.assertEquals(expectedFMap3, actualFMap3, 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest3');
        Test.stopTest();
    }

    // Check checkForfaitAddPermissions without permissions
    @IsTest
    static void forfaitPackagesDetailTest4() {
        final ProfitabilityAnalysis_Selector paSelector4 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA4 = paSelector4.selectByName(setNamesPA4);

        Test.startTest();
            final Map<String, Object> retFMap4 = ForfaitPackagesDetail_Ctrl.checkForfaitAddPermissions(lstPA4[0].Id);

            final Map<String, Object> actualFMap4 = new Map<String, Object>();
            actualFMap4.put('add', (Boolean) retFMap4.get('add'));
            actualFMap4.put('addMessage', (String) retFMap4.get('addMessage'));

            final Map<String, Object> expectedFMap4 = new Map<String, Object>();
            expectedFMap4.put('add', false);
            expectedFMap4.put('addMessage', Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedFMap4, actualFMap4, 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest4');
        Test.stopTest();
    }

    // Check checkForfaitEditPermissions with permissions
    @IsTest
    static void forfaitPackagesDetailTest5() {
        final ProfitabilityAnalysis_Selector paSelector5 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA5 = paSelector5.selectByName(setNamesPA5);

        Test.startTest();
            final Map<String, Object> retFMap5 = ForfaitPackagesDetail_Ctrl.checkForfaitEditPermissions(lstPA5[0].Id, '{"code":"000"}');

            final Map<String, Object> actualFMap5 = new Map<String, Object>();
            actualFMap5.put('edit', (Boolean) retFMap5.get('edit'));

            final Map<String, Object> expectedFMap5 = new Map<String, Object>();
            expectedFMap5.put('edit', true);

            System.assertEquals(expectedFMap5, actualFMap5, 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest5');
        Test.stopTest();
    }

    // Check checkForfaitEditPermissions without permissions
    @IsTest
    static void forfaitPackagesDetailTest6() {
        final ProfitabilityAnalysis_Selector paSelector6 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA6 = paSelector6.selectByName(setNamesPA6);

        Test.startTest();
            final Map<String, Object> retFMap6 = ForfaitPackagesDetail_Ctrl.checkForfaitEditPermissions(lstPA6[0].Id, '{"code":"000"}');

            final Map<String, Object> actualFMap6 = new Map<String, Object>();
            actualFMap6.put('edit', (Boolean) retFMap6.get('edit'));
            actualFMap6.put('editMessage', (String) retFMap6.get('editMessage'));

            final Map<String, Object> expectedFMap6 = new Map<String, Object>();
            expectedFMap6.put('edit', false);
            expectedFMap6.put('editMessage', Label.pkg_edit_perm_error_sample);

            System.assertEquals(expectedFMap6, actualFMap6, 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest6');
        Test.stopTest();
    }

    // Check checkForfaitEditPermissions catch err
    @IsTest
    static void forfaitPackagesDetailTest7() {
        Test.startTest();
            try {
                ForfaitPackagesDetail_Ctrl.checkForfaitEditPermissions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest7');
            }
        Test.stopTest();
    }

    // Check checkForfaitCancelPermissions with permissions
    @IsTest
    static void forfaitPackagesDetailTest8() {
        final ProfitabilityAnalysis_Selector paSelector8 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA8 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA8 = paSelector8.selectByName(setNamesPA8);

        Test.startTest();
            final Map<String, Object> retFMap8 = ForfaitPackagesDetail_Ctrl.checkForfaitCancelPermissions(lstPA8[0].Id, '{"code":"000"}');

            final Map<String, Object> actualFMap8 = new Map<String, Object>();
            actualFMap8.put('cancel', (Boolean) retFMap8.get('cancel'));

            final Map<String, Object> expectedFMap8 = new Map<String, Object>();
            expectedFMap8.put('cancel', true);

            System.assertEquals(expectedFMap8, actualFMap8, 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest8');
        Test.stopTest();
    }

    // Check checkForfaitCancelPermissions without permissions
    @IsTest
    static void forfaitPackagesDetailTest9() {
        final ProfitabilityAnalysis_Selector paSelector9 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA9 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA9 = paSelector9.selectByName(setNamesPA9);

        Test.startTest();
            final Map<String, Object> retFMap9 = ForfaitPackagesDetail_Ctrl.checkForfaitCancelPermissions(lstPA9[0].Id, '{"code":"000"}');

            final Map<String, Object> actualFMap9 = new Map<String, Object>();
            actualFMap9.put('cancel', (Boolean) retFMap9.get('cancel'));
            actualFMap9.put('cancelMessage', (String) retFMap9.get('cancelMessage'));

            final Map<String, Object> expectedFMap9 = new Map<String, Object>();
            expectedFMap9.put('cancel', false);
            expectedFMap9.put('cancelMessage', Label.pkg_cancel_perm_error_sample);

            System.assertEquals(expectedFMap9, actualFMap9, 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest9');
        Test.stopTest();
    }

    // Check checkForfaitEditPermissions catch err
    @IsTest
    static void forfaitPackagesDetailTest10() {
        Test.startTest();
            try {
                ForfaitPackagesDetail_Ctrl.checkForfaitCancelPermissions(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackagesDetail_Ctrl_Test - forfaitPackagesDetailTest10');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void forfaitPackagesDetailCtrlConstructorTest11() {
        Test.startTest();
            final ForfaitPackagesDetail_Ctrl constructorTest11 = new ForfaitPackagesDetail_Ctrl();
            System.assertEquals(constructorTest11, constructorTest11, 'Err at ForfaitPackagesDetail_Ctrl_Test - forfaitPackagesDetailCtrlConstructorTest11');
        Test.stopTest();
    }
}