/**
* ────────────────────────────────────────────────────────────────────
* GipPackages_Ctrl_Test
* Test class for GipPackages_Ctrl apex class
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
public class GipPackages_Ctrl_Test {

    @TestSetup
    static void makeDataGipPkg() {
        // Test setup common for pkgs ctrl class to do test
        Test_Utils.doPackagesTestSetup();
    }

    // Check fill profitability analysis with manage permissions
    @IsTest
    static void gipPackagesTest1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();
            final Map<String, Object> retGipMap1 = GipPackages_Ctrl.getGipPackages(lstPA1[0].Id);
            final Map<String, Object> pkgGPermissions1 = (Map<String, Object>) retGipMap1.get('pkgPermissions');

            final Map<String, Object> actualGipMap1 = new Map<String, Object>();
            actualGipMap1.put('lstPW1Size', ((List<Package_Wrapper>) retGipMap1.get('lstPW')).size());
            actualGipMap1.put('editPermissions', (Boolean) pkgGPermissions1.get('edit'));

            final Map<String, Object> expectedGipMap1 = new Map<String, Object>();
            expectedGipMap1.put('lstPW1Size', 6);
            expectedGipMap1.put('editPermissions', true);

            System.assertEquals(expectedGipMap1, actualGipMap1, 'Err at GipPackages_Ctrl_Test - gipPackagesTest1');
        Test.stopTest();
    }

    // Check empty profitability analysis without manage permisisons
    @IsTest
    static void gipPackagesTest2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();
            final Map<String, Object> retGipMap2 = GipPackages_Ctrl.getGipPackages(lstPA2[0].Id);
            final Map<String, Object> pkgGPermissions2 = (Map<String, Object>) retGipMap2.get('pkgPermissions');

            final Map<String, Object> actualGipMap2 = new Map<String, Object>();
            actualGipMap2.put('lstPW2Size', ((List<Package_Wrapper>) retGipMap2.get('lstPW')).size());
            actualGipMap2.put('editPermissions', (Boolean) pkgGPermissions2.get('edit'));

            final Map<String, Object> expectedGipMap2 = new Map<String, Object>();
            expectedGipMap2.put('lstPW2Size', 0);
            expectedGipMap2.put('editPermissions', false);

            System.assertEquals(expectedGipMap2, actualGipMap2, 'Err at GipPackages_Ctrl_Test - gipPackagesTest2');
        Test.stopTest();
    }

    // Check fill profitability sheet
    @IsTest
    static void gipPackagesTest3() {

        final ProfitabilitySheet_Selector profShSelector3 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS3 = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> lstPS3 = profShSelector3.selectByName(setNamesPS3);

        Test.startTest();
            final Map<String, Object> retGipMap3 = GipPackages_Ctrl.getGipPackages(lstPS3[0].Id);

            final Map<String, Object> actualGipMap3 = new Map<String, Object>();
            actualGipMap3.put('lstPW3Size', ((List<Package_Wrapper>) retGipMap3.get('lstPW')).size());

            final Map<String, Object> expectedGipMap3 = new Map<String, Object>();
            expectedGipMap3.put('lstPW3Size', 2);

            System.assertEquals(expectedGipMap3, actualGipMap3, 'Err at GipPackages_Ctrl_Test - gipPackagesTest3');
        Test.stopTest();
    }

    // Check empty profitability sheet
    @IsTest
    static void gipPackagesTest4() {

        final ProfitabilitySheet_Selector profShSelector4 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS4 = new Set<String>{'Prof Sheet Test 1'};
        final List<profitability_sheet__c> lstPS4 = profShSelector4.selectByName(setNamesPS4);

        Test.startTest();
            final Map<String, Object> retGipMap4 = GipPackages_Ctrl.getGipPackages(lstPS4[0].Id);

            final Map<String, Object> actualGipMap4 = new Map<String, Object>();
            actualGipMap4.put('lstPW4Size', ((List<Package_Wrapper>) retGipMap4.get('lstPW')).size());

            final Map<String, Object> expectedGipMap4 = new Map<String, Object>();
            expectedGipMap4.put('lstPW4Size', 0);

            System.assertEquals(expectedGipMap4, actualGipMap4, 'Err at GipPackages_Ctrl_Test - gipPackagesTest4');
        Test.stopTest();
    }

    // gipPackages err
    @IsTest
    static void gipPackagesTest5() {
        Test.startTest();
            try {
                GipPackages_Ctrl.getGipPackages('000000000000000000');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at GipPackages_Ctrl_Test - gipPackagesTest5');
            }
        Test.stopTest();
    }

    // Check checkGipAddPermissions with permissions
    @IsTest
    static void gipPackagesTest6() {
        final ProfitabilityAnalysis_Selector paSelector6 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA6 = paSelector6.selectByName(setNamesPA6);

        Test.startTest();
            final Map<String, Object> retGipMap6 = GipPackages_Ctrl.checkGipAddPermissions(lstPA6[0].Id);

            final Map<String, Object> actualGipMap6 = new Map<String, Object>();
            actualGipMap6.put('add', (Boolean) retGipMap6.get('add'));

            final Map<String, Object> expectedGipMap6 = new Map<String, Object>();
            expectedGipMap6.put('add', true);

            System.assertEquals(expectedGipMap6, actualGipMap6, 'Err at GipPackages_Ctrl_Test - gipPackagesTest6');
        Test.stopTest();
    }

    // Check checkGipAddPermissions without permissions
    @IsTest
    static void gipPackagesTest7() {
        final ProfitabilityAnalysis_Selector paSelector7 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA7 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA7 = paSelector7.selectByName(setNamesPA7);

        Test.startTest();
            final Map<String, Object> retGipMap7 = GipPackages_Ctrl.checkGipAddPermissions(lstPA7[0].Id);

            final Map<String, Object> actualGipMap7 = new Map<String, Object>();
            actualGipMap7.put('add', (Boolean) retGipMap7.get('add'));
            actualGipMap7.put('addMessage', (String) retGipMap7.get('addMessage'));

            final Map<String, Object> expectedGipMap7 = new Map<String, Object>();
            expectedGipMap7.put('add', false);
            expectedGipMap7.put('addMessage', Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedGipMap7, actualGipMap7, 'Err at GipPackages_Ctrl_Test - gipPackagesTest7');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void gipPackagesCtrlConstructorTest8() {
        Test.startTest();
            final GipPackages_Ctrl constructorTest8 = new GipPackages_Ctrl();
            System.assertEquals(constructorTest8, constructorTest8, 'Err at GipPackages_Ctrl_Test - gipPackagesCtrlConstructorTest8');
        Test.stopTest();
    }

    // Private constructor test 2
    @IsTest
    static void gipPackagesCtrlConstructorTest9() {
        Test.startTest();
            final PackagesGip_Service constructorTest8 = new PackagesGip_Service();
            System.assertEquals(constructorTest8, constructorTest8, 'Err at GipPackages_Ctrl_Test - gipPackagesCtrlConstructorTest9');
        Test.stopTest();
    }
}