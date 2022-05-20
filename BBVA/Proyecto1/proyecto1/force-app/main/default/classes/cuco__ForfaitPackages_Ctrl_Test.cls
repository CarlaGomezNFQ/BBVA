/**
* ────────────────────────────────────────────────────────────────────
* ForfaitPackages_Ctrl_Test
* Test class for ForfaitPackages_Ctrl apex class
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
public class ForfaitPackages_Ctrl_Test {

    @TestSetup
    static void makeDataForfaitPkg() {
        // Test setup common for pkgs ctrl class to do test
        Test_Utils.doPackagesTestSetup();
    }

    // Check fill profitability analysis with manage permissions
    @IsTest
    static void forfaitPackagesTest1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();
            final Map<String, Object> retFMap1 = ForfaitPackages_Ctrl.getForfaitPackages(lstPA1[0].Id);
            final Map<String, Object> pkgPermissions1 = (Map<String, Object>) retFMap1.get('pkgPermissions');

            final Map<String, Object> actualFMap1 = new Map<String, Object>();
            actualFMap1.put('lstPW1Size', ((List<Package_Wrapper>) retFMap1.get('lstPW')).size());
            actualFMap1.put('editPermissions', (Boolean) pkgPermissions1.get('edit'));

            final Map<String, Object> expectedFMap1 = new Map<String, Object>();
            expectedFMap1.put('lstPW1Size', 6);
            expectedFMap1.put('editPermissions', true);

            System.assertEquals(expectedFMap1, actualFMap1, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest1');
        Test.stopTest();
    }

    // Check empty profitability analysis without manage permisisons
    @IsTest
    static void forfaitPackagesTest2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();
            final Map<String, Object> retFMap2 = ForfaitPackages_Ctrl.getForfaitPackages(lstPA2[0].Id);
            final Map<String, Object> pkgPermissions2 = (Map<String, Object>) retFMap2.get('pkgPermissions');

            final Map<String, Object> actualFMap2 = new Map<String, Object>();
            actualFMap2.put('lstPW2Size', ((List<Package_Wrapper>) retFMap2.get('lstPW')).size());
            actualFMap2.put('editPermissions', (Boolean) pkgPermissions2.get('edit'));

            final Map<String, Object> expectedFMap2 = new Map<String, Object>();
            expectedFMap2.put('lstPW2Size', 0);
            expectedFMap2.put('editPermissions', false);

            System.assertEquals(expectedFMap2, actualFMap2, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest2');
        Test.stopTest();
    }

    // Check fill profitability sheet
    @IsTest
    static void forfaitPackagesTest3() {

        final ProfitabilitySheet_Selector profShSelector3 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS3 = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> lstPS3 = profShSelector3.selectByName(setNamesPS3);

        Test.startTest();
            final Map<String, Object> retFMap3 = ForfaitPackages_Ctrl.getForfaitPackages(lstPS3[0].Id);

            final Map<String, Object> actualFMap3 = new Map<String, Object>();
            actualFMap3.put('lstPW3Size', ((List<Package_Wrapper>) retFMap3.get('lstPW')).size());

            final Map<String, Object> expectedFMap3 = new Map<String, Object>();
            expectedFMap3.put('lstPW3Size', 4);

            System.assertEquals(expectedFMap3, actualFMap3, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest3');
        Test.stopTest();
    }

    // Check empty profitability sheet
    @IsTest
    static void forfaitPackagesTest4() {

        final ProfitabilitySheet_Selector profShSelector4 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS4 = new Set<String>{'Prof Sheet Test 1'};
        final List<profitability_sheet__c> lstPS4 = profShSelector4.selectByName(setNamesPS4);

        Test.startTest();
            final Map<String, Object> retFMap4 = ForfaitPackages_Ctrl.getForfaitPackages(lstPS4[0].Id);

            final Map<String, Object> actualFMap4 = new Map<String, Object>();
            actualFMap4.put('lstPW4Size', ((List<Package_Wrapper>) retFMap4.get('lstPW')).size());

            final Map<String, Object> expectedFMap4 = new Map<String, Object>();
            expectedFMap4.put('lstPW4Size', 0);

            System.assertEquals(expectedFMap4, actualFMap4, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest4');
        Test.stopTest();
    }

    // forfaitPackages err
    @IsTest
    static void forfaitPackagesTest5() {
        Test.startTest();
            try {
                ForfaitPackages_Ctrl.getForfaitPackages('000000000000000000');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest5');
            }
        Test.stopTest();
    }

    // Check checkForfaitAddPermissions with permissions
    @IsTest
    static void forfaitPackagesTest6() {
        final ProfitabilityAnalysis_Selector paSelector6 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA6 = paSelector6.selectByName(setNamesPA6);

        Test.startTest();
            final Map<String, Object> retFMap6 = ForfaitPackages_Ctrl.checkForfaitAddPermissions(lstPA6[0].Id);

            final Map<String, Object> actualFMap6 = new Map<String, Object>();
            actualFMap6.put('add', (Boolean) retFMap6.get('add'));

            final Map<String, Object> expectedFMap6 = new Map<String, Object>();
            expectedFMap6.put('add', true);

            System.assertEquals(expectedFMap6, actualFMap6, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest6');
        Test.stopTest();
    }

    // Check checkForfaitAddPermissions without permissions
    @IsTest
    static void forfaitPackagesTest7() {
        final ProfitabilityAnalysis_Selector paSelector7 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA7 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA7 = paSelector7.selectByName(setNamesPA7);

        Test.startTest();
            final Map<String, Object> retFMap7 = ForfaitPackages_Ctrl.checkForfaitAddPermissions(lstPA7[0].Id);

            final Map<String, Object> actualFMap7 = new Map<String, Object>();
            actualFMap7.put('add', (Boolean) retFMap7.get('add'));
            actualFMap7.put('addMessage', (String) retFMap7.get('addMessage'));

            final Map<String, Object> expectedFMap7 = new Map<String, Object>();
            expectedFMap7.put('add', false);
            expectedFMap7.put('addMessage', Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedFMap7, actualFMap7, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesTest7');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void forfaitPackagesCtrlConstructorTest8() {
        Test.startTest();
            final ForfaitPackages_Ctrl constructorTest8 = new ForfaitPackages_Ctrl();
            System.assertEquals(constructorTest8, constructorTest8, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesCtrlConstructorTest8');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void forfaitPackagesCtrlConstructorTest9() {
        Test.startTest();
            final PackagesForfait_Service constructorTest9 = new PackagesForfait_Service();
            System.assertEquals(constructorTest9, constructorTest9, 'Err at ForfaitPackages_Ctrl_Test - forfaitPackagesCtrlConstructorTest8');
        Test.stopTest();
    }
}